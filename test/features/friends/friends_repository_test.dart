import 'package:flutter_test/flutter_test.dart';
import 'package:tomora/features/friends/data/friends_repository.dart';

void main() {
  group('FriendsRepository.connectionId', () {
    test('es simétrico: no importa en qué orden se pasen los uid', () {
      expect(
        FriendsRepository.connectionId('uidA', 'uidB'),
        FriendsRepository.connectionId('uidB', 'uidA'),
      );
    });

    test('junta los dos uid ordenados con "__"', () {
      expect(FriendsRepository.connectionId('b', 'a'), 'a__b');
    });
  });
}
