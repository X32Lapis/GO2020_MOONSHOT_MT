extends KinematicBody2D

var velocity = Vector2()
export var speed = 300
export var direction = 1
export var color = Color(1,1,1)
export var daze_length = 1
export var knockback_strength = 700


func _ready():
	set_modulate(color)


func _physics_process(_delta):
	if direction == 1:
		velocity.x = speed
		$AnimatedSprite.set_flip_h(false)
	else:
		velocity.x = -speed
		$AnimatedSprite.set_flip_h(true)
	
	velocity = move_and_slide(velocity,Vector2.UP)


func _on_TopDetection_body_entered(body):
	body.bounce()
	queue_free()


func _on_HurtBox_body_entered(body):
	body.hurt(get_parent().global_position,daze_length,knockback_strength)



