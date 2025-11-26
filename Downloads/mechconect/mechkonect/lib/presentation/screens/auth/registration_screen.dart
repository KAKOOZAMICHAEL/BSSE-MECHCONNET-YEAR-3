import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _ninController = TextEditingController();
  final _permitController = TextEditingController();
  DateTime? _dateOfBirth;
  String? _selectedGender;

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _ninController.dispose();
    _permitController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    // Format phone number
    String formattedPhone = _phoneController.text.trim();
    if (!formattedPhone.startsWith('256')) {
      if (formattedPhone.startsWith('0')) {
        formattedPhone = '256${formattedPhone.substring(1)}';
      } else {
        formattedPhone = '256$formattedPhone';
      }
    }

    // Prepare registration data to pass through OTP verification
    final registrationData = {
      'username': _usernameController.text.trim(),
      'phone': formattedPhone,
      'email': _emailController.text.trim().isEmpty 
          ? null 
          : _emailController.text.trim(),
      'nin': _ninController.text.trim(),
      'permitNumber': _permitController.text.trim(),
      'dateOfBirth': _dateOfBirth?.toIso8601String(),
      'gender': _selectedGender,
    };

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Store registration data temporarily
    await authProvider.setPendingRegistrationData(registrationData);

    // First send OTP
    await authProvider.loginWithPhone(formattedPhone);

    if (!mounted) return;

    if (authProvider.error == null) {
      context.push('/otp-verification?phone=$formattedPhone');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Registration failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingXL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sign Up',
                style: AppTextStyles.h1(isDark: isDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingSM),
              Text(
                'Create your account to get started',
                style: AppTextStyles.bodyMedium(isDark: isDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingXXL),
              CustomTextField(
                label: 'Username',
                hint: 'Enter username',
                controller: _usernameController,
                validator: Validators.username,
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: AppDimensions.spacingLG),
              CustomTextField(
                label: 'Phone Number',
                hint: '256XXXXXXXXX or 0XXXXXXXXX',
                controller: _phoneController,
                validator: Validators.phoneNumber,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
              ),
              const SizedBox(height: AppDimensions.spacingLG),
              CustomTextField(
                label: 'Email (Optional)',
                hint: 'Enter your email',
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) return null;
                  return Validators.email(value);
                },
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: AppDimensions.spacingLG),
              CustomTextField(
                label: 'NIN (National ID)',
                hint: 'Enter your NIN',
                controller: _ninController,
                validator: Validators.nin,
                prefixIcon: Icons.badge_outlined,
              ),
              const SizedBox(height: AppDimensions.spacingLG),
              CustomTextField(
                label: 'Permit Number',
                hint: 'Enter permit number',
                controller: _permitController,
                validator: Validators.permitNumber,
                prefixIcon: Icons.credit_card_outlined,
              ),
              const SizedBox(height: AppDimensions.spacingLG),
              CustomTextField(
                label: 'Date of Birth',
                hint: _dateOfBirth == null
                    ? 'Select date of birth'
                    : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
                readOnly: true,
                onTap: _selectDateOfBirth,
                validator: (value) {
                  if (_dateOfBirth == null) {
                    return 'Date of birth is required';
                  }
                  return null;
                },
                prefixIcon: Icons.calendar_today_outlined,
              ),
              const SizedBox(height: AppDimensions.spacingLG),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                items: ['Male', 'Female']
                    .map((gender) => DropdownMenuItem(
                          value: gender.toLowerCase(),
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Gender is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacingXXL),
              CustomButton(
                text: 'Create Account',
                onPressed: authProvider.isLoading ? null : _handleRegister,
                isLoading: authProvider.isLoading,
              ),
              const SizedBox(height: AppDimensions.spacingLG),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTextStyles.bodyMedium(isDark: isDark),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Sign In'),
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

