extends Node

signal debug_message(message)

func message(message: String) -> void:
	emit_signal("debug_message", message)
