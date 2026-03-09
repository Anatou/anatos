{ pkgs, lib, option, config, system, ... }:
let
script = pkgs.writeShellScriptBin "lxch" ''
	progname=$(basename "$0")
	# Bashrc variable generated using a regular .bashrc encoded with base64
	bashrc="IyB+Ly5iYXNocmM6IGV4ZWN1dGVkIGJ5IGJhc2goMSkgZm9yIG5vbi1sb2dpbiBzaGVsbHMuCiMgc2VlIC91c3Ivc2hhcmUvZG9jL2Jhc2gvZXhhbXBsZXMvc3RhcnR1cC1maWxlcyAoaW4gdGhlIHBhY2thZ2UgYmFzaC1kb2MpCiMgZm9yIGV4YW1wbGVzCgojIElmIG5vdCBydW5uaW5nIGludGVyYWN0aXZlbHksIGRvbid0IGRvIGFueXRoaW5nCmNhc2UgJC0gaW4KICAgICppKikgOzsKICAgICAgKikgcmV0dXJuOzsKZXNhYwoKIyBkb24ndCBwdXQgZHVwbGljYXRlIGxpbmVzIG9yIGxpbmVzIHN0YXJ0aW5nIHdpdGggc3BhY2UgaW4gdGhlIGhpc3RvcnkuCiMgU2VlIGJhc2goMSkgZm9yIG1vcmUgb3B0aW9ucwpISVNUQ09OVFJPTD1pZ25vcmVib3RoCgojIGFwcGVuZCB0byB0aGUgaGlzdG9yeSBmaWxlLCBkb24ndCBvdmVyd3JpdGUgaXQKc2hvcHQgLXMgaGlzdGFwcGVuZAoKIyBmb3Igc2V0dGluZyBoaXN0b3J5IGxlbmd0aCBzZWUgSElTVFNJWkUgYW5kIEhJU1RGSUxFU0laRSBpbiBiYXNoKDEpCkhJU1RTSVpFPTEwMDAKSElTVEZJTEVTSVpFPTIwMDAKCiMgY2hlY2sgdGhlIHdpbmRvdyBzaXplIGFmdGVyIGVhY2ggY29tbWFuZCBhbmQsIGlmIG5lY2Vzc2FyeSwKIyB1cGRhdGUgdGhlIHZhbHVlcyBvZiBMSU5FUyBhbmQgQ09MVU1OUy4Kc2hvcHQgLXMgY2hlY2t3aW5zaXplCgojIElmIHNldCwgdGhlIHBhdHRlcm4gIioqIiB1c2VkIGluIGEgcGF0aG5hbWUgZXhwYW5zaW9uIGNvbnRleHQgd2lsbAojIG1hdGNoIGFsbCBmaWxlcyBhbmQgemVybyBvciBtb3JlIGRpcmVjdG9yaWVzIGFuZCBzdWJkaXJlY3Rvcmllcy4KI3Nob3B0IC1zIGdsb2JzdGFyCgojIG1ha2UgbGVzcyBtb3JlIGZyaWVuZGx5IGZvciBub24tdGV4dCBpbnB1dCBmaWxlcywgc2VlIGxlc3NwaXBlKDEpClsgLXggL3Vzci9iaW4vbGVzc3BpcGUgXSAmJiBldmFsICIkKFNIRUxMPS9iaW4vc2ggbGVzc3BpcGUpIgoKIyBzZXQgdmFyaWFibGUgaWRlbnRpZnlpbmcgdGhlIGNocm9vdCB5b3Ugd29yayBpbiAodXNlZCBpbiB0aGUgcHJvbXB0IGJlbG93KQppZiBbIC16ICIke2RlYmlhbl9jaHJvb3Q6LX0iIF0gJiYgWyAtciAvZXRjL2RlYmlhbl9jaHJvb3QgXTsgdGhlbgogICAgZGViaWFuX2Nocm9vdD0kKGNhdCAvZXRjL2RlYmlhbl9jaHJvb3QpCmZpCgojIHNldCBhIGZhbmN5IHByb21wdCAobm9uLWNvbG9yLCB1bmxlc3Mgd2Uga25vdyB3ZSAid2FudCIgY29sb3IpCmNhc2UgIiRURVJNIiBpbgogICAgeHRlcm0tY29sb3J8Ki0yNTZjb2xvcikgY29sb3JfcHJvbXB0PXllczs7CmVzYWMKCmNvbG9yX3Byb21wdD0ieWVzIgppZiBbICIkY29sb3JfcHJvbXB0IiA9ICJ5ZXMiIF07IHRoZW4KICAgIFBTMT0nJHtkZWJpYW5fY2hyb290OisoJGRlYmlhbl9jaHJvb3QpfVxbXDAzM1swMTszMm1cXVx1QFxoXFtcMDMzWzAwbVxdOlxbXDAzM1swMTszNG1cXVx3XFtcMDMzWzAwbVxdXCQgJwplbHNlCiAgICBQUzE9JyR7ZGViaWFuX2Nocm9vdDorKCRkZWJpYW5fY2hyb290KX1cdUBcaDpcd1wkICcKZmkKdW5zZXQgY29sb3JfcHJvbXB0IGZvcmNlX2NvbG9yX3Byb21wdAoKIyBJZiB0aGlzIGlzIGFuIHh0ZXJtIHNldCB0aGUgdGl0bGUgdG8gdXNlckBob3N0OmRpcgpjYXNlICIkVEVSTSIgaW4KeHRlcm0qfHJ4dnQqKQogICAgUFMxPSJcW1xlXTA7JHtkZWJpYW5fY2hyb290OisoJGRlYmlhbl9jaHJvb3QpfVx1QFxoOiBcd1xhXF0kUFMxIgogICAgOzsKKikKICAgIDs7CmVzYWMKCiMgZW5hYmxlIGNvbG9yIHN1cHBvcnQgb2YgbHMgYW5kIGFsc28gYWRkIGhhbmR5IGFsaWFzZXMKaWYgWyAteCAvdXNyL2Jpbi9kaXJjb2xvcnMgXTsgdGhlbgogICAgdGVzdCAtciB+Ly5kaXJjb2xvcnMgJiYgZXZhbCAiJChkaXJjb2xvcnMgLWIgfi8uZGlyY29sb3JzKSIgfHwgZXZhbCAiJChkaXJjb2xvcnMgLWIpIgogICAgYWxpYXMgbHM9J2xzIC0tY29sb3I9YXV0bycKICAgICNhbGlhcyBkaXI9J2RpciAtLWNvbG9yPWF1dG8nCiAgICAjYWxpYXMgdmRpcj0ndmRpciAtLWNvbG9yPWF1dG8nCgogICAgYWxpYXMgZ3JlcD0nZ3JlcCAtLWNvbG9yPWF1dG8nCiAgICBhbGlhcyBmZ3JlcD0nZmdyZXAgLS1jb2xvcj1hdXRvJwogICAgYWxpYXMgZWdyZXA9J2VncmVwIC0tY29sb3I9YXV0bycKZmkKCiMgY29sb3JlZCBHQ0Mgd2FybmluZ3MgYW5kIGVycm9ycwpleHBvcnQgR0NDX0NPTE9SUz0nZXJyb3I9MDE7MzE6d2FybmluZz0wMTszNTpub3RlPTAxOzM2OmNhcmV0PTAxOzMyOmxvY3VzPTAxOnF1b3RlPTAxJwoKIyBzb21lIG1vcmUgbHMgYWxpYXNlcwphbGlhcyBsbD0nbHMgLWFsRicKYWxpYXMgbGE9J2xzIC1BJwphbGlhcyBsPSdscyAtQ0YnCgojIEFkZCBhbiAiYWxlcnQiIGFsaWFzIGZvciBsb25nIHJ1bm5pbmcgY29tbWFuZHMuICBVc2UgbGlrZSBzbzoKIyAgIHNsZWVwIDEwOyBhbGVydAphbGlhcyBhbGVydD0nbm90aWZ5LXNlbmQgLS11cmdlbmN5PWxvdyAtaSAiJChbICQ/ID0gMCBdICYmIGVjaG8gdGVybWluYWwgfHwgZWNobyBlcnJvcikiICIkKGhpc3Rvcnl8dGFpbCAtbjF8c2VkIC1lICdcJydzL15ccypbMC05XVwrXHMqLy87cy9bOyZ8XVxzKmFsZXJ0JC8vJ1wnJykiJwoKIyBBbGlhcyBkZWZpbml0aW9ucy4KIyBZb3UgbWF5IHdhbnQgdG8gcHV0IGFsbCB5b3VyIGFkZGl0aW9ucyBpbnRvIGEgc2VwYXJhdGUgZmlsZSBsaWtlCiMgfi8uYmFzaF9hbGlhc2VzLCBpbnN0ZWFkIG9mIGFkZGluZyB0aGVtIGhlcmUgZGlyZWN0bHkuCiMgU2VlIC91c3Ivc2hhcmUvZG9jL2Jhc2gtZG9jL2V4YW1wbGVzIGluIHRoZSBiYXNoLWRvYyBwYWNrYWdlLgoKaWYgWyAtZiB+Ly5iYXNoX2FsaWFzZXMgXTsgdGhlbgogICAgLiB+Ly5iYXNoX2FsaWFzZXMKZmkKCiMgZW5hYmxlIHByb2dyYW1tYWJsZSBjb21wbGV0aW9uIGZlYXR1cmVzICh5b3UgZG9uJ3QgbmVlZCB0byBlbmFibGUKIyB0aGlzLCBpZiBpdCdzIGFscmVhZHkgZW5hYmxlZCBpbiAvZXRjL2Jhc2guYmFzaHJjIGFuZCAvZXRjL3Byb2ZpbGUKIyBzb3VyY2VzIC9ldGMvYmFzaC5iYXNocmMpLgppZiAhIHNob3B0IC1vcSBwb3NpeDsgdGhlbgogIGlmIFsgLWYgL3Vzci9zaGFyZS9iYXNoLWNvbXBsZXRpb24vYmFzaF9jb21wbGV0aW9uIF07IHRoZW4KICAgIC4gL3Vzci9zaGFyZS9iYXNoLWNvbXBsZXRpb24vYmFzaF9jb21wbGV0aW9uCiAgZWxpZiBbIC1mIC9ldGMvYmFzaF9jb21wbGV0aW9uIF07IHRoZW4KICAgIC4gL2V0Yy9iYXNoX2NvbXBsZXRpb24KICBmaQpmaQoKZXhwb3J0IExTX0NPTE9SUz0icnM9MDpkaT0wMTszNDpsbj0wMTszNjptaD0wMDpwaT00MDszMzpzbz0wMTszNTpkbz0wMTszNTpiZD00MDszMzswMTpjZD00MDszMzswMTpvcj00MDszMTswMTptaT0wMDpzdT0zNzs0MTpzZz0zMDs0MzpjYT0wMDp0dz0zMDs0Mjpvdz0zNDs0MjpzdD0zNzs0NDpleD0wMTszMjoqLjd6PTAxOzMxOiouYWNlPTAxOzMxOiouYWx6PTAxOzMxOiouYXBrPTAxOzMxOiouYXJjPTAxOzMxOiouYXJqPTAxOzMxOiouYno9MDE7MzE6Ki5iejI9MDE7MzE6Ki5jYWI9MDE7MzE6Ki5jcGlvPTAxOzMxOiouY3JhdGU9MDE7MzE6Ki5kZWI9MDE7MzE6Ki5kcnBtPTAxOzMxOiouZHdtPTAxOzMxOiouZHo9MDE7MzE6Ki5lYXI9MDE7MzE6Ki5lZ2c9MDE7MzE6Ki5lc2Q9MDE7MzE6Ki5nej0wMTszMToqLmphcj0wMTszMToqLmxoYT0wMTszMToqLmxyej0wMTszMToqLmx6PTAxOzMxOioubHo0PTAxOzMxOioubHpoPTAxOzMxOioubHptYT0wMTszMToqLmx6bz0wMTszMToqLnB5ej0wMTszMToqLnJhcj0wMTszMToqLnJwbT0wMTszMToqLnJ6PTAxOzMxOiouc2FyPTAxOzMxOiouc3dtPTAxOzMxOioudDd6PTAxOzMxOioudGFyPTAxOzMxOioudGF6PTAxOzMxOioudGJ6PTAxOzMxOioudGJ6Mj0wMTszMToqLnRnej0wMTszMToqLnRsej0wMTszMToqLnR4ej0wMTszMToqLnR6PTAxOzMxOioudHpvPTAxOzMxOioudHpzdD0wMTszMToqLnVkZWI9MDE7MzE6Ki53YXI9MDE7MzE6Ki53aGw9MDE7MzE6Ki53aW09MDE7MzE6Ki54ej0wMTszMToqLno9MDE7MzE6Ki56aXA9MDE7MzE6Ki56b289MDE7MzE6Ki56c3Q9MDE7MzE6Ki5hdmlmPTAxOzM1OiouanBnPTAxOzM1OiouanBlZz0wMTszNToqLmp4bD0wMTszNToqLm1qcGc9MDE7MzU6Ki5tanBlZz0wMTszNToqLmdpZj0wMTszNToqLmJtcD0wMTszNToqLnBibT0wMTszNToqLnBnbT0wMTszNToqLnBwbT0wMTszNToqLnRnYT0wMTszNToqLnhibT0wMTszNToqLnhwbT0wMTszNToqLnRpZj0wMTszNToqLnRpZmY9MDE7MzU6Ki5wbmc9MDE7MzU6Ki5zdmc9MDE7MzU6Ki5zdmd6PTAxOzM1OioubW5nPTAxOzM1OioucGN4PTAxOzM1OioubW92PTAxOzM1OioubXBnPTAxOzM1OioubXBlZz0wMTszNToqLm0ydj0wMTszNToqLm1rdj0wMTszNToqLndlYm09MDE7MzU6Ki53ZWJwPTAxOzM1Oioub2dtPTAxOzM1OioubXA0PTAxOzM1OioubTR2PTAxOzM1OioubXA0dj0wMTszNToqLnZvYj0wMTszNToqLnF0PTAxOzM1OioubnV2PTAxOzM1Oioud212PTAxOzM1OiouYXNmPTAxOzM1Oioucm09MDE7MzU6Ki5ybXZiPTAxOzM1OiouZmxjPTAxOzM1OiouYXZpPTAxOzM1OiouZmxpPTAxOzM1OiouZmx2PTAxOzM1OiouZ2w9MDE7MzU6Ki5kbD0wMTszNToqLnhjZj0wMTszNToqLnh3ZD0wMTszNToqLnl1dj0wMTszNToqLmNnbT0wMTszNToqLmVtZj0wMTszNToqLm9ndj0wMTszNToqLm9neD0wMTszNToqLmFhYz0wMDszNjoqLmF1PTAwOzM2OiouZmxhYz0wMDszNjoqLm00YT0wMDszNjoqLm1pZD0wMDszNjoqLm1pZGk9MDA7MzY6Ki5ta2E9MDA7MzY6Ki5tcDM9MDA7MzY6Ki5tcGM9MDA7MzY6Ki5vZ2c9MDA7MzY6Ki5yYT0wMDszNjoqLndhdj0wMDszNjoqLm9nYT0wMDszNjoqLm9wdXM9MDA7MzY6Ki5zcHg9MDA7MzY6Ki54c3BmPTAwOzM2Oip+PTAwOzkwOiojPTAwOzkwOiouYmFrPTAwOzkwOiouY3Jkb3dubG9hZD0wMDs5MDoqLmRwa2ctZGlzdD0wMDs5MDoqLmRwa2ctbmV3PTAwOzkwOiouZHBrZy1vbGQ9MDA7OTA6Ki5kcGtnLXRtcD0wMDs5MDoqLm9sZD0wMDs5MDoqLm9yaWc9MDA7OTA6Ki5wYXJ0PTAwOzkwOioucmVqPTAwOzkwOioucnBtbmV3PTAwOzkwOioucnBtb3JpZz0wMDs5MDoqLnJwbXNhdmU9MDA7OTA6Ki5zd3A9MDA7OTA6Ki50bXA9MDA7OTA6Ki51Y2YtZGlzdD0wMDs5MDoqLnVjZi1uZXc9MDA7OTA6Ki51Y2Ytb2xkPTAwOzkwOiIKY2QgIiRIT01FIiAgfHwgZXhpdAo="

	print_help() {
		echo -e "\x1b[1m$progname\x1b[0m is a helper wrapper around the lxc-* command family"
		echo -e "The options are mostly the same as the lxc-* commands but neater !"
		echo ""
		echo -e "\x1b[1mOptions:\x1b[0m"
		echo "  attach create destroy info ls start stop"
		echo "  enter quick"
		echo ""
		echo -e "\x1b[4menter <lxc-name> [user]\x1b[24m"
		echo "  Creates, starts, and attaches the specified LXC (only if necessary). The container must already exist"
		echo "  If no user is specified, it defaults to the first unpriviligied user. To attach as root, use enter <lxc-name> root"
		echo -e "\x1b[4mquick <lxc-name> [user]\x1b[24m"
		echo "  Starts and attaches the specified LXC (only if necessary) and then stops it when exiting. The container must already exist"
		echo "  If no user is specified, it defaults to the first unpriviligied user. To attach as root, use quick <lxc-name> root"
		echo -e "\x1b[4mattach <lxc-name> [user]\x1b[24m"
		echo "  Enters the specified LXC. The container must already exist"
		echo "  If no user is specified, it defaults to the first unpriviligied user. To attach as root, use attach <lxc-name> root"
		echo -e "\x1b[4mcreate <lxc-name>\x1b[24m"
		echo "  Creates a new LXC with the specified name. The name must be unique. A prompt will appear to choose the distribution"
		echo -e "\x1b[4mdestroy <lxc-name>\x1b[24m"
		echo "  Destroys the specified LXC."
		echo -e "\x1b[4minfo <lxc-name>\x1b[24m"
		echo "  Shows current infos about the specified LXC. The container must already exist."
		echo -e "\x1b[4mls\x1b[24m"
		echo "  Shows all existing LXCs."
		echo -e "\x1b[4mstart <lxc-name>\x1b[24m"
		echo "  Starts the specified LXC. The container must exist."
		echo -e "\x1b[4mstop <lxc-name>\x1b[24m"
		echo "  Stops the specified LXC. The container must exist."
	}

	print_invalid_option_error() {
		echo -e "\x1b[1;31m$progname: Invalid option -- $*\x1b[0m"
	}

	print_no_option_error() {
		echo -e "\x1b[1;31m$progname: No option specified\x1b[0m"
	}

	if [[ ! -n "$1" ]]; then
		print_no_option_error
		print_help
		exit 1
	fi

	ask() {
		# OUTPUT $anwser ("0" or "1")
		local loop=1
		while [[ $loop == 1 ]]; do
			echo -n "$1 "
			read -p "(y/n) > " choice
			case "$choice" in
				y|Y ) loop=0; answer="1";;
				n|N ) loop=0; answer="0";;
				* ) echo "Invalid answer";;
			esac
		done
	}
	is_lxc_running() {
		# OUTPUT $is_running ("0" or "1")
		if [[ "$(sudo lxc-info --name $1 | grep RUNNING | wc -l)" == "0" ]]; then
			is_running="0"
		else
			is_running="1"
		fi
	}
	default_user() {
		# OUTPUT $user (as string)
		local start_stop="0"
		is_lxc_running $1
		if [[ "$is_running" == "1" ]]; then
			start_stop="1"
			stop $1
		fi
		user="$(sudo lxc-execute --name $1 -- getent passwd 1000| cut -f1 -d:)"
		if [[ "$start_stop"="1" ]]; then 
			start $1
		fi
		if [[ ! -n "$user" ]]; then
			user="root"
		fi
	}
	info() {
		sudo lxc-info --name $1
	}
	start() {
		sudo lxc-start --name $1
	}
	stop() {
		sudo lxc-stop --name $1
	}
	destroy() {
		ask "Do you want to destroy LXC $1 ?"
		if [[ "$answer"=="1" ]]; then
			sudo lxc-destroy --name $1
		fi
	}
	attach() {
		default_user $1
		if [[ -n "$2" ]]; then
			user="$2"
		fi
		sudo lxc-attach --name $1 --clear-env -v TERM="$TERM" -- su "$user"
	}
	create() {
		ask "Would you like to configure the LXC environment ?"
		local configure_lxc="$answer"
		local improve_bash="0"
		if [[ "$configure_lxc" == "1" ]]; then 
			ask "> Would you like to improve bash ? (Enable colors, better prompt, aliases, ...)"
			if [[ "$answer" == "1" ]]; then improve_bash="1"; fi
		fi
		sudo lxc-create --name $1 --template download
		default_user $1
		if [[ "$improve_bash"=="1" && "$user" != "root" ]]; then
			stop $1
			sudo lxc-execute --name $1 -- bash -c "echo \"$bashrc\" | base64 -d > /home/$user/.bashrc"
		fi
	}

	enter() {
		if [[ "$(sudo lxc-ls | grep $1)" == "" ]]; then
			ask "There is no LXC named '$1', would you like to create one ?"
			if [[ "$answer" == "1" ]]; then
				create $1
			else
				exit
			fi
		fi
		is_lxc_running $1
		if [[ "$is_running" == "0" ]]; then
			echo "LXC '$1' is not started, starting it..."
		fi
		if [[ -n "$2" ]]; then
			attach "$1" "$2"
		else
			attach "$1"
		fi
		echo "LXC is still running, you can stop it with"
		echo "  $progname stop $1"
	}

	quick() {
		is_lxc_running $1
		if [[ "$is_running" == "0" ]]; then
			echo "LXC '$1' is not started, starting it..."
			start $1
		fi
		if [[ -n "$2" ]]; then
			attach "$1" "$2"
		else
			attach "$1"
		fi
		stop $1
	}

	case "$1" in
		"h"|"help") 
			print_help
			;;
		"a"|"attach") 
			if [[ ! -n "$2" ]]; then
				echo -e "\x1b[1;31m$progname: No LXC specified.\x1b[0m You can list LXCs with $progname ls."
				exit 1
			fi
			if [[ -n "$3" ]]; then
				attach "$2" "$3"
			else
				attach "$2"
			fi
			;;
		"e"|"enter") 
			if [[ ! -n "$2" ]]; then
				echo -e "\x1b[1;31m$progname: No LXC specified.\x1b[0m You can list LXCs with $progname ls."
				exit 1
			fi
			if [[ -n "$3" ]]; then
				enter "$2" "$3"
			else
				enter "$2"
			fi
			;;
		"q"|"quick") 
			if [[ ! -n "$2" ]]; then
				echo -e "\x1b[1;31m$progname: No LXC specified.\x1b[0m You can list LXCs with $progname ls."
				exit 1
			fi
			if [[ -n "$3" ]]; then
				quick "$2" "$3"
			else
				quick "$2"
			fi
			;;
		"c"|"create") 
			if [[ ! -n "$2" ]]; then
				echo -e "\x1b[1;31m$progname: No LXC name specified\x1b[0m. You must specify a name for the LXC to be created."
				exit 1
			fi
			create "$2"
			;;
		"d"|"destroy") 
			if [[ ! -n "$2" ]]; then
				echo -e "\x1b[1;31m$progname: No LXC name specified\x1b[0m. You must specify the LXC to destroy."
				exit 1
			fi
			destroy "$2"
			;;
		"i"|"info") 
			if [[ ! -n "$2" ]]; then
				echo -e "\x1b[1;31m$progname: No LXC name specified\x1b[0m. Cannot lookup infos for an unspecified LXC."
				exit 1
			fi
			info "$2"
			;;
		"ls"|"ps") 
			sudo lxc-ls --fancy
			;;
		"start") 
			if [[ ! -n "$2" ]]; then
				echo -e "\x1b[1;31m$progname: No LXC specified.\x1b[0m You can list LXCs with $progname ls."
				exit 1
			fi
			start "$2"
			;;
		"stop") 
			if [[ ! -n "$2" ]]; then
				echo -e "\x1b[1;31m$progname: No LXC specified.\x1b[0m You can list LXCs with $progname ls."
				exit 1
			fi
			stop "$2"
			;;
		*) 
			print_invalid_option_error
			print_help
			exit 1
			;;
	esac
	'';
in
{
    options.my.home.scripts.lxc-help.enable = lib.mkEnableOption "Enable the lxc-help script";

	config = lib.mkIf config.my.home.scripts.lxc-help.enable {
		home.packages = [script];
	};
}