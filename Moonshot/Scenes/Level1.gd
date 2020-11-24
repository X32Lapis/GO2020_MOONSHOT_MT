extends Node2D


func _physics_process(_delta):
	$"CanvasLayer/UI/Velocity X".text = "Velocity X : " + String($LittleGirl.velocity.x)
	$"CanvasLayer/UI/Velocity Y".text = "Velocity Y : " + String($LittleGirl.velocity.y)
	$CanvasLayer/UI/Fuel.text = "Fuel : " + String($LittleGirl.fuel)
	$CanvasLayer/UI/Cans.text = "Cans : " + String($LittleGirl.cans)
	$LittleGirl/State.text = String($LittleGirl.STATES.keys()[$LittleGirl.state])
	$CanvasLayer/UI/Health.text = "Health: " + String($LittleGirl.health)


func _on_body_entered(body):
	if body.name != "LittleGirl":
		body.direction = body.direction * -1
