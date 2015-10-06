// Generate PNG images of each web page in the pages array
//
// To use, install PhantomJS and run:
// phantomjs generate_marketing_webpage_images.js
//

var baseUrl = "http://127.0.0.1:3000";
var pages = [ '/', '/teach', '/reward', '/limit', '/protect'];
// phantomjs page object and helper flag
var page = require('webpage').create(),
    loadInProgress = false,
    pageIndex = 0;

page.viewportSize = { width: 1024, height: 768 };

// page handlers
page.onLoadStarted = function() {
    loadInProgress = true;
    console.log('page ' + (pageIndex + 1) + ' load started');
};

page.onLoadFinished = function() {
    loadInProgress = false;
    page.render("./web_images/web_" + pages[pageIndex].replace("/", "") + ".png");
    console.log('page ' + (pageIndex + 1) + ' load finished');
    pageIndex++;
};


// try to load or process a new page every 250ms
setInterval(function() {
    if (!loadInProgress && pageIndex < pages.length) {
        console.log("image " + (pageIndex + 1));
        page.open(baseUrl + pages[pageIndex]);
    }
    if (pageIndex == pages.length) {
        console.log("image render complete!");
        phantom.exit();
    }
}, 250);









