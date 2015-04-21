(function ($) {
    $.fn.rangeSelector = function (options) {
        var settings = $.extend({
            blocks: (4 * 24),
            initialSize: 6,
            controlsSize: 2,
            times: []
        }, options);


        return this.each(function () {
            var $that = $(this);
            var isDragging = false;
            var base = $(this).height() / settings.blocks;
            var timeBlocks = [];
            var divArray = []
            var times = null;
            var maxBlock = settings.blocks;
            var minPerBlock = 24 * 60 / settings.blocks;
            var startBlock, endBlock = null;

            console.log('Initial time blocks: ' + JSON.stringify(timeBlocks));
            //setup initial blocks
            for (var x in settings.times) {
                if (typeof(settings.times[x]) == 'object' && settings.times[x].length == 2) {
                    startBlock = (settings.times[x][0] / 60) / minPerBlock;
                    endBlock = (settings.times[x][1] / 60) / minPerBlock;
                    timeBlocks.push([startBlock,endBlock]);
                    var start = startBlock * base;
                    var end = endBlock * base;
                    var div = createDiv(start,end);
                    $that.append(div);
                    divArray.push(div);
                }

            }

            setTimeBlocks();

            $(this).mousedown(function (e) {
                var div = null;
                var posX = $(this).position().left,
                    posY = $(this).position().top;
                var percentY = (e.pageY - posY) / $that.height();
                startBlock = Math.floor(percentY * settings.blocks);
                endBlock = Math.floor(percentY * settings.blocks) + settings.initialSize;
                console.log('Starting block: ' + startBlock);
                var start = startBlock * base; // + $that.position().top;
                var end =  start + (base * settings.initialSize); //start + base;
                var idx = 0;

                for (var x in timeBlocks) {

                    times = timeBlocks[x];
                    console.log('In loop: ' + x + ' : ' + JSON.stringify(times));
                    if (Array.isArray(times) && times.length == 2) {
                        if (times[0] <= startBlock && times[1] < startBlock) {
                            console.log('Found earlier block: ' + times[0] + ':' + times[1]);
                            idx++;
                        } else {
                            if (times[0] <= startBlock && times[1] >= startBlock) {
                                console.log('Using existing div: ' + x);
                                div = divArray[idx];
                                var dialog = document.createElement("div");
                                $(dialog).addClass('panel');
                                $(dialog).attr('title', "Delete this time restriction?");
                                $(dialog).html('<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>This time restriction will be deleted, are you sure?</p>');
                                $that.append(dialog);
                                $( dialog ).dialog({
                                    resizable: false,
                                    height:140,
                                    modal: true,
                                    buttons: {
                                        "Delete Restriction": function() {
                                            divArray.splice(idx,1);
                                            timeBlocks.splice(idx,1);
                                            $( this ).dialog( "close" );
                                            $( div ).remove();

                                        },
                                        Cancel: function() {
                                            $( this ).dialog( "close" );
                                            $( this).remove();
                                        }
                                    }
                                });


                                //var height = (endBlock - times[0]) * base;
                                //timeBlocks[idx][1] = endBlock;
                                //console.log('height: ' + height);
                                //div.style.height = height + 'px';
                                break;
                            } else {
                                console.log('Creating new div at index: ' + x);
                                div = createDiv(start,end);
                                if (idx == 0) {
                                    $that.prepend(div);
                                } else {
                                    var prevDiv = divArray[idx - 1]
                                    $(div).insertAfter(prevDiv);
                                }

                                divArray.splice(idx, 0, div); // inserts the div into the array
                                var elm = [startBlock, (startBlock + 1)];
                                timeBlocks.splice(idx, 0, elm);
                                break;

                            }
                        }
                    }
                }
                if (div == null) {
                    console.log('div still null!');
                    div = createDiv(start,end);
                    $that.append(div);
                    divArray.splice(idx, 0, div); // inserts the div into the array
                    var newElm = [startBlock, (startBlock + 1)];
                    timeBlocks.splice(idx, 0, newElm);
                    setTimeBlocks();
                    div = null;
                } else {
                    console.log('div is not null!');
                }
                console.log('idx: ' + idx + ' - ' + JSON.stringify(timeBlocks));



            });

            function setTimeBlocks(){
                var newTime = [];
                for (var x in timeBlocks) {
                    var start = timeBlocks[x][0] *  minPerBlock * 60; // time is in seconds since midnight
                    var end = timeBlocks[x][1] *  minPerBlock * 60;
                    newTime.push([start, end]);
                }
                $that.data('timeBlocks', newTime);
            }

            function setHeight(e) {
                e.stopPropagation();
                var div = e.data.div;
                if (div == null) {
                    console.log("ERROR - div cannot be null here!");
                    return;
                }
                // this = day div
                var posX = $(this).position().left,
                    posY = $(this).position().top;

                var child = div;
                var idx = 0;
                while ((child = child.previousSibling) != null)
                idx++;

                if (timeBlocks.length > idx + 1) {
                    maxBlock = timeBlocks[(idx + 1)][0];
                } else {
                    maxBlock = settings.blocks;
                }


                var percentY = (e.pageY - posY) / $(this).height();
                console.log('max blocks: ' + maxBlock + ' idx: ' + idx + ' %Y: ' + percentY);
                endBlock = Math.max(Math.min((Math.floor(percentY * settings.blocks) + 1), maxBlock), timeBlocks[idx][0] + (settings.controlsSize * 2));
                startBlock = timeBlocks[idx][0];
                timeBlocks[idx] = [timeBlocks[idx][0], endBlock];

                setTimeBlocks();


                var height = Math.max(Math.floor((timeBlocks[idx][1] - timeBlocks[idx][0]) * base), base);

                console.log(" -- In setHeight -- Height: " + height + " X: " + posX + " Y: " + posY + " e.pageX: " + e.pageX + " e.pageY: " + e.pageY + " Start block: " + timeBlocks[idx][0] + " End block: " + endBlock);
                div.style.height = height + 'px';

                var hours = Math.floor(startBlock * minPerBlock / 60);
                var minutes = (startBlock * minPerBlock % 60) + "";
                while (minutes.length < 2) minutes = "0" + minutes;
                div.firstChild.innerHTML = hours + ":" + minutes;
                hours = Math.floor(endBlock * minPerBlock / 60);
                minutes = (endBlock * minPerBlock % 60) + "";
                while (minutes.length < 2) minutes = "0" + minutes;
                div.lastChild.innerHTML = hours + ":" + minutes;
            }

            function setStartHeight(e) {
                e.stopPropagation();
                var div = e.data.div;
                if (div == null) {
                    console.log("ERROR - div cannot be null here!");
                    return;
                }
                // this = day div
                var posX = $(this).position().left,
                    posY = $(this).position().top;

                var child = div;
                var idx = 0;

                while ((child = child.previousSibling) != null)
                    idx++;

                if (idx > 0) {
                    minBlock = timeBlocks[(idx - 1)][1];
                } else {
                    minBlock = 0;
                }

                var percentY = (e.pageY - posY) / $(this).height();
                console.log('idx' + idx + 'min blocks: ' + minBlock + ' idx: ' + idx + ' %Y: ' + percentY);
                startBlock = Math.min(Math.max((Math.floor(percentY * settings.blocks) + 1), minBlock), timeBlocks[idx][1] - (settings.controlsSize * 2));
                endBlock = timeBlocks[idx][1];
                timeBlocks[idx] = [startBlock, timeBlocks[idx][1]];
                setTimeBlocks();

                var height = Math.max(Math.floor((timeBlocks[idx][1] - timeBlocks[idx][0]) * base), base);

                console.log(" -- In setStartHeight -- Height: " + height + " X: " + posX + " Y: " + posY + " e.pageX: " + e.pageX + " e.pageY: " + e.pageY + " Start block: " + timeBlocks[idx][0] + " End block: " + endBlock);

                div.style.top = startBlock * base  + 'px';
                div.style.height = height + 'px';

                var hours = Math.floor(startBlock * minPerBlock / 60);
                var minutes = (startBlock * minPerBlock % 60) + "";
                while (minutes.length < 2) minutes = "0" + minutes;
                div.firstChild.innerHTML = hours + ":" + minutes;
                hours = Math.floor(endBlock * minPerBlock / 60);
                minutes = (endBlock * minPerBlock % 60) + "";
                while (minutes.length < 2) minutes = "0" + minutes;
                div.lastChild.innerHTML = hours + ":" + minutes;
            }

            function createDiv(startPos,endPos) {
                console.log('Creating div at start: ' + startPos + ' end: ' + endPos);
                var div = document.createElement("div");

                div.style.top = startPos + 'px';
                div.style.height = (endPos - startPos) + 'px'; //(base * settings.initialSize) + 'px';
                div.style.width = $that.width() + 'px';
                div.style.position = 'absolute';
                div.style.backgroundColor = 'yellow';

                var header = document.createElement("div");
                header.style.top = 0;
                header.style.height = (base * settings.controlsSize) + 'px';
                header.style.width = '100%';
                header.style.position = 'absolute';
                header.style.backgroundColor = 'orange';
                header.style.color = 'white';
                header.style.textAlign = 'center';
                header.style.fontSize = '8px';

                $(header).mousedown(function (e) {
                    e.stopPropagation();
                    var parent = this.parentNode;

                    div = parent;
                    console.log('set div');
                    var day = parent.parentNode;

                    $(day).bind("mousemove", {
                        div: div
                    }, setStartHeight);
                    $(day).mouseup(function (e) {
                        e.stopPropagation();
                        $(day).unbind("mousemove", setStartHeight);
                        div = null;
                    });

                });

                var hours = Math.floor(startBlock * minPerBlock / 60);
                var minutes = (startBlock * minPerBlock % 60) + "";
                while (minutes.length < 2) minutes = "0" + minutes;
                header.innerHTML = hours + ":" + minutes;

                $(div).append(header);

                var footer = document.createElement("div");
                footer.style.bottom = 0;
                footer.style.height = (base * settings.controlsSize) + 'px';
                footer.style.width = '100%';
                footer.style.position = 'absolute';
                footer.style.backgroundColor = 'blue';
                footer.style.color = 'white';
                footer.style.textAlign = 'center';
                footer.style.fontSize = '8px';
                footer.style.display = "table-cell";
                footer.style.verticalAlign = 'bottom';
                footer.style.lineHeight = '8px';

                $(footer).mousedown(function (e) {
                    e.stopPropagation();
                    var parent = this.parentNode;

                    div = parent;
                    console.log('set div');
                    var day = parent.parentNode;

                    $(day).bind("mousemove", {
                        div: div
                    }, setHeight);
                    $(day).mouseup(function (e) {
                        e.stopPropagation();
                        $(day).unbind("mousemove", setHeight);
                        div = null;
                    });
                });


                hours = Math.floor(endBlock * minPerBlock / 60);
                minutes = (endBlock * minPerBlock % 60) + "";
                while (minutes.length < 2) minutes = "0" + minutes;
                footer.innerHTML = hours + ":" + minutes;

                $(div).append(footer);

                return div;
            }


        });
    }
}(jQuery));

$('#today').rangeSelector();
$('#tomorrow').rangeSelector({
    blocks: (1 * 24),
    initialSize: 4
});
