using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;

class SimpleWidget extends WatchUi.Layer {

	private var width = 0, height = 0;
	private var curFont, backgroundColor, color;

    function initialize(params) {

		curFont = params[:font];
		var longText = params[:value].toString();
		height = Graphics.getFontHeight(curFont) - 2* (Graphics.getFontHeight(curFont) - Graphics.getFontAscent(curFont));
		width = params[:dc].getTextWidthInPixels(params[:value].toString(), curFont);
		color = params[:color];
		backgroundColor = params[:backgroundColor];

        Layer.initialize(
        	{
        		:locX => params[:x],
        		:locY => params[:y],
        		:width => width,
        		:height => height,
        		:visibility => true,
        		:identifier	=> params[:id]
        	}
        );
    }

	function getX0(){
		return getX();
	}

	function getX1(){
		return getX0() + height;
	}

	function getY0(){
		return getY();
	}

	function getY1(){
		return getY0() + width;
	}

	function getWidth(){
		return width;
	}

	function getHeight(){
		return height;
	}

	function draw(param){
//		System.println(getX0());
//		System.println(getY0());
//		System.println(getX1());
//		System.println(getY1());
//		System.println(curFont);


		clearField();
		border();
		var targetDc = getDc();
		targetDc.setColor(color,Graphics.COLOR_TRANSPARENT);
		if (param[:justify] == null){
			targetDc.drawText(
				getWidth()/2 - 1,
				getHeight()/2 - 1,
				curFont,
				param[:text],
				Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
			);
		}else if ((param[:justify] == Graphics.TEXT_JUSTIFY_LEFT)){
			param[:targetDc].drawText(
				0,
				0,
				curFont,
				param[:text],
				Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
			);
		}
	}

	 function border(){
		var targetDc = getDc();
	    targetDc.setColor(color, Graphics.COLOR_TRANSPARENT);
		targetDc.drawRectangle(0, 0, getWidth(), getHeight());
	}

	function clearField(){
		var targetDc = getDc();
	    targetDc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
		targetDc.fillRectangle(0, 0, getWidth(), getHeight());
	}
 }