extends Node


@export var lives: int = 3
@export var max_aliens: int = 24

@export var max_shake: float = 10
@export var shake_fade: float = 10


var score: int = 0
var shake_strength: float = 0
var aliens_killed: int = 0


@onready var lifes_label: Label = $UI/CanvasLayer/LivesLabel
@onready var score_label: Label = $UI/CanvasLayer/ScoreLabel
@onready var camera: Camera2D = $Camera2D


func _ready() -> void:
	var _signal_connection_id: int = Events.player_hit.connect(decrease_life)
	_signal_connection_id = Events.alien_died.connect(increase_score)


func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		randomize()
		camera.offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))


func decrease_life() -> void:
	lives -= 1
	lifes_label.text = &'Lives: ' + str(lives)
	trigger_shake()

	if lives <= 0:
		# lose
		Events.player_died.emit()


func increase_score(scoreInc: int) -> void:
	aliens_killed += 1
	score += scoreInc
	score_label.text = &'Score: ' + str(score)
	trigger_shake()

	if aliens_killed >= max_aliens:
		# win
		pass


func trigger_shake() -> void:
	shake_strength = max_shake
