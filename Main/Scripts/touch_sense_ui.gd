extends Control


@onready var pb: ProgressBar = $ProgressBar


func _on_timer_timeout() -> void:
	if Global.temp_change == false:
		pb.self_modulate = Color(0, 1, 0)
		Global.env_temp = randi_range(4,6)
		pb.value = Global.env_temp
	else :
		pb.self_modulate = Color(1, 0, 0)
		Global.env_temp = randi_range(8,10)
		pb.value = Global.env_temp
