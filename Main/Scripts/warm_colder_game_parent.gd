extends Node2D

@export var player: CharacterBody2D
@warning_ignore("unused_signal")
signal correct_statue_picked
@warning_ignore("unused_signal")
signal wrong_statue_picked

var correct_statue_name: String = ""
var statue_names = ["Icon", "Icon2", "Icon3", "Icon4", "Icon5"]

func _ready():
	correct_statue_name = statue_names.pick_random()
	print("Korrekte Statue ist: ", correct_statue_name)
