extends GutTest

var PlayerType = preload("res://Scripts/Players/Jack/Player.gd")
var AstarType = preload("res://Scripts/Pathfinding/Astar.gd")

var astarTest: Astar
var playerTest: Player

func createVariables() -> void:
	playerTest = Player.new()
	astarTest = Astar.new()
	add_child(playerTest)
	add_child(astarTest)
	playerTest.playerHP = 3
	playerTest.playerNumber = 'p1'
	playerTest.playerInventory = 5
	playerTest.position = Vector3(0, 0, 0)

func before_each() -> void:
	createVariables()
	await get_tree().process_frame

func after_each() -> void:
	playerTest.queue_free()
	astarTest.queue_free()

func test_initial_health() -> void:
	assert_eq(playerTest.playerHP, 3, "Player should start with full health.")

func test_initial_inventory() -> void:
	assert_eq(playerTest.playerInventory, 5, "Player should start with 5 items in inventory.")

func test_player_number() -> void:
	assert_eq(playerTest.playerNumber, 'p1', "Player should be player 1.")

func test_player_position() -> void:
	assert_eq(playerTest.global_position, Vector3(0, 0, 0), "Player should start at position (0, 0, 0).")

func test_remove_inventory() -> void:
	playerTest.removePlayerInventory()
	assert_eq(playerTest.playerInventory, 4, "Player should have lost an inventory item")
	
func test_take_damage() -> void:
	playerTest.dealDamage(2)
	assert_eq(playerTest.playerHP, 1, "Player took 2 damage and now has to be with 1 HP")
