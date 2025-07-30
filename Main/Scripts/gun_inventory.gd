extends Control

signal all_parts

@onready var icon_dict := {
	"frame": $frame,
	"slide": $slide,
	"bullet": $bullet,
	"barrel": $barrel
}


func update_gun_parts_ui():
	for collected in Global.gun_parts_collected:
		var collected_lower = collected.to_lower()
		for names in icon_dict.keys():
			if names.to_lower() == collected_lower and icon_dict[names]:
				icon_dict[names].hide()
				#Global.gun_parts_collected.erase(collected)
				#$Timer.start()

	if all_icons_removed():
		all_parts.emit()

func steal_gun_part():
	if Global.gun_parts_collected.size() == 0:
		print("Keine Teile vorhanden zum Stehlen.")
		return
	
	var part = Global.gun_parts_collected.pick_random()
	part = part.to_lower()

	Global.gun_parts_collected.erase(part)
	print(Global.gun_parts_collected)
	if not Global.gun_parts_missing.has(part):
		Global.gun_parts_missing.append(part)

	if icon_dict.has(part) and icon_dict[part] != null:
		icon_dict[part].show()
		print("Teil gestohlen und Icon gezeigt:", part)
	else:
		print("Teil gestohlen, aber Icon nicht gefunden:", part)


func all_icons_removed() -> bool:
	for node in icon_dict.values():
		if node != null and node.is_visible():
			return false
	return true


func _on_timer_timeout() -> void:
	update_gun_parts_ui()
