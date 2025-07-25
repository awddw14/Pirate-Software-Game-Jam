extends Control

@onready var music_theme: AudioStreamPlayer2D = $MusicTheme

func _ready() -> void:
	music_theme.autoplay = true

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Main/Scene/world.tscn")


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
