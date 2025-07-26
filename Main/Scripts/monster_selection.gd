extends Control

signal monster_selected

@export var world: Node2D

@onready var label: Label = $Label

var current_select: String = ""

func _on_monster_1_pressed() -> void:
	current_select = "Flying specter"
	label.text = "Current selection: " + current_select
	


func _on_monster_3_pressed() -> void:
	current_select = "Silver bat"
	label.text = "Current selection: " + current_select


func _on_monster_2_pressed() -> void:
	current_select = "Karen centipede"
	label.text = "Current selection: " + current_select


func _on_select_pressed() -> void:
	if Global.gun_parts_collected.size() > 2:
		if current_select !=  "":
			Global.monster_select = current_select
			monster_selected.emit()
			self.queue_free()
	else :
		self.hide()
		world.write("Come back when you got 3 gun parts")
