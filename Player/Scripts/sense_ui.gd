extends Control



@onready var touch_sense_ui: Control = $"../Touch_Sense_UI"
@onready var player: CharacterBody2D = $"../../Player"

func _ready() -> void:
	update_ui()

func _on_sight_pressed() -> void:
	Global.current_sense = "Sight"
	update_ui()


func _on_touch_pressed() -> void:
	Global.current_sense = "Touch"
	update_ui()


func _on_hear_pressed() -> void:
	Global.current_sense = "Hear"
	update_ui()

func update_ui():
	player.update_sense()
	if Global.current_sense == "Touch":
		touch_sense_ui.show()
	else :
		touch_sense_ui.hide()
