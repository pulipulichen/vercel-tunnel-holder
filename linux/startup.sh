#!/bin/bash

cd "$(dirname "$0")"

./setup_url.sh

url_data=$(cat url.txt | grep -o 'u=[^&]*' | awk -F'u=' '{print $2}')

export C=$url_data
export URL=`cat target.txt`
export API=`cat api.txt`

if [ -f "cloudflare-url.txt" ]; then
    # Define the file containing the URL
    url_file="cloudflare-url.txt"

    # Read the URL from the file
    url=$(cat "$url_file")

    response=$(curl -s -o /dev/null -w "%{http_code}" "$url")

    # Check if the response is 503
    if [ "$response" = "530" ]; then
        echo "Error: URL $url is not connectable (response $response)"
    # elif [[ $response == 5* ]]; then
    #     echo "Error: URL $url is not connectable (response $response)"
    elif [ "$response" = "000" ]; then
        echo "Error: URL $url is not connectable (response $response)"
    else
        echo "URL $url is connectable (response $response)"
        exit 0
    fi
fi

pkill cloudflared

rm /tmp/tunnel.log

/usr/local/bin/cloudflared tunnel --no-tls-verify --url "$URL" --logfile /tmp/tunnel.log &
sleep 5

# Define the function
extract_url() {
    local file_content=$(cat /tmp/tunnel.log)
    local url=$(echo "$file_content" | grep -o 'http[s]\?://[^[:space:]]\+.trycloudflare.com' | grep -v '^http://localhost' | grep -v '^http://10')
    echo "$url"
}

# Call the function
url=$(extract_url)
log_file="/tmp/tunnel.log"

# Check if URL is empty
while [ -z "$url" ]; do
    echo "URL is empty. Sleeping for 5 seconds..."
    sleep 5
    url=$(extract_url)
    
    if [ -z "$url" ]; then
        # Use grep to search for the string
        if grep -q "context deadline exceeded" "$log_file"; then
            echo "The string 'context deadline exceeded' is found in $log_file"
            
            random_seconds=$(( ( RANDOM % 2960 ) + 7205 ))  # Generating random number between 5 and 300 (inclusive)

            sleep $random_seconds

            echo "Slept for $random_seconds seconds"

            cd "$(dirname "$0")"
            ./startup.sh &
            exit 0
        fi
    fi
done

echo "$url" > cloudflare-url.txt

# curl -X POST "$API" -d "url=$url&p=$C"
curl -sL "$API/set-url?url=$url&uuid=$C"

echo ""
echo ""
echo "================================================================"
cat url.txt
echo "================================================================"