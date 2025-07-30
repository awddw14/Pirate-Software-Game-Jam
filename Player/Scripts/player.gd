extends CharacterBody2D

signal died

@export var bullet_scene: PackedScene
@export var world: Node2D
var speed: float = 300.0
var ammo: int = 1
var gun_equip: bool = false

@onready var cam: Camera2D = $cam
@onready var light: PointLight2D = $PointLight2D
@onready var weapon: Sprite2D = $weapon
@onready var ap: AnimationPlayer = $ap
@onready var anim: AnimatedSprite2D = $anim

@onready var walk_sound: AudioStreamPlayer2D = $WalkSound
@onready var shot_sound: AudioStreamPlayer2D = $ShotSound
@onready var mute_sound: AudioStreamPlayer2D = $MuteSound

var is_sight: bool = false
var target = null
var crosshair_playing := false
var hurt_count: int = 0

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
	mute_sound.play()

func _process(_delta: float) -> void:
	if gun_equip:
		var mouse_pos = cam.get_global_mouse_position()
		weapon.look_at(mouse_pos)
		weapon.flip_v = mouse_pos.x < global_position.x
		
	if Global.missed:
		death()

func _physics_process(_delta: float) -> void:
	var input_vector := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

	velocity = input_vector * speed

	if Global.missed == false:
		if input_vector != Vector2.ZERO:
			if Global.current_sense == "Hear":
				if !walk_sound.playing:
					mute_sound.stop()
					walk_sound.play()
			else:
				if !mute_sound.playing:
					walk_sound.stop()
					mute_sound.play()

			if abs(input_vector.x) > abs(input_vector.y):
				anim.flip_h = input_vector.x > 0
				anim.play("walk_left")
			elif input_vector.y < 0:
				anim.play("walk_up")
			elif input_vector.y > 0:
				anim.play("walk_down")
		else:
			anim.play("Idle")
			walk_sound.stop()
	else:
		velocity = Vector2.ZERO

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
		shot_sound.play()
		ammo -= 1
		var b = bullet_scene.instantiate()
		add_child(b)
		b.global_position = $weapon/pivot.global_position

func take_damage():
	if hurt_count == 0:
		Global.current_sense = "Hear"
		world.update()
	elif hurt_count == 1:
		Global.current_sense = "Hear"
		world.update()
	elif hurt_count == 2:
		Global.current_sense = "Hear"
		world.update()
		death()
	
	hurt_count += 1


func equip_weapon():
	weapon.show()
	gun_equip = true


func death():
	Global.missed = true
	anim.play("death")
	died.emit()
	await anim.animation_finished
	queue_free()

func _on_touch_sense_body_entered(body: Node2D) -> void:
	if body.is_in_group("Monster"):
		Global.temp_change = body.env_temp
		target = body

func _on_touch_sense_body_exited(body: Node2D) -> void:
	if body.is_in_group("Monster"):
		Global.temp_change = ""
