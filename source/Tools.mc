using Toybox.Application;
using Toybox.System;
using Toybox.Math;
using Toybox.Time;
using Toybox.Time.Gregorian;

module Tools {

    function moonPhase(now)
    {
    	//var now = Time.now();
        var date = Time.Gregorian.info(now, Time.FORMAT_SHORT);
        // date.month, date.day date.year

		var n0 = 0;
		var f0 = 0.0;
		var AG = f0;

		//current date
	    var Y1 = date.year;
	    var M1 = date.month;
	    var D1 = date.day;

	    var YY1 = n0;
	    var MM1 = n0;
	    var K11 = n0;
	    var K21 = n0;
	    var K31 = n0;
	    var JD1 = n0;
	    var IP1 = f0;
	    var DP1 = f0;

	    // calculate the Julian date at 12h UT
	    YY1 = Y1 - ( ( 12 - M1 ) / 10 ).toNumber();
	    MM1 = M1 + 9;
	    if( MM1 >= 12 ) {
	    	MM1 = MM1 - 12;
	    }
	    K11 = ( 365.25 * ( YY1 + 4712 ) ).toNumber();
	    K21 = ( 30.6 * MM1 + 0.5 ).toNumber();
	    K31 = ( ( ( YY1 / 100 ) + 49 ).toNumber() * 0.75 ).toNumber() - 38;

	    JD1 = K11 + K21 + D1 + 59;                  // for dates in Julian calendar
	    if( JD1 > 2299160 ) {
	    	JD1 = JD1 - K31;        				// for Gregorian calendar
		}

	    // calculate moon's age in days
	    IP1 = normalize( ( JD1 - 2451550.1 ) / 29.530588853 );
	    var AG1 = IP1*29.53;

		return AG1.toNumber();

    }

    function normalize( v )
	{
	    v = v - v.toNumber();
	    if( v < 0 ) {
	        v = v + 1;
		}
	    return v;
	}

	function stringReplace(str, find, replace){
		var res = "";
		var ind = str.find(find);
		var len = find.length();
		var first;
		while (ind != null){
			if (ind == 0) {
				first = "";
			} else {
				first = str.substring(0, ind);
			}
			res = res + first + replace;
			str = str.substring(ind + len, str.length());
			ind = str.find(find);
		}
		res = res + str;
		return res;
	}

	function weekOfYear(moment){

		var momentInfo = Gregorian.info(moment, Gregorian.FORMAT_SHORT);
		var jan1 = 	Gregorian.moment(
			{
				:year => momentInfo.year,
				:month => 1,
				:day =>1,
			}
		);

		var jan1DayOfWeek = Gregorian.info(jan1, Gregorian.FORMAT_SHORT).day_of_week;
		jan1DayOfWeek = jan1DayOfWeek == 1 ? 7 : jan1DayOfWeek - 1;

		if (jan1DayOfWeek < 5){

			var beginMoment = jan1;
			if (jan1DayOfWeek > 1){
				beginMoment = Gregorian.moment(
					{
						:year => momentInfo.year-1,
						:month => 12,
						:day =>33-jan1DayOfWeek,
					}
				);
			}
			return 1 + beginMoment.subtract(moment).value()/(Gregorian.SECONDS_PER_DAY*7);
		} else{

			return weekOfYear(
				Gregorian.moment(
					{
						:year => momentInfo.year-1,
						:month => 12,
						:day =>31,
					}
				)
			);
		}
	}

	function min(a,b){
	 if(a>b){
	 	return b;
	 } else {
	 	return a;
	 }
	}

	function max(a,b){
	 if(a>b){
	 	return a;
	 } else {
	 	return b;
	 }
	}

}