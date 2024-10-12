import 'dart:developer' as devtools show log;

import 'package:flutter_riverpod/flutter_riverpod.dart';

extension Log on Object? {
  void log() => devtools.log(toString());
}

/// Useful to log state change in our application
class StateLogger extends ProviderObserver {
  const StateLogger();
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    ('''
* provider: ${provider.runtimeType},
  oldValue: $previousValue ,
  newValue: $newValue
''')
        .log();
  }
}
