import 'package:flutter/material.dart';
import '../services/veloquent_service.dart';
import '../theme/brutalist_theme.dart';
import '../widgets/brutalist_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Please fill in all fields');
      _shakeController.forward(from: 0);
      return;
    }

    if (password.length < 8) {
      setState(() => _error = 'Password must be at least 8 characters');
      _shakeController.forward(from: 0);
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await VeloquentService.instance.login(email, password);
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() => _error = 'Registration failed. Email might be taken.');
      _shakeController.forward(from: 0);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: MonoDecor.pagePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(MonoSpacing.xl),
                  decoration: MonoDecor.tile(MonoColors.amber),
                  child: Text(
                    'SIGN\nUP',
                    textAlign: TextAlign.center,
                    style: MonoText.displayLg.copyWith(
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                ),
                Gap.lg,
                Text(
                  'JOIN MONOLOG TODAY',
                  style: MonoText.label.copyWith(color: MonoColors.textSecondary),
                ),
                Gap.xxxl,

                if (_error != null) ...[
                  AnimatedBuilder(
                    animation: _shakeController,
                    builder: (context, child) {
                      final offset = _shakeController.isAnimating
                          ? 10.0 *
                              (0.5 - _shakeController.value).abs() *
                              (_shakeController.value < 0.5 ? 1 : -1)
                          : 0.0;
                      return Transform.translate(
                        offset: Offset(offset, 0),
                        child: child,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: MonoDecor.cardPadding,
                      decoration: MonoDecor.card(borderColor: MonoColors.danger),
                      child: Text(
                        _error!,
                        style: MonoText.body.copyWith(color: MonoColors.danger),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Gap.lg,
                ],

                Container(
                  decoration: MonoDecor.card(),
                  padding: MonoDecor.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NAME', style: MonoText.label.copyWith(color: MonoColors.amber)),
                      Gap.sm,
                      TextField(
                        controller: _nameController,
                        style: MonoText.bodyLg,
                        decoration: const InputDecoration(
                          hintText: 'Your name',
                        ),
                      ),
                    ],
                  ),
                ),
                Gap.base,

                Container(
                  decoration: MonoDecor.card(),
                  padding: MonoDecor.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('EMAIL', style: MonoText.label.copyWith(color: MonoColors.amber)),
                      Gap.sm,
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: MonoText.bodyLg,
                        decoration: const InputDecoration(
                          hintText: 'you@example.com',
                        ),
                      ),
                    ],
                  ),
                ),
                Gap.base,

                Container(
                  decoration: MonoDecor.card(),
                  padding: MonoDecor.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PASSWORD', style: MonoText.label.copyWith(color: MonoColors.amber)),
                      Gap.sm,
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: MonoText.bodyLg,
                        decoration: const InputDecoration(
                          hintText: 'At least 8 characters',
                        ),
                        onSubmitted: (_) => _register(),
                      ),
                    ],
                  ),
                ),
                Gap.xxl,

                BrutalistButton(
                  label: 'Create Account',
                  onPressed: _register,
                  fullWidth: true,
                  isLoading: _loading,
                ),
                Gap.xl,

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'ALREADY HAVE AN ACCOUNT? LOGIN',
                    style: MonoText.labelSm.copyWith(color: MonoColors.amber),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
