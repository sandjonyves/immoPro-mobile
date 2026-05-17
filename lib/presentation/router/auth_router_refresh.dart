import 'dart:async';

import 'package:flutter/foundation.dart';

/// Réévalue les redirections GoRouter lorsque le Cubit d’auth change.
class AuthRouterRefresh extends ChangeNotifier {
  AuthRouterRefresh(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    unawaited(_sub.cancel());
    super.dispose();
  }
}
