extends Node2D



@onready var won: Label = $UI/won
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var current_sense_label: Label = $UI/current_sense

func _ready() -> void:
	won.hide()

func update_world_ui():
	if current_sense_label != null:
		current_sense_label.text = "Current Sense selected: " + Global.current_sense

func _process(_delta: float) -> void:
	if Global.hit:
		won.show()
		Global.hit = false

	if Global.current_sense == "Sight":
		canvas_modulate.color = Color(0.08, 0.09, 0.15, 1.0)
	elif Global.current_sense == "Touch":
		canvas_modulate.color = Color(0.12, 0.07, 0.07, 1.0)
	else:
		canvas_modulate.color = Color(0.15, 0.15, 0.15, 1.0)
