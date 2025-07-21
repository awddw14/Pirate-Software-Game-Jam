extends Node2D



@onready var won: Label = $UI/won
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var current_sense_label: Label = $UI/current_sense
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	won.hide()

func update_world_ui():
	if current_sense_label != null:
		current_sense_label.text = "Current Sense selected: " + Global.current_sense

func _process(_delta: float) -> void:
	if Global.hit:
		Global.hit = false
		won.text = "YOU WON"
		won.show()
		$MonsteAtrappe.queue_free()
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



func _on_gun_inventory_all_parts() -> void:
	$Player.equip_weapon()


func _on_item_collected() -> void:
	$UI/Gun_Inventory.update_gun_parts_ui()


func _on_code_game_puzzle_solved() -> void:
	$parts/magazine_item.show()
	$UI/Code_Game.hide()
	$code.queue_free()


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
