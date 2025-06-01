extends Node


@onready var sfx_audio_stream_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
@onready var music_audio_stream_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()


const shoot: AudioStream = preload('res://assets/sounds/shoot/source/166418__quonux__scifi-shoot-or-bass.wav')
const win: AudioStream = preload('res://assets/sounds/win/source/270545__littlerobotsoundfactory__jingle_win_01.wav')
const lose: AudioStream = preload('res://assets/sounds/lose/source/159408__noirenex__life-lost-game-over.wav')
const destroy: AudioStream = preload('res://assets/sounds/destroy/converted/explosion.wav')
const bgm: AudioStream = preload('res://assets/music/bgm/source/730222__ncone__suspense-music-sci-fi-loop.mp3')


func _ready() -> void:
    get_tree().current_scene.add_child(sfx_audio_stream_player)
    get_tree().current_scene.add_child(music_audio_stream_player)


func play_sound(sound: AudioStream) -> void:
    sfx_audio_stream_player.stream = sound
    sfx_audio_stream_player.play()


func play_music(music: AudioStream) -> void:
    music_audio_stream_player.stop()
    music_audio_stream_player.stream = music
    music_audio_stream_player.play()


func play_shoot_sound() -> void:
    play_sound(shoot)


func play_win_music() -> void:
    stop_bgm_music()
    stop_all_sounds()
    play_music(win)


func play_lose_music() -> void:
    stop_bgm_music()
    stop_all_sounds()
    play_music(lose)


func play_destroy_sound() -> void:
    play_sound(destroy)


func play_bgm_music() -> void:
    play_music(bgm)


func stop_bgm_music() -> void:
    music_audio_stream_player.stop()


func stop_all_sounds() -> void:
    sfx_audio_stream_player.stop()
