/// Returns a crayon stroke texture,
/// by applying a coarser, more irregular noise function to each pixel.
/// The result looks like a wax crayon drawn on paper.

#version 460 core

#include <flutter/runtime_effect.glsl>

/// Crayon color, represented as a vec3 of RGB values between 0 and 1.
uniform vec3 uColor;

/// Output color at a given pixel.
/// Represented as a vec4 of RGBA values between 0 and 1.
out vec4 fragColor;



// <!-- START NOISE FUNCTIONS FROM https://www.shadertoy.com/view/4dS3Wd -->

// By Morgan McGuire @morgan3d, http://graphicscodex.com
// Reuse permitted under the BSD license.

float hash(float p) { p = fract(p * 0.011); p *= p + 7.5; p *= p + p; return fract(p); }
float hash(vec2 p) {vec3 p3 = fract(vec3(p.xyx) * 0.13); p3 += dot(p3, p3.yzx + 3.333); return fract((p3.x + p3.y) * p3.z); }

float noise(float x) {
    float i = floor(x);
    float f = fract(x);
    float u = f * f * (3.0 - 2.0 * f);
    return mix(hash(i), hash(i + 1.0), u);
}

float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

#define NUM_OCTAVES 4

float fbm(vec2 x) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100);
    mat2 rot = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.50));
    for (int i = 0; i < NUM_OCTAVES; ++i) {
        v += a * noise(x);
        x = rot * x * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

// <!-- END NOISE FUNCTIONS FROM https://www.shadertoy.com/view/4dS3Wd -->


void main() {
    vec2 fragCoord = FlutterFragCoord().xy;

    // Low-frequency noise for coarse crayon grain
    const float coarseFreq = 0.25;
    float coarseNoise = fbm(fragCoord * coarseFreq) * 0.5 + 0.5;

    // High-frequency noise for fine paper texture
    const float fineFreq = 1.5;
    float fineNoise = fbm(fragCoord * fineFreq) * 0.5 + 0.5;

    // Combine: coarse grain dominates, fine texture adds roughness
    float combined = coarseNoise * 0.65 + fineNoise * 0.35;

    // Apply a threshold to create the broken, uneven crayon look.
    // Values below the threshold are nearly transparent (paper showing through).
    float threshold = 0.38;
    float opacity = smoothstep(threshold, threshold + 0.3, combined);

    // Maximum opacity ~0.85 to keep the hand-drawn feel
    opacity = opacity * 0.85;

    fragColor = vec4(uColor * opacity, opacity);
}
