/// 🤖 Generated wholly or partially with Claude Sonnet 4.5; crayon shader loader
library;

import 'dart:ui';

/// Loads and creates instances of the crayon GLSL fragment shader.
abstract class CrayonShader {
  static late final FragmentProgram _program;

  static Future<void> init() async {
    _program = await FragmentProgram.fromAsset('shaders/crayon.frag');
  }

  static FragmentShader create() {
    return _program.fragmentShader();
  }
}
