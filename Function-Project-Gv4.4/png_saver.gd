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
		var file_name: String = timestamp_generator.generate_timestamp() + ".png"
		
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
