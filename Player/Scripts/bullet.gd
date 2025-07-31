extends Area2D


@export var speed: float = 600.0
var velocity: Vector2

func _ready() -> void:
	var target = get_global_mouse_position()
	velocity = (target - global_position).normalized() * speed
	rotation = velocity.angle()

func _process(delta: float) -> void:
	position += velocity * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Monster"):
		Global.hit = true
		queue_free()
		if body.monster_name != Global.monster_select:
			get_parent().death()



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	Global.missed = true
	queue_free()
