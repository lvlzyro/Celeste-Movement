extends Camera2D
class_name ShakeCamera2D

export var decay = 0.8
export var max_offset = Vector2(100, 75)
export var max_roll = 0.1
export (NodePath) var target

var trauma_power = 2
var shake = false;
var trauma = Vector2.ZERO

onready var noise = OpenSimplexNoise.new()
var noise_y = 0

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func shake(x_strength, y_strength):
	shake = true;
	if x_strength != 0:
		if x_strength > 0:
			trauma.x = max(0.5, x_strength);
		else:
			trauma.x = max(0.5, -x_strength);
	if y_strength != 0:
		if y_strength > 0:
			trauma.y = max(0.5, y_strength);
		else:
			 trauma.y = max(0.5, -y_strength);
	
func _process(delta):
	if target:
		global_position = get_node(target).global_position
	if shake: #this will trigger whenever the shake function is called
		trauma.y = max(trauma.y - decay * delta, 0)
		trauma.x = max(trauma.x - decay * delta, 0)
		var amount = Vector2.ZERO
		amount.y = pow(trauma.y, trauma_power)
		amount.x = pow(trauma.x, trauma_power)
		noise_y += 1
		amount.normalized();
		#rotation = max_roll * (amount.x/2 + amount.y/2) * noise.get_noise_2d(noise.seed, noise_y)
		offset.x = max_offset.x * amount.x * noise.get_noise_2d(noise.seed*2, noise_y)
		offset.y = max_offset.y * amount.y * noise.get_noise_2d(noise.seed*3, noise_y)
