extends Label

func _ready() -> void:
	DebugGlobal.connect("debug_message", self, "update_message")

func update_message(message: String) -> void:
	text = message
