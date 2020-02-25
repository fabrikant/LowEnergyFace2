using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;

class LowEnergyFace2View extends WatchUi.WatchFace {

	var dataReader;
	const imageFont = Application.loadResource(Rez.Fonts.images);	
    function initialize() {
		dataReader = new DataReader();
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
		
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_GREEN);
		dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
		
		View.addLayer(new Background({:dc =>dc, :color => Graphics.COLOR_WHITE, :id => :background}));
		
    	var timeWidget = new SimpleWidget(
    		{
    			:dc => dc,
    			:xParent => dc,
    			:yParent => dc,
    			:x => :center,
    			:y => :center,
    			:font => Graphics.FONT_NUMBER_THAI_HOT,
    			:maxLongValue => "23:59",
    			:method => dataReader.method(:time),
    			:color => Graphics.COLOR_BLACK,
    			:backgroundColor => Graphics.COLOR_WHITE,
    			:id => :time
    		}
    	);
    	View.addLayer(timeWidget);

    	var dateWidget = new SimpleWidget(
    		{
    			:dc => dc,
    			:xParent => dc,
    			:yParent => timeWidget,
    			:x => :center,
    			:y => :topThan,
    			:font => Graphics.FONT_SYSTEM_XTINY,
    			:maxLongValue => dataReader.date()[:string],
    			:method => dataReader.method(:date),
    			:color => Graphics.COLOR_BLACK,
    			:backgroundColor => Graphics.COLOR_WHITE,
    			:id => :time
    		}
    	);
    	View.addLayer(dateWidget);
    	
    	var maxLongValue = "9999";
//    	var f1 = new DecorWidget(
//    		{
//    			:dc => dc,
//    			:xParent => timeWidget,
//    			:yParent => timeWidget,
//    			:x => :left,
//    			:y => :bottomThan,
//    			:yOffset => 5,
//    			:font => Graphics.FONT_SYSTEM_XTINY,
//    			//:imageFont => imageFont,
//    			:maxLongValue => maxLongValue,
//    			:method => dataReader.method(:heartRate),
//    			:color => Graphics.COLOR_BLACK,
//    			:backgroundColor => Graphics.COLOR_WHITE,
//    			:id => :f1
//    		}
//    	);
//    	View.addLayer(f1);

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
			layers[i].draw();
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
