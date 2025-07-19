extends CharacterBody2D


var speed: float = 300.0

@onready var cam: Camera2D = $cam

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		cam.apply_shake()

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	var input_vector: Vector2 = Vector2(Input.get_axis("move_left", "move_right"),Input.get_axis("move_up", "move_down")).normalized()
	velocity = input_vector * speed
	move_and_slide()
