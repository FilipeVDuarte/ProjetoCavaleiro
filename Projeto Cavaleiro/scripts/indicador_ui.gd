extends Node2D

# Declaração da variável sprite que será atribuída ao nó "Arrow" quando o script for inicializado
@onready var sprite = $Arrow

# Declaração da variável para a posição alvo, inicialmente nula
var target_position = null

# Margem que será usada para afastar o marcador dos limites da tela
@export var margin = 60.0

# Função chamada a cada frame de física
func _physics_process(_delta):
	# Obtém a transformação atual da tela (canvas)
	var canvas = get_canvas_transform()
	
	# Calcula o canto superior esquerdo da tela em coordenadas globais
	var top_left = -canvas.origin / canvas.get_scale()
	
	# Calcula o tamanho da tela em coordenadas globais
	var size = get_viewport_rect().size / canvas.get_scale()
	
	# Ajusta o retângulo de limites adicionando a margem
	var bounds = Rect2(top_left + Vector2(margin, margin), size - Vector2(2 * margin, 2 * margin))
	
	# Define a posição do marcador dentro dos limites da tela ajustados
	set_marker_position(bounds)
	
	# Define a rotação do marcador
	set_marker_rotation()

# Função para definir a posição do marcador
func set_marker_position(bounds: Rect2):
	if target_position == null:
		# Se a posição alvo é nula, limita a posição global do sprite dentro dos limites da tela ajustados
		sprite.global_position.x = clamp(global_position.x, bounds.position.x, bounds.end.x)
		sprite.global_position.y = clamp(global_position.y, bounds.position.y, bounds.end.y)
	else:
		# Calcula o deslocamento entre a posição global e a posição alvo
		var displacement = global_position - target_position
		
		# Calcula os ângulos dos cantos do retângulo em relação à posição alvo
		var tl = (bounds.position - target_position).angle()
		var tr = (Vector2(bounds.end.x, bounds.position.y) - target_position).angle()
		var bl = (Vector2(bounds.position.x, bounds.position.y) - target_position).angle()
		var br = (bounds.end - target_position).angle()
		
		# Verifica em qual quadrante o deslocamento está e calcula a nova posição do marcador
		if (displacement.angle() > tl && displacement.angle() < tr) \
				|| (displacement.angle() < bl && displacement.angle() > br):
			# Calcula o comprimento na direção y
			var y_length = clamp(displacement.y, bounds.position.y - target_position.y, \
					bounds.end.y - target_position.y)
			var angle = displacement.angle() - PI / 2.0
			var length = y_length / cos(angle) if cos(angle) != 0 else y_length
		else:
			# Calcula o comprimento na direção x
			var x_length = clamp(displacement.y, bounds.position.y - target_position.y, \
					bounds.end.y - target_position.y)
			var angle = displacement.angle()
			var length = x_length / cos(angle) if cos(angle) != 0 else x_length
		
	# Verifica se a posição global está dentro dos limites e esconde/mostra o marcador conforme necessário
	if bounds.has_point(global_position):
		hide()
	else:
		show()

# Função para definir a rotação do marcador
func set_marker_rotation():
	# Calcula o ângulo entre a posição global do nó e a posição do sprite
	var angle = (global_position - sprite.global_position).angle()
	
	# Define a rotação global do sprite para o ângulo calculado
	sprite.global_rotation = angle
