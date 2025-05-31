extends Node


@onready var audio_stream_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()


const shoot: AudioStream = preload('res://assets/sounds/shoot/source/166418__quonux__scifi-shoot-or-bass.wav')


func _ready() -> void:
    get_tree().current_scene.add_child(audio_stream_player)


func play_sfx(sfx: AudioStream) -> void:
    audio_stream_player.stream = sfx
    audio_stream_player.play()


func play_shoot_sound() -> void:
    play_sfx(shoot)
