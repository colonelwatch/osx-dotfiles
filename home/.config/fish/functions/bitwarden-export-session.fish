function bitwarden-export-session
	set -gx BW_SESSION $(bw unlock --raw)
end
