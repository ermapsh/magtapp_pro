import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // Run validation first.
    if (!_formKey.currentState!.validate()) {
      debugPrint('[LOGIN] Validation failed');
      return;
    }

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    debugPrint('[LOGIN] Starting login');
    debugPrint('[LOGIN] Email: $email');
    debugPrint('[LOGIN] Password: ******');

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('[LOGIN] Calling login API...');

      final accessToken = await ref
          .read(authRepositoryProvider)
          .login(email: email, password: password);

      debugPrint('[LOGIN] API successful');
      debugPrint('[LOGIN] Access token received: ${accessToken.isNotEmpty}');

      debugPrint('[LOGIN] Saving authentication session...');

      await ref
          .read(authProvider.notifier)
          .setSession(accessToken: accessToken);

      debugPrint('[LOGIN] Session saved successfully');
      debugPrint('[LOGIN] Navigating to home...');

      if (!mounted) return;

      context.go('/home');

      debugPrint('[LOGIN] Navigation completed');
    } catch (e, stackTrace) {
      debugPrint('[LOGIN] ERROR: $e');
      debugPrint('[LOGIN] STACK TRACE: $stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_getErrorMessage(e))));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      debugPrint('[LOGIN] Finished');
    }
  }

  String _getErrorMessage(Object error) {
    // We'll improve this once we create
    // a proper global API exception handler.
    return 'Login failed. Please check your email and password.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to MagTapp',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 32),

                // EMAIL
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,

                  decoration: const InputDecoration(labelText: 'Email'),

                  validator: (value) {
                    final email = value?.trim() ?? '';

                    if (email.isEmpty) {
                      return 'Email is required';
                    }

                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                    if (!emailRegex.hasMatch(email)) {
                      return 'Enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // PASSWORD
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,

                  onFieldSubmitted: (_) {
                    if (!_isLoading) {
                      _login();
                    }
                  },

                  decoration: InputDecoration(
                    labelText: 'Password',

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,

                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Login'),
                  ),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          context.go('/signup');
                        },
                  child: const Text('Create an account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
