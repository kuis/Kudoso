

- always allowed urls (kidcurrency, apple)
- urls where referer doesn't pass right (ext == ico)
- urls loaded from css files (referer_ext == css && ext == jpg,jpeg,png,gif)
- urls where the url is allowed
- urls where referer is allowed and url isn't a html page (for now has an extension)



Specific filters
----------------

get domain, subdomain, path

match domain, match subdomain, match first part of path
