/// 🤖 Generated wholely or partially with Claude Sonnet 4; GitHub Copilot
library;

import 'package:flutter/material.dart';
import 'package:saber/devils_book/zoom_window/zoom_window_controller.dart';

class ZoomWindowTarget extends StatelessWidget {
  final ZoomWindowController controller;

  const ZoomWindowTarget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (!controller.isVisible) return const SizedBox.shrink();

        return Positioned(
          left: controller.targetRect.left,
          top: controller.targetRect.top,
          width: controller.targetRect.width,
          height: controller.targetRect.height,
          child: IgnorePointer(
            ignoring: true, // Let strokes pass through to canvas
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.1),
                border: Border.all(color: Colors.blueAccent, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: IgnorePointer(
                  ignoring: false, // Reactivate pointer just for the handle
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      controller.updateTargetPosition(details.delta);
                    },
                    child: const MouseRegion(
                      cursor: SystemMouseCursors.move,
                      child: Icon(Icons.open_with, color: Colors.blueAccent, size: 28),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
