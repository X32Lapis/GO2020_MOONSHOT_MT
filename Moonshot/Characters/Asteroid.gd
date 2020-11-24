extends StaticBody2D


export var drift_speed = 10
export var rotation_speed = 5
export var direction = 1


func _physics_process(delta):
	rotation_degrees += rotation_speed * delta
	if direction == 1:
		global_position.x += drift_speed * delta
	else:
		global_position.x -= drift_speed * delta
