#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'
$defaultBaseUrl = 'https://one.gloscai.com/v1'
$providerName = 'one'

function Get-TrimmedValue { param([string]$Value) if ($null -eq $Value) { return '' } return $Value.Trim() }
function Read-SecretValue { param([string]$Prompt) $secureValue = Read-Host -Prompt $Prompt -AsSecureString; if ($null -eq $secureValue) { return '' }; $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureValue); try { return Get-TrimmedValue ([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)) } finally { if ($ptr -ne [IntPtr]::Zero) { [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) } } }
function Get-EnvironmentValue { param([string]$Name) $processValue = [Environment]::GetEnvironmentVariable($Name, 'Process'); if (-not [string]::IsNullOrWhiteSpace($processValue)) { return $processValue }; $userValue = [Environment]::GetEnvironmentVariable($Name, 'User'); if (-not [string]::IsNullOrWhiteSpace($userValue)) { return $userValue }; return '' }
function Prompt-RequiredValue { param([string]$Prompt, [string]$ExistingValue = '', [switch]$Secret) while ($true) { if (-not [string]::IsNullOrWhiteSpace($ExistingValue)) { Write-Host 'Press Enter to keep the current value.' }; $inputValue = if ($Secret) { Read-SecretValue $Prompt } else { Get-TrimmedValue (Read-Host -Prompt $Prompt) }; if (-not [string]::IsNullOrWhiteSpace($inputValue)) { return $inputValue }; if (-not [string]::IsNullOrWhiteSpace($ExistingValue)) { return $ExistingValue }; Write-Host 'Value cannot be empty.' -ForegroundColor Red; Write-Host '' } }
function Write-Utf8NoBomFile { param([string]$FilePath, [string]$Content) $directory = Split-Path -Path $FilePath -Parent; if (-not (Test-Path -Path $directory)) { New-Item -ItemType Directory -Path $directory -Force | Out-Null }; $encoding = New-Object System.Text.UTF8Encoding($false); [System.IO.File]::WriteAllText($FilePath, $Content, $encoding) }

$configFile = Join-Path (Join-Path (Join-Path $HOME '.config') 'crush') 'crush.json'
$existingToken = Get-EnvironmentValue 'ONE_API_KEY'

Write-Host '=== Crush setup ==='
Write-Host ''
Write-Host "base_url will be set to: $defaultBaseUrl"
Write-Host ''
$authToken = Prompt-RequiredValue -Prompt 'AUTH_TOKEN' -ExistingValue $existingToken -Secret
Write-Host ''
$defaultModel = Prompt-RequiredValue -Prompt 'DEFAULT_MODEL'
Write-Host ''

[Environment]::SetEnvironmentVariable('ONE_API_KEY', $authToken, 'User')
Set-Item -Path 'Env:ONE_API_KEY' -Value $authToken

$configContent = ([ordered]@{
    '$schema' = 'https://charm.land/crush.json'
    providers = [ordered]@{
        $providerName = [ordered]@{
            type = 'openai-compat'
            base_url = $defaultBaseUrl
            api_key = '$ONE_API_KEY'
            models = @([ordered]@{
                id = $defaultModel
                name = $defaultModel
                context_window = 1000000
                default_max_tokens = 32768
                can_reason = $true
            })
        }
    }
} | ConvertTo-Json -Depth 8)

Write-Utf8NoBomFile -FilePath $configFile -Content $configContent
Write-Host 'Configuration saved.' -ForegroundColor Green
Write-Host "Config: $configFile"
Write-Host "BASE_URL: $defaultBaseUrl"
Write-Host "AUTH_TOKEN: $(if ($authToken -eq $existingToken -and -not [string]::IsNullOrWhiteSpace($existingToken)) { 'kept existing value' } else { 'updated' })"
Write-Host "DEFAULT_MODEL: $defaultModel"
Write-Host 'Open a new terminal window before running crush.'