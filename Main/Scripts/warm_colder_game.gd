extends Area2D


@onready var tap: Sprite2D = $Tap
@onready var manager: Node2D = $".."

var can_pick_statue: bool = false

func _ready() -> void:
	tap.hide()

func _input(event: InputEvent) -> void:
	if not can_pick_statue:
		return

	if event.is_action_pressed("shoot"):
		can_pick_statue = false
		if Global.temp_change == "hot":
			manager.correct_statue_picked.emit(self)
		elif Global.temp_change == "cold":
			manager.wrong_statue_picked.emit()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		tap.show()
		if self.name == manager.correct_statue_name:
			Global.temp_change = "hot"
		else:
			Global.temp_change = "cold"

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		tap.hide()
		Global.temp_change = ""

func _on_mouse_entered() -> void:
	can_pick_statue = true

func _on_mouse_exited() -> void:
	can_pick_statue = false
