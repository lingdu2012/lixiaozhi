extends CharacterBody2D

var speed = 80.0 # 移动速度 像素/秒
var gravity = 3000.0 # 重力加速度
var jump_force = 1000.0 # 起跳初速度（跳跃高度 ≈ jump_force² / (2 * gravity) ≈ 135 像素）

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# 前进(右)/后退(左)
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	# 重力下落（仅在空中时累加）
	if not is_on_floor():
		velocity.y += gravity * delta
	# 跳跃（仅在落地时）
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = -jump_force
	# 按速度移动并处理与地面的碰撞
	move_and_slide()
	# 限制在画面左右两侧内
	_clamp_to_screen()
	# 播放动画：素材朝右，向左移动时水平翻转
	if direction != 0:
		sprite.play("right")
		sprite.flip_h = direction < 0


# 把角色限制在当前画面的左右边界内（保证整个人都在画面里）
func _clamp_to_screen() -> void:
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return
	# 角色和画面各自的一半宽度（角色取当前帧贴图尺寸 × 实际缩放）
	var frame_texture: Texture2D = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	var half_body: float = frame_texture.get_size().x * global_scale.x * 0.5
	var half_view: float = get_viewport().get_visible_rect().size.x * 0.5
	position.x = clampf(position.x, camera.global_position.x - half_view + half_body, camera.global_position.x + half_view - half_body)
