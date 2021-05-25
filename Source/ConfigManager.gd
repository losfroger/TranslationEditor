extends Node

const SAVE_PATH = "res://config.cfg"

var _config_file:ConfigFile = ConfigFile.new()
var _settings = {
	"api" : {
		"key": "",
		"region": "global"
	}
}


func _ready():
	OS.min_window_size = Vector2(630, 342)
	load_settings()
	print(_settings)

func save_settings():
	for section in _settings.keys():
		for key in _settings[section]:
			_config_file.set_value(section, key, _settings[section][key])
	_config_file.save(SAVE_PATH)


func load_settings():
	var file = File.new()
	if file.file_exists(SAVE_PATH):
		var error = _config_file.load(SAVE_PATH)
		if error != OK:
			print("Error loading config file, error code #", error)
			return
		
		for section in _settings.keys():
			for key in _settings[section]:
				_settings[section][key] = _config_file.get_value(section, key)
	else:
		save_settings()


func get_setting(category, key):
	return _settings[category][key]


func set_setting(category, key, value):
	_settings[category][key] = value
