extends Node
# CORE - central wiring - shelf style - reality based
var total_kills = 0
var total_cash = 0

func _ready():
	print("CORE wired - LaRanaSystem ready")

func add_cash(amt: int):
	total_cash += amt
	var sm = get_node_or_null("/root/StatsManager")
	if sm and sm.has_method("add_cash"):
		sm.add_cash(amt)
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_node("Stats/Currency"):
		player.get_node("Stats/Currency").add_cash(amt)

func add_kill():
	total_kills += 1
	var sm = get_node_or_null("/root/StatsManager")
	if sm and sm.has_method("add_kill"):
		sm.add_kill()
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_node("Stats/Tracker"):
		player.get_node("Stats/Tracker").on_kill()
