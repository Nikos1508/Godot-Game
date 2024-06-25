extends TileMap

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var width = 64
var height = 64
var height2 = 1
@onready var player = get_parent().get_child(1)

func _ready():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	altitude.frequency = 0.001
	generate_chunk(player.position)


func _process(delta):
	if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_accept"):
		generate_chunk(player.position)
		generate_layer(player.position)

func generate_chunk(position):
	var tile_pos = local_to_map(position)
	for x in range(width):
		for y in range(height):
			var world_x = tile_pos.x - width/2  + x
			var world_y = tile_pos.y + 3 + y
			var moist = moisture.get_noise_2d(world_x, world_y) * 10
			var temp = temperature.get_noise_2d(world_x, world_y) * 10
			var alt = altitude.get_noise_2d(world_x, world_y) * 10
			
			if alt < 2:
				set_cell(0, Vector2i(world_x, world_y), 0, Vector2(2, round((temp + 10) / 5)))
			else:
				set_cell(0, Vector2i(world_x, world_y), 0, Vector2(round((moist + 10) / 5), round((temp + 10) / 5)))
				
func generate_layer(position):
	var tile_pos = local_to_map(position)
	for x in range(width):
		for y in range(height2):
			var world_x = tile_pos.x - width/2  + x
			var world_y = tile_pos.y + 3 + y
			set_cell(0, Vector2i(world_x, world_y), 0, Vector2(2, 2))
