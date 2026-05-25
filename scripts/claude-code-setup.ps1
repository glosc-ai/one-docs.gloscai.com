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

function Get-EnvironmentValue {
    param([string]$Name)

    $processValue = [Environment]::GetEnvironmentVariable($Name, 'Process')
    if (-not [string]::IsNullOrWhiteSpace($processValue)) {
        return $processValue
    }

    $userValue = [Environment]::GetEnvironmentVariable($Name, 'User')
    if (-not [string]::IsNullOrWhiteSpace($userValue)) {
        return $userValue
    }

    return ''
}

function Prompt-RequiredValue {
    param(
        [string]$Prompt,
        [string]$ExistingValue = '',
        [switch]$Secret
    )

    while ($true) {
        if (-not [string]::IsNullOrWhiteSpace($ExistingValue)) {
            Write-Host "Press Enter to keep the current value."
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

function Set-UserEnvironmentValue {
    param(
        [string]$Name,
        [string]$Value
    )

    [Environment]::SetEnvironmentVariable($Name, $Value, 'User')
    Set-Item -Path "Env:$Name" -Value $Value
}

Write-Host '=== Claude Code setup ==='
Write-Host ''
Write-Host "ANTHROPIC_BASE_URL will be set to: $defaultBaseUrl"
Write-Host ''

$existingToken = Get-EnvironmentValue 'ANTHROPIC_AUTH_TOKEN'
$existingModel = Get-EnvironmentValue 'ANTHROPIC_MODEL'

$authToken = Prompt-RequiredValue -Prompt 'AUTH_TOKEN' -ExistingValue $existingToken -Secret
Write-Host ''
$defaultModel = Prompt-RequiredValue -Prompt 'DEFAULT_MODEL' -ExistingValue $existingModel
Write-Host ''

$environmentValues = [ordered]@{
    ANTHROPIC_BASE_URL             = $defaultBaseUrl
    ANTHROPIC_AUTH_TOKEN           = $authToken
    ANTHROPIC_MODEL                = $defaultModel
    ANTHROPIC_DEFAULT_OPUS_MODEL   = $defaultModel
    ANTHROPIC_DEFAULT_SONNET_MODEL = $defaultModel
    ANTHROPIC_DEFAULT_HAIKU_MODEL  = $defaultModel
    CLAUDE_CODE_SUBAGENT_MODEL     = $defaultModel
}

foreach ($entry in $environmentValues.GetEnumerator()) {
    Set-UserEnvironmentValue -Name $entry.Key -Value $entry.Value
}

Write-Host 'Configuration saved to user environment variables.' -ForegroundColor Green
Write-Host "ANTHROPIC_BASE_URL: $defaultBaseUrl"
Write-Host "ANTHROPIC_AUTH_TOKEN: $(if ($authToken -eq $existingToken) { 'kept existing value' } else { 'updated' })"
Write-Host "DEFAULT_MODEL: $defaultModel"
Write-Host ''
Write-Host 'Open a new terminal window, or keep using the current PowerShell session.'
