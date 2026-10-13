extends CharacterBody2D

@export var drone_speed := 240
@export var drone_hp := 3
@export var drone_damage := 5
@export var damage_distance := 20

var player: CharacterBody2D
var exploding := false
var _boom_damaged := false
var hp = drone_hp


func _ready() -> void:
	$drone.material = $drone.material.duplicate()
	$boom.monitoring = false


func _physics_process(_delta: float) -> void:
	if exploding:
		return
	drone_active()
	
	
func _process(_delta: float) -> void:
	if exploding:
		return
	$AnimationPlayer.play("drone_anim")


func _on_active_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body


func _on_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		to_explode()


func _on_boom_body_entered(body: Node2D) -> void:
	if _boom_damaged:
		return
	_boom_damaged = true
	if body.is_in_group("player"):
		print("玩家被炸到了！")
		if body.has_method("take_damage"):
			body.take_damage(drone_damage)


func drone_active() -> void:
	if player == null:
		return
	var dir := (player.global_position - global_position).normalized()
	velocity = dir * drone_speed
	move_and_slide()


func to_explode():
	if exploding:
		return
	exploding = true
	$AudioStreamPlayer2D.play()
	drone_speed = 0
	$drone.hide()
	$PointLight2D.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$booming.show()
	$AnimationPlayer.play("boom_before")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("boom")
	await $AnimationPlayer.animation_finished
	queue_free()


func be_exploded():
	if exploding:
		return
	exploding = true
	$AudioStreamPlayer2D.play()
	drone_speed = 0
	$drone.hide()
	$PointLight2D.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$booming.show()
	$AnimationPlayer.play("boom")
	await $AnimationPlayer.animation_finished
	queue_free()


func chain_react():
	for drone in get_tree().get_nodes_in_group("drones"):
		if position.distance_to(drone.position) < damage_distance:
			drone.be_exploded()


func hit(hurt):
	hp -= hurt
	if hp <= 0:
		be_exploded()
	var tween = create_tween()
	tween.tween_property($drone.material, "shader_parameter/progress", 6.0, 0.2)
	tween.tween_property($drone.material, "shader_parameter/progress", 1.0, 0.2)
