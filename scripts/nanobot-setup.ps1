#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'
$defaultBaseUrl = 'https://one.gloscai.com/v1'
$providerName = 'one'

function Get-TrimmedValue { param([string]$Value) if ($null -eq $Value) { return '' } return $Value.Trim() }
function Read-SecretValue { param([string]$Prompt) $secureValue = Read-Host -Prompt $Prompt -AsSecureString; if ($null -eq $secureValue) { return '' }; $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureValue); try { return Get-TrimmedValue ([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)) } finally { if ($ptr -ne [IntPtr]::Zero) { [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) } } }
function Prompt-RequiredValue { param([string]$Prompt, [string]$ExistingValue = '', [switch]$Secret) while ($true) { if (-not [string]::IsNullOrWhiteSpace($ExistingValue)) { Write-Host 'Press Enter to keep the current value.' }; $inputValue = if ($Secret) { Read-SecretValue $Prompt } else { Get-TrimmedValue (Read-Host -Prompt $Prompt) }; if (-not [string]::IsNullOrWhiteSpace($inputValue)) { return $inputValue }; if (-not [string]::IsNullOrWhiteSpace($ExistingValue)) { return $ExistingValue }; Write-Host 'Value cannot be empty.' -ForegroundColor Red; Write-Host '' } }
function Write-Utf8NoBomFile { param([string]$FilePath, [string]$Content) $directory = Split-Path -Path $FilePath -Parent; if (-not (Test-Path -Path $directory)) { New-Item -ItemType Directory -Path $directory -Force | Out-Null }; $encoding = New-Object System.Text.UTF8Encoding($false); [System.IO.File]::WriteAllText($FilePath, $Content, $encoding) }
function Get-NanobotValue { param([string]$FilePath, [string]$Kind) if (-not (Test-Path -Path $FilePath)) { return '' }; try { $json = Get-Content -Path $FilePath -Raw | ConvertFrom-Json; if ($Kind -eq 'model' -and $json.agents.defaults.model) { return [string]$json.agents.defaults.model }; if ($Kind -eq 'token' -and $json.providers.$providerName.apiKey) { return [string]$json.providers.$providerName.apiKey } } catch { return '' }; return '' }

$configFile = Join-Path (Join-Path $HOME '.nanobot') 'config.json'
$existingToken = Get-NanobotValue -FilePath $configFile -Kind 'token'
$existingModel = Get-NanobotValue -FilePath $configFile -Kind 'model'

Write-Host '=== nanobot setup ==='
Write-Host ''
Write-Host "apiBase will be set to: $defaultBaseUrl"
Write-Host ''
$authToken = Prompt-RequiredValue -Prompt 'AUTH_TOKEN' -ExistingValue $existingToken -Secret
Write-Host ''
$defaultModel = Prompt-RequiredValue -Prompt 'DEFAULT_MODEL' -ExistingValue $existingModel
Write-Host ''

$configContent = ([ordered]@{
    agents = [ordered]@{ defaults = [ordered]@{ model = $defaultModel; provider = $providerName } }
    providers = [ordered]@{ $providerName = [ordered]@{ apiKey = $authToken; apiBase = $defaultBaseUrl } }
} | ConvertTo-Json -Depth 8)

Write-Utf8NoBomFile -FilePath $configFile -Content $configContent
Write-Host 'Configuration saved.' -ForegroundColor Green
Write-Host "Config: $configFile"
Write-Host "BASE_URL: $defaultBaseUrl"
Write-Host "AUTH_TOKEN: $(if ($authToken -eq $existingToken -and -not [string]::IsNullOrWhiteSpace($existingToken)) { 'kept existing value' } else { 'updated' })"
Write-Host "DEFAULT_MODEL: $defaultModel"