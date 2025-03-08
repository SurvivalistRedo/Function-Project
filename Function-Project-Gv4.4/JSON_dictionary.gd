class_name JSON_dictionary

static func save(dictionary:Dictionary,save_path:String) -> void:
	var dictionary_types: PackedStringArray = [
		dictionary.get_typed_key_builtin(),
		dictionary.get_typed_value_builtin()]
	var json_string: String = JSON.stringify(Array([dictionary_types,dictionary]),"\t")
	
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	if file == null: print(error_string(file.get_open_error()))
	else: file.store_string(json_string)

static func load(load_path:String) -> Dictionary:
	var json: JSON = JSON.new()
	var file = FileAccess.open(load_path, FileAccess.READ)
	var file_text = file.get_as_text()
	json.parse(file_text)
	
	var loaded_dictionary: Dictionary
	for key in json.data[1].keys():
		var loaded_key = type_convert(key,json.data[0][0].to_int())
		var loaded_value = type_convert(json.data[1][key],json.data[0][1].to_int())
		loaded_dictionary[loaded_key] = loaded_value
	
	return Dictionary(
		loaded_dictionary,
		json.data[0][0].to_int(),&"",null,
		json.data[0][1].to_int(),&"",null
	)
