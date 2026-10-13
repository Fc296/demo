extends CharacterBody2D

@export var speed = 300.0
@export var jump_strength = -320.0
@export var aim_frames: Array[int] = [0, 1, 2, 3, 4, 5, 6, 7]
@export var max_hp := 10

signal shoot_signal(pos:Vector2, dir:Vector2)
var dir :float


func _physics_process(delta: float) -> void:
	move(delta)
	shoot()
	
func _process(_delta: float) -> void:
	animation()
	aim_torso()
	
func move(delta):
	dir = Input.get_axis("left", "right")
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_strength

	if dir:
		velocity.x = dir * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()


func shoot():
	if Input.is_action_pressed("shoot") and $shoot.is_stopped():
		$shoot.start()
		shoot_signal.emit(position,get_local_mouse_position().normalized())


func animation():
	$leg.flip_h = dir < 0
	if is_on_floor():
		$AnimationPlayer.current_animation = "run" if dir != 0 and is_on_floor() else "idle"
	else:
		$AnimationPlayer.current_animation = "jump"


func aim_torso() -> void:
	var aim = get_local_mouse_position()
	if aim.length() < 0.01:
		$torso.frame = 0
		return
	
	var angle = aim.angle()
	var dir_idx = int(fposmod(round(angle/(PI/4)),8.0))
	$torso.frame = aim_frames[dir_idx]


func take_damage(drone_damage):
	max_hp -= drone_damage
	if max_hp <= 0:
		print("game over")
		get_tree().quit()
	
