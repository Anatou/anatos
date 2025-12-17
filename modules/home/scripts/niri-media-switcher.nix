{ pkgs, ... }:
pkgs.writeShellScriptBin "niri-media-switcher" ''
#!/usr/bin/env bash
set -euo pipefail

MEDIA_NAME="media"
STATE_FILE="$HOME/.cache/niri-media-state.json"

workspaces_json="$(niri msg --json workspaces)"

# ---------------------------
# Helpers jq
# ---------------------------

focused_output=$(echo "$workspaces_json" | jq -r '.[] | select(.is_focused) | .output')
focused_ws=$(echo "$workspaces_json" | jq -r '.[] | select(.is_focused) | (.name // .idx)')
edp1_ws=$(echo "$workspaces_json" | jq -r '.[] | select(.output=="eDP-1" and .is_active) | (.name // .idx)')

media_entry=$(echo "$workspaces_json" | jq -r \
  ".[] | select(.name == \"$MEDIA_NAME\") | @json" || true)

media_output=""
media_active=false
media_ws=""

if [[ -n "$media_entry" ]]; then
  media_output=$(echo "$media_entry" | jq -r '.output')
  media_active=$(echo "$media_entry" | jq -r '.is_active')
  media_ws="$MEDIA_NAME"
fi

# ---------------------------
# 1️⃣ Media already focused → restore previous workspace
# ---------------------------

if [[ "$focused_ws" == "$MEDIA_NAME" ]]; then
  if [[ ! -f "$STATE_FILE" ]]; then
    exit 0
  fi

  prev_ws=$(jq -r '.focused_prev_ws // empty' "$STATE_FILE")
  prev_output=$(jq -r '.focused_output // empty' "$STATE_FILE")

  echo $prev_ws
  echo $prev_output

  # Restore previous workspace on the focused output
  if [[ -n "$prev_ws" ]]; then
    echo ""
    niri msg action focus-workspace $prev_ws
  else
    niri msg action focus-workspace 1
  fi

  # Move media back to eDP-1 (always)
  niri msg action move-workspace-to-monitor --reference $MEDIA_NAME eDP-1
  niri msg action move-workspace-to-index --reference $MEDIA_NAME 1

  if [[ "$focused_output" != "eDP-1" ]]; then
    niri msg action focus-monitor eDP-1
    niri msg action focus-workspace $(($edp1_ws+1))
    niri msg action focus-monitor $focused_output
  fi

  exit 0
fi

# ---------------------------
# 2️⃣ Save state
# ---------------------------

mkdir -p "$(dirname "$STATE_FILE")"

jq -n \
  --arg focused_output "$focused_output" \
  --arg focused_prev_ws "$focused_ws" \
  --arg media_prev_output "$media_output" \
  '
  {
    focused_output: $focused_output,
    focused_prev_ws: $focused_prev_ws
  }
  + (
      if ($media_prev_output | length) > 0
      then { media_prev_output: $media_prev_output }
      else {}
      end
    )
  ' > "$STATE_FILE"
# ---------------------------
# 3️⃣ Move media to focused screen
# ---------------------------

niri msg action move-workspace-to-monitor --reference $MEDIA_NAME $focused_output
niri msg action focus-workspace $MEDIA_NAME

# ---------------------------
# 4️⃣ Restore previous screen (if needed)
# ---------------------------

if [[ -n "$media_output" && "$media_output" != "$focused_output" ]]; then
  prev_ws=$(echo "$workspaces_json" | jq -r \
    ".[] | select(.output == \"$media_output\" and .is_active) | (.name // .idx)")

  if [[ -n "$prev_ws" ]]; then
    niri msg action focus-workspace $prev_ws
  fi
fi
''