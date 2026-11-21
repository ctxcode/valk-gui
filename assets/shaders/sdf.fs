#version 330
in vec2 fragPos;
in vec2 fragTexCoord;
in vec4 fragColor;
// Boxes: x, y, width, height. Lines: the two end points.
uniform vec4 rect;
// Corner radii: top left, top right, bottom right, bottom left
uniform vec4 radii;
uniform float border;
uniform float blur;
// 0 box, 1 shadow, 2 line, 3 image, 4 arc
uniform int mode;
uniform vec4 fill;
uniform vec4 fill2;
uniform int gradient;
// Radians, as CSS: 0 upwards, clockwise
uniform float angle;
uniform vec4 stroke;
uniform sampler2D texture0;
out vec4 finalColor;

float box(vec2 p, vec2 half_size, vec4 r) {
    float c = p.x > 0.0 ? (p.y > 0.0 ? r.z : r.y) : (p.y > 0.0 ? r.w : r.x);
    vec2 q = abs(p) - half_size + c;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - c;
}

float erf(float x) {
    float s = sign(x);
    float a = abs(x);
    x = 1.0 + (0.278393 + (0.230389 + 0.078108 * (a * a)) * a) * a;
    x *= x;
    return s - s / (x * x);
}

vec4 premultiply(vec4 c) {
    return vec4(c.rgb * c.a, c.a);
}

void main() {
    if (mode == 2) {
        vec2 pa = fragPos - rect.xy;
        vec2 ba = rect.zw - rect.xy;
        float h = clamp(dot(pa, ba) / max(dot(ba, ba), 0.0001), 0.0, 1.0);
        float d = length(pa - ba * h) - border * 0.5;
        float aa = max(fwidth(d), 0.0001);
        finalColor = vec4(fill.rgb, fill.a * clamp(0.5 - d / aa, 0.0, 1.0));
        return;
    }
    if (mode == 4) {
        // rect: (cx, cy, radius, 0), radii: (cos(mid), sin(mid), cos(half_span), sin(half_span))
        vec2 p = fragPos - rect.xy;
        vec2 q = vec2(p.x * radii.x + p.y * radii.y, abs(-p.x * radii.y + p.y * radii.x));
        vec2 sc = radii.zw;
        float r = rect.z;
        float d = (q.x * sc.y > q.y * sc.x) ? abs(length(q) - r) : length(q - sc * r);
        d -= border * 0.5;
        float aa = max(fwidth(d), 0.0001);
        finalColor = vec4(fill.rgb, fill.a * clamp(0.5 - d / aa, 0.0, 1.0));
        return;
    }
    vec2 half_size = rect.zw * 0.5;
    vec2 p = fragPos - rect.xy - half_size;
    float d = box(p, half_size, radii);
    if (mode == 1) {
        float sigma = max(blur * 0.5, 0.0001);
        float a = 0.5 - 0.5 * erf(d / (sigma * 1.41421356));
        finalColor = vec4(fill.rgb, fill.a * a);
        return;
    }
    float aa = max(fwidth(d), 0.0001);
    float outer = clamp(0.5 - d / aa, 0.0, 1.0);
    if (mode == 3) {
        vec4 t = texture(texture0, fragTexCoord) * fragColor;
        finalColor = vec4(t.rgb, t.a * outer);
        return;
    }
    vec4 c = premultiply(fill);
    if (gradient == 1) {
        vec2 dir = vec2(sin(angle), -cos(angle));
        float extent = abs(half_size.x * dir.x) + abs(half_size.y * dir.y);
        float t = clamp(dot(p, dir) / max(extent, 0.0001) * 0.5 + 0.5, 0.0, 1.0);
        c = mix(premultiply(fill), premultiply(fill2), t);
    }
    if (border > 0.0) {
        float inner = clamp(0.5 - (d + border) / aa, 0.0, 1.0);
        c = mix(premultiply(stroke), c, inner);
    }
    c *= outer;
    finalColor = c.a > 0.0 ? vec4(c.rgb / c.a, c.a) : vec4(0.0);
}
