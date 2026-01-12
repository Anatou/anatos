name:
''
if [[ -v DEVSHELL ]]; then
        export DEVSHELL="${name} & $DEVSHELL"
    else    
        export DEVSHELL=${name}
    fi
    export name="''\${DEVSHELL}"
''