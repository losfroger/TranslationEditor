extends Control

# Subs
onready var subList = $"../Panel/MarginContainer/VBoxContainer/MainInterfacePanel/MarginContainer/VBoxContainer/SubtitleContainer/MarginContainer/SubList"
onready var subEntry = preload("res://Scenes/Entries/SubEntry.tscn")
onready var commentEntry = preload("res://Scenes/Entries/CommentEntry.tscn")
onready var tlEntry = preload("res://Scenes/Entries/TranslateEntry.tscn")

enum ADD_OPTION {
	NORMAL,
	BELOW_NODE
}

enum MOVE {
	UP,
	DOWN
}


# == MOVE ENTRIES ==

func move_entry(option = MOVE.UP):
	if is_instance_valid(get_focus_owner()):
		var focusOwner = get_focus_owner().owner
		var index = get_focus_owner().owner.get_index()
		DebugGlobal.message("Moving entry: " + focusOwner.to_string())
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
			DebugGlobal.message("Adding entry: " + entryInstance.to_string())
			subList.add_child(entryInstance)
			created = true
		
		ADD_OPTION.BELOW_NODE:
			if is_instance_valid(focusOwner):
				if focusOwner.owner.is_in_group("sub_entry"):
					DebugGlobal.message("Adding entry below: " + entryInstance.to_string())
					subList.add_child_below_node(focusOwner.owner, entryInstance)
					created = true
	
	if created:
		entryInstance.connect("delete", self, "delete_entry")
	
	if focus:
		entryInstance.get_focus()


func delete_entry() -> void:
	var focusOwner = get_focus_owner()
	DebugGlobal.message("Deliting entry: " + focusOwner.owner.to_string())
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


func _on_AddTL_pressed() -> void:
	var tlInstance = tlEntry.instance()
	
	if subList.get_child_count() > 0:
		var focusOwner = get_focus_owner()
		add_entry(tlInstance, ADD_OPTION.BELOW_NODE, focusOwner)
	else:
		add_entry(tlInstance)

# == DUPLICATE ENTRIES ==

func _on_Duplicate_pressed() -> void:
	if subList.get_child_count() > 0:
		var focusOwner = get_focus_owner().owner
		DebugGlobal.message("Dupe entry: " + focusOwner.to_string())
		if is_instance_valid(focusOwner):
			var duplicatedEntry = focusOwner.duplicate()
			subList.add_child_below_node(focusOwner, duplicatedEntry)
			duplicatedEntry.reset_caret()
			duplicatedEntry.duplicated()
			duplicatedEntry.get_focus()


func _on_Delete_pressed() -> void:
	delete_entry()
