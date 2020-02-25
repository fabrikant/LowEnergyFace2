using Toybox.System;
using Toybox.SensorHistory;
using Toybox.ActivityMonitor;
using Toybox.Activity;
using Toybox.Time;
using Toybox.Time.Gregorian;

class DataReader extends Toybox.Lang.Object {

	var cash;
	
	function initialize(){
		clearCash();
	}
	
	function clearCash(){
		cash = {};
	}
	
	function time(){
		var res = {};
		var clockTime = System.getClockTime();
		res[:value]  = clockTime.hour*100+clockTime.min;
		res[:string] = clockTime.hour.format("%02d")+":"+clockTime.min.format("%02d"); 
		return res;
	}
	
	function date(){
		var now = Time.now();
		var today = Gregorian.info(now, Time.FORMAT_MEDIUM);

		if (cash[:date] != null && cash[:date][:value] == today.day){
			return cash[:date];			
		}
		var todayShort = Gregorian.info(now, Time.FORMAT_SHORT);
		var firstDayOfYear = Gregorian.moment(
			{
				:year => today.year,
				:month => 1,
				:day =>1,
			}
		);
		var dur = firstDayOfYear.subtract(now);
		var dayOfYear = 1+dur.value()/Gregorian.SECONDS_PER_DAY;
		var weekFromFirstDay = dur.value()/(Gregorian.SECONDS_PER_DAY*7);
		var firstDayOfWeekSettings = System.getDeviceSettings().firstDayOfWeek;
		var dayOfWeek = todayShort.day_of_week;
		if (firstDayOfWeekSettings == 2){
			dayOfWeek = dayOfWeek == 1 ? 7 : dayOfWeek-1;
		} else if(firstDayOfWeekSettings == 7){
			dayOfWeek = dayOfWeek == 7 ? 1 : dayOfWeek+1;
		}

		var dateString = "%D.%m.%Y %W %DN/%WN";
		dateString = Tools.stringReplace(dateString,"%WN",Tools.weekOfYear(now));
		dateString = Tools.stringReplace(dateString,"%DN",dayOfYear);
		dateString = Tools.stringReplace(dateString,"%w",dayOfWeek);
		dateString = Tools.stringReplace(dateString,"%W",today.day_of_week);
		dateString = Tools.stringReplace(dateString,"%d",today.day);
		dateString = Tools.stringReplace(dateString,"%D",today.day.format("%02d"));
		dateString = Tools.stringReplace(dateString,"%m",todayShort.month.format("%02d"));
		dateString = Tools.stringReplace(dateString,"%M",today.month);
		dateString = Tools.stringReplace(dateString,"%y",today.year.toString().substring(2, 4));
		dateString = Tools.stringReplace(dateString,"%Y",today.year);
		
		cash[:date] = {:value => today.day, :string => dateString};
		return cash[:date];		
	}
	
	function heartRate(){
		var value = 0;
		var info = Activity.getActivityInfo();
		if (info != null){
			if (info has :currentHeartRate){
				value = info.currentHeartRate;
			}
		}
		if (value == null){
			if (Toybox has :SensorHistory){
				if (Toybox.SensorHistory has :getHeartRateHistory){
					var iter = SensorHistory.getHeartRateHistory({:period =>1, :order => SensorHistory.ORDER_NEWEST_FIRST});
					if (iter != null){
						var sample = iter.next();
						if (sample != null){
							if (sample.data != null){
								value = sample.data;
							}
						}
					}
				}
			}
		}
		
		return {:value => value, :string => value.toString(), :imageString => "g"};	
	}
}