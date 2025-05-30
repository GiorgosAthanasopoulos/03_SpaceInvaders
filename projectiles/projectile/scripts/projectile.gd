extends RigidBody2D


@export var texture: Texture2D
@export var my_scale: Vector2 = Vector2(1, 1)
@export var my_rotation: float = 0


@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
    sprite.texture = texture
    sprite.scale = my_scale
    collision_shape.scale = my_scale
    rotation = deg_to_rad(my_rotation)


func _physics_process(_delta: float) -> void:
    var movement_vector: Vector2 = get_movement_vector()
    var collision: KinematicCollision2D = move_and_collide(movement_vector)
    handle_collisions(collision)


func handle_collisions(collision: KinematicCollision2D) -> void:
    if collision == null:
        return

    var collider: PhysicsBody2D = collision.get_collider()
    if not is_instance_valid(collider):
        return

    # collision mask is only set for aliens so when we hit them we disappear
    # TODO: particle effect
    queue_free()


func get_movement_vector() -> Vector2:
    var movement_vector: Vector2 = Vector2.ZERO

    return movement_vector