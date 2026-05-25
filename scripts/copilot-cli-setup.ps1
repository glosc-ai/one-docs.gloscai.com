#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'

$defaultBaseUrl = 'https://one.gloscai.com/v1'

function Get-TrimmedValue {
    param([string]$Value)
    if ($null -eq $Value) { return '' }
    return $Value.Trim()
}

function Read-SecretValue {
    param([string]$Prompt)
    $secureValue = Read-Host -Prompt $Prompt -AsSecureString
    if ($null -eq $secureValue) { return '' }
    $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureValue)
    try { return Get-TrimmedValue ([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)) }
    finally {
        if ($ptr -ne [IntPtr]::Zero) { [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }
    }
}

function Get-EnvironmentValue {
    param([string]$Name)
    $processValue = [Environment]::GetEnvironmentVariable($Name, 'Process')
    if (-not [string]::IsNullOrWhiteSpace($processValue)) { return $processValue }
    $userValue = [Environment]::GetEnvironmentVariable($Name, 'User')
    if (-not [string]::IsNullOrWhiteSpace($userValue)) { return $userValue }
    return ''
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

function Set-UserEnvironmentValue {
    param([string]$Name, [string]$Value)
    [Environment]::SetEnvironmentVariable($Name, $Value, 'User')
    Set-Item -Path "Env:$Name" -Value $Value
}

Write-Host '=== GitHub Copilot CLI setup ==='
Write-Host ''
Write-Host "COPILOT_PROVIDER_BASE_URL will be set to: $defaultBaseUrl"
Write-Host ''

$existingToken = Get-EnvironmentValue 'COPILOT_PROVIDER_API_KEY'
$existingModel = Get-EnvironmentValue 'COPILOT_MODEL'

$authToken = Prompt-RequiredValue -Prompt 'AUTH_TOKEN' -ExistingValue $existingToken -Secret
Write-Host ''
$defaultModel = Prompt-RequiredValue -Prompt 'DEFAULT_MODEL' -ExistingValue $existingModel
Write-Host ''

$environmentValues = [ordered]@{
    COPILOT_PROVIDER_TYPE     = 'openai'
    COPILOT_PROVIDER_BASE_URL = $defaultBaseUrl
    COPILOT_PROVIDER_API_KEY  = $authToken
    COPILOT_MODEL             = $defaultModel
}

foreach ($entry in $environmentValues.GetEnumerator()) {
    Set-UserEnvironmentValue -Name $entry.Key -Value $entry.Value
}

Write-Host 'Configuration saved to user environment variables.' -ForegroundColor Green
Write-Host "BASE_URL: $defaultBaseUrl"
Write-Host "AUTH_TOKEN: $(if ($authToken -eq $existingToken -and -not [string]::IsNullOrWhiteSpace($existingToken)) { 'kept existing value' } else { 'updated' })"
Write-Host "DEFAULT_MODEL: $defaultModel"
Write-Host 'Open a new terminal window before running copilot.'