extends CharacterBody2D


@export var alien_death_score: int = 10
@export var mothership_death_score: int = 30
@export var texture: Texture2D
@export var shoot_delay_ms: float = 1000
@export var shoot_probability: float = 0.3


@onready var sprite: Sprite2D = $Sprite2D


var shoot_timer: float = 0


func _ready() -> void:
	sprite.texture = texture


func _physics_process(delta: float) -> void:
	var movement_vector: Vector2 = get_movement_vector(delta)
	var collision: KinematicCollision2D = move_and_collide(movement_vector)
	handle_collisions(collision)
	handle_alien_shooting(delta)


func handle_collisions(collision: KinematicCollision2D) -> void:
	if collision == null:
		return

	var collider: PhysicsBody2D = collision.get_collider()
	if not is_instance_valid(collider):
		return

	# collision mask is only set for friendly bullets so we know we ve been hit we need to die
	Events.alien_died.emit(mothership_death_score if false else alien_death_score)
	queue_free()


func get_movement_vector(_delta: float) -> Vector2:
	var movement_vector: Vector2 = Vector2.ZERO

	# ai movement

	return movement_vector


func handle_alien_shooting(delta: float) -> void:
	shoot_timer -= delta

	if shoot_timer <= 0:
		shoot_timer = shoot_delay_ms

		randomize()
		if randf() < shoot_probability:
			shoot()


func shoot() -> void:
	# remember to have a change of shooting down a bomb
	pass
