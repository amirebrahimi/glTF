precision highp float;
varying vec3 v_normal;
varying vec2 v_texcoord0;
uniform sampler2D u_ambient;
uniform sampler2D u_diffuse;
uniform vec4 u_emission;
uniform vec4 u_specular;
uniform sampler2D u_bump;
uniform float u_shininess;
uniform vec3 u_light0Color;
varying vec3 v_light1Direction;
uniform float u_light1ConstantAttenuation;
uniform float u_light1LinearAttenuation;
uniform float u_light1QuadraticAttenuation;
uniform vec3 u_light1Color;
varying vec3 v_light2Direction;
uniform float u_light2ConstantAttenuation;
uniform float u_light2LinearAttenuation;
uniform float u_light2QuadraticAttenuation;
uniform vec3 u_light2Color;
void main(void) {
vec3 normal = normalize(v_normal);
vec4 color = vec4(0., 0., 0., 0.);
vec4 diffuse = vec4(0., 0., 0., 1.);
vec3 diffuseLight = vec3(0., 0., 0.);
vec4 emission;
vec4 ambient;
vec4 specular;
ambient = texture2D(u_ambient, v_texcoord0);
diffuse = texture2D(u_diffuse, v_texcoord0);
emission = u_emission;
specular = u_specular;
vec3 specularLight = vec3(0., 0., 0.);
vec3 ambientLight = vec3(0., 0., 0.);
{
ambientLight += u_light0Color;
}
{
float specularIntensity = 0.;
float attenuation = 1.0;
float range = length(v_light1Direction);
attenuation = 1.0 / ( u_light1ConstantAttenuation + (u_light1LinearAttenuation * range) + (u_light1QuadraticAttenuation * range * range) ) ;
vec3 l = normalize(v_light1Direction);
vec3 h = normalize(l+vec3(0.,0.,1.));
specularIntensity = max(0., pow(max(dot(normal,h), 0.) , u_shininess)) * attenuation;
specularLight += u_light1Color * specularIntensity;
diffuseLight += u_light1Color * max(dot(normal,l), 0.) * attenuation;
}
{
float specularIntensity = 0.;
float attenuation = 1.0;
float range = length(v_light2Direction);
attenuation = 1.0 / ( u_light2ConstantAttenuation + (u_light2LinearAttenuation * range) + (u_light2QuadraticAttenuation * range * range) ) ;
vec3 l = normalize(v_light2Direction);
vec3 h = normalize(l+vec3(0.,0.,1.));
specularIntensity = max(0., pow(max(dot(normal,h), 0.) , u_shininess)) * attenuation;
specularLight += u_light2Color * specularIntensity;
diffuseLight += u_light2Color * max(dot(normal,l), 0.) * attenuation;
}
ambient.xyz *= ambientLight;
color.xyz += ambient.xyz;
specular.xyz *= specularLight;
color.xyz += specular.xyz;
diffuse.xyz *= diffuseLight;
color.xyz += diffuse.xyz;
color.xyz += emission.xyz;
color = vec4(color.rgb * diffuse.a, diffuse.a);
gl_FragColor = color;
}
