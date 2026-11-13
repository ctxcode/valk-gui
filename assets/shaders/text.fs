#version 330
in vec2 fragTexCoord;
in vec4 fragColor;
uniform sampler2D texture0;
uniform vec4 colDiffuse;
out vec4 finalColor;

// Glyph coverage with steeper edges, so small text looks crisp. Dark text on a light
// background gets more, as it otherwise looks thin.
void main() {
    float a = texture(texture0, fragTexCoord).a;
    float luma = dot(fragColor.rgb, vec3(0.2126, 0.7152, 0.0722));
    float k = mix(0.8, 0.3, luma);
    a = a * (k + 1.0) / (a * k + 1.0);
    finalColor = vec4(fragColor.rgb, fragColor.a * a) * colDiffuse;
}
