extends GPUParticles2D


@onready var spawn_time: float = Time.get_ticks_msec()


@export var max_lifetime: float = 2000.0


func _process(_delta: float) -> void:
    if Time.get_ticks_msec() - spawn_time > max_lifetime:
        queue_free()
