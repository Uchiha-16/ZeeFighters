extends CharacterBody2D

#Globals Variables
var frame = 0
@export var id: int

#Attributes
@export var percentage = 0
@export var stocks = 3
@export var weight = 92
var freezeframes = 0

#Buffers
var l_cancel = 0
var cooldown = 0
var shield_buffer = 0

#Knockback
var hdecay
var vdecay
var knockback
var hitstun
var connected:bool

#Ground Variables
var dash_duration = 10

#Landing Variables
var landing_frames = 0
var lag_frames = 0

#Air Variables
var jump_squat = 3
var fastfall = false
var airJump = 0
@export var airJumpMax = 1

#Ledges 
var last_ledge = false
var regrab = 30
var catch = false

#Hitboxes
@export var hitbox: PackedScene
@export var projectile: PackedScene
@export var grabbox: PackedScene
var health_bar: ProgressBar
var selfState

#Temporary Variables
var hit_pause = 0 
var hit_pause_dur = 0
var temp_pos = Vector2(0,0)
var temp_vel = Vector2(0,0)

#Attacks
var projectile_cooldown = 0
var grabbing = false

#Onready Variables
@onready var GroundL = get_node('Raycasts/GroundL')
@onready var GroundR = get_node('Raycasts/GroundR')
@onready var Ledge_Grab_F = get_node("Raycasts/Ledge_Grab_F")
@onready var Ledge_Grab_B = get_node("Raycasts/Ledge_Grab_B")
@onready var gun_pos = get_node("gun_pos")
@onready var states = $State
@onready var anim = %AnimationPlayer
@onready var hurtbox = %Hurtbox
@onready var parrybox = %Parrybox

#FOX's main attributes
var RUNSPEED = 310 *2
var DASHSPEED = 350 *2
var WALKSPEED = 159 *2
var GRAVITY = 1800 *2
var JUMPFORCE = 469 *2
var MAX_JUMPFORCE = 732 *2
var DOUBLEJUMPFORCE = 830 *2
var MAXAIRSPEED = 300 *2
var AIR_ACCEL = 30 *2
var FALLSPEED = 51 *2
var FALLINGSPEED = 857 *2
var MAXFALLSPEED = 857 *2
var TRACTION = 38 *2
var ROLL_DISTANCE = 350 *2
var air_dodge_speed = 500 *2
var UP_B_LAUNCHSPEED = 500 *2

func create_hitbox(width, height, damage,angle,base_kb, kb_scaling,duration,type,points,angle_flipper,hitlag=1):
	var hitbox_instance = hitbox.instantiate()
	self.add_child(hitbox_instance)
	#Rotates The Points 
	if direction() == 1:
		hitbox_instance.set_parameters(width, height, damage,angle,base_kb, kb_scaling,duration,type,points,angle_flipper,hitlag)
	else:
		var flip_x_points = Vector2(-points.x, points.y)
		hitbox_instance.set_parameters(width, height, damage,-angle+180,base_kb, kb_scaling,duration,type,flip_x_points,angle_flipper,hitlag)
	return hitbox_instance


func create_projectile(dir_x,dir_y,point):
	#Instance projectile
	var projectile_instance = projectile.instantiate()
	projectile_instance.player_list.append(self)
	get_parent().add_child(projectile_instance)
	#sets position
	gun_pos.set_position(point)
	#Flips the direction
	if direction() == 1:
		projectile_instance.dir(dir_x,dir_y)
		projectile_instance.set_global_position(gun_pos.get_global_position())
	else:
		gun_pos.position.x = -gun_pos.position.x
		projectile_instance.dir(-(dir_x),dir_y)
		projectile_instance.set_global_position(gun_pos.get_global_position())
	return projectile_instance

func updateframes(delta):
	frame += floor(delta *60)
	l_cancel -= floor(delta *60)
	clampi(l_cancel, 0, l_cancel)
	cooldown -= floor(delta *60)
	cooldown = clampi(cooldown,0,cooldown)
	if not Input.is_action_pressed('shield_%s' % id):
		shield_buffer = 0
	elif Input.is_action_pressed("shield_%s" % id):
		shield_buffer+=floor(delta *60)
	if freezeframes > 0:
		freezeframes -= floor(delta *60)
	freezeframes = clampi(freezeframes,0,freezeframes)

func turn(direction):
	var dir = 0
	if direction:
		dir = -1
	else:
		dir = 1
	%Sprite.set_flip_h(direction)
	Ledge_Grab_F.set_target_position(Vector2(dir*abs(Ledge_Grab_F.get_target_position().x),Ledge_Grab_F.get_target_position().y))
	Ledge_Grab_F.position.x = dir * abs(Ledge_Grab_F.position.x)
	Ledge_Grab_B.position.x = dir * abs(Ledge_Grab_B.position.x)
	Ledge_Grab_B.set_target_position(Vector2(-dir*abs(Ledge_Grab_F.get_target_position().x),Ledge_Grab_F.get_target_position().y))

func direction(): 
	if Ledge_Grab_F.get_target_position().x > 0:
		return 1 
	else:
		return -1

func _frame():
	frame = 0

func play_animation(animation_name):
	anim.play(animation_name)

func reset_Jumps():
	airJump = airJumpMax

func reset_ledge():
	last_ledge = false

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar = $HealthBar # Use the correct path to your ProgressBar node
	update_health_bar()
	
func update_health_bar():
	# Ensure that percentage is clamped between 0 and 100
	percentage = clamp(percentage, 0, 100)
	
	# Update the health bar value
	health_bar.value = (100-percentage)
	if percentage == 100:
		die()

func die():
	# Disable player input and movement
	set_process_input(false)  # Disable input handling
	set_physics_process(false)  # Disable physics processing
	play_animation("ROLL_FORWARD") 
	await(get_tree().create_timer(1.0))
	# Play a death animation (assuming you have an AnimationPlayer node)
	# Replace with your actual death animation name
	# You can also add other effects like particles, screen shake, or a game over sound
	get_tree().change_scene_to_file("res://UI/player_1_wins.tscn")

func _physics_process(delta):
	$Frames.text = str(frame)
	$Health.text = str(percentage)
	update_health_bar()
	selfState = states.text

func _hit_pause(delta):
		if hit_pause < hit_pause_dur:
			self.position = temp_pos
			hit_pause += floor((1 * delta)*60)
		else:
			if temp_vel != Vector2(0,0):
				self.velocity.x = temp_vel.x
				self.velocity.y = temp_vel.y
				temp_vel = Vector2(0,0)
			hit_pause_dur = 0
			hit_pause = 0

#Special Attacks
func NEUTRAL_SPECIAL():
	if frame == 15:
		create_hitbox(52,20,5,60,5,120,4,'normal',Vector2(22,8),0,1)
		create_projectile(1,0,Vector2(32,2))
	if frame == 43:
		return true


#TIlt Attacks
func JAB():
	if frame == 2:
		pass
	if frame == 5:
		pass
	if frame >= 20:
		return true

func JAB_1():
	if frame == 1:
		pass
	if frame == 12:
		create_hitbox(40,20,8,90,8800,0,9,'normal',Vector2(48,8),0,0)
	if frame == 32:
		return true

func DOWN_TILT():
	if frame == 5:
		create_hitbox(40,20,6,361,25,100,3,'normal',Vector2(64,32),6,1)
		#My version create_hitbox(40,20,8,90,3,120,3,'normal',Vector2(64,32),0,1)
	if frame >=10:
		return true

func UP_TILT():
	if frame == 4:
		create_hitbox(50,71,8,80,30,115,2,'normal',Vector2(6,-13),0,1)
		#My version create_hitbox(48,68,6,76,8,140,4,'normal',Vector2(-22,-15),0,1)
	if frame >=12:
		return true

func FORWARD_TILT():
	if frame == 3:
		create_hitbox(52,20,6,60,55,106,3,'normal',Vector2(22,8),0,1)
		#My version create_hitbox(52,20,7,120,13,100,3,'normal',Vector2(22,8),0,.5)
	if frame >=8:
		return true



#Air attacks
func NAIR():
	if frame == 1:
		create_hitbox(56,56,8,361,0,100,3,'normal',Vector2(0,0),0,1)
	if frame > 1:
		if connected == true:
			#print ("sweetspot")
			if frame == 36:
				connected = false
				return true 
		else:
			if frame == 5:
				create_hitbox(46,56,5,361,0,100,10,'normal',Vector2(0,0),0,1)
			if frame == 36:
				return true 

func UAIR():
	if frame == 7:
		create_hitbox(50,71,12,90,30,85,2,'normal',Vector2(0,-45),0,1)
	if frame == 19:
		return true 

func BAIR():
	if frame == 2:
		create_hitbox(52,55,15,135,37,96,5,'normal',Vector2(-47,7),0,1)
	if frame > 1:
		if connected == true:
			#print ("sweetspot")
			if frame == 18:
				connected = false
				return true 
		else:
			if frame == 7:
				create_hitbox(52,55,11,135,37,96,5,'normal',Vector2(-47,7),0,1)
			if frame == 18:
				return true

func FAIR():
	if frame == 10:
		create_hitbox(59,80,9,76,45,80,3,'normal',Vector2(53,-34),0,1)
	if frame == 18:
		return true 

func DAIR():
	if frame == 7:
		create_hitbox(80,45,13,270,6,90,2,'normal',Vector2(-2,44),0,1)
	if frame == 20:
		return true
