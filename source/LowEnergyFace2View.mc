using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;


class LowEnergyFace2View extends WatchUi.WatchFace {


    function initialize() {

        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {

    	var timeWidget = new SimpleWidget(
    		{
    			:dc => dc,
    			:xParent => dc,
    			:yParent => dc,
    			:x => :center,
    			:y => :center,
    			:font => Graphics.FONT_NUMBER_HOT,
    			:value => "23:59:59",
    			:color => Graphics.COLOR_BLACK,
    			:backgroundColor => Graphics.COLOR_WHITE,
    			:id => :time
    		}
    	);
    	View.addLayer(timeWidget);
    	
    	var top = new SimpleWidget(
    		{
    			:dc => dc,
    			:xParent => timeWidget,
    			:yParent => timeWidget,
    			:x => :right,
    			:y => :bottomThan,
    			:font => Graphics.FONT_SMALL,
    			:value => "23:59:59",
    			:color => Graphics.COLOR_WHITE,
    			:backgroundColor => Graphics.COLOR_BLACK,
    			:id => :top
    		}
    	);
    	View.addLayer(top);

    	var topRight = new SimpleWidget(
    		{
    			:dc => dc,
    			:xParent => top,
    			:yParent => top,
    			:x => :leftThan,
    			:y => :bottomThan,
    			:font => Graphics.FONT_SMALL,
    			:value => "23:59:59",
    			:color => Graphics.COLOR_WHITE,
    			:backgroundColor => Graphics.COLOR_BLACK,
    			:id => :topRight
    		}
    	);
    	View.addLayer(topRight);

    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {

		//timeWidget.draw({:text => timeString});
		var layers = View.getLayers();

		for (var i = 0; i < layers.size(); i++){
			if (layers[i].getId() == :time){
				var clockTime = System.getClockTime();
				var timeString = clockTime.hour.format("%02d")+":"+clockTime.min.format("%02d")+":"+clockTime.sec.format("%02d");
				layers[i].draw({:text => timeString});
			}else{
				layers[i].draw({:text => "1234567"});			
			}
		}
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
