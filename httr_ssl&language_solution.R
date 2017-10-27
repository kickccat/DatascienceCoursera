# Solution for:
# Error in curl::curl_fetch_memory(url, handle = handle) : 
# Peer certificate cannot be authenticated with given CA certificates
library(httr)
set_config(config(ssl_verifypeer = 0L))

# Set the local language as english
Sys.setlocale(category = "LC_ALL", locale = "English")