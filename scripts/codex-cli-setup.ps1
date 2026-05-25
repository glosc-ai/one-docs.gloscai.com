#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'

$defaultBaseUrl = 'https://one.gloscai.com/v1'

function Get-TrimmedValue {
    param([string]$Value)

    if ($null -eq $Value) {
        return ''
    }

    return $Value.Trim()
}

function Read-SecretValue {
    param([string]$Prompt)

    $secureValue = Read-Host -Prompt $Prompt -AsSecureString
    if ($null -eq $secureValue) {
        return ''
    }

    $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureValue)
    try {
        return Get-TrimmedValue ([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr))
    }
    finally {
        if ($ptr -ne [IntPtr]::Zero) {
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
        }
    }
}

function Prompt-RequiredValue {
    param(
        [string]$Prompt,
        [string]$ExistingValue = '',
        [switch]$Secret
    )

    while ($true) {
        if (-not [string]::IsNullOrWhiteSpace($ExistingValue)) {
            Write-Host 'Press Enter to keep the current value.'
        }

        $inputValue = if ($Secret) {
            Read-SecretValue $Prompt
        }
        else {
            Get-TrimmedValue (Read-Host -Prompt $Prompt)
        }

        if (-not [string]::IsNullOrWhiteSpace($inputValue)) {
            return $inputValue
        }

        if (-not [string]::IsNullOrWhiteSpace($ExistingValue)) {
            return $ExistingValue
        }

        Write-Host 'Value cannot be empty.' -ForegroundColor Red
        Write-Host ''
    }
}

function Get-CodexConfigValue {
    param(
        [string]$FilePath,
        [string]$Key
    )

    if (-not (Test-Path -Path $FilePath)) {
        return ''
    }

    $content = Get-Content -Path $FilePath -Raw -ErrorAction SilentlyContinue
    if ([string]::IsNullOrWhiteSpace($content)) {
        return ''
    }

    if ($Key -eq 'model' -and $content -match '(?m)^\s*model\s*=\s*"([^"]+)"') {
        return $matches[1]
    }

    return ''
}

function Get-CodexAuthValue {
    param([string]$FilePath)

    if (-not (Test-Path -Path $FilePath)) {
        return ''
    }

    $content = Get-Content -Path $FilePath -Raw -ErrorAction SilentlyContinue
    if ([string]::IsNullOrWhiteSpace($content)) {
        return ''
    }

    if ($content -match '"OPENAI_API_KEY"\s*:\s*"([^"]+)"') {
        return $matches[1] -replace '[\r\n]', ''
    }

    return ''
}

function Write-Utf8NoBomFile {
    param(
        [string]$FilePath,
        [string]$Content
    )

    $directory = Split-Path -Path $FilePath -Parent
    if (-not (Test-Path -Path $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }

    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($FilePath, $Content, $encoding)
}

function Invoke-WslCommand {
    param([string]$Command)

    return & wsl.exe bash -lc $Command 2>$null
}

function Test-WslAvailable {
    if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
        return $false
    }

    try {
        $result = Invoke-WslCommand 'printf ok'
        return $result -eq 'ok'
    }
    catch {
        return $false
    }
}

function Get-WslCodexValue {
    param([string]$Kind)

    if (-not (Test-WslAvailable)) {
        return ''
    }

    $command = switch ($Kind) {
        'model' {
            'if [ -f ~/.codex/config.toml ]; then sed -n ''s/^[[:space:]]*model[[:space:]]*=[[:space:]]*"\(.*\)"$/\1/p'' ~/.codex/config.toml | head -n1; fi'
        }
        'token' {
            'if [ -f ~/.codex/auth.json ]; then sed -n ''s/.*"OPENAI_API_KEY"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p'' ~/.codex/auth.json | head -n1; fi'
        }
        default {
            ''
        }
    }

    if ([string]::IsNullOrWhiteSpace($command)) {
        return ''
    }

    try {
        return Get-TrimmedValue (Invoke-WslCommand $command)
    }
    catch {
        return ''
    }
}

function Sync-CodexToWsl {
    param(
        [string]$ConfigContent,
        [string]$AuthContent
    )

    if (-not (Test-WslAvailable)) {
        return $false
    }

    $configBase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($ConfigContent))
    $authBase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($AuthContent))
    $command = @"
mkdir -p ~/.codex
printf '%s' '$configBase64' | base64 -d > ~/.codex/config.toml
printf '%s' '$authBase64' | base64 -d > ~/.codex/auth.json
chmod 700 ~/.codex
chmod 600 ~/.codex/config.toml ~/.codex/auth.json
"@

    try {
        Invoke-WslCommand $command | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

$codexDirectory = Join-Path $HOME '.codex'
$configFile = Join-Path $codexDirectory 'config.toml'
$authFile = Join-Path $codexDirectory 'auth.json'

$existingModel = Get-CodexConfigValue -FilePath $configFile -Key 'model'
if ([string]::IsNullOrWhiteSpace($existingModel)) {
    $existingModel = Get-WslCodexValue -Kind 'model'
}

$existingToken = Get-CodexAuthValue -FilePath $authFile
if ([string]::IsNullOrWhiteSpace($existingToken)) {
    $existingToken = Get-WslCodexValue -Kind 'token'
}

Write-Host '=== Codex CLI setup ==='
Write-Host ''
Write-Host "OPENAI base_url will be set to: $defaultBaseUrl"
Write-Host ''

$authToken = Prompt-RequiredValue -Prompt 'AUTH_TOKEN' -ExistingValue $existingToken -Secret
Write-Host ''
$defaultModel = Prompt-RequiredValue -Prompt 'DEFAULT_MODEL' -ExistingValue $existingModel
Write-Host ''

$escapedBaseUrl = $defaultBaseUrl -replace '"', '""'
$configContent = @"
model = "$defaultModel"
model_provider = "custom"
model_reasoning_effort = "medium"
disable_response_storage = true

[model_providers.custom]
name = "custom"
base_url = "$escapedBaseUrl"
wire_api = "responses"
"@

$authContent = ([ordered]@{
        OPENAI_API_KEY = $authToken
    } | ConvertTo-Json -Depth 3)

Write-Utf8NoBomFile -FilePath $configFile -Content $configContent
Write-Utf8NoBomFile -FilePath $authFile -Content $authContent

$wslSynced = Sync-CodexToWsl -ConfigContent $configContent -AuthContent $authContent

Write-Host 'Configuration saved to Codex config files.' -ForegroundColor Green
Write-Host "Windows config: $configFile"
Write-Host "Windows auth: $authFile"
if ($wslSynced) {
    Write-Host 'WSL config was updated in ~/.codex as well.'
}
else {
    Write-Host 'WSL sync skipped. If you run Codex inside WSL, run the shell setup script there as well.' -ForegroundColor Yellow
}
Write-Host "BASE_URL: $defaultBaseUrl"
Write-Host "AUTH_TOKEN: $(if ($authToken -eq $existingToken -and -not [string]::IsNullOrWhiteSpace($existingToken)) { 'kept existing value' } else { 'updated' })"
Write-Host "DEFAULT_MODEL: $defaultModel"