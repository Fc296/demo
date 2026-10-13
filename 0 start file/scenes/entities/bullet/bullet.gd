extends Area2D

class_name Bullet

var direction :Vector2
@export var bullet_speed := 900.0
@export var hit_hurt := 1


func _ready() -> void:
	$AudioStreamPlayer2D.play()


func _physics_process(delta: float) -> void:
	position += direction * delta * bullet_speed


func set_up(pos:Vector2, dir:Vector2):
	position = pos + dir * 16
	direction = dir


func _on_body_entered(body: Node2D) -> void:
	var hurt = hit_hurt
	if "hit" in body:
		body.hit(hurt)
	queue_free()
