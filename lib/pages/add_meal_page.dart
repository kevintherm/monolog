import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/day_provider.dart';
import '../theme/brutalist_theme.dart';
import '../widgets/brutalist_button.dart';

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  String? _selectedName;
  final _caloriesController = TextEditingController();
  final _customNameController = TextEditingController();
  bool _saving = false;
  bool _useCustomName = false;

  static const List<Map<String, dynamic>> _presets = [
    {'name': 'Breakfast', 'icon': Icons.wb_sunny_outlined, 'color': Color(0xFFF5CE42)},
    {'name': 'Lunch', 'icon': Icons.wb_cloudy_outlined, 'color': Color(0xFFE8C547)},
    {'name': 'Dinner', 'icon': Icons.nights_stay_outlined, 'color': Color(0xFFD4A017)},
    {'name': 'Snack', 'icon': Icons.cookie_outlined, 'color': Color(0xFF9B7510)},
  ];

  @override
  void dispose() {
    _caloriesController.dispose();
    _customNameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _useCustomName ? _customNameController.text.trim() : _selectedName;
    final calories = int.tryParse(_caloriesController.text);

    if (name == null || name.isEmpty || calories == null) return;

    setState(() => _saving = true);
    await context.read<DayProvider>().addMeal(name, calories);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: MonoDecor.pagePadding,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(MonoSpacing.sm),
                      decoration: BoxDecoration(
                        border: Border.all(color: MonoColors.border, width: 2),
                      ),
                      child: const Icon(Icons.arrow_back, color: MonoColors.amber, size: 22),
                    ),
                  ),
                  Gap.hBase,
                  Text('ADD MEAL', style: MonoText.h2.copyWith(color: MonoColors.amber)),
                ],
              ),
            ),
            Gap.base,

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: MonoSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CHOOSE A MEAL', style: MonoText.label.copyWith(color: MonoColors.textSecondary)),
                    Gap.md,

                    ...(_presets.map((preset) {
                      final isSelected = !_useCustomName && _selectedName == preset['name'];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: MonoSpacing.sm),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _selectedName = preset['name'] as String;
                            _useCustomName = false;
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: double.infinity,
                            padding: MonoDecor.cardPadding,
                            decoration: isSelected
                                ? MonoDecor.cardAccent(color: (preset['color'] as Color).withValues(alpha: 0.15))
                                : MonoDecor.card(),
                            child: Row(
                              children: [
                                Icon(
                                  preset['icon'] as IconData,
                                  color: isSelected ? MonoColors.amber : MonoColors.textSecondary,
                                  size: 24,
                                ),
                                Gap.hBase,
                                Text(
                                  (preset['name'] as String).toUpperCase(),
                                  style: MonoText.labelLg.copyWith(
                                    color: isSelected ? MonoColors.amber : MonoColors.textPrimary,
                                  ),
                                ),
                                const Spacer(),
                                if (isSelected)
                                  const Icon(Icons.check, color: MonoColors.amber, size: 22),
                              ],
                            ),
                          ),
                        ),
                      );
                    })),

                    GestureDetector(
                      onTap: () => setState(() {
                        _useCustomName = true;
                        _selectedName = null;
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: double.infinity,
                        padding: MonoDecor.cardPadding,
                        decoration: _useCustomName
                            ? MonoDecor.cardAccent()
                            : MonoDecor.card(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.edit_outlined,
                                  color: _useCustomName ? MonoColors.amber : MonoColors.textSecondary,
                                  size: 24,
                                ),
                                Gap.hBase,
                                Text(
                                  'CUSTOM',
                                  style: MonoText.labelLg.copyWith(
                                    color: _useCustomName ? MonoColors.amber : MonoColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            if (_useCustomName) ...[
                              Gap.md,
                              TextField(
                                controller: _customNameController,
                                autofocus: true,
                                style: MonoText.bodyLg,
                                decoration: const InputDecoration(hintText: 'Meal name...'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Gap.xl,

                    Text('CALORIES', style: MonoText.label.copyWith(color: MonoColors.textSecondary)),
                    Gap.md,
                    Container(
                      decoration: MonoDecor.card(),
                      padding: MonoDecor.cardPadding,
                      child: TextField(
                        controller: _caloriesController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: MonoText.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: MonoText.number.copyWith(color: MonoColors.textMuted),
                          suffixText: 'CAL',
                          suffixStyle: MonoText.label.copyWith(color: MonoColors.textSecondary),
                        ),
                      ),
                    ),
                    Gap.xxl,

                    BrutalistButton(
                      label: 'Save Meal',
                      onPressed: _save,
                      fullWidth: true,
                      icon: Icons.check,
                      isLoading: _saving,
                    ),
                    Gap.xxl,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
