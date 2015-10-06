//var page = require('webpage').create();
//page.open('http://github.com/', function() {
//    page.render('github.png');
//    phantom.exit();
//});
var page = require('webpage').create();
page.viewportSize = { width: 1024, height: 768 };
page.open('http://127.0.0.1:3000/', function() {
    page.render('./web_images/kudoso_index_web.png');
    phantom.exit();
});
//page.viewportSize = { width: 640, height: 960 };
//page.open('http://127.0.0.1:3000/', function() {
//    page.render('./web_images/kudoso_index_iphone4s.png');
//});
