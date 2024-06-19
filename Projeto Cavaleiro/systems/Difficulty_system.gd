extends Node

@export var mob_spawner: MobSpawner
@export var initial_spawn_rate: float = 60.0
@export var spawn_rate_per_minute: float = 30
@export var wave_duraction: float = 20.0
@export var break_intensity: float = 0.5

var time: float = 0.0

func _process(delta: float) -> void:
	#Ignorar Game Over
	if GameManager.is_game_over: return
	
	#Temporizador
	time += delta
	
	#Dificuldade Linear (Linha 1)
	var spawn_rate = initial_spawn_rate + spawn_rate_per_minute * (time / 60.0)
	
	#Sistema de Ondas (Linha 2)
		# Sin é uma função matemática que vai retornar uma onda senoidal
	var sin_wave = sin((time * TAU) / wave_duraction)
	var wave_factor = remap(sin_wave, -1.0, 1.0, break_intensity, 1)
	spawn_rate *= wave_factor
	
	#Aplica Dificuldade
	mob_spawner.mob_per_minute = spawn_rate
	
	
