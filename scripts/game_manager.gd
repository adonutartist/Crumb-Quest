extends  Node
var crumbs := 0
var selected_creature = null
func add_crumbs(amount: int):
	crumbs += amount
	print("Crumbs:", crumbs)
func select_creature(creature):
	if selected_creature == creature:
		selected_creature.set_selected(false)
		selected_creature = null
		return
	if selected_creature:
		selected_creature.set_selected(false)
	selected_creature = creature
	selected_creature.set_selected(true)
func deselect_creature():
	if selected_creature:
		selected_creature.set_selected(false)
		selected_creature = null
