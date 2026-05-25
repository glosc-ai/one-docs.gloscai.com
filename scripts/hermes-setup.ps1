#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'

$defaultBaseUrl = 'https://one.gloscai.com/v1'

function Get-TrimmedValue { param([string]$Value) if ($null -eq $Value) { return '' } return $Value.Trim() }
function Read-SecretValue { param([string]$Prompt) $secureValue = Read-Host -Prompt $Prompt -AsSecureString; if ($null -eq $secureValue) { return '' }; $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureValue); try { return Get-TrimmedValue ([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)) } finally { if ($ptr -ne [IntPtr]::Zero) { [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) } } }
function Get-EnvironmentValue { param([string]$Name) $processValue = [Environment]::GetEnvironmentVariable($Name, 'Process'); if (-not [string]::IsNullOrWhiteSpace($processValue)) { return $processValue }; $userValue = [Environment]::GetEnvironmentVariable($Name, 'User'); if (-not [string]::IsNullOrWhiteSpace($userValue)) { return $userValue }; return '' }
function Prompt-RequiredValue { param([string]$Prompt, [string]$ExistingValue = '', [switch]$Secret) while ($true) { if (-not [string]::IsNullOrWhiteSpace($ExistingValue)) { Write-Host 'Press Enter to keep the current value.' }; $inputValue = if ($Secret) { Read-SecretValue $Prompt } else { Get-TrimmedValue (Read-Host -Prompt $Prompt) }; if (-not [string]::IsNullOrWhiteSpace($inputValue)) { return $inputValue }; if (-not [string]::IsNullOrWhiteSpace($ExistingValue)) { return $ExistingValue }; Write-Host 'Value cannot be empty.' -ForegroundColor Red; Write-Host '' } }
function Write-Utf8NoBomFile { param([string]$FilePath, [string]$Content) $directory = Split-Path -Path $FilePath -Parent; if (-not (Test-Path -Path $directory)) { New-Item -ItemType Directory -Path $directory -Force | Out-Null }; $encoding = New-Object System.Text.UTF8Encoding($false); [System.IO.File]::WriteAllText($FilePath, $Content, $encoding) }
function ConvertTo-YamlDoubleQuoted { param([string]$Value) return '"' + $Value.Replace('\', '\\').Replace('"', '\"') + '"' }
function Update-DotEnvValue { param([string]$FilePath, [string]$Name, [string]$Value) $directory = Split-Path -Path $FilePath -Parent; if (-not (Test-Path -Path $directory)) { New-Item -ItemType Directory -Path $directory -Force | Out-Null }; $line = "$Name=$Value"; $lines = if (Test-Path -Path $FilePath) { @(Get-Content -Path $FilePath) } else { @() }; $output = New-Object System.Collections.Generic.List[string]; $written = $false; foreach ($existingLine in $lines) { if ($existingLine -match "^$([regex]::Escape($Name))=") { if (-not $written) { $output.Add($line); $written = $true }; continue }; $output.Add($existingLine) }; if (-not $written) { $output.Add($line) }; Write-Utf8NoBomFile -FilePath $FilePath -Content (($output -join "`n") + "`n") }
function Update-HermesModelConfig { param([string]$FilePath, [string]$ModelBlock) $lines = if (Test-Path -Path $FilePath) { @(Get-Content -Path $FilePath) } else { @() }; $output = New-Object System.Collections.Generic.List[string]; $inModel = $false; $written = $false; foreach ($line in $lines) { if ($line -match '^model:\s*$') { if (-not $written) { foreach ($blockLine in ($ModelBlock -split "`n")) { if ($blockLine.Length -gt 0) { $output.Add($blockLine) } }; $written = $true }; $inModel = $true; continue }; if ($inModel -and $line -match '^[^\s#][^:]*:') { $inModel = $false }; if (-not $inModel) { $output.Add($line) } }; if (-not $written) { if ($output.Count -gt 0 -and $output[$output.Count - 1].Length -gt 0) { $output.Add('') }; foreach ($blockLine in ($ModelBlock -split "`n")) { if ($blockLine.Length -gt 0) { $output.Add($blockLine) } } }; Write-Utf8NoBomFile -FilePath $FilePath -Content (($output -join "`n") + "`n") }

$hermesDir = Join-Path $HOME '.hermes'
$configFile = Join-Path $hermesDir 'config.yaml'
$envFile = Join-Path $hermesDir '.env'
$existingToken = Get-EnvironmentValue 'ONE_API_KEY'

Write-Host '=== Hermes setup ==='
Write-Host ''
Write-Host "base_url will be set to: $defaultBaseUrl"
Write-Host ''
$authToken = Prompt-RequiredValue -Prompt 'AUTH_TOKEN' -ExistingValue $existingToken -Secret
Write-Host ''
$defaultModel = Prompt-RequiredValue -Prompt 'DEFAULT_MODEL'
Write-Host ''

[Environment]::SetEnvironmentVariable('ONE_API_KEY', $authToken, 'User')
Set-Item -Path 'Env:ONE_API_KEY' -Value $authToken
Update-DotEnvValue -FilePath $envFile -Name 'ONE_API_KEY' -Value $authToken

$apiKeyRef = '${ONE_API_KEY}'
$modelBlock = @"
model:
  provider: custom
  default: $(ConvertTo-YamlDoubleQuoted $defaultModel)
  base_url: $(ConvertTo-YamlDoubleQuoted $defaultBaseUrl)
  api_key: $(ConvertTo-YamlDoubleQuoted $apiKeyRef)
  api_mode: chat_completions
  context_length: 128000
"@

Update-HermesModelConfig -FilePath $configFile -ModelBlock $modelBlock
Write-Host 'Configuration saved.' -ForegroundColor Green
Write-Host "Config: $configFile"
Write-Host "Env: $envFile"
Write-Host "BASE_URL: $defaultBaseUrl"
Write-Host "AUTH_TOKEN: $(if ($authToken -eq $existingToken -and -not [string]::IsNullOrWhiteSpace($existingToken)) { 'kept existing value' } else { 'updated' })"
Write-Host "DEFAULT_MODEL: $defaultModel"
Write-Host 'Start a new Hermes session for the model change to take effect.'