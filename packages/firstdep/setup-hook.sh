# firstDepSetup() {
#   export MYSETUPHOOK="value"
#   echo "!! Running my setup hook"
# }

#addEnvHooks "$hostOffset" firstDepSetup
# preBuildHooks+=(firstDepSetup)
# preConfigurePhases="${preConfigurePhases:-} firstDepSetup"

export MYSETUPHOOK="notinfunction"
