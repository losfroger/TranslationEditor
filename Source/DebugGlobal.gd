extends Node

signal debug_message(message)

func message(message: String) -> void:
	print(message)
	emit_signal("debug_message", message)
