/// 🤖 Generated wholely or partially with Claude Sonnet 4.5 ✨
///
/// iOS plugin that bridges Apple Pencil advanced interactions
/// (double-tap, squeeze, barrel roll) to Flutter via an EventChannel.
///
/// - Double-tap: available on Apple Pencil 2nd gen + Pro (iOS 12.1+)
/// - Squeeze: available on Apple Pencil Pro (iOS 17.5+)
/// - Barrel roll: available on Apple Pencil Pro (iOS 16.0+)

import Flutter
import UIKit

/// Forwards Apple Pencil interaction events to Flutter via the
/// `saber/pencil_interaction` EventChannel.
@objc class SaberPencilPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  static let channelName = "saber/pencil_interaction"

  private var eventSink: FlutterEventSink?
  private var pencilInteraction: UIPencilInteraction?
  private var rollRecognizer: SaberBarrelRollGestureRecognizer?

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterEventChannel(
      name: channelName,
      binaryMessenger: registrar.messenger()
    )
    let instance = SaberPencilPlugin()
    channel.setStreamHandler(instance)
    registrar.publish(instance)
  }

  // MARK: - FlutterStreamHandler

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    attachToPencilInteraction()
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    detachFromPencilInteraction()
    return nil
  }

  // MARK: - Setup

  private func attachToPencilInteraction() {
    guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }

    // Double-tap (Apple Pencil 2nd gen +, iOS 12.1+)
    if #available(iOS 12.1, *) {
      let interaction = UIPencilInteraction()
      interaction.delegate = self
      rootVC.view.addInteraction(interaction)
      pencilInteraction = interaction
    }

    // Barrel roll: read UITouch.rollAngle without consuming touches (iOS 16+)
    if #available(iOS 16.0, *) {
      let recognizer = SaberBarrelRollGestureRecognizer(onRollChanged: { [weak self] angle in
        self?.eventSink?(["type": "barrelRoll", "angle": angle])
      })
      rootVC.view.addGestureRecognizer(recognizer)
      rollRecognizer = recognizer
    }
  }

  private func detachFromPencilInteraction() {
    guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }

    if let interaction = pencilInteraction {
      rootVC.view.removeInteraction(interaction)
      pencilInteraction = nil
    }

    if let recognizer = rollRecognizer {
      rootVC.view.removeGestureRecognizer(recognizer)
      rollRecognizer = nil
    }
  }
}

// MARK: - UIPencilInteractionDelegate

@available(iOS 12.1, *)
extension SaberPencilPlugin: UIPencilInteractionDelegate {
  func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
    eventSink?(["type": "doubleTap"])
  }
}

// Squeeze support (Apple Pencil Pro, iOS 17.5+)
@available(iOS 17.5, *)
extension SaberPencilPlugin {
  // Called via Objective-C runtime when available; we register this
  // through the UIPencilInteractionDelegate protocol when the OS supports it.
  @objc func pencilInteraction(
    _ interaction: UIPencilInteraction,
    didReceiveSqueeze squeeze: UIPencilInteraction.Squeeze
  ) {
    switch squeeze.phase {
    case .began:
      eventSink?(["type": "squeeze", "phase": "began"])
    case .changed:
      break // ignore intermediate updates
    case .ended:
      eventSink?(["type": "squeeze", "phase": "ended"])
    case .cancelled:
      break
    @unknown default:
      break
    }
  }
}

// MARK: - Barrel Roll Gesture Recognizer

/// A passive gesture recognizer that reads the roll angle from a stylus touch
/// without consuming the touches, so Flutter's own touch pipeline is unaffected.
class SaberBarrelRollGestureRecognizer: UIGestureRecognizer {
  private let onRollChanged: (Double) -> Void

  init(onRollChanged: @escaping (Double) -> Void) {
    self.onRollChanged = onRollChanged
    super.init(target: nil, action: nil)
    cancelsTouchesInView = false
    delaysTouchesBegan = false
    delaysTouchesEnded = false
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesBegan(touches, with: event)
    reportRoll(from: touches)
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesMoved(touches, with: event)
    reportRoll(from: touches)
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesEnded(touches, with: event)
    state = .failed
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesCancelled(touches, with: event)
    state = .failed
  }

  /// Recognizer should never block other gesture recognizers.
  override func canPrevent(_ preventedGestureRecognizer: UIGestureRecognizer) -> Bool {
    return false
  }

  override func canBePrevented(by preventingGestureRecognizer: UIGestureRecognizer) -> Bool {
    return false
  }

  @available(iOS 16.0, *)
  private func reportRoll(from touches: Set<UITouch>) {
    guard let touch = touches.first, touch.type == .pencil else { return }
    onRollChanged(Double(touch.rollAngle))
  }
}
