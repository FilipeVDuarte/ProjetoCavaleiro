class_name Player
extends CharacterBody2D

@export_category("Moviment")
@export var speed: float = 300.0

@export_category("Dano")
@export var damage: int = 2

@export_category("Ritual")
@export var ritual_damage: int = 0
@export var ritual_interval: float = 15
@export var ritual_scene: PackedScene

@export_category("Health")
@export var health: int = 100
@export var max_health: int = 100
@export var death_prefab: PackedScene

@export_category("Itens")
@export var item_cc:int = 0
@export var item_qc:int = 0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_area: Area2D = $Attack_Area
@onready var slash: Sprite2D = $Slash
@onready var hitbox_area: Area2D = $HitboxArea
@onready var health_progress_bar: ProgressBar = $HealthProgressBar

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var ritual_cooldown: float = 0.0

signal meat_collected(value: int)
signal mark_collected(value: int)
signal coin_collected(value: int)
signal damaged_amount(value: int)
signal quest_collected(value: int)

func _ready():
	GameManager.player = self
	meat_collected.connect(func(value: int): GameManager.vida_counter += 1)
	coin_collected.connect(func(value: int): GameManager.coin_counter += 1)
	quest_collected.connect(func(value: int): GameManager.quest_counter += 1)

func _process(delta: float) -> void:
	GameManager.player_position = position
	
	# Ler inputs
	read_input()
	
	#Processar ataque
	update_attack_cooldown(delta)
	if Input.is_action_just_pressed("shoot"):
		attack()
		
	# Processar animação de andar e parado
	play_animation()
	if not is_attacking:
		rotate_sprite()
		
	#Processar dano
	update_hitbox_detection(delta)
	
	#Ritual
	update_ritual(delta)
	
	#Atualizar Barra de Vida
	health_progress_bar.max_value = max_health
	health_progress_bar.value = health

func _physics_process(_delta: float) -> void: # Se mexe com física colocar aqui
	# Modificar a velocidade
	var target_velocity = input_vector * speed  # Multiplicando pelo speed
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()  # Passando o velocity como argumento e o vetor de direção

func update_attack_cooldown(delta: float) -> void:
	# Atualizar temporizador do ataque
	if is_attacking:
		attack_cooldown -= delta 
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			slash.visible = false
			animation_player.play("idle")
		else: 
			is_attacking = true

func update_ritual(delta: float) -> void:
	#Atualizar temporizador
	ritual_cooldown -= delta
	if ritual_cooldown > 0: return
	#Resetar Temporizador
	ritual_cooldown = ritual_interval
	
	#Criar Ritual || instanciou e colou no player
	var ritual = ritual_scene.instantiate()
	ritual_damage = ritual.damage_amount
	add_child(ritual)

func read_input() -> void:
	# Obter o input vector
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	#Apagar deadzone do input vector
	var _deadzone = 0.15
	if abs(input_vector.x) < 0.15:
		input_vector.x = 0.0
	if abs(input_vector.y) < 0.15:
		input_vector.y = 0.0
	
	# Atualizar o is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func play_animation() -> void:
		# Tocar animação
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("walk")
			else:
				animation_player.play("idle")

func rotate_sprite() -> void:
# Girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
		slash.flip_h = false
		#Desmarcar Flip.h do Sprite 2D
		pass
	elif input_vector.x < 0:
		sprite.flip_h = true
		slash.flip_h = true
		#Marcar Flip.hh  do Sprite 2D
		pass

func attack() -> void:
	if is_attacking:
		return
	
	if is_running:
		animation_player.play("walk_escudo")
	else:
		animation_player.play("idle_escudo")
		
	attack_cooldown = 0.6
	
	is_attacking =  true

func deal_damage_to_enemies() -> void:
	var bodies = attack_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
				
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= 0.3:
				enemy.damage(damage) 
			print("Dot: ", dot_product)

func update_hitbox_detection(delta: float) -> void:
	#Temporizador
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	
	#Frequência (2x por segundo)
	hitbox_cooldown = 0.5
	
	#Detectar inimigos
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var _enemy: Enemy = body
			var damage_amount = 1
			damage_to_player(damage_amount)

func damage_to_player(amount: int) -> void:
	if health <= 0: return
	health -= amount
	print("PLayer recebeu dano ", amount, ", Vida: ", health, "/", max_health )
	
	#Animação de tomar dano
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	if health <= 0:
		die()

func die() -> void:
	GameManager.end_game()
	
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	print("Player morreu")
	queue_free()

func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	print("Player recebeu cura de ", amount, ". A vida total é de ", health, "/", max_health)
	return health

func coin_collect(coin_amount:int) -> void:
	item_cc += coin_amount
	print("jogador achou ", coin_amount, " total de ", item_cc)

func quest_collect(quest_amount: int) -> void:
	item_cc += quest_amount
	#quest_collected.connect(func(value: int): GameManager.quest_counter += 1)
	#print(GameManager.quest_counter)
