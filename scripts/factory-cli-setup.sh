#!/usr/bin/env bash

set -Eeuo pipefail
umask 077

DEFAULT_BASE_URL='https://one.gloscai.com/v1'

if ! [ -r /dev/tty ]; then
  echo 'Error: /dev/tty is not readable. Please run this script in an interactive terminal.' >&2
  exit 1
fi

trim() {
  printf '%s' "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

read_tty() {
  local prompt="${1:-}"
  local input
  read -r -p "$prompt" input < /dev/tty || true
  printf '%s' "${input:-}"
}

read_secret_tty() {
  local prompt="${1:-}"
  local input
  read -r -s -p "$prompt" input < /dev/tty || true
  echo >&2
  printf '%s' "${input:-}"
}

json_escape() {
  local str="${1:-}"
  str="${str//\\/\\\\}"
  str="${str//"/\\"}"
  str="${str//$'\n'/\\n}"
  str="${str//$'\r'/\\r}"
  str="${str//$'\t'/\\t}"
  printf '%s' "$str"
}

prompt_required_value() {
  local label="${1:-Value}"
  local existing_value="${2:-}"
  local secret="${3:-false}"

  while true; do
    if [ -n "$existing_value" ]; then
      echo 'Press Enter to keep the current value.' >&2
    fi

    local input_value=''
    if [ "$secret" = 'true' ]; then
      input_value="$(read_secret_tty "$label: ")"
    else
      input_value="$(read_tty "$label: ")"
    fi

    input_value="$(trim "$input_value")"
    input_value="$(printf '%s' "$input_value" | tr -d '\r\n')"

    if [ -n "$input_value" ]; then
      printf '%s' "$input_value"
      return 0
    fi

    if [ -n "$existing_value" ]; then
      printf '%s' "$existing_value"
      return 0
    fi

    echo 'Value cannot be empty.' >&2
    echo >&2
  done
}

get_factory_value() {
  local file_path="${1:-}"
  local field_name="${2:-}"
  [ -f "$file_path" ] || return 0
  sed -n "s/.*\"$field_name\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" "$file_path" | head -n 1 | tr -d '\r\n'
}

main() {
  local factory_dir="$HOME/.factory"
  local config_file="$factory_dir/config.json"
  local existing_model existing_token auth_token default_model

  existing_model="$(get_factory_value "$config_file" 'model')"
  existing_token="$(get_factory_value "$config_file" 'api_key')"

  echo '=== Factory Droid CLI setup ==='
  echo
  echo "OPENAI base_url will be set to: $DEFAULT_BASE_URL"
  echo

  auth_token="$(prompt_required_value 'AUTH_TOKEN' "$existing_token" 'true')"
  echo
  default_model="$(prompt_required_value 'DEFAULT_MODEL' "$existing_model" 'false')"
  echo

  mkdir -p "$factory_dir"

  cat > "$config_file" <<EOF
{
  "custom_models": [
    {
      "model_display_name": "$(json_escape "$default_model [custom]")",
      "model": "$(json_escape "$default_model")",
      "base_url": "$DEFAULT_BASE_URL",
      "api_key": "$(json_escape "$auth_token")",
      "provider": "openai",
      "max_tokens": 128000
    }
  ]
}
EOF

  chmod 700 "$factory_dir" 2>/dev/null || true
  chmod 600 "$config_file" 2>/dev/null || true

  echo 'Configuration saved to Factory Droid config file.'
  echo "Config: $config_file"
  echo "BASE_URL: $DEFAULT_BASE_URL"
  if [ "$auth_token" = "$existing_token" ] && [ -n "$existing_token" ]; then
    echo 'AUTH_TOKEN: kept existing value'
  else
    echo 'AUTH_TOKEN: updated'
  fi
  echo "DEFAULT_MODEL: $default_model"
}

main "$@"