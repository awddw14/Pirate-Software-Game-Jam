extends Node2D

@export var player: CharacterBody2D

@export var silver_bat: PackedScene
@export var flying_specter: PackedScene
@export var karen_centipede: PackedScene

@onready var won: Label = $UI/won
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var current_sense_label: Label = $UI/current_sense

@onready var flickering_timer: Timer = $flickering_timer
@onready var player_spawn_point: Marker2D = $SpawnPoint

@onready var scratch: Node2D = $scratch
@onready var lights: Node2D = $Lights
@onready var footstep: Node2D = $footstep

@onready var teleport_points: Node2D = $teleport_points
@onready var note: Control = $UI/InGameNotes


var spawn_points: Array = ["spawn1", "spawn2", "spawn3", "spawn4"]

var monster_pick: Array = ["silver_bat","flying_specter", "karen_centipede"]
var monster = null
var two_gun: bool = false

func _ready() -> void:
	$parts/frame_item.hide()
	$parts/bullet_item.hide()
	$parts/barrel_item.hide()
	$parts/slide_item.hide()
	won.hide()
	scratch.hide()
	footstep.hide()
	$UI/book.hide()
	print(monster_pick)
	choose_monster()

func update_world_ui():
	if current_sense_label != null:
		current_sense_label.text = "Current Sense selected: " + Global.current_sense

func _process(_delta: float) -> void:
	
	if Global.gun_parts_collected.size() > 1 and !two_gun:
		two_gun = true
		$parts/frame_item.global_position = $frame_spawn.global_position
		$parts/frame_item.show()
	
	
	if Global.current_sense == "Sight":
		$"Furniture/83".show()
		$"Furniture/57".show()
	else:
		$"Furniture/83".hide()
		$"Furniture/57".hide()
	
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
		$UI/Sense_UI.disable_sense(10)
		spawn_monster_new()
	elif player.hurt_count == 1:
		$UI/Gun_Inventory.steal_gun_part()
		$UI/Sense_UI.update_ui()
		$UI/Sense_UI.disable_sense(15)
		spawn_monster_new()

func write(text: String):
	note.msg(text)

func scratches():
	if monster:
		monster.make_noise()
		if monster.scratches:
			scratch.show()
			note.msg("What are these scratches everywhere")
		if monster.light_flick:
			note.msg("Weird...someone is playing around with the electricity")
			flickering_timer.autostart = true
			flickering_timer.start()
			$light_humming.play()
		if monster.block_doors: 
			Global.block_the_door = true
		if monster.footsteps:
			footstep.show()
			note.msg("look closer to see monster evidence")

func light_flickering(on: bool):
	if monster:
		if monster.light_flick:
			if on:
				for i in lights.get_children():
					i.enabled = false
			if !on:
				for i in lights.get_children():
					i.enabled = true

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
		note.msg("you got only one shot...dont miss it !")


func _on_item_collected() -> void:
	$UI/Gun_Inventory.update_gun_parts_ui()


func _on_code_game_puzzle_solved() -> void:
	$parts/barrel_item.show()
	$parts/barrel_item.global_position = $code/Marker2D.global_position
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
	$UI/Code_Game.hide()
	$death_music.play()
	$UI/InGameMenu.hide()
	$UI/menu.hide()


func _on_retry_pressed() -> void:
	Global.reset()
	get_tree().reload_current_scene()


func _on_flickering_timer_timeout() -> void:
	light_flickering(true)
	await get_tree().create_timer(0.2).timeout
	light_flickering(false)



func _on_warm_colder_game_wrong_statue_picked() -> void:
	player.global_position = player_spawn_point.global_position
	note.msg("Wrong box....you need to focus")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if Global.monster_select == "":
			$UI/MonsterSelection.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if Global.monster_select == "":
			$UI/MonsterSelection.hide()
		else:
			if $parts/bullet_item != null : 
				$parts/bullet_item.global_position = $bullet_spawn.global_position
				$FinalSelectionArea.queue_free()


func _on_monster_selection_monster_selected() -> void:
	$parts/bullet_item.show()
	$parts/bullet_item.global_position = $bullet_spawn.global_position


func _on_warm_colder_game_correct_statue_picked(box: Variant) -> void:
	await get_tree().create_timer(0.2).timeout
	if $WarmColderGame != null:
		note.msg("Its getting cold around you.....")
		$parts/slide_item.show()
		$parts/slide_item.global_position = box.global_position
		$WarmColderGame.queue_free()


func _on_book_pressed() -> void:
	$UI/MonsterBook.show()
	$UI/Sense_UI.hide()
	Global.current_sense = "Touch"
	$UI/Sense_UI.update_ui()


func _on_menu_pressed() -> void:
	$UI/InGameMenu.show()


func _on_book_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$UI/book.show()
		note.msg("Strange that she left this out.  Her vision must have gone too bad.")
		$IconBook.queue_free()
