extends CharacterBody2D


@export var alien_death_score: int = 10
@export var mothership_death_score: int = 30
@export var explosion_particles: PackedScene


func _physics_process(delta: float) -> void:
	var movement_vector: Vector2 = get_movement_vector(delta)
	var collision: KinematicCollision2D = move_and_collide(movement_vector)
	handle_collisions(collision)


func handle_collisions(collision: KinematicCollision2D) -> void:
	if collision == null:
		return

	var collider: PhysicsBody2D = collision.get_collider()
	if not is_instance_valid(collider):
		return

	# collision mask is only set for friendly bullets so we know we ve been hit we need to die
	# TODO: particle effect?
	var particles: GPUParticles2D = explosion_particles.instantiate()
	particles.global_position = global_position
	particles.global_rotation = global_rotation
	particles.emitting = true
	add_child(particles)

	Events.alien_died.emit(mothership_death_score if false else alien_death_score) # TODO: check if mothership then more points
	queue_free()


func get_movement_vector(_delta: float) -> Vector2:
	var movement_vector: Vector2 = Vector2.ZERO

	# TODO: ai movement in a grid

	return movement_vector
