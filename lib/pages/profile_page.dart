import 'package:flutter/material.dart';
import '../services/veloquent_service.dart';
import '../theme/brutalist_theme.dart';
import '../widgets/confirm_bottom_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final user = VeloquentService.instance.currentUser;
    _nameController = TextEditingController(
      text: user?['name']?.toString() ?? '',
    );
    _emailController = TextEditingController(
      text: user?['email']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await VeloquentService.instance.updateProfile(
        name: _nameController.text.trim(),
        password: _passwordController.text.isNotEmpty
            ? _passwordController.text
            : null,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('PROFILE UPDATED')));
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _error = VeloquentService.formatError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PROFILE'), centerTitle: false),
      body: SingleChildScrollView(
        padding: MonoDecor.pagePadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('EDIT YOUR INFORMATION', style: MonoText.label),
              Gap.xl,

              Text(
                'NAME',
                style: MonoText.labelSm.copyWith(
                  color: MonoColors.textSecondary,
                ),
              ),
              Gap.xs,
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Enter your name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              Gap.lg,

              Text(
                'EMAIL',
                style: MonoText.labelSm.copyWith(
                  color: MonoColors.textSecondary,
                ),
              ),
              Gap.xs,
              TextFormField(
                controller: _emailController,
                enabled: false,
                decoration: const InputDecoration(hintText: 'Enter your email'),
                style: MonoText.body.copyWith(color: MonoColors.textMuted),
              ),
              Gap.lg,

              Text(
                'NEW PASSWORD (OPTIONAL)',
                style: MonoText.labelSm.copyWith(
                  color: MonoColors.textSecondary,
                ),
              ),
              Gap.xs,
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Leave blank to keep current',
                ),
                obscureText: true,
              ),
              Gap.xxl,

              if (_error != null) ...[
                Text(
                  _error!,
                  style: MonoText.bodySm.copyWith(color: MonoColors.danger),
                ),
                Gap.base,
              ],

              GestureDetector(
                onTap: _loading ? null : _save,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: MonoSpacing.base,
                  ),
                  decoration: MonoDecor.cardAccent(
                    color: _loading ? MonoColors.surface : MonoColors.amber,
                  ),
                  child: Center(
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            'SAVE CHANGES',
                            style: MonoText.labelLg.copyWith(
                              color: Colors.black,
                            ),
                          ),
                  ),
                ),
              ),
              Gap.xl,

              const Divider(),
              Gap.xl,

              GestureDetector(
                onTap: () async {
                  final confirmed = await ConfirmBottomSheet.show(
                    context,
                    title: 'LOGOUT',
                    message: 'Are you sure you want to end your session?',
                    confirmLabel: 'LOGOUT',
                  );

                  if (confirmed == true && context.mounted) {
                    await VeloquentService.instance.logout();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: MonoSpacing.base,
                  ),
                  decoration: MonoDecor.card(borderColor: MonoColors.border),
                  child: Center(
                    child: Text(
                      'LOGOUT',
                      style: MonoText.labelLg.copyWith(
                        color: MonoColors.textSecondary,
                      ),
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
}
