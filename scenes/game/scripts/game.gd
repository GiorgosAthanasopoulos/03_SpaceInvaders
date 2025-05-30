extends Node


@export var lives: int = 3


var score: int = 0


@onready var lifes_label: Label = $UI/CanvasLayer/LivesLabel
@onready var score_label: Label = $UI/CanvasLayer/ScoreLabel


func _ready() -> void:
    var _signal_connection_id: int = Events.player_hit.connect(decrease_life)
    _signal_connection_id = Events.alien_died.connect(increase_score)


func decrease_life() -> void:
    lives -= 1
    lifes_label.text = "Lives: " + str(lives)

    if lives <= 0:
        # TODO: anything else when player died (eg restart?)
        Events.player_died.emit()


func increase_score(scoreInc: int) -> void:
    score += scoreInc
    score_label.text = "Score: " + str(score)
