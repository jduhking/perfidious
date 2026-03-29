shader_type canvas_item;
render_mode blend_mix;

uniform bool Enabled = false;
uniform vec4 effect_color: source_color;
uniform float tint_strength = 0.5; // Strength of the tint (0 = no tint, 1 = full tint)

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 tinted_color = mix(previous_color, vec4(effect_color.rgb, previous_color.a), tint_strength);
	vec4 new_color = previous_color;
	if (Enabled == true) {
		new_color = tinted_color;
	}
	COLOR = new_color * COLOR.a;
}
