extends CharacterBody2D


@export var alien_death_score: int = 10
@export var texture: Texture2D

@export var shoot_delay: float = 2
@export var shoot_probability: float = 0.3
@export var shoot_bomb_probability: float = 0.3

@export var bomb: PackedScene = preload('res://projectiles/bomb/bomb.tscn')
@export var bullet: PackedScene = preload('res://projectiles/bullet/bullet.tscn')

@export var speed: Vector2 = Vector2(150, 10)
@export var aliens_move_right: bool = true


@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


var shoot_timer: float = 0
var bomb_counter: int = 1
var bullet_counter: int = 1


func _ready() -> void:
	sprite.texture = texture
	var error: Error = Events.alien_switch_dir.connect(_on_aliens_switch_dir) as Error
	if error != OK:
		print("failed to connect alien switch dirs: ", error_string(error))


func _physics_process(delta: float) -> void:
	if State.paused:
		return

	var movement_vector: Vector2 = get_movement_vector(delta)
	var collision: KinematicCollision2D = move_and_collide(movement_vector * delta)
	handle_collisions(collision)
	handle_alien_shooting(delta)


func handle_collisions(collision: KinematicCollision2D) -> void:
	if collision == null:
		return

	var collider: PhysicsBody2D = collision.get_collider()
	if not is_instance_valid(collider):
		return

	# collision mask is only set for friendly bullets so we know we ve been hit we need to die
	if not collider.name.contains('Wall'):
		Events.alien_died.emit(alien_death_score)
		Audio.play_destroy_sound()
		queue_free()
	else:
		Events.alien_switch_dir.emit()


func get_movement_vector(_delta: float) -> Vector2:
	var movement_vector: Vector2 = Vector2.ZERO

	movement_vector.x = (1 if aliens_move_right else -1) * speed.x

	return movement_vector


func handle_alien_shooting(delta: float) -> void:
	shoot_timer -= delta

	if shoot_timer <= 0:
		shoot_timer = shoot_delay

		randomize()
		if randf() < shoot_probability:
			shoot()


func shoot() -> void:
	if randf() < shoot_bomb_probability:
		shoot_bomb()
	else:
		shoot_bullet()


func shoot_bomb() -> void:
	var instance: Node = bomb.instantiate()
	instance.name = &'Bomb ' + str(bomb_counter)
	bomb_counter += 1
	@warning_ignore(&'unsafe_property_access')
	instance.global_position = global_position
	get_tree().current_scene.add_child(instance)


func shoot_bullet() -> void:
	var instance: Node = bullet.instantiate()
	instance.name = &'Bullet ' + str(bullet_counter)
	bullet_counter += 1
	@warning_ignore(&'unsafe_property_access')
	instance.global_position = global_position
	get_tree().current_scene.add_child(instance)


func _on_aliens_switch_dir() -> void:
	global_position.y += speed.y
	aliens_move_right = not aliens_move_right
