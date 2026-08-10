extends CanvasLayer
@onready var fill: Sprite2D = $Meter/Fill
var bar_width : float
func _ready():
	bar_width = fill.texture.get_width()
	ProgressionManager.progress_changed.connect(update_progress)
	update_progress(ProgressionManager.progress)
func update_progress(value):
	var ratio = value / 100.0
	fill.region_rect = Rect2(0, 0, bar_width * ratio, fill.texture.get_height())
