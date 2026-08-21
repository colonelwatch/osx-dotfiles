# Install

1. Clone this repository with the command `git clone --recurse-submodules https://github.com/colonelwatch/osx-dotfiles .dotfiles`.
   - If this command opens a GUI prompt to install command line tools, accept the prompt.
2. Navigate to the downloaded folder with the command `cd .dotfiles`.
3. Launch the bootstrap with the command `./bootstrap.sh`.
4. Install KiCad with the command `brew install kicad`, and enter the password when prompted.
5. Reboot the machine to apply changes.
6. Log into JetBrains and download DataGrip under the fallback license.
7. Log into XMOS and download XTC Tools.

<!-- TODO: establish how XMOS SetEnv.sh script's supporting of only Bash will be handled -->

# Post-install

- When the laptop is plugged into an external display, use BetterDisplay to tweak the resolution and refresh rate.
- Open Macs Fan Control, and when prompted to enable fan control, accept the prompt.
- Log into Zotero and do an initial sync.
- In System Settings:
  - Under "General" > "Sharing", set "Local hostname" to `kenny-osx.local`.
  - Under "Mouse", set "Natural scrolling" to off.
  - Under "Battery" > "Charging", set "Charge Limit" to 80%.
- In Google Chrome:
  - Under "Passwords and Autofill" > "Google Password Manager" > "Settings", set "Offer to save passwords and passkeys" to off.
  - Add and activate the Bitwarden extension.
  - Under "Settings" > "Appearance" > "Theme", set the theme to yellow.
- In the terminal:
  - Run `gh auth login -p https -w` and follows the prompts to set up Git over HTTPS.
