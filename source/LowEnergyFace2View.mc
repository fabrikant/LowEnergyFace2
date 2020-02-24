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
    			:x => 0,
    			:y => dc.getWidth()/2,
    			:font => Graphics.FONT_NUMBER_HOT,
    			:value => "23:59:59",
    			:dc => dc,
    			:color => Graphics.COLOR_DK_GREEN,
    			:backgroundColor => Graphics.COLOR_DK_RED,
    			:id => :time
    		}
    	);
    	View.addLayer(timeWidget);

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
