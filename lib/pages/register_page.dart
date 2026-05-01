import 'package:flutter/material.dart';
import 'package:veloquent_sdk/veloquent_sdk.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Please fill in all fields');
      return;
    }

    if (password.length < 8) {
      setState(() => _error = 'Password must be at least 8 characters');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await VeloquentService.instance.register(name, email, password);
      await VeloquentService.instance.login(email, password);
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on SdkError catch (e) {
      debugPrint('SDK Error (Register): ${e.message} (Code: ${e.code})');
      setState(() => _error = VeloquentService.formatError(e));
    } catch (e, stack) {
      debugPrint('Unexpected Register Error: $e');
      debugPrint('Stack Trace: $stack');
      setState(() => _error = VeloquentService.formatError(e));
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
                Column(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 200,
                    ),
                    Gap.base,
                    Text(
                      'SIGN UP',
                      textAlign: TextAlign.center,
                      style: MonoText.display.copyWith(
                        color: MonoColors.amber,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
                Gap.lg,
                Text(
                  'JOIN MONOLOG TODAY',
                  style: MonoText.label.copyWith(color: MonoColors.textSecondary),
                ),
                Gap.xxxl,

                if (_error != null) ...[
                  Container(
                    width: double.infinity,
                    padding: MonoDecor.cardPadding,
                    decoration: MonoDecor.card(borderColor: MonoColors.danger),
                    child: Text(
                      _error!,
                      style: MonoText.body.copyWith(color: MonoColors.danger),
                      textAlign: TextAlign.center,
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
