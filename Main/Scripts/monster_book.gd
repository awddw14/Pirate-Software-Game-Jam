extends Control

@onready var anim: AnimatedSprite2D = $anim

@onready var page_1: Node2D = $Page1
@onready var page_2: Node2D = $Page2
@onready var page_3: Node2D = $Page3
@onready var page_4: Node2D = $Page4

@onready var sense_ui: Control = $"../Sense_UI"

var current_page := 1

func _ready() -> void:
	self.hide()
	_update_page_visibility()

func _on_button_pressed() -> void:
	sense_ui.show()
	self.hide()
	

func _on_next_page_pressed() -> void:
	anim.offset.y = 0
	page_1.hide()
	page_2.hide()
	page_3.hide()
	page_4.hide()
	current_page += 1
	if current_page > 4:
		current_page = 1
	anim.play("NextPage")

func _on_anim_animation_finished() -> void:
	if anim.animation == "NextPage":
		anim.play("Idle")
		anim.offset.y = 50
		_update_page_visibility()

func _update_page_visibility() -> void:
	page_1.visible = (current_page == 4)
	page_2.visible = (current_page == 2)
	page_3.visible = (current_page == 3)
	page_4.visible = (current_page == 1)
