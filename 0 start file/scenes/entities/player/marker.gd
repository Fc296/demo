extends Node2D

@export var pulse_speed := 3.0  # 每秒来回缩放几次，觉得太快/太慢就调这个
@export var scale_bs := Vector2(0.36, 0.36)
var _time := 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _exit_tree() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	marker_anim(delta)


func marker_anim(delta):
	scale = scale_bs
	_time += delta  # 按住攻击键时做缩放动画
	if Input.is_action_pressed("shoot"):
		var t := (sin(_time * pulse_speed * TAU) + 1.0) / 2.0 # sin 在 -1~1 之间平滑变化，+1 后除以 2 变成 0~1
		scale = scale_bs * lerpf(0.5, 2.0 / 3.0, t) # 再映射到 0.5 ~ 2/3，就是“原大小的一半到三分之二”之间来回
	else:
		scale = scale_bs
