extends TextureRect

var boxSize: float = 32

func _process(delta):
	if HUDmanager.Player1InventorySize == 0:
		self.visible = false
	else:
		self.visible = true
		self.custom_minimum_size.x = boxSize * HUDmanager.Player1InventorySize