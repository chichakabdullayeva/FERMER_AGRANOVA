import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../../models/app_localizations_stub.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegisterSuccess;
  final VoidCallback onLoginTap;

  const RegisterScreen({
    Key? key,
    required this.onRegisterSuccess,
    required this.onLoginTap,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _farmNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String? _errorMessage;

  final _authService = AuthService();

  AppLocalizations _localizations(BuildContext context) {
    return AppLocalizations.of(context) ?? AppLocalizationsEn();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _farmNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
        farmName: _farmNameController.text.trim(),
        location: _locationController.text.trim(),
      );
      widget.onRegisterSuccess();
    } catch (e, st) {
      // Log error and stack trace to console for debugging
      // (Visible in terminal when running `flutter run`)
      debugPrint('Register error: $e');
      debugPrint('$st');
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = _localizations(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.darkGreen, AppColors.forestGreen],
            ),
          ),
          child: Column(
            children: [
              // App Header
              Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: widget.onLoginTap,
                      icon: const Icon(Icons.arrow_back, color: AppColors.white),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          loc.appTitle,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Registration Form
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        loc.buttonRegister,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: loc.labelEmail,
                          hintText: loc.hintEnterEmail,
                          prefixIcon: const Icon(Icons.email, color: AppColors.darkGreen),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.darkGreen, width: 2),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return loc.validationEmailRequired;
                          if (!value!.contains('@')) return loc.validationInvalidEmail;
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Full Name
                      TextFormField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          labelText: loc.labelFullName,
                          hintText: loc.hintEnterFullName,
                          prefixIcon: const Icon(Icons.person, color: AppColors.darkGreen),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.darkGreen, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) return loc.validationNameRequired;
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Farm Name
                      TextFormField(
                        controller: _farmNameController,
                        decoration: InputDecoration(
                          labelText: loc.labelFarmName,
                          hintText: loc.hintEnterFarmName,
                          prefixIcon: const Icon(Icons.agriculture, color: AppColors.darkGreen),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.darkGreen, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) return loc.validationNameRequired;
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Location
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: loc.labelLocation,
                          prefixIcon: const Icon(Icons.location_on, color: AppColors.darkGreen),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.darkGreen, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: loc.labelPassword,
                          hintText: loc.hintEnterPassword,
                          prefixIcon: const Icon(Icons.lock, color: AppColors.darkGreen),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword ? Icons.visibility : Icons.visibility_off,
                              color: AppColors.darkGreen,
                            ),
                            onPressed: () => setState(() => _showPassword = !_showPassword),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.darkGreen, width: 2),
                          ),
                        ),
                        obscureText: !_showPassword,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return loc.validationPasswordRequired;
                          if (value!.length < 8) return loc.validationPasswordLength;
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: loc.labelConfirmPassword,
                          prefixIcon: const Icon(Icons.lock, color: AppColors.darkGreen),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                              color: AppColors.darkGreen,
                            ),
                            onPressed: () =>
                                setState(() => _showConfirmPassword = !_showConfirmPassword),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.darkGreen, width: 2),
                          ),
                        ),
                        obscureText: !_showConfirmPassword,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return loc.validationPasswordMatch;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Error Message
                      if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.error),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                      if (_errorMessage != null) const SizedBox(height: 16),

                      // Register Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkGreen,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(AppColors.white),
                          ),
                        )
                            : Text(
                          loc.buttonRegister,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Artıq hesabınız var? ",
                            style: TextStyle(color: AppColors.darkGray),
                          ),
                          GestureDetector(
                            onTap: widget.onLoginTap,
                            child: Text(
                              loc.buttonLogin,
                              style: const TextStyle(
                                color: AppColors.darkGreen,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
