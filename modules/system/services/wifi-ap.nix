{ config, lib, pkgs, ... }:

let
  cfg = config.my.system.services.wifi-ap;

  wifiApCtl = pkgs.writeShellScriptBin "wifi-apctl" ''
    #!/usr/bin/env bash

    set -u

    WIFI="${cfg.wifiInterface}"
    AP_SERVICE="wifi-ap.service"
    STATE_DIR="/run/wifi-apctl"
    STATE_FILE="$STATE_DIR/fallback"

    NMCLI="${pkgs.networkmanager}/bin/nmcli"
    IW="${pkgs.iw}/bin/iw"
    SYSTEMCTL="${pkgs.systemd}/bin/systemctl"
    JOURNALCTL="${pkgs.systemd}/bin/journalctl"
    IP="${pkgs.iproute2}/bin/ip"
    GREP="${pkgs.gnugrep}/bin/grep"
    AWK="${pkgs.gawk}/bin/awk"
    SORT="${pkgs.coreutils}/bin/sort"
    HEAD="${pkgs.coreutils}/bin/head"
    SLEEP="${pkgs.coreutils}/bin/sleep"
    DATE="${pkgs.coreutils}/bin/date"
    MKDIR="${pkgs.coreutils}/bin/mkdir"
    RM="${pkgs.coreutils}/bin/rm"
    CAT="${pkgs.coreutils}/bin/cat"
    TR="${pkgs.coreutils}/bin/tr"

    AP_READY="/run/wifi-ap/ready"

    # Codes de retour utilisés par wifi-ap.
    # 75 = canal/fréquence incompatible avec le mode AP.
    CHANNEL_INCOMPATIBLE=75

    log() {
      printf '[wifi-apctl] %s\n' "$*" >&2
    }

    ok() {
      printf '  ✓ %s\n' "$*"
    }

    warn() {
      printf '  ! %s\n' "$*" >&2
    }

    error() {
      printf '  ✗ %s\n' "$*" >&2
    }

    require_root() {
      if [ "$EUID" -ne 0 ]; then
        error "wifi-apctl doit être lancé en root."
        error "Essaie : sudo wifi-apctl $*"
        exit 1
      fi
    }

    current_connection() {
      "$NMCLI" -g GENERAL.CONNECTION device show "$WIFI" 2>/dev/null \
        | "$HEAD" -n 1
    }

    current_ssid() {
      "$IW" dev "$WIFI" link 2>/dev/null \
        | "$AWK" -F': ' '/^[[:space:]]*SSID:/ {print $2; exit}'
    }

    current_bssid() {
      "$IW" dev "$WIFI" link 2>/dev/null \
        | "$AWK" '/Connected to/ {print $3; exit}'
    }

    current_freq() {
		"$IW" dev "$WIFI" link 2>/dev/null \
			| "$AWK" '/^[[:space:]]*freq:/ {
				f = $2
				sub(/\.0$/, "", f)
				print f
				exit
			}'
	}

    current_channel() {
      local freq
      freq="$(current_freq)"

      case "$freq" in
        2412) echo 1 ;;
        2417) echo 2 ;;
        2422) echo 3 ;;
        2427) echo 4 ;;
        2432) echo 5 ;;
        2437) echo 6 ;;
        2442) echo 7 ;;
        2447) echo 8 ;;
        2452) echo 9 ;;
        2457) echo 10 ;;
        2462) echo 11 ;;
        2467) echo 12 ;;
        2472) echo 13 ;;

        5180) echo 36 ;;
        5200) echo 40 ;;
        5220) echo 44 ;;
        5240) echo 48 ;;
        5260) echo 52 ;;
        5280) echo 56 ;;
        5300) echo 60 ;;
        5320) echo 64 ;;
        5500) echo 100 ;;
        5520) echo 104 ;;
        5540) echo 108 ;;
        5560) echo 112 ;;
        5580) echo 116 ;;
        5600) echo 120 ;;
        5620) echo 124 ;;
        5640) echo 128 ;;
        5660) echo 132 ;;
        5680) echo 136 ;;
        5700) echo 140 ;;
        5720) echo 144 ;;
        5745) echo 149 ;;
        5765) echo 153 ;;
        5785) echo 157 ;;
        5805) echo 161 ;;
        5825) echo 165 ;;

        *) echo "" ;;
      esac
    }

    show_link() {
      local ssid bssid freq channel

      ssid="$(current_ssid)"
      bssid="$(current_bssid)"
      freq="$(current_freq)"
      channel="$(current_channel)"

      if [ -n "$ssid" ]; then
        printf '  SSID      : %s\n' "$ssid"
        printf '  BSSID     : %s\n' "$bssid"
        printf '  fréquence : %s MHz\n' "$freq"
        printf '  canal     : %s\n' "$channel"
      else
        printf '  Wi-Fi     : non connecté\n'
      fi
    }

    service_failed_status() {
      local rc

      rc="$("$SYSTEMCTL" show -p ExecMainStatus --value "$AP_SERVICE" 2>/dev/null || true)"

      if [ -z "$rc" ]; then
        rc=1
      fi

      case "$rc" in
        0|"")
          rc=1
          ;;
      esac

      return "$rc"
    }

    channel_error_in_journal() {
      "$JOURNALCTL" \
        -u "$AP_SERVICE" \
        -n 100 \
        --no-pager \
        2>/dev/null \
        | "$GREP" -Eqi \
          'NO-IR|Primary frequency not allowed|Hardware does not support configured channel|Could not select hw_mode and channel|configured channel.*not'
    }

    start_ap_service() {
		log "Démarrage de $AP_SERVICE..."

		"$SYSTEMCTL" reset-failed "$AP_SERVICE" 2>/dev/null || true

		if ! "$SYSTEMCTL" start "$AP_SERVICE"; then
			local rc
			rc="$("$SYSTEMCTL" show -p ExecMainStatus --value "$AP_SERVICE" 2>/dev/null || echo 1)"

			[ -n "$rc" ] || rc=1

			return "$rc"
		fi

		# systemctl start retourne rapidement pour Type=simple.
		# On attend que le service soit réellement prêt ou qu'il échoue.
		local i
		for i in 1 2 3 4 5 6 7 8 9 10; do

			if "$SYSTEMCTL" is-failed --quiet "$AP_SERVICE"; then
				local rc
				rc="$("$SYSTEMCTL" show -p ExecMainStatus --value "$AP_SERVICE" 2>/dev/null || echo 1)"

				[ -n "$rc" ] || rc=1

				return "$rc"
			fi

			if "$SYSTEMCTL" is-active --quiet "$AP_SERVICE"; then
				# Si ton service crée ce fichier, c'est la meilleure
				# indication qu'il est réellement prêt.
				if [ -e "/run/wifi-ap/ready" ]; then
					ok "AP démarré."
					return 0
				fi

				# À défaut du fichier ready, laisser quelques secondes
				# au service avant de considérer qu'il est OK.
				if [ "$i" -ge 3 ]; then
					ok "Service AP actif."
					return 0
				fi
			fi

			"$SLEEP" 1
		done

		if "$SYSTEMCTL" is-active --quiet "$AP_SERVICE"; then
			ok "Service AP actif."
			return 0
		fi

		local rc
		rc="$("$SYSTEMCTL" show -p ExecMainStatus --value "$AP_SERVICE" 2>/dev/null || echo 1)"
		[ -n "$rc" ] || rc=1

		return "$rc"
	}

    stop_ap_service() {
      if "$SYSTEMCTL" is-active --quiet "$AP_SERVICE" 2>/dev/null; then
        log "Arrêt de $AP_SERVICE..."
        "$SYSTEMCTL" stop "$AP_SERVICE"
        ok "AP arrêté."
      else
        log "AP déjà arrêté."
      fi
    }

    scan_candidates() {
      local ssid current_bssid

      ssid="$(current_ssid)"
      current_bssid="$(current_bssid)"

      [ -n "$ssid" ] || return 0

      log "Recherche d'autres BSSID pour SSID : $ssid"

      "$NMCLI" device wifi rescan ifname "$WIFI" 2>/dev/null || true
      "$SLEEP" 1

      "$NMCLI" \
        -t \
        --separator $'\t' \
        -f BSSID,SSID,FREQ,SIGNAL,CHAN \
        device wifi list \
        2>/dev/null \
      | while IFS=$'\t' read -r bssid candidate_ssid freq signal channel; do

          [ "$candidate_ssid" = "$ssid" ] || continue
          [ "$bssid" = "$current_bssid" ] && continue
          [ -n "$bssid" ] || continue

          printf '%s\t%s\t%s\t%s\n' \
            "$bssid" \
            "$freq" \
            "$signal" \
            "$channel"
        done \
      | "$SORT" -t $'\t' -k3,3nr
    }

    jump_to_bssid() {
      local connection="$1"
      local bssid="$2"
      local freq="$3"
      local signal="$4"
      local channel="$5"

      printf '\n'
      log "Tentative avec un autre BSSID :"
      printf '  BSSID     : %s\n' "$bssid"
      printf '  fréquence : %s MHz\n' "$freq"
      printf '  canal     : %s\n' "$channel"
      printf '  signal    : %s%%\n' "$signal"

      if "$NMCLI" connection up \
          id "$connection" \
          ifname "$WIFI" \
          ap "$bssid" \
          >/dev/null 2>&1; then

        # Laisser NM terminer l'association.
        "$SLEEP" 2

        local actual_bssid
        actual_bssid="$(current_bssid)"

        if [ "$actual_bssid" = "$bssid" ]; then
          ok "Connecté à $bssid."
          return 0
        fi

        warn "NM n'a pas confirmé le BSSID demandé."
        return 1
      fi

      warn "Impossible de se connecter à $bssid."
      return 1
    }

    try_other_bssids() {
      local connection
      local candidates
      local bssid freq signal channel
      local rc

      connection="$(current_connection)"

      if [ -z "$connection" ] || [ "$connection" = "--" ]; then
        error "Aucun profil NetworkManager actif."
        return 1
      fi

      candidates="$(scan_candidates)"

      if [ -z "$candidates" ]; then
        warn "Aucun autre BSSID trouvé pour ce SSID."
        return 1
      fi

      while IFS=$'\t' read -r bssid freq signal channel; do
        [ -n "$bssid" ] || continue

        jump_to_bssid \
          "$connection" \
          "$bssid" \
          "$freq" \
          "$signal" \
          "$channel" || continue

        log "Nouvelle tentative de démarrage de l'AP..."

        start_ap_service
        rc=$?

        if [ "$rc" -eq 0 ]; then
          ok "AP démarré après changement de BSSID."
          return 0
        fi

        if [ "$rc" -ne "$CHANNEL_INCOMPATIBLE" ]; then
          error "Le service wifi-ap a échoué pour une autre raison (code $rc)."
          return "$rc"
        fi

        warn "Canal $channel incompatible, on essaie le suivant."
      done <<< "$candidates"

      return 1
    }

    save_fallback_state() {
      local managed connected connection

      "$MKDIR" -p "$STATE_DIR"

      managed="$("$NMCLI" -g GENERAL.NM-MANAGED device show "$WIFI" 2>/dev/null || echo yes)"
      managed="$("$TR" '[:upper:]' '[:lower:]' <<< "$managed")"

      case "$managed" in
        yes|oui|true|vrai)
          managed="yes"
          ;;
        *)
          managed="no"
          ;;
      esac

      connection="$(current_connection)"

      if [ -n "$connection" ] && [ "$connection" != "--" ]; then
        connected="1"
      else
        connected="0"
        connection=""
      fi

      {
        printf '%s\n' "$managed"
        printf '%s\n' "$connected"
        printf '%s\n' "$connection"
      } > "$STATE_FILE"
    }

    fallback_disconnect() {
      log "Aucun BSSID compatible."
      log "Passage en mode AP sans connexion Wi-Fi amont."

      save_fallback_state

      "$NMCLI" device disconnect "$WIFI" >/dev/null 2>&1 || true

      # Empêche NetworkManager de se reconnecter automatiquement
      # pendant que l'AP fonctionne.
      "$NMCLI" device set "$WIFI" managed no

      "$SLEEP" 1

      start_ap_service
      local rc=$?

      if [ "$rc" -ne 0 ]; then
        error "Impossible de démarrer l'AP en mode fallback."
        restore_fallback
        return "$rc"
      fi

      ok "AP lancé sans connexion Wi-Fi amont."
      return 0
    }

    restore_fallback() {
      [ -f "$STATE_FILE" ] || return 0

      local managed connected connection

      mapfile -t state < "$STATE_FILE"

      managed="''${state[0]:-yes}"
      connected="''${state[1]:-0}"
      connection="''${state[2]:-}"

      log "Restauration de NetworkManager..."

      "$NMCLI" device set "$WIFI" managed "$managed" || true

      if [ "$connected" = "1" ] \
          && [ -n "$connection" ] \
          && [ "$managed" = "yes" ]; then

        log "Restauration de la connexion : $connection"

        "$NMCLI" connection up \
          id "$connection" \
          ifname "$WIFI" \
          >/dev/null 2>&1 || true
      fi

      "$RM" -f "$STATE_FILE"
      ok "NetworkManager restauré."
    }

    do_start() {
      if "$SYSTEMCTL" is-active --quiet "$AP_SERVICE" 2>/dev/null; then
        warn "L'AP est déjà actif."
        show_link
        return 0
      fi

      # Récupération d'un éventuel état laissé par un précédent
      # lancement interrompu.
      if [ -f "$STATE_FILE" ]; then
        warn "Un ancien état fallback existe, restauration préalable."
        restore_fallback
      fi

      printf '\n'
      printf '=== Wi-Fi AP ===\n'
      show_link
      printf '\n'

      local connection
      connection="$(current_connection)"

      if [ -z "$connection" ] || [ "$connection" = "--" ]; then
        warn "Pas de connexion Wi-Fi amont."
        fallback_disconnect
        return $?
      fi

      log "Tentative avec le BSSID actuel..."

      start_ap_service
      local rc=$?

      if [ "$rc" -eq 0 ]; then
        printf '\n'
        ok "AP démarré avec le BSSID actuel."
        return 0
      fi

      if [ "$rc" -ne "$CHANNEL_INCOMPATIBLE" ]; then
        error "wifi-ap a échoué (code $rc)."
        "$JOURNALCTL" -u "$AP_SERVICE" -n 30 --no-pager >&2 || true
        return "$rc"
      fi

      printf '\n'
      warn "Le canal du BSSID actuel ne permet pas le mode AP."
      log "Tentative de déplacement vers un autre BSSID du même SSID..."

      if try_other_bssids; then
        return 0
      fi

      printf '\n'
      warn "Aucun BSSID compatible trouvé."

      fallback_disconnect
    }

    do_stop() {
      stop_ap_service
      restore_fallback
    }

    do_status() {
      printf '=== wifi-apctl status ===\n'

      printf '\n[Wi-Fi amont]\n'
      show_link

      printf '\n[Connexion NetworkManager]\n'
      printf '  profil : %s\n' "$(current_connection)"

      printf '\n[AP]\n'

      if "$SYSTEMCTL" is-active --quiet "$AP_SERVICE" 2>/dev/null; then
        printf '  état   : actif\n'
      else
        printf '  état   : arrêté\n'
      fi

      if [ -e "$AP_READY" ]; then
        printf '  ready  : oui\n'
      else
        printf '  ready  : non\n'
      fi

	  if "$SYSTEMCTL" is-active --quiet "$AP_SERVICE" 2>/dev/null; then
		PASSWORD_FILE="/etc/wifi-ap/password"

		if [ -r "$PASSWORD_FILE" ]; then
			printf '\n[AP credentials]\n'
			printf '  mot de passe : %s\n' \
				"$(${pkgs.coreutils}/bin/tr -d '\n' < "$PASSWORD_FILE")"
		fi
      fi

      if [ -f "$STATE_FILE" ]; then
        printf '\n[Fallback]\n'
        printf '  mode   : Wi-Fi amont désactivé\n'
      fi
    }

    usage() {
      cat <<EOF
Usage:
  wifi-apctl start
  wifi-apctl stop
  wifi-apctl status

Le démarrage tente :
  1. BSSID actuel
  2. autres BSSID du même SSID
  3. fallback sans Wi-Fi amont
EOF
    }

    require_root "$@"

    case "''${1:-}" in
      start)
        do_start
        ;;
      stop)
        do_stop
        ;;
      status)
        do_status
        ;;
      *)
        usage
        exit 1
        ;;
    esac
  '';

  startScript = pkgs.writeShellScript "wifi-ap-start" ''
    set -eu

    WIFI="${cfg.wifiInterface}"
    AP="${cfg.apInterface}"
	PASSWORD_FILE="/etc/wifi-ap/password"

    AP_SSID="${cfg.ssid}"

    cleanup_configs() {
      rm -f "$HOSTAPD_CONFIG" "$DNSMASQ_CONFIG"
    }

    cleanup() {
      echo "Stopping Wi-Fi AP..."

      # Stop dnsmasq
      if [ -n "''${DNSMASQ_PID:-}" ]; then
        kill "$DNSMASQ_PID" 2>/dev/null || true
        wait "$DNSMASQ_PID" 2>/dev/null || true
      fi

      # Stop hostapd
      if [ -n "''${HOSTAPD_PID:-}" ]; then
        kill "$HOSTAPD_PID" 2>/dev/null || true
        wait "$HOSTAPD_PID" 2>/dev/null || true
      fi

      # Remove forwarding rules
      ${pkgs.iptables}/bin/iptables -D FORWARD \
        -i "$AP" \
        -o "$WIFI" \
        -j ACCEPT 2>/dev/null || true

      ${pkgs.iptables}/bin/iptables -D FORWARD \
        -i "$WIFI" \
        -o "$AP" \
        -m conntrack \
        --ctstate RELATED,ESTABLISHED \
        -j ACCEPT 2>/dev/null || true

      # Remove NAT
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING \
        -s "${cfg.network}" \
        -o "$WIFI" \
        -j MASQUERADE 2>/dev/null || true

      # Disable forwarding
      ${pkgs.sysctl}/bin/sysctl -w net.ipv4.ip_forward=0 >/dev/null || true

      # Remove AP interface
      if ${pkgs.iw}/bin/iw dev "$AP" info >/dev/null 2>&1; then
        ${pkgs.iw}/bin/iw dev "$AP" del || true
      fi
    }

    echo "Waiting for $WIFI to be connected..."

    while true; do
      LINK="$(${pkgs.iw}/bin/iw dev "$WIFI" link || true)"

      if echo "$LINK" | ${pkgs.gnugrep}/bin/grep -q '^Connected'; then
        FREQ="$(
          echo "$LINK" |
            ${pkgs.gawk}/bin/awk '/freq:/ { print int($2); exit }'
        )"

        if [ -n "''${FREQ:-}" ]; then
          break
        fi
      fi

      sleep 1
    done

    echo "Current Wi-Fi frequency: $FREQ MHz"

    # 2.4 GHz
    if [ "$FREQ" -ge 2412 ] && [ "$FREQ" -le 2484 ]; then
      CHANNEL="$(
        ${pkgs.gawk}/bin/awk \
          -v freq="$FREQ" \
          'BEGIN {
            if (freq == 2484)
              print 14
            else
              print (freq - 2407) / 5
          }'
      )"

      HW_MODE="g"

    # 5 GHz
    elif [ "$FREQ" -ge 5000 ] && [ "$FREQ" -le 5900 ]; then
      # 5 GHz channels are always a multiple of 5 MHz away from 5000 MHz.
      # Reject anything that doesn't land on an exact channel number instead
      # of silently truncating (or handing hostapd a non-integer channel).
      if [ $(( (FREQ - 5000) % 5 )) -ne 0 ]; then
        echo "Frequency $FREQ MHz does not map to a standard 5 GHz channel" >&2
        exit 1
      fi

      CHANNEL="$(( (FREQ - 5000) / 5 ))"

      HW_MODE="a"

    else
      echo "Unsupported Wi-Fi frequency: $FREQ MHz" >&2
      exit 1
    fi

    echo "Using channel $CHANNEL (hw_mode=$HW_MODE)"

    # Load the persistent AP password, creating it on first start.
	mkdir -p "$(dirname "$PASSWORD_FILE")"
	chmod 700 "$(dirname "$PASSWORD_FILE")"

	if [ ! -s "$PASSWORD_FILE" ]; then
		PASSWORD="$(
			${pkgs.openssl}/bin/openssl rand -hex 32 |
			${pkgs.coreutils}/bin/cut -c1-15
		)"

		printf '%s\n' "$PASSWORD" > "$PASSWORD_FILE"
	fi

	chmod 600 "$PASSWORD_FILE"

	PASSWORD="$(
		${pkgs.coreutils}/bin/tr -d '\n' < "$PASSWORD_FILE"
	)"

    echo "========================================"
    echo "Wi-Fi AP started"
    echo "SSID:     $AP_SSID"
    echo "Password: $PASSWORD"
    echo "Channel:  $CHANNEL"
    echo "Network:  ${cfg.network}"
    echo "Gateway:  ${cfg.address}"
    echo "========================================"

    # Make sure an old interface isn't hanging around.
    if ${pkgs.iw}/bin/iw dev "$AP" info >/dev/null 2>&1; then
        echo "$AP already exists, removing it..."
        ${pkgs.iw}/bin/iw dev "$AP" del
    fi

    echo "Creating $AP..."

    ${pkgs.iw}/bin/iw dev "$WIFI" interface add "$AP" type __ap

    ${pkgs.iproute2}/bin/ip link set "$AP" up

    ${pkgs.iproute2}/bin/ip addr add \
      "${cfg.address}/${toString cfg.prefixLength}" \
      dev "$AP"

    # Enable IPv4 forwarding.
    ${pkgs.sysctl}/bin/sysctl -w net.ipv4.ip_forward=1

    # NAT AP -> Wi-Fi.
    ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING \
      -s "${cfg.network}" \
      -o "$WIFI" \
      -j MASQUERADE

    # Allow forwarding from AP to the Internet.
    ${pkgs.iptables}/bin/iptables -A FORWARD \
      -i "$AP" \
      -o "$WIFI" \
      -j ACCEPT

    ${pkgs.iptables}/bin/iptables -A FORWARD \
      -i "$WIFI" \
      -o "$AP" \
      -m conntrack \
      --ctstate RELATED,ESTABLISHED \
      -j ACCEPT

    HOSTAPD_CONFIG="$(
      ${pkgs.coreutils}/bin/mktemp
    )"

    DNSMASQ_CONFIG="$(
      ${pkgs.coreutils}/bin/mktemp
    )"

    cleanup_configs() {
      rm -f "$HOSTAPD_CONFIG" "$DNSMASQ_CONFIG"
    }

    trap 'cleanup_configs; cleanup' EXIT INT TERM

    cat > "$HOSTAPD_CONFIG" <<EOF
interface=$AP
driver=nl80211

ssid=$AP_SSID
hw_mode=$HW_MODE
channel=$CHANNEL

auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
wpa_passphrase=$PASSWORD
EOF

    cat > "$DNSMASQ_CONFIG" <<EOF
interface=$AP
bind-interfaces

dhcp-authoritative
dhcp-range=${cfg.dhcpStart},${cfg.dhcpEnd},255.255.255.0,${cfg.dhcpLeaseTime}

dhcp-option=3,${cfg.address}
dhcp-option=6,${cfg.address}

no-resolv
server=${cfg.upstreamDns}

log-dhcp
EOF

    echo "Starting hostapd..."

	HOSTAPD_LOG="$RUNTIME_DIRECTORY/hostapd.log"
    ${pkgs.hostapd}/bin/hostapd "$HOSTAPD_CONFIG" \
    	> "$HOSTAPD_LOG" 2>&1 &
    HOSTAPD_PID=$!

    echo "Starting DHCP/DNS..."

    ${pkgs.dnsmasq}/bin/dnsmasq \
      --keep-in-foreground \
      --conf-file="$DNSMASQ_CONFIG" &
    DNSMASQ_PID=$!

	wait "$HOSTAPD_PID"
	HOSTAPD_RC=$?

	if [ "$HOSTAPD_RC" -ne 0 ]; then
		echo "wifi-ap: hostapd failed with code $HOSTAPD_RC"

		if grep -Eqi \
			'NO-IR|Primary frequency not allowed|Hardware does not support configured channel|Could not select hw_mode and channel' \
			"$HOSTAPD_LOG" 2>/dev/null; then

			echo "wifi-ap: channel/frequency incompatible with AP mode"
			exit 75
		fi

		exit "$HOSTAPD_RC"
	fi

    # Watch both processes: if either one dies, tear the whole AP down
    # instead of silently limping along without DHCP/DNS or without the
    # radio actually up.
    set +e
    wait -n "$HOSTAPD_PID" "$DNSMASQ_PID"
    EXIT_CODE=$?
    set -e

    if kill -0 "$HOSTAPD_PID" 2>/dev/null; then
      echo "dnsmasq exited unexpectedly (code $EXIT_CODE)" >&2
    elif kill -0 "$DNSMASQ_PID" 2>/dev/null; then
      echo "hostapd exited unexpectedly (code $EXIT_CODE)" >&2
    fi

    exit "$EXIT_CODE"
  '';

in
{
  options.my.system.services.wifi-ap = {
    enable = lib.mkEnableOption "manual Wi-Fi access point";

    wifiInterface = lib.mkOption {
      type = lib.types.str;
      default = "wlp98s0";
      description = "Physical Wi-Fi interface used for the upstream connection.";
    };

    apInterface = lib.mkOption {
      type = lib.types.str;
      default = "ap0";
      description = "Virtual Wi-Fi AP interface.";
    };

    ssid = lib.mkOption {
      type = lib.types.str;
      default = "NixOS-AP";
      description = "SSID of the access point.";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "192.168.50.1";
      description = "IPv4 address of the AP.";
    };

    network = lib.mkOption {
      type = lib.types.str;
      default = "192.168.50.0/24";
      description = "IPv4 network used by the AP.";
    };

    prefixLength = lib.mkOption {
      type = lib.types.int;
      default = 24;
    };

    dhcpStart = lib.mkOption {
      type = lib.types.str;
      default = "192.168.50.100";
    };

    dhcpEnd = lib.mkOption {
      type = lib.types.str;
      default = "192.168.50.200";
    };

    dhcpLeaseTime = lib.mkOption {
      type = lib.types.str;
      default = "12h";
    };

    upstreamDns = lib.mkOption {
      type = lib.types.str;
      default = "1.1.1.1";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      iw
      iproute2
      iptables
      hostapd
      dnsmasq
      openssl

	  wifiApCtl
    ];

    networking.networkmanager.unmanaged = [
      "interface-name:${cfg.apInterface}"
    ];

	networking.firewall.interfaces.${cfg.apInterface}.allowedUDPPorts = [ 67 ];

    systemd.services.wifi-ap = {
      description = "Wi-Fi Access Point (${cfg.apInterface})";

      # Important: deliberately NOT wantedBy=...
      # The user controls it manually with systemctl.
      wantedBy = [ ];

      after = [ "NetworkManager.service" ];
      wants = [ "NetworkManager.service" ];

      serviceConfig = {
        Type = "simple";

        ExecStart = startScript;

        # We need root for iw/ip/iptables.
        User = "root";

        # Give the service a clean runtime directory.
        RuntimeDirectory = "wifi-ap";

        # If something crashes, don't leave the AP around.
        Restart = "no";
      };
    };
  };
}