extends Control

signal all_parts

@onready var icon_dict := {
	"magazine": $Magazine,
	"ammobox": $Ammobox,
	"bullet": $Bullet,
	"grenade": $Grenade
}


func update_gun_parts_ui():
	for collected in Global.gun_parts_collected.duplicate():
		var collected_lower = collected.to_lower()
		for names in icon_dict.keys():
			if names.to_lower() == collected_lower and icon_dict[names]:
				icon_dict[names].queue_free()
				Global.gun_parts_collected.erase(collected)
				$Timer.start()

	if all_icons_removed():
		all_parts.emit()


func all_icons_removed() -> bool:
	for node in icon_dict.values():
		if node != null and node.is_inside_tree():
			return false
	return true


func _on_timer_timeout() -> void:
	update_gun_parts_ui()
