extends Control

# Menus
onready var fileMenu = $Panel/MarginContainer/VBoxContainer/Menus/FileMenu
onready var actorMenu = $Panel/MarginContainer/VBoxContainer/Menus/ActorMenu
# Subs
onready var subList = $Panel/MarginContainer/VBoxContainer/SubtitleContainer/MarginContainer/SubList
onready var subContainer = $Panel/MarginContainer/VBoxContainer/SubtitleContainer
onready var subEntry = preload("res://Scenes/Entries/SubEntry.tscn")
onready var commentEntry = preload("res://Scenes/Entries/CommentEntry.tscn")
# Popups
onready var popupContainer = $PopupWindows
onready var saveSubDialog = $PopupWindows/SaveSubFileDialog
onready var loadSubDialog = $PopupWindows/LoadSubFileDialog
onready var errorDialog = $PopupWindows/ErrorDialog
onready var newFileDialog = $PopupWindows/NewFileDialog
onready var quitDialog = $PopupWindows/QuitDialog

enum ADD_OPTION {
	NORMAL,
	BELOW_NODE
}

enum MOVE {
	UP,
	DOWN
}

# TODO: Add functionality to the actor menu

func _enter_tree() -> void:
	ProjectSettings.set_setting("display/window/size/always_on_top", true)
	print(ProjectSettings.get_setting("display/window/size/always_on_top"))


func _ready() -> void:
	get_tree().call_group("sub_entry", "queue_free")
	fileMenu.get_popup().connect("id_pressed", self, "_on_FileMenu_id_pressed")
	quitDialog.saveDialog = saveSubDialog
	
	for popup in popupContainer.get_children():
		(popup as Popup).connect("popup_hide", self, "_on_popup_hide")
		(popup as Popup).connect("about_to_show", self, "_on_popup_show")


# Handle quit request
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if subList.get_child_count() > 0:
			quitDialog.call_deferred("show")
		else:
			get_tree().quit()

# SHORTCUTS
# TODO: Duplicate line
# TODO: Use the last actor when entering a new one entry
func _unhandled_input(event: InputEvent) -> void:
	# Adding entries
	if event.get_action_strength("add_entry"):
		_on_AddEntry_pressed()
	
	# Delete entry
	if event.get_action_strength("delete_entry"):
		delete_entry()
	
	# Move entry
	if event.get_action_strength("move_up"):
		move_entry(MOVE.UP)
	if event.get_action_strength("move_down"):
		move_entry(MOVE.DOWN)
	
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


# == MOVE ENTRIES ==

func move_entry(option = MOVE.UP):
	if is_instance_valid(get_focus_owner()):
		var focusOwner = get_focus_owner().owner
		var index = get_focus_owner().owner.get_index()
		
		match option:
			MOVE.UP:
				index = max(0, index - 1)
			MOVE.DOWN:
				index = min(subList.get_child_count(), index + 1)
		
		subList.move_child(focusOwner, index)
		focusOwner.get_focus()


func _on_ArrowDown_pressed() -> void:
	move_entry(MOVE.DOWN)


func _on_ArrowUp_pressed() -> void:
	move_entry(MOVE.UP)


# == ADDING SUBS AND COMMENTS ==

func add_entry(entryInstance, option = ADD_OPTION.NORMAL, focusOwner = null, focus = true) -> void:
	var created = false
	match option:
		ADD_OPTION.NORMAL:
			subList.add_child(entryInstance)
			created = true
		
		ADD_OPTION.BELOW_NODE:
			if is_instance_valid(focusOwner):
				if focusOwner.owner.is_in_group("sub_entry"):
					subList.add_child_below_node(focusOwner.owner, entryInstance)
					created = true
	
	if created:
		entryInstance.connect("delete", self, "delete_entry")
	
	if focus:
		entryInstance.get_focus()


func delete_entry() -> void:
	var focusOwner = get_focus_owner()
	if is_instance_valid(focusOwner):
		if focusOwner.owner.is_in_group("sub_entry"):
			var index = focusOwner.owner.get_index() + 1
			var finalIndex = (index 
				if index < subList.get_child_count() 
				else subList.get_child_count() - 2)
			
			focusOwner.owner.queue_free()
			
			# In case the list is empty after the delete
			if finalIndex >= 0:
				subList.get_child(finalIndex).get_focus()


func _on_AddEntry_pressed() -> void:
	var subInstance = subEntry.instance()
	
	# Check if the list is empty or not
	if subList.get_child_count() > 0:
		var focusOwner = get_focus_owner()
		add_entry(subInstance, ADD_OPTION.BELOW_NODE, focusOwner)
	else:
		add_entry(subInstance)


func _on_AddComment_pressed() -> void:
	var commentInstance = commentEntry.instance()
	
	if subList.get_child_count() > 0:
		var focusOwner = get_focus_owner()
		add_entry(commentInstance, ADD_OPTION.BELOW_NODE, focusOwner)
	else:
		add_entry(commentInstance)


# == DUPLICATE ENTRIES ==

func _on_Duplicate_pressed() -> void:
	if subList.get_child_count() > 0:
		var focusOwner = get_focus_owner().owner
		if is_instance_valid(focusOwner):
			var duplicatedEntry = focusOwner.duplicate()
			subList.add_child_below_node(focusOwner, duplicatedEntry)
			duplicatedEntry.subText.caret_position = 0
			duplicatedEntry.get_focus()

# == SAVING AND LOADING ==
# TODO: Save the last place you saved the file and reload it on run
# TODO: Add confirmation to exit when you have something
# TODO: Rework saving so that it know when you made changes
# TODO: Load only the actors option
# TODO: Load from file dropping
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


# Save File
func _on_SaveSubFileDialog_file_selected(path: String) -> void:
	print("Saving: " + path)
	
	var file = File.new()
	file.open(path, File.WRITE)
	
	# Add actor list
	file.store_line("#" + ActorGlobal.get_text())
	
	for sub in subList.get_children():
		file.store_line(sub.get_text())
	
	file.close()
	


# Load file
func _on_LoadSubFileDialog_file_selected(path: String) -> void:
	print("Loading: " + path)
	
	var file = File.new()
	file.open(path, File.READ)
	
	# Remove previous entries
	get_tree().call_group("sub_entry", "queue_free")
	
	# Process actors
	ActorGlobal.load_actors(file.get_line())
	
	while(not file.eof_reached()):
		var subEntryText = file.get_line()
		
		if not subEntryText.empty():
			# Check if it's a comment or a translation
			if "#" in subEntryText:
				var entryLoad = subEntryText.split("#")
				var comInstance = commentEntry.instance()
				add_entry(comInstance, ADD_OPTION.NORMAL, null, false)
				comInstance.load_entry(entryLoad[1])
			else:
				var entryLoad  = subEntryText.split(":")
				
				var subInstance = subEntry.instance()
				add_entry(subInstance, ADD_OPTION.NORMAL, null, false)
				subInstance.load_entry(entryLoad[0], entryLoad[1])
	
	subList.get_child(subList.get_child_count() - 1).get_focus()
	
	file.close()


func _on_NewFileDialog_confirmed() -> void:
	get_tree().call_group("sub_entry", "queue_free")

# Deal with pop ups
func _on_popup_show() -> void:
	self.set_process_input(false)

func _on_popup_hide() -> void:
	self.set_process_input(true)
