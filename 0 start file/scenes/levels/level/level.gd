extends Node2D

@export var bullet_scene : PackedScene

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ESC"):
		get_tree().quit()

func _on_player_shoot_signal(pos: Vector2, dir: Vector2) -> void:
	var bullet : Bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.set_up(pos,dir)
