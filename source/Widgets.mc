using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;

class DecorWidget extends SimpleWidget{
   	
    function initialize(param) {
    	setViewParams(param);
    	height = Graphics.getFontHeight(font) - 2* (Graphics.getFontHeight(font) - Graphics.getFontAscent(font))+1;
		//var imageFont = param[:imageFont];
		var imageFont = Application.loadResource(Rez.Fonts.images);   	
    	var imageHeight = Graphics.getFontHeight(imageFont) - 2* (Graphics.getFontHeight(imageFont) - Graphics.getFontAscent(imageFont))+1;
    	height = Tools.max(height, imageHeight);
    	width = param[:dc].getTextWidthInPixels(param[:maxLongValue], font) + height;
    	
    	SimpleWidget.initialize(param);
	}
	
	function setViewParams(param){
		//imageFont = param[:imageFont];
		SimpleWidget.setViewParams(param);		
	}
	
	function draw(){
	
		var arrayValues = method.invoke();
		if (oldValue == arrayValues[:value]){
			return;
		} 
		clearField();
		
		
		var y = getHeight()/2 - 1;
		var targetDc = getDc();
		targetDc.setColor(color,Graphics.COLOR_TRANSPARENT);
		targetDc.drawText(
			0,
			y,
			Application.loadResource(Rez.Fonts.images),
			arrayValues[:imageString],
			Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
		);
		drawTextValue(height, arrayValues);	
	}
} 

class SimpleWidget extends WatchUi.Layer {

	protected var width = 0, height = 0;
	protected var font, backgroundColor, color, justify;
	protected var method = null;
	protected var oldValue = null;
	
	//param 
	//	:font
	//	:dc
	//	:color
	//	:backgroundColor
	//  :justify - optional
	//	:maxLongValue - text for calculating widht and height
	//	:xParent - dc or widget or null
	//	:yParent - dc or widget or null
	//	:x - num or if :parent set - :left, :leftThan, :right, :rightThan, :center
	//	:y - num or if :parent set - :top, :bottom, :topThan, :bottomThan, :center
	//  :xOffset - num or null
	//  :yOffset - num or null
	//	:method - method for calculate value
	//
    function initialize(param) {

		setViewParams(param);
		
		if (height==0){
			height = Graphics.getFontHeight(font) - 2* (Graphics.getFontHeight(font) - Graphics.getFontAscent(font))+1;
		}
		if (width==0){
			width = param[:dc].getTextWidthInPixels(param[:maxLongValue], font);
		}

		var coord = coord(param);
        Layer.initialize(
        	{
        		:locX => coord[0],
        		:locY => coord[1],
        		:width => width,
        		:height => height,
        		:visibility => true,
        		:identifier	=> param[:id]
        	}
        );
    }

	private function coord(param){
		var coord = [0,0];
		var parentCoord = new [4];
		
		if (param[:xParent] == null){
			coord[0] = param[:x];
		} else {
			
			if(param[:xParent] instanceof Toybox.Graphics.Dc){
				parentCoord[0] = 0;
				parentCoord[2] = param[:xParent].getWidth();
			} else {
				parentCoord[0] = param[:xParent].getX0();
				parentCoord[2] = param[:xParent].getX1();
			}
			
			if (param[:x] == :left){
				coord[0] = parentCoord[0];
			} else if (param[:x] == :leftThan){
				coord[0] = parentCoord[0] - width;
			} else if (param[:x] == :right){
				coord[0] = parentCoord[2] - width;							
			} else if (param[:x] == :rightThan){
				coord[0] = parentCoord[2];							
			} else if (param[:x] == :center){
				coord[0] = (parentCoord[2]-parentCoord[0])/2 - width / 2;
			}
		}
		
		if (param[:yParent] == null){
			coord[1] = param[:y];
		} else {
			if(param[:yParent] instanceof Toybox.Graphics.Dc){
				parentCoord[1] = 0;
				parentCoord[3] = param[:yParent].getHeight();
			} else {
				parentCoord[1] = param[:yParent].getY0();
				parentCoord[3] = param[:yParent].getY1();
			}
			
			if (param[:y] == :top){
				coord[1] = parentCoord[1];
			} else if (param[:y] == :topThan){
				coord[1] = parentCoord[1] - height;
			} else if (param[:y] == :bottom){
				coord[1] = parentCoord[3] - height;
			} else if (param[:y] == :bottomThan){
				coord[1] = parentCoord[3];
			} else if (param[:y] == :center){
				coord[1] = (parentCoord[3]-parentCoord[1])/2 - height / 2;
			}
		}
		if (param[:xOffset] != null){
			coord[0] += param[:xOffset]; 
		}
		if (param[:yOffset] != null){
			coord[1] += param[:yOffset]; 
		}
		return coord;
	}
	
	function drawTextValue(xOffset, arrayValues){
	
		oldValue = arrayValues[:value];
		
		border();
		var targetDc = getDc();
		
		targetDc.setColor(color,Graphics.COLOR_TRANSPARENT);
		var y = getHeight()/2 - 1;
		if (justify == null || justify == Graphics.TEXT_JUSTIFY_CENTER){
			targetDc.drawText(
				xOffset + (getWidth()- xOffset)/2 - 1,
				y,
				font,
				arrayValues[:string],
				Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
			);
		}else if (justify == Graphics.TEXT_JUSTIFY_LEFT){
			targetDc.drawText(
				xOffset,
				y,
				font,
				arrayValues[:string],
				Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
			);
		}else if (justify == Graphics.TEXT_JUSTIFY_RIGHT){
			targetDc.drawText(
				getX1()-targetDc.getTextWidthInPixels(value, font),
				y,
				font,
				arrayValues[:string],
				Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
			);
		}
	}
		
	function draw(){
		var arrayValues = method.invoke();
		
		if (oldValue == arrayValues[:value]){
			return;
		} 
		clearField();
		drawTextValue(0, arrayValues);
				
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
	
	function setViewParams(param){
		font = param[:font];
		color = param[:color];
		backgroundColor = param[:backgroundColor];
		method = param[:method];
	}
	
	function getX0(){
		return getX();
	}

	function getX1(){
		return getX0() + width;
	}

	function getY0(){
		return getY();
	}

	function getY1(){
		return getY0() + height;
	}

	function getWidth(){
		return width;
	}

	function getHeight(){
		return height;
	}
	
 }