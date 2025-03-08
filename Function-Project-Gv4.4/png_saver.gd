@tool class_name png_saver extends EditorScript

func _run() -> void:
	var project_name: String = ProjectSettings.get_setting("application/config/name")
	var engine_exe_folder: String = parent_folder(OS.get_executable_path())
	
	if false:
		JSON_dictionary.save(
			Dictionary({
					project_name+"/Archive":
						"Nec vero, ut noster Lucilius, recusabo, quo minus omnes mea legant."
				},
				TYPE_STRING,&"",null,
				TYPE_STRING,&"",null
			),
			engine_exe_folder+"/project_directory.txt"
		)
	
	else:
		var img_data: PackedByteArray = PackedByteArray()
		for pixel in 512*512:
			for channel in 4:
				img_data.append(randi_range(0,255))
		var img: Image = Image.create_from_data(512,512,false,Image.FORMAT_RGBA8,img_data)
		var file_name: String = generate_timestamp() + ".png"
		
		var save_path: String = JSON_dictionary.load(
			engine_exe_folder+"/project_directory.txt"
		)[project_name+"/Archive"]
		
		img.save_png(save_path+"/"+file_name)
		print(file_name+" saved into "+save_path)

static func parent_folder(path: String) -> String:
	while true:
		if path.length() == 0:
			break
		elif path.substr(path.length()-1) == "/":
			break
		else:
			path = path.erase(path.length()-1,1)
	path = path.erase(path.length()-1,1)
	return path

static func generate_timestamp() -> String:
	var timestamp: String
	var datetime: Dictionary = Time.get_datetime_dict_from_system()
	var timezone: Dictionary = Time.get_time_zone_from_system()
	var runtime_milliseconds: int = Time.get_ticks_msec()
	
	for key in datetime.keys():
		if (key == "weekday"): continue
		var appendage: String
		match(key):
			"year": appendage = str(datetime[key]) + "_"
			"month": appendage = month_string_from_int(datetime[key]) + "_"
			"day": appendage = ordinal_numeral_string_from_int(datetime[key]) + "_"
			"hour": appendage = "%02d"%[datetime[key]] + "-"
			"minute": appendage = "%02d"%[datetime[key]] + "-"
			"second":
				appendage = appendage + "%02d"%[datetime[key]] + "_"
				appendage = appendage + UTC_stamp_string_from_minutes_int(timezone["bias"]) + "_"
				appendage = appendage + "dst"+("TRUE" if datetime["dst"] else "FALSE") + "_"
				appendage = appendage + "rt-msec-"+str(runtime_milliseconds)
			_: breakpoint
		timestamp = timestamp + appendage
	
	return timestamp

static func month_string_from_int(month:int) -> String:
	const months: Dictionary[int,String] = {
		1:"January",2:"February",3:"March",4:"April",
		5:"May",6:"June",7:"July",8:"August",
		9:"September",10:"October",11:"November",12:"December"
	}
	if months.has(month): return months[month]
	else: return "Wildcard"

static func ordinal_numeral_string_from_int(day:int) -> String:
	const ordinal_numerals: Dictionary[int, String] = {
		1: "1st",  2: "2nd",  3: "3rd",  4: "4th",  5: "5th",  6: "6th",
		7: "7th",  8: "8th",  9: "9th", 10: "10th", 11: "11th", 12: "12th",
		13: "13th", 14: "14th", 15: "15th", 16: "16th", 17: "17th", 18: "18th",
		19: "19th", 20: "20th", 21: "21st", 22: "22nd", 23: "23rd", 24: "24th",
		25: "25th", 26: "26th", 27: "27th", 28: "28th", 29: "29th", 30: "30th",
		31: "31st"
	}
	if ordinal_numerals.has(day): return ordinal_numerals[day]
	else: return "Wildcard"

static func UTC_stamp_string_from_minutes_int(bias:int) -> String:
	var sign: String = " + " if (bias >= 0) else "-"
	var hour: int = absi(bias)/60
	var minute: int = absi(bias)%60
	return "UTC%s%02d%02d" % [sign,hour,minute]
