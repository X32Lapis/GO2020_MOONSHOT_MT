extends Node2D



func _physics_process(_delta):
#	$"CanvasLayer/UI/Velocity X".text = "Velocity X : " + String($LittleGirl.velocity.x)
#	$"CanvasLayer/UI/Velocity Y".text = "Velocity Y : " + String($LittleGirl.velocity.y)
	$CanvasLayer/UI/WaterLevels.text = "Water Level: " + String($LittleGirl.fuel)
#	$LittleGirl/State.text = String($LittleGirl.STATES.keys()[$LittleGirl.state])


func _on_body_entered(body):
	body.direction = body.direction * -1


func _on_FirstTier_body_entered(body):
	if get_node("ForegroundGrass") != null:
		get_node("ForegroundGrass").queue_free()
		
	if get_node("LowerLevelBG") != null:
		get_node("LowerLevelBG").queue_free()
		
	if get_node("Floor") != null:
		get_node("Floor").queue_free()
		
	if get_node("LowerLevelBG") != null:
		get_node("LowerLevelBG").queue_free() 
		
	if get_node("Enemies/BirdsGrp") != null:
		get_node("Enemies/BirdsGrp").queue_free()
		
	if get_node("Enemies/InsectsGrp") != null:
		get_node("Enemies/InsectsGrp").queue_free()
		
	if get_node("Lower_BG_Gradient") != null:
		get_node("Lower_BG_Gradient").queue_free()
		
	if get_node("Obstacles/LowerClouds") != null:
		get_node("Obstacles/LowerClouds").queue_free()
	
	if get_node("Label") != null:
		get_node("Label").queue_free()


func _on_SecondTier_body_entered(body):
	if get_node("Obstacles/FirstTier") != null:
		get_node("Obstacles/FirstTier").queue_free()
		
	if get_node("Enemies/AttackBirdsGrp") != null:
		get_node("Enemies/AttackBirdsGrp").queue_free()


func _on_LastTier_body_entered(body):
	if get_node("Mid_BG_Gradient") != null:
		get_node("Mid_BG_Gradient").queue_free()
	
	if get_node("Enemies/StormCloudsGrp") != null:
		get_node("Enemies/StormCloudsGrp").queue_free()


func _on_Finished_body_entered(_body):
	$AnimationPlayer.play("Fade_out")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Scenes/EndingLevel.tscn")
