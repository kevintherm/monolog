import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
  final _proteinController = TextEditingController();
  final _customNameController = TextEditingController();
  final _picker = ImagePicker();
  XFile? _imageFile;
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
    _proteinController.dispose();
    _customNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() => _imageFile = pickedFile);
    }
  }

  Future<void> _save() async {
    final name = _useCustomName ? _customNameController.text.trim() : _selectedName;
    final calories = int.tryParse(_caloriesController.text);
    final protein = int.tryParse(_proteinController.text);

    if (name == null || name.isEmpty || calories == null || protein == null || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and pick a photo')),
      );
      return;
    }

    setState(() => _saving = true);
    final success = await context.read<DayProvider>().addMeal(name, calories, protein, _imageFile!);
    setState(() => _saving = false);
    if (success && mounted) Navigator.pop(context);
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
                    Text('MEAL PHOTO', style: MonoText.label.copyWith(color: MonoColors.textSecondary)),
                    Gap.md,
                    GestureDetector(
                      onTap: () async {
                        final source = await showModalBottomSheet<ImageSource>(
                          context: context,
                          backgroundColor: MonoColors.surface,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          builder: (context) => SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: MonoSpacing.md),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt, color: MonoColors.amber),
                                    title: Text('TAKE PHOTO', style: MonoText.label),
                                    onTap: () => Navigator.pop(context, ImageSource.camera),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library, color: MonoColors.amber),
                                    title: Text('CHOOSE FROM GALLERY', style: MonoText.label),
                                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                        if (source != null) _pickImage(source);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: MonoDecor.card(
                          color: MonoColors.surfaceHigh,
                        ),
                        child: _imageFile != null
                            ? Image.file(
                                File(_imageFile!.path),
                                fit: BoxFit.cover,
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add_a_photo_outlined, color: MonoColors.textMuted, size: 40),
                                  Gap.sm,
                                  Text('TAP TO UPLOAD PHOTO', style: MonoText.labelSm.copyWith(color: MonoColors.textMuted)),
                                ],
                              ),
                      ),
                    ),
                    Gap.xl,

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CALORIES', style: MonoText.label.copyWith(color: MonoColors.textSecondary)),
                              Gap.md,
                              Container(
                                decoration: MonoDecor.card(),
                                padding: MonoDecor.cardPadding,
                                child: TextField(
                                  controller: _caloriesController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  style: MonoText.numberSm,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: '0',
                                    hintStyle: MonoText.numberSm.copyWith(color: MonoColors.textMuted),
                                    suffixText: 'CAL',
                                    suffixStyle: MonoText.labelSm.copyWith(color: MonoColors.textSecondary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap.hBase,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PROTEIN', style: MonoText.label.copyWith(color: MonoColors.textSecondary)),
                              Gap.md,
                              Container(
                                decoration: MonoDecor.card(),
                                padding: MonoDecor.cardPadding,
                                child: TextField(
                                  controller: _proteinController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  style: MonoText.numberSm,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: '0',
                                    hintStyle: MonoText.numberSm.copyWith(color: MonoColors.textMuted),
                                    suffixText: 'G',
                                    suffixStyle: MonoText.labelSm.copyWith(color: MonoColors.textSecondary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
