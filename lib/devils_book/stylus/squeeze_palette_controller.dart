/// 🤖 Generated wholely or partially with Claude Sonnet 4; GitHub Copilot
library;

import 'package:flutter/material.dart';

class SqueezePaletteController extends ChangeNotifier {
  var isVisible = false;
  var position = Offset.zero;

  void showAt(Offset newPosition) {
    position = newPosition;
    isVisible = true;
    notifyListeners();
  }

  void hide() {
    if (isVisible) {
      isVisible = false;
      notifyListeners();
    }
  }

  static var isDevTriggerActive = false;

  void toggleDevTrigger(Size screenSize) {
    if (isVisible) {
      hide();
      isDevTriggerActive = false;
    } else {
      showAt(Offset(screenSize.width / 2, screenSize.height / 2));
      isDevTriggerActive = true;
    }
  }
}
