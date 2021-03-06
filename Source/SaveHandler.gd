extends Control

onready var EntryHandler = $"../EntryHandler"

# == SAVING AND LOADING ==
# TODO: Rework saving so that it know when you made changes
# TODO: Load only the actors option
# TODO: Load from file dropping

# Save File
func _on_SaveSubFileDialog_file_selected(path: String) -> void:
	DebugGlobal.message("Save: " + path)
	
	var file = File.new()
	file.open(path, File.WRITE)
	
	# Add actor list
	file.store_line("#" + ActorGlobal.get_text())
	
	for sub in EntryHandler.subList.get_children():
		file.store_line(sub.get_text())
	
	file.close()
	


# Load file
func _on_LoadSubFileDialog_file_selected(path: String) -> void:
	DebugGlobal.message("Load: " + path)
	
	var file = File.new()
	file.open(path, File.READ)
	
	# Remove previous entries
	get_tree().call_group("sub_entry", "queue_free")
	
	# Process actors
	var counter = 2
	if ActorGlobal.load_actors(file.get_line()):
		while(not file.eof_reached()):
			var subEntryText = file.get_line()
			
			if not subEntryText.empty():
				# Check if it's a comment or a translation
				if "#" in subEntryText:
					var entryLoad = subEntryText.split("#")
					var comInstance = EntryHandler.commentEntry.instance()
					EntryHandler.add_entry(comInstance, EntryHandler.ADD_OPTION.NORMAL, null, false)
					comInstance.load_entry(entryLoad[1])
				else:
					var entryLoad  = subEntryText.split(":")
					
					var subInstance = EntryHandler.subEntry.instance()
					EntryHandler.add_entry(subInstance, EntryHandler.ADD_OPTION.NORMAL, null, false)
					if subInstance.load_entry(entryLoad[0], entryLoad[1]) == false:
						DebugGlobal.message(
							"Error line " + String(counter) 
							+ " (actor not found): " + subEntryText)
				
				counter += 1
		
		EntryHandler.subList.get_child(EntryHandler.subList.get_child_count() - 1).get_focus()
		DebugGlobal.message("Loaded: " + path)
	
	file.close()


func _on_NewFileDialog_confirmed() -> void:
	get_tree().call_group("sub_entry", "queue_free")
	ActorGlobal.reset_actors()
