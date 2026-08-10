extends Node
signal progress_changed(value)
signal checkpoint_reached(id)
var progress := 0.0
const CHECKPOINTS := [
	25.0,
	60.0,
	100.0
]
var reached := []
func _ready():
	progress = 0.0
	reached.clear()
func add_progress(amount: float):
	progress += amount
	progress = clamp(progress, 0.0, 100.0)
	print("PROGRESS: ", progress)
	progress_changed.emit(progress)
	check_checkpoints()
func check_checkpoints():
	for i in CHECKPOINTS.size():
		if progress >= CHECKPOINTS[i] and i not in reached:
			reached.append(i)
			print("CHECKPOINT REACHED: ", i)
			checkpoint_reached.emit(i)
func evolution_completed(amount: float):
	add_progress(amount)
func reset_game():
	progress = 0.0
	reached.clear()
	progress_changed.emit(progress)
	print("PROGRESS RESET")
