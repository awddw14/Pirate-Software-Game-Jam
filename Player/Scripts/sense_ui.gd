extends Control



@onready var touch_sense_ui: Control = $"../Touch_Sense_UI"
@onready var player: CharacterBody2D = $"../../Player"
@onready var world: Node2D = $"../.."

@onready var sight_b: Button = $Sight
@onready var touch_b: Button = $Touch
@onready var hear_b: Button = $Hear


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
	world.update_world_ui()
	if Global.current_sense == "Touch":
		touch_sense_ui.show()
		touch_b.disabled = true
		sight_b.disabled = false
		hear_b.disabled = false
	elif Global.current_sense == "Sight":
		touch_sense_ui.hide()
		touch_b.disabled = false
		sight_b.disabled = true
		hear_b.disabled = false
	elif Global.current_sense == "Hear":
		touch_sense_ui.hide()
		touch_b.disabled = false
		sight_b.disabled = false
		hear_b.disabled = true
	else :
		touch_sense_ui.hide()
		touch_b.disabled = false
		sight_b.disabled = false
		hear_b.disabled = false
