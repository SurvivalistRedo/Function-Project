class_name timestamp_generator

static func generate_timestamp() -> String:
	var datetime: Dictionary = Time.get_datetime_dict_from_system()
	var timezone: Dictionary = Time.get_time_zone_from_system()
	var runtime_milliseconds: int = Time.get_ticks_msec()
	var timestamp: String
	
	for key in datetime.keys():
		if (key == "weekday") or (key == "dst"): continue
		var tens_place: int = ( datetime[key]%100 - datetime[key]%10 ) / 10
		var ones_place: int = datetime[key]%10
		var ordinal_suffix: String = ordinal_suffix_string_from_ints(tens_place,ones_place)
		var appendage: String
		if ["year","month","day","hour","minute"].has(key):
			appendage = "%02d"%[datetime[key]] + ordinal_suffix + key.left(1).capitalize() + "_"
		elif ["second"].has(key):
			appendage = "%02d"%[datetime[key]] + ordinal_suffix + key.left(1).capitalize() + "_"
			appendage = appendage + UTC_stamp_string_from_minutes_int(timezone["bias"]) + "_"
			appendage = appendage + "dst"+("TRUE" if datetime["dst"] else "FALSE") + "_"
			appendage = appendage + "rt-msec-"+str(runtime_milliseconds)
		else:
			return "Wildcard"
		timestamp = timestamp + appendage
	
	return timestamp

#static func month_string_from_int(month:int) -> String:
	#const months: Dictionary[int,String] = {
		#1:"January",2:"February",3:"March",4:"April",
		#5:"May",6:"June",7:"July",8:"August",
		#9:"September",10:"October",11:"November",12:"December"
	#}
	#if months.has(month): return months[month]
	#else: return "Wildcard"

static func ordinal_suffix_string_from_ints(tens_place:int,ones_place:int) -> String:
	if tens_place == 1:
		return "th"
	else:
		if [0,4,5,6,7,8,9].has(ones_place):
			return "th"
		else:
			match (ones_place):
				1: return "st"
				2: return "nd"
				3: return "rd"
				_: return "Wildcard"

static func UTC_stamp_string_from_minutes_int(bias:int) -> String:
	var sign: String = " + " if (bias >= 0) else "-"
	var hour: int = absi(bias)/60
	var minute: int = absi(bias)%60
	return "UTC%s%02dh%02dm"%[sign,hour,minute]
