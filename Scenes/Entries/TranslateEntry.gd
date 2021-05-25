extends EntryActor
class_name EntryTranslate

onready var tlText = $VBoxContainer/TranslateText

# FIXME: When duplicating the translated line looks wrong

var translated:bool = true setget set_translated

func _ready() -> void:
	subText = $VBoxContainer/SubText


func set_translated(newValue: bool):
	translated = newValue
	if newValue == true:
		remove_from_group("tl_entry")
	else:
		add_to_group("tl_entry")


func _on_SubText_text_changed(new_text: String) -> void:
	self.translated = false


func get_text():
	return actorButton.get_item_text(actorButton.get_selected_id()) + ": " + tlText.text
