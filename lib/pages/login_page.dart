import 'package:flutter/material.dart';
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
    _emailController.dispose();
    _passwordController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _error = 'Please fill in all fields');
      _shakeController.forward(from: 0);
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
    } catch (e) {
      setState(() => _error = 'Invalid credentials');
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
                    'MONO\nLOG',
                    textAlign: TextAlign.center,
                    style: MonoText.displayLg.copyWith(
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                ),
                Gap.lg,
                Text(
                  'DAILY WORKOUT TRACKER',
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
