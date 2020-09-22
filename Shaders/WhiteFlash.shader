shader_type canvas_item;
uniform bool white;

void fragment() {
	vec4 baseColour = texture(TEXTURE, UV);
	if (white) {
		COLOR = vec4(1.0, 1.0, 1.0, baseColour.a);
	} else {
		COLOR = baseColour;
	}
}