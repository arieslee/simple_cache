import 'package:flutter_test/flutter_test.dart';

import 'package:simple_cache/simple_cache.dart';

void main() {
  test('Test cache initialization', () {
    final simpleCache = SimpleCache.getInstance();;
    expect(simpleCache, isNotNull);
  });
}
