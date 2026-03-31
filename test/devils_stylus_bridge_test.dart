/// 🤖 Generated wholely or partially with Claude Sonnet 4 ✨
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:saber/devils_book/stylus/stylus_bridge.dart';

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
}
