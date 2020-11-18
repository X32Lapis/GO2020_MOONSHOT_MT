extends StaticBody2D


var rotationAngle = 0.0
var velocity = Vector2()
var driftSpeed = 10
var rotationSpeed = 5

func _physics_process(delta):
	rotation_degrees += rotationSpeed * delta
	position.x -= driftSpeed * delta
