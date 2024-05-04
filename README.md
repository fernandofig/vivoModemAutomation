# VivoModem Automation

This are a few scripts that mostly serves as a foundation for automating some tasks on the Brazil's Vivo ONT modems. For now the only tasks automated are only retrieval of IPV6 delegated prefix and rebooting the modem, since that's all I use it for at the moment.

These scripts have been written and tested on an OpenWRT-enabled router running version 23.05.2 of OpenWRT with `curl` installed, since I use these automations from this router. But they're bash scripts, so as long as you have `curl` on your `PATH`, these scripts should run pretty much everywhere with minor modifications.
