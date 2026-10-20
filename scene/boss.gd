extends CharacterBody2D

@onready var body_shape: CollisionShape2D = $CollisionShape2D


# Called every frame. 让 Boss 始终贴着画面右侧边缘
func _process(_delta: float) -> void:
	_keep_at_right_edge()


# 把 Boss 贴在当前画面的右边缘（按碰撞体尺寸算实际体型，保证整个人都在画面里）
func _keep_at_right_edge() -> void:
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return
	var shape := body_shape.shape as RectangleShape2D
	# 从节点原点到身体右边缘的距离 = 碰撞体中心偏移 + 一半宽度，再乘上场景缩放
	var half_body: float = (body_shape.position.x + shape.size.x * 0.5) * global_scale.x
	var half_view: float = get_viewport().get_visible_rect().size.x * 0.5
	position.x = camera.global_position.x + half_view - half_body-20
