extends Node

signal loaded_settings()
signal changed_settings()
signal loaded_languages()
const SAVE_PATH = "res://config.cfg"

var _config_file:ConfigFile = ConfigFile.new()
var _settings = {
	"api" : {
		"key": "",
		"region": "global",
	},
	"config" : {
		"default_directory": OS.get_system_dir(OS.SYSTEM_DIR_MOVIES),
		"window_size": Vector2(680, 760),
		"dialog_quit": true,
		"default_tl_lang": 0,
	},
	"debug" : {
		"show_debug": false,
		"debug_timer": 5,
	}
}
var _default_settings = _settings.duplicate(true)
var loaded_languages:Array = []

func _ready() -> void:
	OS.min_window_size = Vector2(630, 340)
	load_settings_file()
	apply_settings()
	
	DebugGlobal.message("Loaded settings")
	emit_signal("loaded_settings")

func save_settings_file():
	DebugGlobal.message("Save settings file")
	for section in _settings.keys():
		for key in _settings[section]:
			_config_file.set_value(section, key, _settings[section][key])
	_config_file.save(SAVE_PATH)


func load_settings_file():
	var file = File.new()
	if file.file_exists(SAVE_PATH):
		DebugGlobal.message("Loading settings file")
		var error = _config_file.load(SAVE_PATH)
		if error != OK:
			print("Error loading config file, error code #", error)
			return
		
		for section in _settings.keys():
			for key in _settings[section]:
				_settings[section][key] = _config_file.get_value(section, key)
	else:
		DebugGlobal.message("Settings file not found, making one")
		save_settings_file()


func apply_settings():
	DebugGlobal.message("Apply settings")
	get_tree().set_auto_accept_quit(not get_setting("config", "dialog_quit"))
	OS.window_size = get_setting("config", "window_size")


func restore_settings():
	DebugGlobal.message("Reset settings")
	_settings = _default_settings.duplicate(true)
	get_tree().set_auto_accept_quit(not get_setting("config", "dialog_quit"))
	OS.window_size = get_setting("config", "window_size")
	emit_signal("changed_settings")


func get_setting(category, key):
	return _settings[category][key]


func set_setting(category, key, value):
	_settings[category][key] = value


func changed_settings():
	DebugGlobal.message("Emmit signal changed settings")
	emit_signal("changed_settings")
