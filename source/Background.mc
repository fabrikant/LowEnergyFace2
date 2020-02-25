using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;

class Background extends WatchUi.Layer {

	var height, width, color;
	
    function initialize(param) {

		height = param[:dc].getHeight();
		width = param[:dc].getWidth();
		color = param[:color];
        Layer.initialize(
        	{
        		:locX => 0,
        		:locY => 0,
        		:width => width,
        		:height =>height,
        		:visibility => true,
        		:identifier	=> param[:id]
        	}
        );
    }

		
	function draw(){
		var targetDC = getDc();
		targetDC.setColor(color, Graphics.COLOR_TRANSPARENT);
		targetDC.fillRectangle(0, 0, width, height);
	}


 }