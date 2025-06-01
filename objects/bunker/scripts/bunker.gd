extends RigidBody2D


@export var lives: int = 3


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(_delta: float) -> void:
	var movement_vector: Vector2 = get_movement_vector()
	var collision: KinematicCollision2D = move_and_collide(movement_vector)
	handle_collisions(collision)


func get_movement_vector() -> Vector2:
	var movement_vector: Vector2 = Vector2.ZERO

	return movement_vector


func handle_collisions(collision: KinematicCollision2D) -> void:
	if collision == null:
		return

	var collider: PhysicsBody2D = collision.get_collider()
	if not is_instance_valid(collider):
		return

	lives -= 1
	animated_sprite.frame += 1
	Audio.play_destroy_sound()

	if lives <= 0:
		Particles.spawn_explosives(global_position, global_rotation)
		queue_free()
