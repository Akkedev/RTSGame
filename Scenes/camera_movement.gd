extends Node2D

#camera_move
@export_range (0,1000,1) var camera_move_speed: float = 1000.0

#camera_zoom
var camera_zoom_direction: float = 0
@export_range(0.1, 4.0, 0.1) var camera_zoom_speed = 1.0
@export_range(0.5, 2.0, 0.1) var camera_zoom_min = 0.5
@export_range(0.5, 2.0, 0.1) var camera_zoom_max = 2.0
@export_range(0,2,0.1) var camera_zoom_speed_dampener: float = 0.92

# Flags
var camera_can_process: bool = true
var camera_can_move_base: bool = true
var camera_can_zoom: bool = true

# Nodes
@onready var camera_base: Node2D = $camera_base
@onready var camera: Camera2D = $camera_base/Camera2D


func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if !camera_can_process:return
	
	camera_base_move(delta)
	camera_zoom_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	# Camera Zoom
	if event.is_action("camera_zoom_in"):
		camera_zoom_direction = -1
	elif event.is_action("camera_zoom_out"):
		camera_zoom_direction = 1

# Moves the base of the camera with arrowkeys
func camera_base_move(delta: float) -> void:
	if !camera_can_move_base: return
	var velocity_direction: Vector2 = Vector2.ZERO
	
	if Input.is_action_pressed("camera_up"): velocity_direction -= transform.y
	
	if Input.is_action_pressed("camera_down"): velocity_direction += transform.y
	
	if Input.is_action_pressed("camera_left"): velocity_direction -= transform.x
	
	if Input.is_action_pressed("camera_right"): velocity_direction += transform.x
	
	position += velocity_direction.normalized() * delta * camera_move_speed

	print(velocity_direction)
	
#Controls camera zoom
func camera_zoom_update(delta: float) -> void:
	if !camera_can_zoom:return
	
	var zoom_change: float = camera_zoom_speed * camera_zoom_direction * delta
	var new_zoom := camera.zoom + Vector2(zoom_change, zoom_change)
	
	var clamped_zoom_x = clamp(new_zoom.x, camera_zoom_min, camera_zoom_max)
	var clamped_zoom_y = clamp(new_zoom.y, camera_zoom_min, camera_zoom_max)
	
	camera.zoom = Vector2(clamped_zoom_x, clamped_zoom_y)
	camera_zoom_direction *= camera_zoom_speed_dampener
	
	
	print(camera.zoom)
