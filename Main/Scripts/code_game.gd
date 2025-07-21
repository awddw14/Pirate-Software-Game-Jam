extends Control

signal  puzzle_solved

@onready var code_label: Label = $Code

var code: int = 1234
var prev_text: String = ""

func _ready() -> void:
	code_label.text = ""
	hide()


func write(text: String):
	if code_label.text.length() >= 4:
		return
	$Code/ColorRect.self_modulate = Color(0.0,0.0,1.0)
	prev_text = text
	code_label.text += text

func _on_button_0_pressed() -> void:
	write("1")


func _on_button_1_pressed() -> void:
	write("2")


func _on_button_2_pressed() -> void:
	write("3")


func _on_button_3_pressed() -> void:
	write("4")


func _on_button_4_pressed() -> void:
	write("5")


func _on_button_5_pressed() -> void:
	write("6")


func _on_button_6_pressed() -> void:
	write("7")


func _on_button_7_pressed() -> void:
	write("8")


func _on_button_8_pressed() -> void:
	write("9")


func _on_button_9_pressed() -> void:
	write("0")


func _on_delete_pressed() -> void:
	if code_label.text.length() > 0:
		code_label.text = code_label.text.substr(0, code_label.text.length() - 1)


func _on_submit_pressed() -> void:
	if code_label.text == str(code):
		$Code/ColorRect.self_modulate = Color(0.0,1.0,0.0)
		await get_tree().create_timer(1).timeout
		puzzle_solved.emit()
	else:
		$Code/ColorRect.self_modulate = Color(1.0, 0.0, 0.0)
		await get_tree().create_timer(1).timeout
		$Code/ColorRect.self_modulate = Color(0.0,0.0,1.0)
		code_label.text = ""


func _on_exit_pressed() -> void:
	self.hide()
