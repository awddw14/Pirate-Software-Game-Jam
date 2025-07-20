extends Area2D

signal collected

@export var icon: Texture2D
@export var part_name: String

func _ready() -> void:
	$Sprite.texture = icon
	$Sprite.scale = Vector2(0.2 , 0.2)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.gun_parts_collected.append(part_name)
		collected.emit()
		queue_free()
