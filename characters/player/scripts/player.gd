extends CharacterBody2D


@export var speed: float = 12.5
@export var shoot_delay: float = 0.25
@export var rocket: PackedScene = preload('res://projectiles/rocket/rocket.tscn')


var shoot_timer: float = 0
var rocket_counter: int = 1


func _ready() -> void:
	var _signal_connection_id: int = Events.player_died.connect(_on_player_died)


func _physics_process(delta: float) -> void:
	var movement_vector: Vector2 = get_movement_vector()

	var collision: KinematicCollision2D = move_and_collide(movement_vector)
	handle_collision(collision)

	handle_player_shooting(delta)


func get_movement_vector() -> Vector2:
	var movement_vector: Vector2 = Vector2.ZERO

	if Input.is_action_pressed(&'move_left'):
		movement_vector.x = - speed
	if Input.is_action_pressed(&'move_right'):
		movement_vector.x = + speed

	return movement_vector


func handle_collision(collision: KinematicCollision2D) -> void:
	if collision == null:
		return

	var collider: PhysicsBody2D = collision.get_collider()
	if not is_instance_valid(collider):
		return

	# hit by an enemy_bullet
	if not collider.name.contains(&'Wall'):
		Events.player_hit.emit()


func handle_player_shooting(delta: float) -> void:
	shoot_timer -= delta

	if Input.is_action_just_pressed(&'shoot') and shoot_timer <= 0:
		shoot_timer = shoot_delay
		Audio.play_shoot_sound()
		shoot()


func shoot() -> void:
	var instance: Node = rocket.instantiate()
	instance.name = "Rocket" + str(rocket_counter)
	rocket_counter += 1
	@warning_ignore(&'unsafe_property_access')
	instance.global_position = position
	get_tree().current_scene.add_child(instance)


func _on_player_died() -> void:
	Particles.spawn_explosives(global_position, global_rotation)
	queue_free()
