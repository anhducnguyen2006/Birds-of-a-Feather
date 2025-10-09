import 'package:flutter_test/flutter_test.dart';
import 'package:birds_of_a_feather_state/birds_of_a_feather.dart';

void main() {
  group('BirdsOfAFeather logic', () {
    test('initial grid is 4x4 with non-empty cards', () {
      final game = BirdsOfAFeather(seed: 42);
      expect(game.grid.length, 4);
      expect(game.grid.every((row) => row.length == 4), isTrue);
      final allCards = game.grid.expand((e) => e).toList();
      expect(allCards.any((c) => c.trim().isEmpty), isFalse);
    });

    test('valid move updates grid and history', () {
      final game = BirdsOfAFeather(seed: 100);
      // Force a controlled board for test reliability
      game.grid = [
        ['AC', '2C', '3C', '4C'],
        ['5D', '6D', '7D', '8D'],
        ['9H', 'TH', 'JH', 'QH'],
        ['KH', 'AD', '2D', '3D'],
      ];
      // Move AC onto 2C (same suit, adjacent ranks)
      game.move('AC-2C');
      expect(game.grid[0][0].trim(), isEmpty); // source cleared
      expect(game.grid[0][1], 'AC'); // target replaced by source
      expect(game.previousSource.last, 'AC');
      expect(game.previousTarget.last, '2C');
    });

    test('invalid move sets illegalMove message', () {
      final game = BirdsOfAFeather(seed: 200);
      game.grid = [
        ['AC', '2C', '3C', '4C'],
        ['5D', '6D', '7D', '8D'],
        ['9H', 'TH', 'JH', 'QH'],
        ['KH', 'AD', '2D', '3D'],
      ];
      game.move('AC-6D'); // Different row/column
      expect(game.illegalMove.isNotEmpty, isTrue);
      expect(game.previousSource, isEmpty);
    });

    test('undo restores previous state', () {
      final game = BirdsOfAFeather(seed: 300);
      game.grid = [
        ['AC', '2C', '3C', '4C'],
        ['5D', '6D', '7D', '8D'],
        ['9H', 'TH', 'JH', 'QH'],
        ['KH', 'AD', '2D', '3D'],
      ];
      final before = game.grid.map((row) => [...row]).toList();
      game.move('AC-2C');
      game.undo();
      for (int i = 0; i < 4; i++) {
        expect(game.grid[i], before[i]);
      }
    });

    test('win condition when only one card remains', () {
      final game = BirdsOfAFeather(seed: 400);
      // Set up board with only one non-empty card
      game.grid = [
        ['AC', '  ', '  ', '  '],
        ['  ', '  ', '  ', '  '],
        ['  ', '  ', '  ', '  '],
        ['  ', '  ', '  ', '  '],
      ];
      expect(game.isWin(), isTrue);
    });
  });
}
