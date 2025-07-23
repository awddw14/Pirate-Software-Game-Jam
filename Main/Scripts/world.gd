extends Node2D

@export var player: CharacterBody2D

@export var silver_bat: PackedScene
@export var flying_specter: PackedScene
@export var karen_centipede: PackedScene

@onready var won: Label = $UI/won
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var current_sense_label: Label = $UI/current_sense


@onready var scratch: Node2D = $scratch

@onready var teleport_points: Node2D = $teleport_points

var spawn_points: Array = ["spawn1", "spawn2", "spawn3", "spawn4"]

var monster_pick: Array = ["silver_bat","flying_specter", "karen_centipede"]
var monster = null

func _ready() -> void:
	won.hide()
	scratch.hide()
	print(monster_pick)
	choose_monster()

func update_world_ui():
	if current_sense_label != null:
		current_sense_label.text = "Current Sense selected: " + Global.current_sense

func _process(_delta: float) -> void:
	if Global.hit:
		Global.hit = false
		won.text = "YOU WON"
		won.show()
		monster.queue_free()
		_on_player_died()
		if Global.current_sense != "Sight":
			Global.current_sense = "Sight"
			player.update_sense()
	elif Global.missed:
		won.text = "YOU LOST"
		won.self_modulate = Color(1,0,0)
		won.show()
	
	if Global.current_sense == "Sight":
		canvas_modulate.color = Color(0.08, 0.09, 0.15, 1.0)
	elif Global.current_sense == "Touch":
		canvas_modulate.color = Color(0.0, 0.0, 0.0, 1.0) #Color(0.06, 0.035, 0.035, 1.0)
	else:
		canvas_modulate.color = Color(0.0, 0.0, 0.0, 1.0) #Color(0.15, 0.15, 0.15, 1.0)

func update():
	if player.hurt_count == 0:
		$UI/Sense_UI.update_ui()
		$UI/Sense_UI.disable_sense()
		spawn_monster_new()
	elif player.hurt_count == 1:
		$UI/Gun_Inventory.steal_gun_part()
		$UI/Sense_UI.update_ui()
		$UI/Sense_UI.disable_sense()
		spawn_monster_new()

func scratches():
	if monster:
		if monster.scratches:
			scratch.show()


func spawn_monster_new():
	var random_spawn = spawn_points.pick_random()
	print(random_spawn)
	for i in teleport_points.get_children():
		if i.name == random_spawn:
			for j in self.get_children():
				if j.is_in_group("Monster"):
					j.global_position = i.global_position
					monster = j

func choose_monster():
	var random_monster = monster_pick.pick_random()
	print(random_monster)
	if random_monster == "silver_bat":
		var s = silver_bat.instantiate()
		add_child(s)
		spawn_monster_new()
	elif random_monster == "flying_specter":
		var f = flying_specter.instantiate()
		add_child(f)
		spawn_monster_new()
	elif random_monster == "karen_centipede":
		var k = karen_centipede.instantiate()
		add_child(k)
		spawn_monster_new()

func _on_gun_inventory_all_parts() -> void:
	if player:
		player.equip_weapon()


func _on_item_collected() -> void:
	$UI/Gun_Inventory.update_gun_parts_ui()


func _on_code_game_puzzle_solved() -> void:
	$parts/magazine_item.show()
	$UI/Code_Game.hide()
	$code.queue_free()
	scratches()


func _on_code_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$UI/Code_Game.show()


func _on_code_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$UI/Code_Game.hide()


func _on_player_died() -> void:
	$UI/current_sense.hide()
	$UI/Gun_Inventory.hide()
	$UI/Sense_UI.hide()
	$UI/Touch_Sense_UI.hide()


func _on_retry_pressed() -> void:
	Global.hit = false
	Global.missed = false
	Global.gun_parts_collected = []
	Global.gun_parts_missing = []
	Global.current_sense = ""
	get_tree().change_scene_to_file("res://Main/Scene/world.tscn")
