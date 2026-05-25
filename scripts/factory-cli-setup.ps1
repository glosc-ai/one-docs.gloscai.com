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

function Get-FactoryConfigValue {
    param(
        [string]$FilePath,
        [string]$FieldName
    )

    if (-not (Test-Path -Path $FilePath)) {
        return ''
    }

    try {
        $json = Get-Content -Path $FilePath -Raw | ConvertFrom-Json
        if ($json.custom_models -and $json.custom_models.Count -gt 0) {
            $value = $json.custom_models[0].$FieldName
            if ($null -ne $value) {
                return [string]$value
            }
        }
    }
    catch {
        $content = Get-Content -Path $FilePath -Raw -ErrorAction SilentlyContinue
        if ($FieldName -eq 'model' -and $content -match '"model"\s*:\s*"([^"]+)"') {
            return $matches[1]
        }
        if ($FieldName -eq 'api_key' -and $content -match '"api_key"\s*:\s*"([^"]+)"') {
            return $matches[1] -replace '[\r\n]', ''
        }
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

$factoryDirectory = Join-Path $HOME '.factory'
$configFile = Join-Path $factoryDirectory 'config.json'
$existingModel = Get-FactoryConfigValue -FilePath $configFile -FieldName 'model'
$existingToken = Get-FactoryConfigValue -FilePath $configFile -FieldName 'api_key'

Write-Host '=== Factory Droid CLI setup ==='
Write-Host ''
Write-Host "OPENAI base_url will be set to: $defaultBaseUrl"
Write-Host ''

$authToken = Prompt-RequiredValue -Prompt 'AUTH_TOKEN' -ExistingValue $existingToken -Secret
Write-Host ''
$defaultModel = Prompt-RequiredValue -Prompt 'DEFAULT_MODEL' -ExistingValue $existingModel
Write-Host ''

$configContent = ([ordered]@{
        custom_models = @(
                [ordered]@{
                        model_display_name = "$defaultModel [custom]"
                        model = $defaultModel
                        base_url = $defaultBaseUrl
                        api_key = $authToken
                        provider = 'openai'
                        max_tokens = 128000
                }
        )
} | ConvertTo-Json -Depth 4)

Write-Utf8NoBomFile -FilePath $configFile -Content $configContent

Write-Host 'Configuration saved to Factory Droid config file.' -ForegroundColor Green
Write-Host "Config: $configFile"
Write-Host "BASE_URL: $defaultBaseUrl"
Write-Host "AUTH_TOKEN: $(if ($authToken -eq $existingToken -and -not [string]::IsNullOrWhiteSpace($existingToken)) { 'kept existing value' } else { 'updated' })"
Write-Host "DEFAULT_MODEL: $defaultModel"