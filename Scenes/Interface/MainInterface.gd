extends Control

# Menus
onready var fileMenu = $Panel/MarginContainer/VBoxContainer/Menus/FileMenu
onready var actorMenu = $Panel/MarginContainer/VBoxContainer/Menus/ActorMenu
# Subs
onready var subList = $Panel/MarginContainer/VBoxContainer/MainInterfacePanel/MarginContainer/VBoxContainer/SubtitleContainer/MarginContainer/SubList
onready var EntryHandler = $EntryHandler
# Saving
onready var SaveHandler = $SaveHandler
# Popups
onready var popupContainer = $PopupWindows

onready var saveSubDialog = $PopupWindows/SaveSubFileDialog
onready var loadSubDialog = $PopupWindows/LoadSubFileDialog
onready var newFileDialog = $PopupWindows/NewFileDialog

onready var errorDialog = $PopupWindows/ErrorDialog
onready var quitDialog = $PopupWindows/QuitDialog

onready var addActorDialog = $PopupWindows/AddActor

onready var settingDialog = $PopupWindows/ConfigDialog

# TODO: Add functionality to the actor menu

func _ready() -> void:
	#get_tree().call_group("sub_entry", "queue_free")
	fileMenu.get_popup().connect("id_pressed", self, "_on_FileMenu_id_pressed")
	actorMenu.get_popup().connect("id_pressed", self, "_on_ActorMenu_id_pressed")
	quitDialog.saveDialog = saveSubDialog
	
	load_config()
	
	ConfigManager.connect("changed_settings", self, "load_config")
	
	for popup in popupContainer.get_children():
		(popup as Popup).connect("popup_hide", self, "_on_popup_hide")
		(popup as Popup).connect("about_to_show", self, "_on_popup_show")


func load_config() -> void:
	saveSubDialog.current_dir = ConfigManager.get_setting("config", "default_directory")
	loadSubDialog.current_dir = ConfigManager.get_setting("config", "default_directory")

# Handle quit request
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if (subList.get_child_count() > 0 
			and ConfigManager.get_setting("config", "dialog_quit")):
			quitDialog.call_deferred("show")
		else:
			get_tree().quit()

# SHORTCUTS
# TODO: Use the last actor when entering a new one entry
func _input(event: InputEvent) -> void:
	# Adding entries
	if event.get_action_strength("add_entry"):
		EntryHandler._on_AddEntry_pressed()
	
	# Delete entry
	if event.get_action_strength("delete_entry"):
		EntryHandler.delete_entry()
	
	# Move entry
	if event.get_action_strength("move_up"):
		EntryHandler.move_entry(EntryHandler.MOVE.UP)
	if event.get_action_strength("move_down"):
		EntryHandler.move_entry(EntryHandler.MOVE.DOWN)
	
	# Change actors
	if event.get_action_strength("next_actor"):
		var focusOwner = get_focus_owner().owner
		focusOwner.change_actor(focusOwner.CHANGE_ACTOR.NEXT)
	if event.get_action_strength("prev_actor"):
		var focusOwner = get_focus_owner().owner
		focusOwner.change_actor(focusOwner.CHANGE_ACTOR.PREVIOUS)
	
	
	# Saving | loading
	if event.get_action_strength("save_file"):
		save_file()
	if event.get_action_strength("load_file"):
		loadSubDialog.popup()


func save_file() -> void:
	if subList.get_child_count() > 0:
		saveSubDialog.popup()
	else:
		errorDialog.dialog_text = "The sub list is empty"
		errorDialog.popup()


func _on_FileMenu_id_pressed(id: int) -> void:
	match id:
		0: # Save
			save_file()
		1: # Load
			loadSubDialog.popup()
		2: # New
			if subList.get_child_count() > 0:
				newFileDialog.popup_centered()


func _on_ActorMenu_id_pressed(id: int) -> void:
	match id:
		0: # Add
			addActorDialog.popup()


# Deal with pop ups
func _on_popup_show() -> void:
	self.set_process_input(false)

func _on_popup_hide() -> void:
	self.set_process_input(true)


func _on_Settings_pressed() -> void:
	settingDialog.popup_centered()
