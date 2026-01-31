extends WorldEnvironment

@export var color_a: Color = Color(1.0, 0.12, 0.55)      # Rosa/magenta neon Hotline Miami
@export var color_b: Color = Color(0.05, 0.75, 1.0)      # Cian neon
@export var base_speed: float = 0.35                     # Velocidad general (pulso/ondas)
@export var spiral_arms: float = 4.0                     # Número de brazos (3-6 para vibe HM)
@export var spiral_tightness: float = 8.0                # Densidad radial (más alto = más vueltas)
@export var spiral_rotation_speed: float = 0.4           # Rotación global (lenta)
@export var spiral_flow_speed: float = 1.2               # Velocidad de "flujo" a lo largo de la espiral (hacia afuera/adentro)
@export var spiral_breath_intensity: float = 0.2         # Intensidad de respiración (expansión sutil)
@export var scan_intensity: float = 0.15                 # Scanlines CRT
@export var vignette_strength: float = 0.5               # Viñeta bordes
@export var wave_intensity: float = 0.4                  # Ondas/pulso

var color_rect: ColorRect
var canvas_layer: CanvasLayer
var shader_material: ShaderMaterial

func _ready() -> void:
	if not environment:
		environment = Environment.new()
	
	# Setup probado (BG_CANVAS + layer -1 = fondo atrás)
	environment.background_mode = Environment.BG_CANVAS
	environment.background_canvas_max_layer = -1
	
	canvas_layer = get_node_or_null("HotlineBgLayer")
	if not canvas_layer:
		canvas_layer = CanvasLayer.new()
		canvas_layer.name = "HotlineBgLayer"
		canvas_layer.layer = -1
		add_child(canvas_layer, true)
	
	color_rect = canvas_layer.get_node_or_null("HotlineBgRect")
	if not color_rect:
		color_rect = ColorRect.new()
		color_rect.name = "HotlineBgRect"
		color_rect.anchor_right = 1.0
		color_rect.anchor_bottom = 1.0
		color_rect.grow_horizontal = Control.GROW_DIRECTION_BOTH
		color_rect.grow_vertical = Control.GROW_DIRECTION_BOTH
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		canvas_layer.add_child(color_rect, true)
	
	_create_spiral_shader()
	color_rect.material = shader_material
	
	environment.adjustment_enabled = true
	environment.adjustment_saturation = 1.4
	environment.adjustment_contrast = 1.15
	environment.adjustment_brightness = 1.05

func _create_spiral_shader() -> void:
	shader_material = ShaderMaterial.new()
	var shader = Shader.new()
	shader_material.shader = shader
	
	# Shader con movimiento espiral auténtico (logarítmico + flujo radial + rotación + respiración)
	var shader_code = """shader_type canvas_item;

uniform vec4 color_a : source_color;
uniform vec4 color_b : source_color;
uniform float base_speed;
uniform float spiral_arms;
uniform float spiral_tightness;
uniform float spiral_rotation_speed;
uniform float spiral_flow_speed;
uniform float spiral_breath_intensity;
uniform float scan_intensity;
uniform float vignette_strength;
uniform float wave_intensity;

void fragment() {
	vec2 uv = UV;
	vec2 center = uv * 2.0 - 1.0;
	float r = length(center) + 0.001;  // Evita div0
	float angle = atan(center.y, center.x);
	float t = TIME * base_speed;
	
	// RESPIRACIÓN SUTIL (expansión/contracción global lenta)
	float breath = sin(t * 0.3) * spiral_breath_intensity;
	r += breath * r;
	
	// ESPIRAL LOGARÍTMICA VERDADERA (forma natural, brazos que crecen exponencialmente)
	float log_r = log(r);
	float spiral_phase = angle * spiral_arms - log_r * spiral_tightness;
	
	// MOVIMIENTO ESPIRAL AUTÉNTICO:
	// - Rotación lenta (todo gira)
	// - Flujo radial (patrón "corre" a lo largo de los brazos, como vórtice)
	spiral_phase -= t * spiral_rotation_speed;                    // Rotación global
	spiral_phase -= t * spiral_flow_speed * log_r;                // Flujo a lo largo de la espiral (hacia afuera)
	
	float spiral = sin(spiral_phase) * 0.5 + 0.5;
	
	// Pulso de colores + influencia espiral (para movimiento integrado)
	float pulse = 0.5 + 0.5 * sin(t * 0.8 + spiral * 4.0 + breath);
	vec3 col = mix(color_a.rgb, color_b.rgb, pulse + spiral * wave_intensity * 0.3);
	
	// Onda vertical + toque espiral
	float grad = uv.y + sin(t * 0.5 + uv.x * 3.0 + spiral) * wave_intensity * 0.1;
	col = mix(col, mix(color_b.rgb, color_a.rgb, grad), 0.25);
	
	// Scanlines CRT
	float scan = sin(SCREEN_UV.y * 900.0 + t * 4.0) * scan_intensity;
	col -= scan * (1.0 - r * 0.6);
	
	// Viñeta
	float vig = 1.0 - r * vignette_strength;
	col *= vig;
	
	// Clamp seguro
	col = clamp(col, vec3(0.0), vec3(1.0));
	
	COLOR = vec4(col, 1.0);
}
"""
	
	shader.code = shader_code
	
	_update_shader_params()

func _update_shader_params() -> void:
	if shader_material:
		shader_material.set_shader_parameter("color_a", color_a)
		shader_material.set_shader_parameter("color_b", color_b)
		shader_material.set_shader_parameter("base_speed", base_speed)
		shader_material.set_shader_parameter("spiral_arms", spiral_arms)
		shader_material.set_shader_parameter("spiral_tightness", spiral_tightness)
		shader_material.set_shader_parameter("spiral_rotation_speed", spiral_rotation_speed)
		shader_material.set_shader_parameter("spiral_flow_speed", spiral_flow_speed)
		shader_material.set_shader_parameter("spiral_breath_intensity", spiral_breath_intensity)
		shader_material.set_shader_parameter("scan_intensity", scan_intensity)
		shader_material.set_shader_parameter("vignette_strength", vignette_strength)
		shader_material.set_shader_parameter("wave_intensity", wave_intensity)

func _process(_delta: float) -> void:
	_update_shader_params()
