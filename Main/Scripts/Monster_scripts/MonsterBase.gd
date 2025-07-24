extends CharacterBody2D

@export var monster_name: String
@export var env_temp: String
@export var sight_visible: bool
@export var sounds: bool
@export var scratches: bool
@export var block_doors: bool
@export var light_flick: bool
@export var player: CharacterBody2D
@export var move_speed: float = 200.0

var chasing: bool = false

func _ready() -> void:
	self.add_to_group("Monster")
	hide()
	get_player()

func _process(_delta: float) -> void:
	if Global.current_sense == "Sight" and sight_visible:
		show()
		self.collision_layer = 1
	else:
		self.collision_layer = 2
		hide()

func make_noise():
	if sounds:
		print("Screaming sounds")

func get_player():
	var player1 = get_parent().get_children()
	if is_inside_tree():
		for i in player1:
			if i.is_in_group("Player"):
				player = i

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not is_visible():
		return
		
	if body.is_in_group("Player"):
		body.take_damage()
