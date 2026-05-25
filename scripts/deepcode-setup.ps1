#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'
$defaultBaseUrl = 'https://one.gloscai.com/v1'

function Get-TrimmedValue { param([string]$Value) if ($null -eq $Value) { return '' } return $Value.Trim() }
function Read-SecretValue {
    param([string]$Prompt)
    $secureValue = Read-Host -Prompt $Prompt -AsSecureString
    if ($null -eq $secureValue) { return '' }
    $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureValue)
    try { return Get-TrimmedValue ([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)) }
    finally { if ($ptr -ne [IntPtr]::Zero) { [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) } }
}
function Prompt-RequiredValue {
    param([string]$Prompt, [string]$ExistingValue = '', [switch]$Secret)
    while ($true) {
        if (-not [string]::IsNullOrWhiteSpace($ExistingValue)) { Write-Host 'Press Enter to keep the current value.' }
        $inputValue = if ($Secret) { Read-SecretValue $Prompt } else { Get-TrimmedValue (Read-Host -Prompt $Prompt) }
        if (-not [string]::IsNullOrWhiteSpace($inputValue)) { return $inputValue }
        if (-not [string]::IsNullOrWhiteSpace($ExistingValue)) { return $ExistingValue }
        Write-Host 'Value cannot be empty.' -ForegroundColor Red
        Write-Host ''
    }
}
function Write-Utf8NoBomFile {
    param([string]$FilePath, [string]$Content)
    $directory = Split-Path -Path $FilePath -Parent
    if (-not (Test-Path -Path $directory)) { New-Item -ItemType Directory -Path $directory -Force | Out-Null }
    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($FilePath, $Content, $encoding)
}
function Get-DeepCodeValue {
    param([string]$FilePath, [string]$Name)
    if (-not (Test-Path -Path $FilePath)) { return '' }
    try {
        $json = Get-Content -Path $FilePath -Raw | ConvertFrom-Json
        if ($json.env -and $null -ne $json.env.$Name) { return [string]$json.env.$Name }
    }
    catch { return '' }
    return ''
}

$configFile = Join-Path (Join-Path $HOME '.deepcode') 'settings.json'
$existingToken = Get-DeepCodeValue -FilePath $configFile -Name 'API_KEY'
$existingModel = Get-DeepCodeValue -FilePath $configFile -Name 'MODEL'

Write-Host '=== Deep Code setup ==='
Write-Host ''
Write-Host "BASE_URL will be set to: $defaultBaseUrl"
Write-Host ''
$authToken = Prompt-RequiredValue -Prompt 'AUTH_TOKEN' -ExistingValue $existingToken -Secret
Write-Host ''
$defaultModel = Prompt-RequiredValue -Prompt 'DEFAULT_MODEL' -ExistingValue $existingModel
Write-Host ''

$configContent = ([ordered]@{
    env = [ordered]@{
        MODEL = $defaultModel
        BASE_URL = $defaultBaseUrl
        API_KEY = $authToken
    }
    thinkingEnabled = $true
    reasoningEffort = 'max'
} | ConvertTo-Json -Depth 5)

Write-Utf8NoBomFile -FilePath $configFile -Content $configContent
Write-Host 'Configuration saved.' -ForegroundColor Green
Write-Host "Config: $configFile"
Write-Host "BASE_URL: $defaultBaseUrl"
Write-Host "AUTH_TOKEN: $(if ($authToken -eq $existingToken -and -not [string]::IsNullOrWhiteSpace($existingToken)) { 'kept existing value' } else { 'updated' })"
Write-Host "DEFAULT_MODEL: $defaultModel"