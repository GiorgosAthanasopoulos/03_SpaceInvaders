extends RigidBody2D


@export var texture: Texture2D
@export var my_scale: Vector2 = Vector2(1, 1)
@export var explosion_particles: PackedScene = preload('res://particles/explosion/explosion_particles.tscn')


@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


var particles_counter: int = 1


func _ready() -> void:
	sprite.texture = texture
	sprite.scale = my_scale
	collision_shape.scale = my_scale


func _physics_process(delta: float) -> void:
	if State.paused:
		return

	var movement_vector: Vector2 = get_movement_vector()
	var collision: KinematicCollision2D = move_and_collide(movement_vector * delta)
	handle_collisions(collision)


func handle_collisions(collision: KinematicCollision2D) -> void:
	if collision == null:
		return

	var collider: PhysicsBody2D = collision.get_collider()
	if not is_instance_valid(collider):
		return

	# collision mask is only set for aliens/enemy bullets so when we hit them we disappear
	if not collider.name.contains(&'Bunker') and not collider.name.contains('HorizontalWall'):
		Audio.play_destroy_sound()
		Particles.spawn_explosives(global_position, global_rotation)
	if collider.name.contains('Player'):
		Events.player_hit.emit()

	get_parent().queue_free()


func get_movement_vector() -> Vector2:
	var movement_vector: Vector2 = Vector2.ZERO

	return movement_vector
