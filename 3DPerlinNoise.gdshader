shader_type spatial;
render_mode unshaded;

uniform float noise_scale = 1.0;
uniform vec3 noise_transform;


vec3 random3D(vec3 uvw){
	
    uvw = vec3( dot(uvw, vec3(127.1,311.7, 513.7) ),
               dot(uvw, vec3(269.5,183.3, 396.5) ),
			   dot(uvw, vec3(421.3,314.1, 119.7) ) );
			
    return -1.0 + 2.0 * fract(sin(uvw) * 43758.5453123);
}

float noise3D(vec3 uvw){
	uvw *= noise_scale;
	uvw += noise_transform;
	
	vec3 gridIndex = floor(uvw); 
	vec3 gridFract = fract(uvw);
	
	vec3 blur = smoothstep(0.0, 1.0, gridFract);
	
	vec3 blb = gridIndex + vec3(0.0, 0.0, 0.0);
	vec3 brb = gridIndex + vec3(1.0, 0.0, 0.0);
	vec3 tlb = gridIndex + vec3(0.0, 1.0, 0.0);
	vec3 trb = gridIndex + vec3(1.0, 1.0, 0.0);
	vec3 blf = gridIndex + vec3(0.0, 0.0, 1.0);
	vec3 brf = gridIndex + vec3(1.0, 0.0, 1.0);
	vec3 tlf = gridIndex + vec3(0.0, 1.0, 1.0);
	vec3 trf = gridIndex + vec3(1.0, 1.0, 1.0);
	
	vec3 gradBLB = random3D(blb); 
	vec3 gradBRB = random3D(brb);
	vec3 gradTLB = random3D(tlb);
	vec3 gradTRB = random3D(trb);
	vec3 gradBLF = random3D(blf);
	vec3 gradBRF = random3D(brf);
	vec3 gradTLF = random3D(tlf);
	vec3 gradTRF = random3D(trf);
	
	
	vec3 distToPixelFromBLB = gridFract - vec3(0.0, 0.0, 0.0);
	vec3 distToPixelFromBRB = gridFract - vec3(1.0, 0.0, 0.0);
	vec3 distToPixelFromTLB = gridFract - vec3(0.0, 1.0, 0.0);
	vec3 distToPixelFromTRB = gridFract - vec3(1.0, 1.0, 0.0);
	vec3 distToPixelFromBLF = gridFract - vec3(0.0, 0.0, 1.0);
	vec3 distToPixelFromBRF = gridFract - vec3(1.0, 0.0, 1.0);
	vec3 distToPixelFromTLF = gridFract - vec3(0.0, 1.0, 1.0);
	vec3 distToPixelFromTRF = gridFract - vec3(1.0, 1.0, 1.0);
	
	float dotBLB = dot(gradBLB, distToPixelFromBLB);
	float dotBRB = dot(gradBRB, distToPixelFromBRB);
	float dotTLB = dot(gradTLB, distToPixelFromTLB);
	float dotTRB = dot(gradTRB, distToPixelFromTRB);
	float dotBLF = dot(gradBLF, distToPixelFromBLF);
	float dotBRF = dot(gradBRF, distToPixelFromBRF);
	float dotTLF = dot(gradTLF, distToPixelFromTLF);
	float dotTRF = dot(gradTRF, distToPixelFromTRF);
	
	
	return mix(
		mix(
			mix(dotBLB, dotBRB, blur.x),
			mix(dotTLB, dotTRB, blur.x), blur.y
		),
		mix(
			mix(dotBLF, dotBRF, blur.x),
			mix(dotTLF, dotTRF, blur.x), blur.y
		), blur.z
	) + 0.5;
}

void vertex(){
	COLOR.rgb = VERTEX + 0.5;
}

void fragment() {
	vec3 uvw = COLOR.rgb;

	ALBEDO = vec3(noise3D(uvw));
}
