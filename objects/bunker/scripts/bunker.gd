extends RigidBody2D


@export var lives: int = 3


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var collision_shape2: CollisionShape2D = $CollisionShape2D2
@onready var collision_shape1: CollisionShape2D = $CollisionShape2D1


func _ready() -> void:
    collision_shape.disabled = false
    collision_shape2.disabled = true
    collision_shape1.disabled = true


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
    if animated_sprite.frame == 1:
        collision_shape.disabled = true
        collision_shape2.disabled = false
        collision_shape1.disabled = true
    elif animated_sprite.frame == 2:
        collision_shape.disabled = true
        collision_shape2.disabled = true
        collision_shape1.disabled = false

    if lives <= 0:
        Particles.spawn_explosives(global_position, global_rotation)
        queue_free()
