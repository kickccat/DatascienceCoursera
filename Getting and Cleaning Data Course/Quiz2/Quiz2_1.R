setwd("C:/Users/yi.zhou/Workspace/DataScience/R/Coursera/Quiz2")

# Register an application with the Github API here https://github.com/settings/applications. Access the API to get information on your instructors repositories (hint: this is the url you want "https://api.github.com/users/jtleek/repos"). Use this data to find the time that the datasharing repo was created. What time was it created?
# 
# This tutorial may be useful (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). You may also need to run the code in the base R package and not R studio.

library(httr)
library(httpuv)
library(jsonlite)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at at
#    https://github.com/settings/applications.
#    Use any URL for the homepage URL:
#   (http://github.com is fine) and  http://localhost:1410 as the callback URL
#
#   Replace your key (Client ID) and (Client) secret below.
myapp <- oauth_app(appname =  "Coursera_getting_and_cleaning_data",
                   key = "1471e5db2fc524725731",
                   secret = "2d225dff28d398e49a265caa4dc69bf79493474e")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)

# 4.1 Stop at the error status
req <- GET("https://api.github.com/users/jtleek/repos", gtoken) # the instructors repositories
stop_for_status(req)
content(req)

# 4.2 OR:
req <- with_config(gtoken, GET("https://api.github.com/users/jtleek/repos"))
stop_for_status(req)
content(req)

# Extract from request info
json1 <- content(req)

# Convert to dataframe
json2 <- jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset dataframe
json2[json2$full_name=="jtleek/datasharing", "created_at"] # "2013-11-07T13:25:07Z"