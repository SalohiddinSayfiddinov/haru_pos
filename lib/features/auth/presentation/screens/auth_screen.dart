import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_pos/core/assets/app_images.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/routes/app_pages.dart';
import 'package:haru_pos/core/utils/validators.dart';
import 'package:haru_pos/core/widgets/app_buttons.dart';
import 'package:haru_pos/core/widgets/app_snack_bar.dart';
import 'package:haru_pos/core/widgets/app_text_field.dart';
import 'package:haru_pos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:haru_pos/features/auth/presentation/widgets/auth_image_side.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _loginController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          AuthImageSide(),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 454),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Добро пожаловать",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40.0,
                                ),
                              ),
                            ),
                          ),
                          Image(image: AssetImage(AppImages.sushi)),
                        ],
                      ),
                      SizedBox(height: 64),
                      AppTextField(
                        controller: _loginController,
                        hintText: 'Введите логин',
                        validator: Validators.simpleValidator,
                      ),
                      SizedBox(height: 20.0),
                      AppTextField(
                        controller: _passwordController,
                        hintText: 'Введите пароль',
                        obscureText: true,
                        validator: Validators.simpleValidator,
                      ),
                      SizedBox(height: 50.0),
                      BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthError) {
                            AppSnackbar.error(context, state.message);
                          } else if (state is AuthAuthenticated) {
                            context.go(AppPages.dashboard);
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;
                          return PrimaryButton(
                            width: double.infinity,
                            title: 'Войти',
                            isLoading: isLoading,
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context.read<AuthBloc>().add(
                                  LoginEvent(
                                    username: _loginController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
