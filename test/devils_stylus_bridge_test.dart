/// 🤖 Generated wholely or partially with Claude Sonnet 4 ✨
library;

import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saber/devils_book/stylus/devils_stylus_event.dart';
import 'package:saber/devils_book/stylus/stylus_bridge.dart';
import 'package:saber/devils_book/stylus/stylus_state.dart';

void main() {
  group('StylusBridge.parseEvent', () {
    test('returns null for non-Map input', () {
      expect(StylusBridge.parseEvent(null), isNull);
      expect(StylusBridge.parseEvent('string'), isNull);
      expect(StylusBridge.parseEvent(42), isNull);
      expect(StylusBridge.parseEvent([1, 2]), isNull);
    });

    test('returns null for unknown type', () {
      expect(StylusBridge.parseEvent({'type': 'unknown'}), isNull);
    });

    test('returns null for missing type key', () {
      expect(StylusBridge.parseEvent(<String, dynamic>{}), isNull);
    });

    test('parses doubleTap event', () {
      final event = StylusBridge.parseEvent({'type': 'doubleTap'});
      expect(event, isNotNull);
      expect(event!.type, PencilEventType.doubleTap);
      expect(event.barrelRollAngle, isNull);
    });

    test('parses squeeze began event', () {
      final event = StylusBridge.parseEvent(
        {'type': 'squeeze', 'phase': 'began'},
      );
      expect(event, isNotNull);
      expect(event!.type, PencilEventType.squeezeBegan);
    });

    test('parses squeeze ended event', () {
      final event = StylusBridge.parseEvent(
        {'type': 'squeeze', 'phase': 'ended'},
      );
      expect(event, isNotNull);
      expect(event!.type, PencilEventType.squeezeEnded);
    });

    test('returns null for squeeze with unknown phase', () {
      expect(
        StylusBridge.parseEvent(
          {'type': 'squeeze', 'phase': 'changed'},
        ),
        isNull,
      );
    });

    test('returns null for squeeze with missing phase', () {
      expect(
        StylusBridge.parseEvent({'type': 'squeeze'}),
        isNull,
      );
    });

    test('parses barrelRoll event with angle', () {
      final event = StylusBridge.parseEvent(
        {'type': 'barrelRoll', 'angle': 1.5},
      );
      expect(event, isNotNull);
      expect(event!.type, PencilEventType.barrelRoll);
      expect(event.barrelRollAngle, 1.5);
    });

    test('parses barrelRoll event with integer angle', () {
      final event = StylusBridge.parseEvent(
        {'type': 'barrelRoll', 'angle': 2},
      );
      expect(event, isNotNull);
      expect(event!.type, PencilEventType.barrelRoll);
      expect(event.barrelRollAngle, 2.0);
    });

    test('parses barrelRoll event with null angle', () {
      final event = StylusBridge.parseEvent(
        {'type': 'barrelRoll', 'angle': null},
      );
      expect(event, isNotNull);
      expect(event!.type, PencilEventType.barrelRoll);
      expect(event.barrelRollAngle, isNull);
    });

    test('parses barrelRoll event with missing angle key', () {
      final event = StylusBridge.parseEvent({'type': 'barrelRoll'});
      expect(event, isNotNull);
      expect(event!.type, PencilEventType.barrelRoll);
      expect(event.barrelRollAngle, isNull);
    });

    test('parses barrelRoll with negative angle', () {
      final event = StylusBridge.parseEvent(
        {'type': 'barrelRoll', 'angle': -3.14},
      );
      expect(event, isNotNull);
      expect(event!.barrelRollAngle, closeTo(-3.14, 0.001));
    });
  });

  group('StylusState native event handling', () {
    late StylusState state;

    setUp(() {
      state = StylusState();
    });

    tearDown(() {
      state.dispose();
    });

    test('barrel roll event updates latestBarrelRoll', () {
      var notified = false;
      state.addListener(() => notified = true);

      state.onNativePencilEvent(
        const PencilEvent(type: PencilEventType.barrelRoll, barrelRollAngle: 1.23),
      );

      expect(state.latestBarrelRoll, 1.23);
      expect(notified, isTrue);
    });

    test('squeeze began sets isSqueezing to true', () {
      expect(state.isSqueezing, isFalse);

      state.onNativePencilEvent(
        const PencilEvent(type: PencilEventType.squeezeBegan),
      );

      expect(state.isSqueezing, isTrue);
    });

    test('squeeze ended sets isSqueezing to false', () {
      state.onNativePencilEvent(
        const PencilEvent(type: PencilEventType.squeezeBegan),
      );
      expect(state.isSqueezing, isTrue);

      state.onNativePencilEvent(
        const PencilEvent(type: PencilEventType.squeezeEnded),
      );
      expect(state.isSqueezing, isFalse);
    });

    test('doubleTap event notifies listeners', () {
      var notifyCount = 0;
      state.addListener(() => notifyCount++);

      state.onNativePencilEvent(
        const PencilEvent(type: PencilEventType.doubleTap),
      );

      expect(notifyCount, 1);
    });

    test('updateEvent enriches with latestBarrelRoll when event has none', () {
      state.onNativePencilEvent(
        const PencilEvent(type: PencilEventType.barrelRoll, barrelRollAngle: 0.75),
      );

      final event = const DevilsStylusEvent(
        position: Offset(100, 200),
        pressure: 0.8,
        altitude: 1.2,
        azimuth: 0.5,
      );

      state.updateEvent(event);

      expect(state.currentEvent!.barrelRoll, 0.75);
      expect(state.currentEvent!.position, const Offset(100, 200));
    });

    test('updateEvent does not overwrite existing barrelRoll', () {
      state.onNativePencilEvent(
        const PencilEvent(type: PencilEventType.barrelRoll, barrelRollAngle: 0.75),
      );

      final event = const DevilsStylusEvent(
        position: Offset(100, 200),
        pressure: 0.8,
        altitude: 1.2,
        azimuth: 0.5,
        barrelRoll: 1.5,
      );

      state.updateEvent(event);

      expect(state.currentEvent!.barrelRoll, 1.5);
    });
  });
}
