import 'package:flutter/material.dart';
import 'package:veloquent_sdk/veloquent_sdk.dart';
import '../services/veloquent_service.dart';
import '../theme/brutalist_theme.dart';
import '../widgets/brutalist_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _error = 'Please fill in all fields');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await VeloquentService.instance.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on SdkError catch (e) {
      debugPrint('SDK Error: ${e.message} (Code: ${e.code})');
      setState(() => _error = VeloquentService.formatError(e));
    } catch (e, stack) {
      debugPrint('Unexpected Login Error: $e');
      debugPrint('Stack Trace: $stack');
      setState(() => _error = VeloquentService.formatError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await VeloquentService.instance.loginWithGoogleNative();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      debugPrint('Google login error: $e');
      setState(() => _error = 'Google login failed. Please try again.');
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
                Image.asset(
                  'assets/logo.png',
                  width: 240,
                ),
                Gap.lg,
                Text(
                  'DAILY WORKOUT TRACKER',
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
                          hintText: '••••••••',
                        ),
                        onSubmitted: (_) => _login(),
                      ),
                    ],
                  ),
                ),
                Gap.xxl,

                BrutalistButton(
                  label: 'Login',
                  onPressed: _login,
                  fullWidth: true,
                  isLoading: _loading,
                ),
                Gap.base,
                BrutalistButton(
                  label: 'Sign in with Google',
                  onPressed: _loginWithGoogle,
                  fullWidth: true,
                  variant: BrutalistButtonVariant.tonal,
                  icon: Icons.login,
                  isLoading: _loading,
                ),
                Gap.xl,

                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text(
                    "DON'T HAVE AN ACCOUNT? REGISTER",
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
