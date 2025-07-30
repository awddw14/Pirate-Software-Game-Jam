extends Control

func _ready() -> void:
	hide()

func _on_continue_pressed() -> void:
	self.hide()

func _on_leave_match_pressed() -> void:
	get_tree().change_scene_to_file("res://Main/Scene/main_menu.tscn")
