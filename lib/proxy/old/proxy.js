// Cert stuff: http://mitmproxy.org/doc/ssl.html
// Also could try: https://github.com/mdp/middlefiddle
// https://github.com/greim/hoxy


var Proxy = require('mitm-proxy')
  , url   = require('url')
  , http = require('http');


var FilterProxy = {
  filters: [
    'http://www.facebook.com/',
    'https://www.facebook.com/',
    'http://www.digg.com/',
    'http://www.google.com/'
  ],

  updateFilters: function(response) {
    var body = '';

    // keep track of the data you receive
    response.on('data', function(data) {
      body += data + "\n";
    });

    // finished? ok, write the data to a file
    response.on('end', function() {
      console.log("Loaded: ", body.length);
      FilterProxy.filters = JSON.parse(body);
      console.log(FilterProxy.filters);
      setTimeout(function() { FilterProxy.runUpdate(); }, 2000);
    });
  },

  runUpdate: function() {
    console.log('load filters');
    // make the request, and then end it, to close the connection
    http.get("http://kidcurrency.herokuapp.com/users/6/filters.json", this.updateFilters);
  },


  processor: function(proxy) {

    this.url_rewrite = function(req_url, request) {
      // console.log("REQ: ", req_url);
      // console.log("REQ1: ", request.headers);
      var allow = false;

      var filters = FilterProxy.filters;
      var url = req_url.href;

      var referer = request.headers['referer'];

      for (var i=0;i < filters.length;i++) {
        var filter = filters[i];

        // normalize urls to ignore https?:// and www
        filter = filter.replace(/^https?[:]\/\//, '').replace(/^www[.]/, '');
        url = url.replace(/^https?[:]\/\//, '').replace(/^www[.]/, '');

        var regex = new RegExp('^'+filter+'.*$', 'i');
        if (url.match(regex) || (referer && referer.match(regex))) {
          allow = true;
        }
      }

      console.log(allow, url);
      if (!allow) {
        req_url.hostname = "nodejs.org";
      }
    };

    // proxy.on('request', function(request, req_url) {
    //   console.log("Requesting: " + url.format(req_url));
    //   req_url.hostname = 'google.com';
    // });
  },

  start: function() {
    console.log('starting proxy...');
    new Proxy({proxy_port: 8080}, this.processor);//, mitm_port: 8000
    this.runUpdate();
  }
};

FilterProxy.start();
