extends KinematicBody2D

var velocity = Vector2()
var speed = 100
export var direction = 1


func _physics_process(delta):
	if direction == 1:
		velocity.x = speed
	else:
		velocity.x = -speed
	
	velocity = move_and_slide(velocity,Vector2.UP)



func _on_TopDetection_body_entered(body):
	body.bounce()
	queue_free()


func _on_BottomDetection_body_entered(body):
	body.downHurt()


func _on_SideDetection_body_entered(body):
	body.sideHurt(position.x)
