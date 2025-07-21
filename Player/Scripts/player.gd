extends CharacterBody2D

signal died

@export var bullet_scene: PackedScene

var speed: float = 300.0
var ammo: int = 1
var gun_equip: bool = false

@onready var cam: Camera2D = $cam
@onready var light: PointLight2D = $PointLight2D
@onready var weapon: Sprite2D = $weapon
@onready var ap: AnimationPlayer = $ap
@onready var anim: AnimatedSprite2D = $anim
@onready var crosshair: Sprite2D = $Crosshair

var is_sight: bool = false
var target = null
var crosshair_playing := false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and gun_equip:
		shoot()
		cam.apply_shake()
	if event.is_action_pressed("ui_down"):
		equip_weapon()

func _ready() -> void:
	light.scale = Vector2(2,2)
	weapon.hide()
	self.add_to_group("Player")

func _process(_delta: float) -> void:
	if gun_equip:
		var mouse_pos = cam.get_global_mouse_position()
		weapon.look_at(mouse_pos)
		weapon.flip_v = mouse_pos.x < global_position.x
		
	if gun_equip and target != null:
		crosshair.global_position = target.global_position
		
		if not crosshair_playing and target != null:
			play_crosshair_anim()
	
	if Global.missed:
		death()

func _physics_process(_delta: float) -> void:
	var input_vector: Vector2 = Vector2(Input.get_axis("move_left", "move_right"),Input.get_axis("move_up", "move_down")).normalized()
	velocity = input_vector * speed
	if Global.missed == false:
		if input_vector.x < 0 or input_vector.y < 0:
			anim.flip_h = true
			anim.play("Walk")
		elif input_vector.x > 0 or input_vector.y > 0:
			anim.flip_h = false
			anim.play("Walk")
		elif velocity == Vector2(0,0):
			anim.play("Idle")
	move_and_slide()

func update_sense():
	if Global.current_sense == "Sight":
		is_sight = true
		ap.play("Sight_Fade_1")
		await ap.animation_finished
		light.scale = Vector2(8,8)
		light.color = Color(1.0, 1.0, 1.0)
	else :
		if is_sight:
			ap.play("Sight_Fade_2")
			await ap.animation_finished
			is_sight = false
		light.color = Color(0.5, 0.5, 0.5)
		light.scale = Vector2(3,3)

func shoot():
	if ammo != 0:
		ammo -= 1
		var b = bullet_scene.instantiate()
		add_child(b)
		b.global_position = $weapon/pivot.global_position

func equip_weapon():
	weapon.show()
	gun_equip = true

func play_crosshair_anim():
	if not gun_equip or target == null:
		return
	crosshair_playing = true
	crosshair.show()
	ap.play("Crosshair_anim")
	await ap.animation_finished
	ap.play_backwards("Crosshair_anim")
	await ap.animation_finished
	crosshair_playing = false

func death():
	anim.play("death")
	await anim.animation_finished
	queue_free()
	died.emit()

func _on_touch_sense_body_entered(body: Node2D) -> void:
	if body.is_in_group("Monster"):
		Global.temp_change = body.env_temp
		target = body

func _on_touch_sense_body_exited(body: Node2D) -> void:
	if body.is_in_group("Monster"):
		Global.temp_change = ""
		crosshair.hide()
