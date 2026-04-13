extends CharacterBody3D

# 1. Variables at the top
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003 

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# 2. This runs when the game starts
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# 3. This handles mouse movement and ESC key
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# 1. Rotate the whole Player body LEFT/RIGHT
		rotate_y(-event.relative.x * SENSITIVITY)
		
		# 2. Rotate the HEAD node UP/DOWN (which carries the camera with it)
		$Head.rotate_x(-event.relative.y * SENSITIVITY)
		
		# 3. Clamp the HEAD rotation so you don't flip over
		$Head.rotation.x = clamp($Head.rotation.x, deg_to_rad(-80), deg_to_rad(80))
# 4. This handles physics (walking/gravity)
func _physics_process(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get movement input (WASD / Arrows)
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
