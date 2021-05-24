extends Control

# Menus
onready var fileMenu = $Panel/MarginContainer/VBoxContainer/Menus/FileMenu
onready var actorMenu = $Panel/MarginContainer/VBoxContainer/Menus/ActorMenu
# Subs
onready var subList = $Panel/MarginContainer/VBoxContainer/SubtitleContainer/MarginContainer/SubList
onready var subContainer = $Panel/MarginContainer/VBoxContainer/SubtitleContainer
onready var subEntry = preload("res://Scenes/SubEntry.tscn")
onready var commentEntry = preload("res://Scenes/CommentEntry.tscn")
# Popups
onready var saveSubDialog = $SaveSubFileDialog
onready var loadSubDialog = $LoadSubFileDialog
onready var errorDialog = $ErrorDialog

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

# SHORTCUTS
# TODO: Duplicate line
# TODO: Use the last actor when entering a new one entry
func _input(event: InputEvent) -> void:
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
	print("Move")
	var focusOwner = get_focus_owner().owner
	var index = get_focus_owner().owner.get_index()
	
	match option:
		MOVE.UP:
			index = max(0, index - 1)
		MOVE.DOWN:
			index = min(subList.get_child_count(), index + 1)
	
	subList.move_child(focusOwner, index)

# == ADDING SUBS AND COMMENTS ==

func add_entry(entryInstance, option = ADD_OPTION.NORMAL, focusOwner = null) -> void:
	var created = false
	match option:
		ADD_OPTION.NORMAL:
			subList.add_child(entryInstance)
			created = true
		
		ADD_OPTION.BELOW_NODE:
			if focusOwner != null:
				if focusOwner.owner.is_in_group("sub_entry"):
					subList.add_child_below_node(focusOwner.owner, entryInstance)
					created = true
	
	# Check if it was created, in case the focus owner is null
	if created:
		yield(get_tree().create_timer(0.1), "timeout")
		entryInstance.loaded()


func delete_entry() -> void:
	var focusOwner = get_focus_owner()
	if focusOwner != null:
		if focusOwner.owner.is_in_group("sub_entry"):
			var index = focusOwner.owner.get_index() + 1
			var finalIndex = index if index < subList.get_child_count() else subList.get_child_count() - 2
			
			focusOwner.owner.queue_free()
			
			# In case the list is empty after the delete
			if finalIndex >= 0:
				subList.get_child(finalIndex).subText.grab_focus()


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


# == SAVING AND LOADING ==
# TODO: Save the last place you saved the file and reload it on run
# TODO: Add confirmation to exit when you have something
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
				add_entry(comInstance)
				comInstance.load_entry(entryLoad[1])
			else:
				var entryLoad  = subEntryText.split(":")
				
				var subInstance = subEntry.instance()
				add_entry(subInstance)
				subInstance.load_entry(entryLoad[0], entryLoad[1])
	
	file.close()

