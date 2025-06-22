import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:email_validator/email_validator.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/routes/route_names.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';
import 'package:immuno_warriors/shared/widgets/buttons/holographic_button.dart';
import 'package:immuno_warriors/shared/widgets/forms/input_field.dart';
import 'package:immuno_warriors/shared/widgets/feedback/snackbar_manager.dart';
import 'package:immuno_warriors/features/auth/providers/auth_provider.dart';
import 'package:immuno_warriors/shared/widgets/buttons/action_button.dart';
import 'package:immuno_warriors/shared/widgets/common/theme_selection_dialog.dart';

import '../../home/home_screen.dart'; // Pour le fond

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    AppLogger.info('LoginScreen initialisé');

    _emailController.addListener(_validateEmailInput);
    _passwordController.addListener(_validatePasswordInput);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen<String?>(errorMessageProvider, (previous, next) {
        if (next != null && next.isNotEmpty && mounted) {
          SnackbarManager.showError(context, next);
          ref.read(authProvider.notifier).clearError();
        }
      });
    });
  }

  void _validateEmailInput() {
    final isValid = EmailValidator.validate(_emailController.text.trim());
    if (_isEmailValid != isValid) {
      setState(() {
        _isEmailValid = isValid;
      });
    }
  }

  void _validatePasswordInput() {
    final value = _passwordController.text;
    final isValid = value.isNotEmpty && value.length >= 6;
    if (_isPasswordValid != isValid) {
      setState(() {
        _isPasswordValid = isValid;
      });
    }
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      final authNotifier = ref.read(authProvider.notifier);
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        await authNotifier.signIn(email: email, password: password);
        if (!mounted) return;

        final authState = ref.read(authProvider);
        if (authState.isSignedIn) {
          AppLogger.info('Utilisateur $email connecté avec succès');
          SnackbarManager.showSuccess(
            context,
            'Connexion réussie ! Bienvenue, ${authState.username ?? authState.email}',
          );
          context.goNamed(RouteNames.dashboard, extra: authState.userId);
        }
      } catch (e, stackTrace) {
        AppLogger.error(
          'Erreur lors de la connexion',
          error: e,
          stackTrace: stackTrace,
        );
      }
    }
  }

  void _nextStep() {
    if (EmailValidator.validate(_emailController.text.trim())) {
      setState(() {
        _currentStep = 1;
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      SnackbarManager.showError(context, AppStrings.invalidEmail);
    }
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      context.goNamed(RouteNames.profileAuthOptions);
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateEmailInput);
    _passwordController.removeListener(_validatePasswordInput);
    _emailController.dispose();
    _passwordController.dispose();
    _pageController.dispose();
    AppLogger.info('LoginScreen disposé');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final authLoading = ref.watch(authLoadingProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          HexGridBackground(size: size),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isLandscape ? size.width * 0.05 : size.width * 0.08,
                vertical: size.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  SizedBox(height: size.height * 0.03),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth:
                                isLandscape
                                    ? size.width * 0.6
                                    : size.width * 0.95,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FuturisticText(
                                AppStrings.loginTitle,
                                size: isLandscape ? 32 : 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height:
                                    isLandscape
                                        ? size.height * 0.32
                                        : size.height * 0.38,
                                child: PageView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: _pageController,
                                  children: [
                                    _buildEmailStep(size, isLandscape),
                                    _buildPasswordStep(
                                      size,
                                      isLandscape,
                                      authLoading,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: size.height * 0.05),
                              _buildBottomSection(context, isLandscape),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ActionButton(
          fallbackIcon: Icons.arrow_back,
          tooltip: 'Retour',
          onPressed: _goBack,
        ),
        Row(
          children: [
            ActionButton(
              fallbackIcon: Icons.help,
              tooltip: 'Aide',
              onPressed: () => context.goNamed(RouteNames.help),
            ),
            const SizedBox(width: 8),
            ActionButton(
              fallbackIcon: Icons.palette,
              tooltip: 'Changer le thème',
              onPressed:
                  () => showDialog(
                    context: context,
                    builder:
                        (context) => ThemeSelectionDialog(
                          onThemeSelected: (themeMode) {
                            AppLogger.info('Thème sélectionné: $themeMode');
                            Navigator.of(context).pop();
                          },
                          themeIconController: AnimationController(
                            vsync: this,
                            duration: const Duration(milliseconds: 400),
                          ),
                        ),
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmailStep(Size size, bool isLandscape) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: InputField(
            controller: _emailController,
            labelText: AppStrings.emailHint,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.textColorPrimary,
            ),
            validator:
                (value) =>
                    EmailValidator.validate(value ?? '')
                        ? null
                        : AppStrings.invalidEmail,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 48,
          width: 48,
          child: VirusButton(
            onPressed: _isEmailValid ? _nextStep : null,
            borderColor: AppColors.textColorSecondary,
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: AppColors.textColorPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStep(Size size, bool isLandscape, bool authLoading) {
    return Form(
      key: _formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputField(
                  controller: _passwordController,
                  labelText: AppStrings.passwordHint,
                  obscureText: true,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.textColorPrimary,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.invalidPassword;
                    }
                    if (value.length < 6) {
                      return AppStrings.weakPassword;
                    }
                    return null;
                  },
                  onChanged: (value) => _validatePasswordInput(),
                ),
                SizedBox(height: size.height * 0.01),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _handleForgotPassword(),
                    child: FuturisticText(
                      AppStrings.forgotPassword,
                      color: AppColors.primaryAccentColor,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 48,
            width: 48,
            child: VirusButton(
              onPressed:
                  (_isPasswordValid && !authLoading) ? _handleSignIn : null,
              borderColor: AppColors.textColorSecondary,
              child:
                  authLoading
                      ? const CircularProgressIndicator(
                        color: AppColors.textColorPrimary,
                      )
                      : const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                        color: AppColors.textColorPrimary,
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, bool isLandscape) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FuturisticText(
                  AppStrings.orConnectWith,
                  color: AppColors.textColorSecondary,
                  size: 13,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    VirusButton(
                      onPressed: _signInWithGoogle,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.g_mobiledata,
                        size: 24,
                        color: AppColors.textColorPrimary,
                      ),
                    ),
                    SizedBox(width: 10),
                    VirusButton(
                      onPressed: _signInWithFacebook,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.facebook,
                        size: 24,
                        color: AppColors.textColorPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FuturisticText(
                  AppStrings.noAccount,
                  color: AppColors.textColorSecondary,
                  size: 13,
                  textAlign: TextAlign.right,
                ),
                TextButton(
                  onPressed: () => context.goNamed(RouteNames.register),
                  child: FuturisticText(
                    AppStrings.registerAccount,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    size: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (!EmailValidator.validate(email)) {
      SnackbarManager.showWarning(
        context,
        'Veuillez d\'abord entrer une adresse e-mail valide',
      );
      setState(() {
        _currentStep = 0;
        _pageController.jumpToPage(0);
      });
      return;
    }

    try {
      await ref
          .read(authProvider.notifier)
          .sendPasswordResetEmail(email: email);
      if (mounted) {
        SnackbarManager.showSuccess(
          context,
          'E-mail de réinitialisation envoyé à $email',
        );
      }
    } catch (e) {
      AppLogger.error(
        'Erreur lors de l\'envoi de l\'e-mail de réinitialisation',
        error: e,
      );
    }
  }

  void _signInWithGoogle() {
    SnackbarManager.showWarning(context, AppStrings.socialLoginNotImplemented);
  }

  void _signInWithFacebook() {
    SnackbarManager.showWarning(context, AppStrings.socialLoginNotImplemented);
  }
}
