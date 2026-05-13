// lib/features/auth/presentation/screens/register_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../config/routes/route_names.dart';
import '../../data/models/auth_state.dart';
import '../../domain/providers/auth_provider.dart';
import '../widgets/auth_form_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    
    FocusScope.of(context).unfocus();
    ref.read(authProvider.notifier).clearError();
    
    await ref.read(authProvider.notifier).register(
          name: _nameController.text.trim(),
          mobile: _mobileController.text.trim(),
          email: _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;
    final errorMsg = authState is AuthFailure ? (authState).message : null;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (errorMsg != null) ...[
                          _buildErrorBanner(errorMsg),
                          const SizedBox(height: 24),
                        ],
                        
                        // Full Name
                        AuthFormField(
                          key: const ValueKey('nameField'),
                          label: 'Full Name',
                          hint: 'e.g. Manav Ramani',
                          prefixIcon: Icons.person_outline,
                          controller: _nameController,
                          enabled: !isLoading,
                          infoMessage: 'Enter your full legal name. This will be used on your shop bills and reports.',
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Full name is required';
                            if (v.trim().length < 2) return 'Name must be at least 2 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Mobile Number
                        AuthFormField(
                          key: const ValueKey('mobileField'),
                          label: 'Mobile Number',
                          hint: 'e.g. 9876543210',
                          prefixIcon: Icons.phone_android_outlined,
                          keyboardType: TextInputType.phone,
                          controller: _mobileController,
                          enabled: !isLoading,
                          infoMessage: 'Your 10-digit mobile number will be your primary login ID and for cloud sync recovery.',
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Mobile number is required';
                            if (!RegExp(r'^[0-9]{10}$').hasMatch(v.trim())) {
                              return 'Please enter a valid 10-digit mobile number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email
                        AuthFormField(
                          key: const ValueKey('emailField'),
                          label: 'Email (Optional)',
                          hint: 'e.g. manav@example.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          enabled: !isLoading,
                          infoMessage: 'Optional. We will use this to send you monthly business reports and security alerts.',
                          validator: (v) {
                            if (v != null && v.trim().isNotEmpty) {
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                                return 'Enter a valid email address';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password
                        AuthFormField(
                          key: const ValueKey('passwordField'),
                          label: 'Password',
                          hint: 'Min. 6 characters',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          controller: _passwordController,
                          enabled: !isLoading,
                          infoMessage: 'Choose a strong password with at least 6 characters to secure your business data.',
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Password is required';
                            if (v.length < 6) return 'Password must be at least 6 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Confirm Password
                        AuthFormField(
                          key: const ValueKey('confirmPasswordField'),
                          label: 'Confirm Password',
                          hint: 'Re-enter password',
                          prefixIcon: Icons.lock_clock_outlined,
                          isPassword: true,
                          controller: _confirmPasswordController,
                          enabled: !isLoading,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: _onRegister,
                          infoMessage: 'Confirm your password to ensure you typed it correctly.',
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Please confirm your password';
                            if (v != _passwordController.text) return 'Passwords do not match';
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: isLoading ? null : _onRegister,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                            backgroundColor: AppColors.primary,
                          ),
                          child: isLoading 
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('CREATE ACCOUNT'),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account? ', style: TextStyle(color: AppColors.textMuted)),
                            TextButton(
                              onPressed: () => context.go(RouteNames.login),
                              child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 24, 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => context.go(RouteNames.login),
          ),
          const SizedBox(width: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Join the Heshab ecosystem',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
  }
}
