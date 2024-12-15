#!/bin/bash

# Filename: dork_generator.sh
# Description: Generates Google Dork search URLs for a given domain

# Predefined dorks
dorks=(
  'site:{DOMAIN} inurl:admin'
  'site:{DOMAIN} inurl:login'
  'site:{DOMAIN} ext:txt "password"'
  'site:{DOMAIN} ext:log "username" "password"'
  'site:{DOMAIN} ext:env "DB_USERNAME" "DB_PASSWORD"'
  'site:{DOMAIN} ext:sql "INSERT INTO users"'
  'site:{DOMAIN} ext:json "credentials"'
  'site:{DOMAIN} ext:bak'
  'site:{DOMAIN} inurl:/.git'
  'site:{DOMAIN} intitle:index.of "backup"'
  'site:{DOMAIN} intitle:index.of ".git/config"'
  'site:{DOMAIN} ext:sql "select * from"'
  'site:{DOMAIN} ext:env "API_KEY"'
  'site:{DOMAIN} "BEGIN RSA PRIVATE KEY"'
)

# Ask for the domain
read -p "Enter the domain (e.g., example.com): " domain

# Validate input
if [[ -z "$domain" ]]; then
  echo "Domain cannot be empty. Exiting."
  exit 1
fi

# Generate links
output_file="dork_links_${domain}.txt"
echo "Generating dork search links for domain: $domain"
echo "Links saved to $output_file"
echo "-----------------------------" > "$output_file"

for dork in "${dorks[@]}"; do
  # Replace {DOMAIN} with the user's input
  dork_query=${dork//\{DOMAIN\}/$domain}
  # Encode the dork for a Google search URL
  encoded_dork=$(echo "$dork_query" | jq -sRr @uri)
  # Generate the full Google search URL
  google_link="https://www.google.com/search?q=$encoded_dork"
  # Save to file
  echo "$google_link" >> "$output_file"
  echo "$google_link"
done

echo "Done! All dork links are saved in $output_file."
