import 'package:flutter/material.dart';

import 'package:immopro/app.dart';
import 'package:immopro/application/auth/auth_cubit.dart';
import 'package:immopro/core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await sl<AuthCubit>().restaurerSession();
  runApp(const ImmoProApp());
}
