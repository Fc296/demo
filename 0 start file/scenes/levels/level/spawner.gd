extends Area2D

@export var drone_scene : PackedScene
@export var drone_count : int
@export var drone_posi : Array[Vector2] = []


var _spawn = false


func _on_body_entered(body: Node2D) -> void:
	print(body)
	if _spawn:
		return
	if not body.is_in_group("player"):
		return
	_spawn = true
	_spawn_drones.call_deferred()


func _spawn_drones() -> void:
	for i in drone_count:
		var pos := drone_posi[i % drone_posi.size()]
		var drone = drone_scene.instantiate() as CharacterBody2D
		get_tree().current_scene.add_child(drone)
		drone.global_position = pos
