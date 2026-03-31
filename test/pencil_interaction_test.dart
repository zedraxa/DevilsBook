/// 🤖 Generated wholly or partially with Claude Sonnet 4 ✨
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:saber/data/tools/pencil_interaction.dart';

void main() {
  group('PencilInteractionService.parseEvent', () {
    test('returns null for non-Map input', () {
      expect(PencilInteractionService.parseEvent(null), isNull);
      expect(PencilInteractionService.parseEvent('string'), isNull);
      expect(PencilInteractionService.parseEvent(42), isNull);
      expect(PencilInteractionService.parseEvent([1, 2]), isNull);
    });

    test('returns null for unknown type', () {
      expect(PencilInteractionService.parseEvent({'type': 'unknown'}), isNull);
    });

    test('returns null for missing type key', () {
      expect(PencilInteractionService.parseEvent(<String, dynamic>{}), isNull);
    });

    test('parses doubleTap event', () {
      final event =
          PencilInteractionService.parseEvent({'type': 'doubleTap'});
      expect(event, isNotNull);
      expect(event!.type, PencilInteractionEventType.doubleTap);
      expect(event.barrelRollAngle, isNull);
    });

    test('parses squeeze began event', () {
      final event = PencilInteractionService.parseEvent(
        {'type': 'squeeze', 'phase': 'began'},
      );
      expect(event, isNotNull);
      expect(event!.type, PencilInteractionEventType.squeezeBegin);
    });

    test('parses squeeze ended event', () {
      final event = PencilInteractionService.parseEvent(
        {'type': 'squeeze', 'phase': 'ended'},
      );
      expect(event, isNotNull);
      expect(event!.type, PencilInteractionEventType.squeezeEnd);
    });

    test('returns null for squeeze with unknown phase', () {
      expect(
        PencilInteractionService.parseEvent(
          {'type': 'squeeze', 'phase': 'changed'},
        ),
        isNull,
      );
    });

    test('returns null for squeeze with missing phase', () {
      expect(
        PencilInteractionService.parseEvent({'type': 'squeeze'}),
        isNull,
      );
    });

    test('parses barrelRoll event with angle', () {
      final event = PencilInteractionService.parseEvent(
        {'type': 'barrelRoll', 'angle': 1.5},
      );
      expect(event, isNotNull);
      expect(event!.type, PencilInteractionEventType.barrelRoll);
      expect(event.barrelRollAngle, 1.5);
    });

    test('parses barrelRoll event with integer angle', () {
      final event = PencilInteractionService.parseEvent(
        {'type': 'barrelRoll', 'angle': 2},
      );
      expect(event, isNotNull);
      expect(event!.type, PencilInteractionEventType.barrelRoll);
      expect(event.barrelRollAngle, 2.0);
    });

    test('parses barrelRoll event with null angle', () {
      final event = PencilInteractionService.parseEvent(
        {'type': 'barrelRoll', 'angle': null},
      );
      expect(event, isNotNull);
      expect(event!.type, PencilInteractionEventType.barrelRoll);
      expect(event.barrelRollAngle, isNull);
    });

    test('parses barrelRoll event with missing angle key', () {
      final event =
          PencilInteractionService.parseEvent({'type': 'barrelRoll'});
      expect(event, isNotNull);
      expect(event!.type, PencilInteractionEventType.barrelRoll);
      expect(event.barrelRollAngle, isNull);
    });

    test('parses barrelRoll with negative angle', () {
      final event = PencilInteractionService.parseEvent(
        {'type': 'barrelRoll', 'angle': -3.14},
      );
      expect(event, isNotNull);
      expect(event!.barrelRollAngle, closeTo(-3.14, 0.001));
    });
  });
}
