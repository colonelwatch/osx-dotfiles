function bitwarden-unlock-openalex
	set -gx OPENALEX_API_KEY $(bitwarden get notes "OpenAlex API Key")
end

