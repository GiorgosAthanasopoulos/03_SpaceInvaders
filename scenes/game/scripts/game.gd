extends Node


@export var lives: int = 3
@export var max_aliens: int = 24

@export var max_shake: float = 10
@export var shake_fade: float = 10

@export var mothership_spawn_location: Vector2 = Vector2(115, 75)
@export var mothership: PackedScene = preload('res://characters/alien/mothership.tscn')
@export var mothership_y_spawn_threshold: int = 150


var score: int = 0
var shake_strength: float = 0
var aliens_killed: int = 0


@onready var lifes_label: Label = $UI/CanvasLayer/LivesLabel
@onready var score_label: Label = $UI/CanvasLayer/ScoreLabel
@onready var camera: Camera2D = $Camera2D

@onready var popup: CanvasLayer = $WinLostPopup/CanvasLayer
@onready var label: Label = $WinLostPopup/CanvasLayer/StateLabel

@onready var row_1: Node2D = $Entities/Aliens/Row1
@onready var row_2: Node2D = $Entities/Aliens/Row2
@onready var row_3: Node2D = $Entities/Aliens/Row3


func _ready() -> void:
	var _signal_connection_id: int = Events.player_hit.connect(decrease_life)
	_signal_connection_id = Events.alien_died.connect(increase_score)
	Audio.play_bgm_music()


func _process(delta: float) -> void:
	if State.paused:
		return

	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		randomize()
		camera.offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))

	handle_mothership(delta)

	if get_alien_count() == 0:
		# win
		State.paused = true
		popup.visible = true
		label.text = 'You won!'

		Audio.play_win_music()


func decrease_life() -> void:
	lives -= 1
	lifes_label.text = &'Lives: ' + str(lives)
	trigger_shake()

	if lives <= 0:
		# lose
		State.paused = true
		popup.visible = true
		label.text = 'You lost!'

		Audio.play_lose_music()
		Events.player_died.emit()


func increase_score(scoreInc: int) -> void:
	aliens_killed += 1
	score += scoreInc
	score_label.text = &'Score: ' + str(score)
	trigger_shake()

	if get_alien_count() == 0:
		# win
		State.paused = true
		popup.visible = true
		label.text = 'You won!'

		Audio.play_win_music()


func trigger_shake() -> void:
	shake_strength = max_shake


func _on_restart_button_pressed() -> void:
	State.paused = false
	popup.visible = false

	var error: Error = get_tree().reload_current_scene() as Error
	if error != OK:
		print("error occured while trying to restart scene upon restart button pressed: ", error_string(error))


func handle_mothership(delta: float) -> void:
	if not State.mothership:
		State.mothership_timer -= delta

		if State.mothership_timer <= 0 and get_highest_alien_y() > mothership_y_spawn_threshold:
			State.mothership = true

			var instance: Node = mothership.instantiate()
			add_child(instance)
			@warning_ignore('unsafe_property_access')
			instance.global_position = mothership_spawn_location


func get_highest_alien_y() -> float:
	var highest_y: float = INF
	var all_aliens: Array[Node] = row_1.get_children()
	all_aliens.append_array(row_2.get_children())
	all_aliens.append_array(row_3.get_children())

	for alien: CharacterBody2D in all_aliens:
		if alien.global_position.y < highest_y:
			highest_y = alien.global_position.y

	return highest_y


func get_alien_count() -> int:
	var all_aliens: Array[Node] = row_1.get_children()
	all_aliens.append_array(row_2.get_children())
	all_aliens.append_array(row_3.get_children())
	return all_aliens.size()
