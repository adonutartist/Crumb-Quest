extends Button
@onready var tutorial_popup = $"../TutorialPopup"
func _ready():
	pressed.connect(_on_pressed)
func _on_pressed():
	tutorial_popup.open_tutorial()
