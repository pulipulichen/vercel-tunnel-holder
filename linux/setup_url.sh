#!/bin/bash

if [ ! -f "url.txt" ]; then
  # Define the URL
  url=`cat api.txt`

  # Fetch data from the URL using curl
  # result=$(curl -sL "$url/get-id")
  result=$(uuidgen)

  # Check if the result is not empty
  if [ -n "$result" ]; then
      # Do something with the result, such as printing it
      echo "https://rb.gy/f7njeo?u=${result}" > url.txt
  else
      echo "Error: No result obtained from the curl command."
  fi
fi
