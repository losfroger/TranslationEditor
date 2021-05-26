extends WindowDialog

# Config
onready var directoryPath = $Margin/MainContainer/Tabs/General/VBox/Directory/DirectoryPath
onready var acceptQuit = $Margin/MainContainer/Tabs/General/VBox/AcceptQuit
# Window Size
onready var winWidth = $Margin/MainContainer/Tabs/General/VBox/WindowSize/Width/WidthBox
onready var winHeight = $Margin/MainContainer/Tabs/General/VBox/WindowSize/Height/HeightBox
# Api
onready var apiKey = $Margin/MainContainer/Tabs/Api/VBox/ApiKey
onready var apiRegion = $Margin/MainContainer/Tabs/Api/VBox/ApiRegion

onready var resetBtn = $Margin/MainContainer/Tabs/General/VBox/Reset

onready var fileDialog = $FileDialog
onready var acceptDialog = $AcceptDialog

func _ready() -> void:
	resetBtn.connect("pressed", acceptDialog, "popup_centered")
	
	ConfigManager.connect("changed_settings", self, "load_settings")
	load_settings()

func load_settings() -> void:
	# Config
	directoryPath.text = ConfigManager.get_setting("config", "default_directory")
	acceptQuit.pressed = ConfigManager.get_setting("config", "dialog_quit")
	# WinSize
	winWidth.value = ConfigManager.get_setting("config", "window_size").x
	winHeight.value = ConfigManager.get_setting("config", "window_size").y
	# Api
	apiKey.text = ConfigManager.get_setting("api", "key")
	apiRegion.text = ConfigManager.get_setting("api", "region")
	
	fileDialog.current_dir = ConfigManager.get_setting("config", "default_directory")


func _on_DirectoryButton_pressed() -> void:
	fileDialog.popup()


func _on_FileDialog_dir_selected(dir: String) -> void:
	directoryPath.text = dir
	fileDialog.current_dir = dir


func _on_WindowSize_pressed() -> void:
	var size:Vector2 = OS.window_size
	winWidth.value = size.x
	winHeight.value = size.y

# Revert things
func _on_AcceptDialog_confirmed() -> void:
	ConfigManager.restore_settings()

# Save settings
func _on_Accept_pressed() -> void:
	ConfigManager.set_setting("config", "default_directory", directoryPath.text)
	ConfigManager.set_setting("config", "dialog_quit", acceptQuit.pressed)
	# WinSize
	ConfigManager.set_setting("config", "window_size", Vector2(winWidth.value, winHeight.value))
	# Api
	ConfigManager.set_setting("api", "key", apiKey.text)
	ConfigManager.set_setting("api", "region", apiRegion.text)
	
	ConfigManager.save_settings_file()
	ConfigManager.apply_settings()
	ConfigManager.changed_settings()
	hide()


func _on_Cancel_pressed() -> void:
	hide()
