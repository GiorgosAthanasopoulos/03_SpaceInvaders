extends RigidBody2D


# TODO: upon being hit change texture to partially/fully destroyed and maybe play sound/particle fx


@export var lives: int = 3


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
    # TODO: change texture
    if lives <= 0:
        queue_free()
        # TODO: sfx?
        # TODO: particles?
