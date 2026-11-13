#version 330
in vec2 fragPos;
uniform vec4 rect;
uniform float radius;
uniform float border;
uniform float blur;
uniform int mode;
uniform vec4 fill;
uniform vec4 stroke;
out vec4 finalColor;

float box(vec2 p, vec2 half_size, float r) {
    vec2 q = abs(p) - half_size + r;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r;
}

float erf(float x) {
    float s = sign(x);
    float a = abs(x);
    x = 1.0 + (0.278393 + (0.230389 + 0.078108 * (a * a)) * a) * a;
    x *= x;
    return s - s / (x * x);
}

void main() {
    if (mode == 2) {
        // A line from rect.xy to rect.zw, `border` wide
        vec2 pa = fragPos - rect.xy;
        vec2 ba = rect.zw - rect.xy;
        float h = clamp(dot(pa, ba) / max(dot(ba, ba), 0.0001), 0.0, 1.0);
        float d = length(pa - ba * h) - border * 0.5;
        float aa = max(fwidth(d), 0.0001);
        finalColor = vec4(fill.rgb, fill.a * clamp(0.5 - d / aa, 0.0, 1.0));
        return;
    }
    vec2 half_size = rect.zw * 0.5;
    vec2 p = fragPos - rect.xy - half_size;
    float r = min(radius, min(half_size.x, half_size.y));
    float d = box(p, half_size, r);
    if (mode == 1) {
        // A shadow: the box blurred by a gaussian with sigma blur / 2
        float sigma = max(blur * 0.5, 0.0001);
        float a = 0.5 - 0.5 * erf(d / (sigma * 1.41421356));
        finalColor = vec4(fill.rgb, fill.a * a);
        return;
    }
    float aa = max(fwidth(d), 0.0001);
    float outer = clamp(0.5 - d / aa, 0.0, 1.0);
    vec4 c = vec4(fill.rgb * fill.a, fill.a);
    if (border > 0.0) {
        float inner = clamp(0.5 - (d + border) / aa, 0.0, 1.0);
        c = mix(vec4(stroke.rgb * stroke.a, stroke.a), c, inner);
    }
    c *= outer;
    finalColor = c.a > 0.0 ? vec4(c.rgb / c.a, c.a) : vec4(0.0);
}
