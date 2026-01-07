{ pkgs, lib, config, nixosConfig, ... }:
{

    options.my.home.services.tailscale.enable = lib.mkEnableOption "Enable tailscale";

    config = lib.mkIf config.my.home.services.tailscale.enable {
        home.packages = [
            pkgs.tailscale
            (pkgs.writeShellScriptBin "tailscale-up" ''
            kitty --detach sh -c "sudo tailscaled"

            MAX_RETRIES=10
            RETRY_DELAY=3 # seconds
            command_to_run="sudo tailscale up --accept-routes"

            attempt=0
            exit_status=1 # Initialize with a non-zero value to ensure the loop starts

            while [ "$exit_status" -ne 0 ]; do
                attempt=$((attempt + 1))
                echo "Attempt $attempt: Starting tailscale VPN..."

                # Execute the command and capture its output and exit status
                output=$($command_to_run &> /dev/null)
                exit_status=$? # $? holds the exit status of the last executed command

                if [ "$exit_status" -eq 0 ]; then
                    echo "Connected to tailscale VPN"
                    #break # Exit the loop on success
                else
                    echo "Could not connect to tailscale VPN, maybe the daemon has not started yet ? (exit status: $exit_status)"
                    if [ "$attempt" -ge "$MAX_RETRIES" ]; then
                        echo "Error: Maximum retries reached. Command failed persistently."
                        exit 1
                    fi
                    echo "Retrying in $RETRY_DELAY seconds..."
                    sleep "$RETRY_DELAY"
                fi
            done

            exit 0
            '')
        ];
        
    };
}



