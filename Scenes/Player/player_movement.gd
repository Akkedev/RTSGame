extends CharacterBody2D

# this will not work
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var start_position : Vector2 = self.position
var current_direction := Vector2.ZERO
var target_position : Vector2 = self.position
var moving : bool = false


func _physics_process(delta: float) -> void:
	# check if player should be moving
	if moving == false:
		return
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if((target_position-self.global_position).dot(current_direction) > 0):
		velocity = current_direction * SPEED
	else:
		velocity = Vector2.ZERO
		moving = false
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	#Handle input for player movement
	if event.is_action_pressed("PlayerMovement"):
		var click_position = self.make_input_local(event).position
		current_direction = click_position.normalized()
		start_position = self.global_position
		target_position = start_position + click_position
		moving = true
