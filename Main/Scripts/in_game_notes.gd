extends Control

@onready var label: Label = $Label

@export var typing_speed: float = 0.05
@onready var ap: AnimationPlayer = $ap

var _full_text: String = ""
var _char_index: int = 0
var _is_typing: bool = false

func _ready() -> void:
	label.hide()
	msg("Its getting cold around you.....")

func msg(text: String):
	label.show()
	ap.play("Fade_in")
	_full_text = text
	_char_index = 0
	label.text = ""
	_is_typing = true
	type_next_char()

func type_next_char():
	if _char_index < _full_text.length():
		label.text += _full_text[_char_index]
		_char_index += 1
		await get_tree().create_timer(typing_speed).timeout
		type_next_char()
	else:
		await get_tree().create_timer(8).timeout
		ap.play("Fade_out")
		await ap.animation_finished
		label.hide()
		_is_typing = false
