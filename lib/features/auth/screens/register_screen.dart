import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:email_validator/email_validator.dart';

import 'package:immuno_warriors/core/constants/app_assets.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/core/routes/route_names.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';
import 'package:immuno_warriors/shared/ui/screen_utils.dart';
import 'package:immuno_warriors/shared/widgets/forms/input_field.dart';
import 'package:immuno_warriors/shared/widgets/feedback/snackbar_manager.dart';
import 'package:immuno_warriors/features/auth/providers/auth_provider.dart';
import 'package:immuno_warriors/shared/widgets/buttons/action_button.dart';
import 'package:immuno_warriors/shared/widgets/common/theme_selection_dialog.dart';

import '../../../shared/widgets/buttons/holographic_button.dart';
import '../../home/home_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final PageController _pageController = PageController();

  int _currentStep = 0;
  String? _selectedAvatarUrl;
  bool _avatarSelected = false;

  bool _isUsernameValid = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isPasswordConfirmValid = false;

  @override
  void initState() {
    super.initState();
    AppLogger.info('RegisterScreen initialisé');

    _usernameController.addListener(_validateUsernameInput);
    _emailController.addListener(_validateEmailInput);
    _passwordController.addListener(_validatePasswordInput);
    _confirmPasswordController.addListener(_validatePasswordConfirmInput);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen<String?>(errorMessageProvider, (previous, next) {
        if (next != null && next.isNotEmpty && mounted) {
          SnackbarManager.showError(context, next);
          ref.read(authProvider.notifier).clearError();
        }
      });
    });
  }

  void _validateUsernameInput() {
    final isValid = _usernameController.text.trim().length >= 3;
    if (_isUsernameValid != isValid) setState(() => _isUsernameValid = isValid);
  }

  void _validateEmailInput() {
    final isValid = EmailValidator.validate(_emailController.text.trim());
    if (_isEmailValid != isValid) setState(() => _isEmailValid = isValid);
  }

  void _validatePasswordInput() {
    final password = _passwordController.text;
    final isValid = password.length >= 6;
    if (_isPasswordValid != isValid) setState(() => _isPasswordValid = isValid);
  }

  void _validatePasswordConfirmInput() {
    final confirmPassword = _confirmPasswordController.text;
    final isValid =
        confirmPassword == _passwordController.text &&
        confirmPassword.length >= 6;
    if (_isPasswordConfirmValid != isValid) {
      setState(() => _isPasswordConfirmValid = isValid);
    }
  }

  void _selectAvatar(String avatarUrl) {
    setState(() {
      _selectedAvatarUrl = avatarUrl;
      _avatarSelected = true;
    });
  }

  void _nextStep() {
    bool currentStepIsValid = false;
    if (_currentStep == 0) {
      currentStepIsValid = _avatarSelected;
      if (!currentStepIsValid) {
        SnackbarManager.showError(context, AppStrings.selectAvatar);
      }
    } else if (_currentStep == 1) {
      currentStepIsValid = _isUsernameValid;
      if (!currentStepIsValid) {
        SnackbarManager.showError(context, AppStrings.invalidUsername);
      }
    } else if (_currentStep == 2) {
      currentStepIsValid = _isEmailValid;
      if (!currentStepIsValid) {
        SnackbarManager.showError(context, AppStrings.invalidEmail);
      }
    } else if (_currentStep == 3) {
      currentStepIsValid = _isPasswordValid;
      if (!currentStepIsValid) {
        SnackbarManager.showError(context, AppStrings.weakPassword);
      }
    } else if (_currentStep == 4) {
      currentStepIsValid = _isPasswordConfirmValid;
      if (!currentStepIsValid) {
        SnackbarManager.showError(context, AppStrings.passwordMismatch);
      }
    }

    if (!currentStepIsValid) return;

    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      _handleSignUp();
    }
  }

  void _prevStep() {
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

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate() && _selectedAvatarUrl != null) {
      final authNotifier = ref.read(authProvider.notifier);
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        await authNotifier.signUp(
          email: email,
          password: password,
          username: username,
          avatarUrl: _selectedAvatarUrl,
        );

        if (!mounted) return;
        final authState = ref.read(authProvider);

        if (authState.isSignedIn) {
          _showSuccessDialog(context, username);
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              context.goNamed(RouteNames.dashboard, extra: authState.userId);
            }
          });
        }
      } catch (e, stackTrace) {
        AppLogger.error(
          'Erreur lors de l\'inscription',
          error: e,
          stackTrace: stackTrace,
        );
      }
    } else if (_selectedAvatarUrl == null) {
      SnackbarManager.showError(context, AppStrings.selectAvatar);
    }
  }

  void _showSuccessDialog(BuildContext context, String username) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.backgroundColor.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.successColor,
                  size: 60,
                ),
                const SizedBox(height: 8),
                FuturisticText(
                  AppStrings.profileCreated,
                  size: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.successColor,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                FuturisticText(
                  '${AppStrings.welcomeToImmunoWarriors} $username!',
                  size: 13,
                  color: AppColors.textColorPrimary,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
    );
  }

  @override
  void dispose() {
    _usernameController.removeListener(_validateUsernameInput);
    _emailController.removeListener(_validateEmailInput);
    _passwordController.removeListener(_validatePasswordInput);
    _confirmPasswordController.removeListener(_validatePasswordConfirmInput);

    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pageController.dispose();
    AppLogger.info('RegisterScreen disposé');
    super.dispose();
  }

  bool _canGoNext() {
    if (_currentStep == 0) return _avatarSelected;
    if (_currentStep == 1) return _isUsernameValid;
    if (_currentStep == 2) return _isEmailValid;
    if (_currentStep == 3) return _isPasswordValid;
    if (_currentStep == 4) return _isPasswordConfirmValid;
    return false;
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
                horizontal:
                    ScreenUtils.getScreenWidth(context) *
                    (isLandscape ? 0.05 : 0.08),
                vertical: ScreenUtils.getScreenHeight(context) * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  SizedBox(height: ScreenUtils.getScreenHeight(context) * 0.01),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth:
                                isLandscape
                                    ? size.width * 0.6
                                    : size.width * 0.98,
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FuturisticText(
                                _currentStep == 0
                                    ? AppStrings.chooseYourAvatar
                                    : AppStrings.registerTitle,
                                size: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColorPrimary,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 18),
                              SizedBox(
                                height:
                                    _currentStep == 0
                                        ? (isLandscape
                                            ? size.height * 0.22
                                            : size.height * 0.16)
                                        : (isLandscape
                                            ? size.height * 0.22
                                            : size.height * 0.24),
                                child: PageView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: _pageController,
                                  children: [
                                    _buildAvatarSelection(size, isLandscape),
                                    _buildUsernameStep(size, isLandscape),
                                    _buildEmailStep(size, isLandscape),
                                    _buildPasswordStep(size, isLandscape),
                                    _buildPasswordConfirmStep(
                                      size,
                                      isLandscape,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_currentStep > 0)
                                    VirusButton(
                                      borderColor: AppColors.textColorSecondary,
                                      onPressed: _prevStep,
                                      width: 60,
                                      height: 32,
                                      child: FuturisticText(
                                        AppStrings.back,
                                        textAlign: TextAlign.center,
                                        size: 14,
                                        color: AppColors.textColorPrimary,
                                      ),
                                    ),
                                  if (_currentStep > 0) SizedBox(width: 16),
                                  VirusButton(
                                    borderColor: AppColors.textColorSecondary,
                                    onPressed:
                                        (authLoading && _currentStep == 4)
                                            ? null
                                            : (_canGoNext() ? _nextStep : null),
                                    width: 60,
                                    height: 32,
                                    child:
                                        authLoading && _currentStep == 4
                                            ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color:
                                                    AppColors.textColorPrimary,
                                              ),
                                            )
                                            : FuturisticText(
                                              _currentStep == 4
                                                  ? AppStrings.registerButton
                                                  : AppStrings
                                                      .continueButtonText,
                                              textAlign: TextAlign.center,
                                              size: 14,
                                              color: AppColors.textColorPrimary,
                                            ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
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
          onPressed: _prevStep,
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

  Widget _buildAvatarSelection(Size size, bool isLandscape) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: isLandscape ? size.height * 0.12 : size.height * 0.12,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppAssets.availableAvatars.length,
            itemBuilder: (context, index) {
              final avatarPath = AppAssets.availableAvatars[index];
              return GestureDetector(
                onTap: () => _selectAvatar(avatarPath),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Container(
                    width: isLandscape ? 60 : 54,
                    height: isLandscape ? 60 : 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            _selectedAvatarUrl == avatarPath
                                ? AppColors.textColorPrimary
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        avatarPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 32,
                            color: AppColors.textColorPrimary,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8),
        FuturisticText(
          _selectedAvatarUrl == null
              ? AppStrings.selectAvatar
              : 'Avatar sélectionné ✅',
          color:
              _selectedAvatarUrl == null
                  ? AppColors.biohazardColor
                  : AppColors.successColor,
          size: 13,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUsernameStep(Size size, bool isLandscape) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InputField(
            controller: _usernameController,
            labelText: AppStrings.enterUsername,
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.textColorPrimary,
              size: 20,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.invalidUsername;
              }
              if (value.length < 3) {
                return AppStrings.usernameTooShort;
              }
              return null;
            },
            onChanged: (value) => _validateUsernameInput(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailStep(Size size, bool isLandscape) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InputField(
          controller: _emailController,
          labelText: AppStrings.emailHint,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(
            Icons.email_outlined,
            color: AppColors.textColorPrimary,
            size: 20,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return AppStrings.invalidEmail;
            if (!EmailValidator.validate(value)) return AppStrings.invalidEmail;
            return null;
          },
          onChanged: (value) => _validateEmailInput(),
        ),
      ],
    );
  }

  Widget _buildPasswordStep(Size size, bool isLandscape) {
    return Form(
      key: _formKey,
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
              size: 20,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.invalidPassword;
              }
              if (value.length < 6) return AppStrings.weakPassword;
              return null;
            },
            onChanged: (value) => _validatePasswordInput(),
          ),
          SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _buildPasswordConfirmStep(Size size, bool isLandscape) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InputField(
            controller: _confirmPasswordController,
            labelText: AppStrings.confirmPasswordHint,
            obscureText: true,
            prefixIcon: const Icon(
              Icons.lock_reset_outlined,
              color: AppColors.textColorPrimary,
              size: 20,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.invalidPassword;
              }
              if (value != _passwordController.text) {
                return AppStrings.passwordMismatch;
              }
              return null;
            },
            onChanged: (value) => _validatePasswordConfirmInput(),
          ),
          SizedBox(height: 18),
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
                  AppStrings.alreadyHaveAccount,
                  color: AppColors.textColorSecondary,
                  size: 13,
                  textAlign: TextAlign.right,
                ),
                TextButton(
                  onPressed: () => context.goNamed(RouteNames.login),
                  child: FuturisticText(
                    AppStrings.signInHere,
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

  void _signInWithGoogle() {
    SnackbarManager.showWarning(context, AppStrings.socialLoginNotImplemented);
  }

  void _signInWithFacebook() {
    SnackbarManager.showWarning(context, AppStrings.socialLoginNotImplemented);
  }
}
