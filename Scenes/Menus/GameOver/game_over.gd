extends CanvasLayer

@onready var subtitle = $VBoxContainer/SubTitle

func _ready() -> void:
	if HUDmanager.Player1Health <= 0:
		subtitle.text = "[center]Jack morreu..."
	elif HUDmanager.Player2Health <= 0:
		subtitle.text = "[center]John morreu..."
