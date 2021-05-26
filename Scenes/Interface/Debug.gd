extends Label

onready var timer = $Timer
var _use_timer = true

func _ready() -> void:
	visible = false
	if ConfigManager.get_setting("debug", "debug_timer") == -1:
		_use_timer = false
		visible = true
	if ConfigManager.get_setting("debug", "show_debug"):
		DebugGlobal.connect("debug_message", self, "update_message")
		if _use_timer:
			timer.wait_time = ConfigManager.get_setting("debug", "debug_timer")

func update_message(message: String) -> void:
	visible = ConfigManager.get_setting("debug", "show_debug")
	text = message
	if _use_timer:
		timer.start()


func _on_Timer_timeout() -> void:
	visible = false
