shader_type spatial;
render_mode unshaded;

uniform float grid_scale = 1.0;


vec2 random2D(vec2 uv){
	
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise2D(vec2 uv){
	uv *= grid_scale;
	vec2 gridIndex = floor(uv); 
	vec2 gridFract = fract(uv);
	
	vec2 blur = smoothstep(0.0, 1.0, gridFract);
	
	vec2 bl = gridIndex + vec2(0.0, 0.0);
	vec2 br = gridIndex + vec2(1.0, 0.0);
	vec2 tl = gridIndex + vec2(0.0, 1.0);
	vec2 tr = gridIndex + vec2(1.0, 1.0);
	
	vec2 gradBL = random2D(bl); 
	vec2 gradBR = random2D(br);
	vec2 gradTL = random2D(tl);
	vec2 gradTR = random2D(tr);
	
	vec2 distToPixelFromBL = gridFract - vec2(0.0, 0.0);
	vec2 distToPixelFromBR = gridFract - vec2(1.0, 0.0);
	vec2 distToPixelFromTL = gridFract - vec2(0.0, 1.0);
	vec2 distToPixelFromTR = gridFract - vec2(1.0, 1.0);
	
	float dotBL = dot(gradBL, distToPixelFromBL);
	float dotBR = dot(gradBR, distToPixelFromBR);
	float dotTL = dot(gradTL, distToPixelFromTL);
	float dotTR = dot(gradTR, distToPixelFromTR);
	
	return mix(mix(dotBL, dotBR, blur.x), mix(dotTL, dotTR, blur.x), blur.y) + 0.5;
}

void vertex(){
	COLOR.rgb = vec3(UV, 0.0);
}

void fragment() {
	
	ALBEDO = vec3(noise2D(UV));
}
