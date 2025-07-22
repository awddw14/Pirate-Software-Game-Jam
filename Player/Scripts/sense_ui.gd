extends Control



@onready var touch_sense_ui: Control = $"../Touch_Sense_UI"
@onready var player: CharacterBody2D = $"../../Player"
@onready var world: Node2D = $"../.."

@onready var sight_b: Button = $Sight
@onready var touch_b: Button = $Touch
@onready var hear_b: Button = $Hear

@onready var time_label: Label = $time_label

var can_use_sense: bool = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1") and can_use_sense and not sight_b.disabled:
		sight_b.pressed.emit()
	elif event.is_action_pressed("2") and can_use_sense and not touch_b.disabled:
		touch_b.pressed.emit()
	elif event.is_action_pressed("3") and can_use_sense and not hear_b.disabled:
		hear_b.pressed.emit()

func _ready() -> void:
	update_ui()
	time_label.hide()

func _process(_delta: float) -> void:
	if not can_use_sense:
		time_label.text = "Disabled: " + str(int($Timer.time_left))


func _on_sight_pressed() -> void:
	Global.current_sense = "Sight"
	update_ui()


func _on_touch_pressed() -> void:
	Global.current_sense = "Touch"
	update_ui()


func _on_hear_pressed() -> void:
	Global.current_sense = "Hear"
	update_ui()

func disable_sense():
	time_label.show()
	can_use_sense = false
	$Timer.start()

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


func _on_timer_timeout() -> void:
	can_use_sense = true
	time_label.hide()
