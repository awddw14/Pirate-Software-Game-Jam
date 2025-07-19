extends Node2D



@onready var won: Label = $UI/won

func _ready() -> void:
	won.hide()


func _process(_delta: float) -> void:
	if Global.hit:
		won.show()
		Global.hit = false
