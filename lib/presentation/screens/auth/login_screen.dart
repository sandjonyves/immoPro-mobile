import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../application/auth/auth_cubit.dart';
import '../../../application/auth/auth_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../navigation/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(text: 'client@immopro.cm');
  final _pass = TextEditingController(text: 'client123');
  var _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(homeRouteForRole(state.utilisateur.role));
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final loading = state is AuthLoading;
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'ImmoPro',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.syneHeading(context, size: 32).copyWith(
                      color: AppColors.primaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Terrains, maisons et audit au Cameroun',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.interBody(context),
                  ),
                  const SizedBox(height: 48),
                  AppTextField(
                    controller: _email,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _pass,
                    label: 'Mot de passe',
                    obscure: _obscure,
                    suffix: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Se connecter',
                    loading: loading,
                    onPressed: loading
                        ? null
                        : () => context.read<AuthCubit>().connecter(
                              email: _email.text,
                              motDePasse: _pass.text,
                            ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Démo : admin@immopro.cm / agent@immopro.cm / client@immopro.cm — mots de passe admin123, agent123, client123.',
                    style: AppTextStyles.interLabel(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
