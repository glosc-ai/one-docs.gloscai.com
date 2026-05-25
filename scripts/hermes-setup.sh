#!/usr/bin/env bash

set -Eeuo pipefail
umask 077

DEFAULT_BASE_URL='https://one.gloscai.com/v1'

if ! [ -r /dev/tty ]; then echo 'Error: /dev/tty is not readable. Please run this script in an interactive terminal.' >&2; exit 1; fi

trim() { printf '%s' "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'; }
read_tty() { local prompt="${1:-}" input; read -r -p "$prompt" input < /dev/tty || true; printf '%s' "${input:-}"; }
read_secret_tty() { local prompt="${1:-}" input; read -r -s -p "$prompt" input < /dev/tty || true; echo >&2; printf '%s' "${input:-}"; }
yaml_double_quote() { local str="${1:-}"; str="${str//\\/\\\\}"; str="${str//"/\\"}"; printf '"%s"' "$str"; }
sh_single_quote() { printf "'%s'" "$(printf '%s' "${1:-}" | sed "s/'/'\\''/g")"; }
upsert_export() { local rcfile="${1:-}" key="${2:-}" value="${3:-}"; mkdir -p "$(dirname "$rcfile")"; [ -f "$rcfile" ] || touch "$rcfile"; local line="export $key=$(sh_single_quote "$value")" pattern="^[[:space:]]*(export[[:space:]]+)?$key="; if grep -Eq "$pattern" "$rcfile"; then sed -i.bak -E "s|$pattern.*$|$line|g" "$rcfile"; rm -f "$rcfile.bak"; else printf '%s\n' "$line" >> "$rcfile"; fi; }
read_env_from_rcs() { local key="${1:-}" value; value="$(printenv "$key" || true)"; if [ -n "$value" ]; then printf '%s' "$value"; return 0; fi; for rcfile in "$HOME/.zshrc" "$HOME/.bashrc"; do [ -f "$rcfile" ] || continue; local line; line="$(grep -E '^[[:space:]]*(export[[:space:]]+)?'"$key"'=' "$rcfile" | tail -n 1 || true)"; [ -n "$line" ] || continue; line="${line#export }"; line="${line#"$key"=}"; line="$(trim "$line")"; line="$(printf '%s' "$line" | sed -E "s/^'(.*)'$/\1/; s/^\"(.*)\"$/\1/")"; printf '%s' "$line"; return 0; done; printf '%s' ''; }
prompt_required_value() { local label="${1:-Value}" existing_value="${2:-}" secret="${3:-false}"; while true; do if [ -n "$existing_value" ]; then echo 'Press Enter to keep the current value.' >&2; fi; local input_value=''; if [ "$secret" = 'true' ]; then input_value="$(read_secret_tty "$label: ")"; else input_value="$(read_tty "$label: ")"; fi; input_value="$(trim "$input_value")"; input_value="$(printf '%s' "$input_value" | tr -d '\r\n')"; if [ -n "$input_value" ]; then printf '%s' "$input_value"; return 0; fi; if [ -n "$existing_value" ]; then printf '%s' "$existing_value"; return 0; fi; echo 'Value cannot be empty.' >&2; echo >&2; done; }
upsert_env_value() { local file="${1:-}" key="${2:-}" value="${3:-}" line tmp; mkdir -p "$(dirname "$file")"; line="$key=$value"; tmp="$(mktemp)"; if [ -f "$file" ]; then awk -v key="$key" -v line="$line" 'BEGIN{done=0} $0 ~ "^" key "=" { if (!done) { print line; done=1 } next } { print } END { if (!done) print line }' "$file" > "$tmp"; else printf '%s\n' "$line" > "$tmp"; fi; mv "$tmp" "$file"; chmod 600 "$file" 2>/dev/null || true; }
replace_model_block() { local file="${1:-}" block="${2:-}" tmp; mkdir -p "$(dirname "$file")"; tmp="$(mktemp)"; if [ -f "$file" ]; then awk -v block="$block" 'BEGIN{in_model=0; done=0} /^model:[[:space:]]*$/ { if (!done) { print block; done=1 } in_model=1; next } in_model && /^[^[:space:]#][^:]*:/ { in_model=0 } !in_model { print } END { if (!done) { if (NR > 0) print ""; print block } }' "$file" > "$tmp"; else printf '%s\n' "$block" > "$tmp"; fi; mv "$tmp" "$file"; chmod 600 "$file" 2>/dev/null || true; }

main() {
  local hermes_dir="$HOME/.hermes" config_file="$HOME/.hermes/config.yaml" env_file="$HOME/.hermes/.env" existing_token auth_token default_model model_block
  existing_token="$(read_env_from_rcs 'ONE_API_KEY')"
  echo '=== Hermes setup ==='; echo; echo "base_url will be set to: $DEFAULT_BASE_URL"; echo
  auth_token="$(prompt_required_value 'AUTH_TOKEN' "$existing_token" 'true')"; echo
  default_model="$(prompt_required_value 'DEFAULT_MODEL' '' 'false')"; echo
  for rcfile in "$HOME/.zshrc" "$HOME/.bashrc"; do upsert_export "$rcfile" 'ONE_API_KEY' "$auth_token"; done
  mkdir -p "$hermes_dir"
  upsert_env_value "$env_file" 'ONE_API_KEY' "$auth_token"
  model_block="model:
  provider: custom
  default: $(yaml_double_quote "$default_model")
  base_url: $(yaml_double_quote "$DEFAULT_BASE_URL")
  api_key: \"\${ONE_API_KEY}\"
  api_mode: chat_completions
  context_length: 128000"
  replace_model_block "$config_file" "$model_block"
  echo 'Configuration saved.'
  echo "Config: $config_file"
  echo "Env: $env_file"
  echo "BASE_URL: $DEFAULT_BASE_URL"
  if [ "$auth_token" = "$existing_token" ] && [ -n "$existing_token" ]; then echo 'AUTH_TOKEN: kept existing value'; else echo 'AUTH_TOKEN: updated'; fi
  echo "DEFAULT_MODEL: $default_model"
  echo 'Start a new Hermes session for the model change to take effect.'
}

main "$@"