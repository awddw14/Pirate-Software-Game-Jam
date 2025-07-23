extends "res://Main/Scripts/Monster_scripts/MonsterBase.gd"


@onready var nav_agent: NavigationAgent2D = $nav_agent



func _physics_process(_delta: float) -> void:
	if not is_visible():
		return

	if player and chasing:
		var next_pos = nav_agent.get_next_path_position()
		var direction = (next_pos - global_position).normalized()
		velocity = direction * move_speed
		move_and_slide()

func make_path():
	if player:
		nav_agent.target_position = player.global_position

func _on_timer_timeout() -> void:
	make_path()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	chasing = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	chasing = false
