import 'package:flutter/material.dart';

void main() {
  runApp(const LoginUiApp());
}

class LoginUiApp extends StatelessWidget {
  const LoginUiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Welcome back, ${_emailController.text.trim()}!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE0E7FF),
              Color(0xFFF8FAFC),
              Color(0xFFFDF2F8),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: _LoginCard(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  rememberMe: _rememberMe,
                  obscurePassword: _obscurePassword,
                  onRememberChanged: (value) {
                    setState(() => _rememberMe = value ?? false);
                  },
                  onTogglePassword: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  onSubmit: _submit,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.rememberMe,
    required this.obscurePassword,
    required this.onRememberChanged,
    required this.onTogglePassword,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final bool obscurePassword;
  final ValueChanged<bool?> onRememberChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF312E81).withValues(alpha: 0.14),
            blurRadius: 36,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _BrandBadge(),
              const SizedBox(height: 28),
              Text(
                'Welcome back',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue managing your account.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: const Color(0xFF64748B)),
              ),
              const SizedBox(height: 28),
              TextFormField(
                key: const Key('emailField'),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) {
                    return 'Email is required';
                  }
                  if (!email.contains('@') || !email.contains('.')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('passwordField'),
                controller: passwordController,
                obscureText: obscurePassword,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) => onSubmit(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    key: const Key('togglePasswordButton'),
                    tooltip: obscurePassword ? 'Show password' : 'Hide password',
                    onPressed: onTogglePassword,
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  final password = value ?? '';
                  if (password.isEmpty) {
                    return 'Password is required';
                  }
                  if (password.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    key: const Key('rememberMeCheckbox'),
                    value: rememberMe,
                    onChanged: onRememberChanged,
                  ),
                  const Text('Remember me'),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Forgot password?'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('signInButton'),
                onPressed: onSubmit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text('Sign in'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New here?'),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Create account'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandBadge extends StatelessWidget {
  const _BrandBadge();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.28),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: const Icon(
          Icons.shield_moon_rounded,
          color: Colors.white,
          size: 34,
        ),
      ),
    );
  }
}
