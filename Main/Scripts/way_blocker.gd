extends StaticBody2D


@onready var cs: CollisionShape2D = $cs

var click: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and click:
		queue_free()


func _process(_delta: float) -> void:
	if Global.block_the_door:
		show()
		cs.disabled = false
	else:
		cs.disabled = true
		hide()

func _on_area_2d_mouse_entered() -> void:
	click = true


func _on_area_2d_mouse_exited() -> void:
	click = false
