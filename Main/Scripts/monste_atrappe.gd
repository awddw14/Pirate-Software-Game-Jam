extends CharacterBody2D


@export var monster_name: String
@export var env_temp: String
@export var sight_visible: bool
@export var sounds: bool


func _ready() -> void:
	self.add_to_group("Monster")
	hide()


func _process(_delta: float) -> void:
	if Global.current_sense == "Sight" and sight_visible:
		show()
		self.collision_layer = 1
	else :
		self.collision_layer = 2
		hide()
