extends Control

@onready var music_theme: AudioStreamPlayer = $music_theme
@onready var music_2: AudioStreamPlayer = $music2


func _ready() -> void:
	music_theme.play()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Main/Scene/world.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_music_theme_finished() -> void:
	music_2.play()


func _on_music_2_finished() -> void:
	music_theme.play()
