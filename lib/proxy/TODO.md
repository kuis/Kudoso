NEW Oct 2013
------------

Trouble connceting to dispatch server
Add router channel to admin


New filtering
-------------

1) Check blacklist -> block if its in the blacklist
2) Check if blockall enabled
  if blockall is enabled
    check whitelist
  elsif filtering enabled
    check the filter -> allow if the filter allows it
    check if its in the whitelist



## UPDATED TODO
Make router timeout routers that aren't pinging


On prohibited page, show what the url is to show that its not a domain.  Make it scale for iframes (youtube ads for example)
make it so the upgrade_check.sh maybe checks its own version?  (should we just do a curl ... | sh)
Make it so we don't change the password when we update /etc/config/wireless
Add ping/pong so we better know when the connection has timed out





Have you tested on the iPhone? When I just tried it, I got the screen saying Setup Completed. When I pressed continue, I got redirected to a page that had http:// in the address bar and a message on the screen that says "Safari cannot open the page because the address is invalid." I'm able to navigate to sites so I think it is just that the Continue button being mapped to an invalid URL

Final TODO:

Fix:
2003933016:error:0906D06C:lib(9):func(109):reason(108):NA:0:Expecting: ANY PRIVATE KEY
2003933016:error:140B0009:lib(20):func(176):reason(9):NA:0:
proxy: ssl.cpp: 166: SslContext_t::SslContext_t(bool, const string&, const string&): Assertion `e > 0' failed.

https://github.com/eventmachine/eventmachine/blob/master/ext/ssl.cpp


- Make an image with a default password
- Maybe build in changing the wifi password


- Handle when we can't connect to kudoso
- Break connections when the state for a user changes
- Instead of using the session for the redirect url, pass through url

- Finish router admin - add login
- Finish setting up SSL



-------------
- Have user filters include clear_in with all
- validate remote peer

- '*' for urls needs to support :clear_in
- OpenDNS family shield integration
- Block all other ports
- let user assign device names

Coreys router:
10:BF:48:E7:01:56

Remote SSH user on router.kudoso.com
user: updjwic9
pass: 39vsfi29sijfgjsl


-- Can wait --
- Handle can't connect to SSL key server - need to show a page saying the issue maybe? (http redirect)
- validate remote https connection



