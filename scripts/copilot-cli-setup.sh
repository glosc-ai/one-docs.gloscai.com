#!/usr/bin/env bash

set -Eeuo pipefail
umask 077

DEFAULT_BASE_URL='https://one.gloscai.com/v1'

if ! [ -r /dev/tty ]; then
  echo 'Error: /dev/tty is not readable. Please run this script in an interactive terminal.' >&2
  exit 1
fi

trim() { printf '%s' "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'; }
read_tty() { local prompt="${1:-}" input; read -r -p "$prompt" input < /dev/tty || true; printf '%s' "${input:-}"; }
read_secret_tty() { local prompt="${1:-}" input; read -r -s -p "$prompt" input < /dev/tty || true; echo >&2; printf '%s' "${input:-}"; }
sh_single_quote() { printf "'%s'" "$(printf '%s' "${1:-}" | sed "s/'/'\\''/g")"; }

upsert_export() {
  local rcfile="${1:-}" key="${2:-}" value="${3:-}"
  [ -n "$rcfile" ] || return 1
  [ -n "$key" ] || return 1
  mkdir -p "$(dirname "$rcfile")"
  [ -f "$rcfile" ] || touch "$rcfile"
  local line="export $key=$(sh_single_quote "$value")"
  local pattern="^[[:space:]]*(export[[:space:]]+)?$key="
  if grep -Eq "$pattern" "$rcfile"; then
    sed -i.bak -E "s|$pattern.*$|$line|g" "$rcfile"
    rm -f "$rcfile.bak"
  else
    printf '%s\n' "$line" >> "$rcfile"
  fi
}

read_env_from_rcs() {
  local key="${1:-}" value=''
  [ -n "$key" ] || { printf '%s' ''; return 0; }
  value="$(printenv "$key" || true)"
  if [ -n "$value" ]; then printf '%s' "$value"; return 0; fi
  for rcfile in "$HOME/.zshrc" "$HOME/.bashrc"; do
    [ -f "$rcfile" ] || continue
    local line
    line="$(grep -E '^[[:space:]]*(export[[:space:]]+)?'"$key"'=' "$rcfile" | tail -n 1 || true)"
    [ -n "$line" ] || continue
    line="${line#export }"
    line="${line#"$key"=}"
    line="$(trim "$line")"
    line="$(printf '%s' "$line" | sed -E "s/^'(.*)'$/\1/; s/^\"(.*)\"$/\1/")"
    printf '%s' "$line"
    return 0
  done
  printf '%s' ''
}

prompt_required_value() {
  local label="${1:-Value}" existing_value="${2:-}" secret="${3:-false}"
  while true; do
    if [ -n "$existing_value" ]; then echo 'Press Enter to keep the current value.' >&2; fi
    local input_value=''
    if [ "$secret" = 'true' ]; then input_value="$(read_secret_tty "$label: ")"; else input_value="$(read_tty "$label: ")"; fi
    input_value="$(trim "$input_value")"
    input_value="$(printf '%s' "$input_value" | tr -d '\r\n')"
    if [ -n "$input_value" ]; then printf '%s' "$input_value"; return 0; fi
    if [ -n "$existing_value" ]; then printf '%s' "$existing_value"; return 0; fi
    echo 'Value cannot be empty.' >&2
    echo >&2
  done
}

main() {
  local existing_token existing_model auth_token default_model
  existing_token="$(read_env_from_rcs 'COPILOT_PROVIDER_API_KEY')"
  existing_model="$(read_env_from_rcs 'COPILOT_MODEL')"

  echo '=== GitHub Copilot CLI setup ==='
  echo
  echo "COPILOT_PROVIDER_BASE_URL will be set to: $DEFAULT_BASE_URL"
  echo
  auth_token="$(prompt_required_value 'AUTH_TOKEN' "$existing_token" 'true')"
  echo
  default_model="$(prompt_required_value 'DEFAULT_MODEL' "$existing_model" 'false')"
  echo

  for rcfile in "$HOME/.zshrc" "$HOME/.bashrc"; do
    upsert_export "$rcfile" 'COPILOT_PROVIDER_TYPE' 'openai'
    upsert_export "$rcfile" 'COPILOT_PROVIDER_BASE_URL' "$DEFAULT_BASE_URL"
    upsert_export "$rcfile" 'COPILOT_PROVIDER_API_KEY' "$auth_token"
    upsert_export "$rcfile" 'COPILOT_MODEL' "$default_model"
  done

  echo 'Configuration saved to ~/.zshrc and ~/.bashrc.'
  echo "BASE_URL: $DEFAULT_BASE_URL"
  if [ "$auth_token" = "$existing_token" ] && [ -n "$existing_token" ]; then echo 'AUTH_TOKEN: kept existing value'; else echo 'AUTH_TOKEN: updated'; fi
  echo "DEFAULT_MODEL: $default_model"
  echo 'Open a new terminal window, or run: source ~/.zshrc'
}

main "$@"