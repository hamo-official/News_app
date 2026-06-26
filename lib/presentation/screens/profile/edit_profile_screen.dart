import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  final _phoneCtrl = TextEditingController();
  String? _country;
  DateTime? _dob;
  bool _submitted = false;

  static const _countries = [
    'Egypt',
    'United States',
    'United Kingdom',
    'Canada',
    'Germany',
    'France',
    'Saudi Arabia',
    'United Arab Emirates',
    'Australia',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthCubit>().state;
    final name =
        state is AuthAuthenticated ? state.profile?.fullName ?? '' : '';
    _nameCtrl = TextEditingController(text: name);
    _loadLocal();
  }

  Future<void> _loadLocal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _phoneCtrl.text = prefs.getString('profile_phone') ?? '';
      final c = prefs.getString('profile_country');
      _country = (c != null && _countries.contains(c)) ? c : null;
      final dob = prefs.getString('profile_dob');
      if (dob != null) _dob = DateTime.tryParse(dob);
    });
  }

  Future<void> _persistLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_phone', _phoneCtrl.text.trim());
    if (_country != null) await prefs.setString('profile_country', _country!);
    if (_dob != null) {
      await prefs.setString('profile_dob', _dob!.toIso8601String());
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _submitted = true;
    _persistLocal();
    context.read<AuthCubit>().updateProfile(fullName: _nameCtrl.text.trim());
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 20),
      firstDate: DateTime(1920),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.navy),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  String _fmtDate(DateTime d) =>
      '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated && _submitted) {
          _submitted = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Changes saved successfully'),
              backgroundColor: AppColors.navy,
            ),
          );
          context.pop();
        } else if (state is AuthError && _submitted) {
          _submitted = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorRed,
            ),
          );
        }
      },
      builder: (context, state) {
        final profile = state is AuthAuthenticated ? state.profile : null;
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: SafeArea(
            child: Column(
              children: [
                _topBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(4.w),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: AppColors.surfaceContainer,
                                            width: 4),
                                      ),
                                      child: CircleAvatar(
                                        radius: 50.r,
                                        backgroundColor: AppColors.brightBlue,
                                        child: Text(
                                          _initials(profile?.fullName ??
                                              profile?.email ?? 'U'),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 36.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: GestureDetector(
                                        onTap: () => ScaffoldMessenger.of(
                                                context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Photo upload coming soon!'))),
                                        child: Container(
                                          padding: EdgeInsets.all(8.w),
                                          decoration: const BoxDecoration(
                                            color: AppColors.navy,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.edit_rounded,
                                              size: 16.sp, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 14.h),
                                Text(
                                  profile?.fullName?.isNotEmpty == true
                                      ? profile!.fullName!
                                      : 'NovaNews Reader',
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Premium Subscriber',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 32.h),
                          _label('Full Name'),
                          SizedBox(height: 8.h),
                          _textField(
                            controller: _nameCtrl,
                            hint: 'Enter your full name',
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Enter your name'
                                : null,
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              _label('Email Address'),
                              Row(
                                children: [
                                  Icon(Icons.lock_rounded,
                                      size: 13.sp, color: AppColors.outline),
                                  SizedBox(width: 3.w),
                                  Text('Verified',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.outline)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          _disabledField(profile?.email ?? ''),
                          SizedBox(height: 20.h),
                          _label('Phone Number'),
                          SizedBox(height: 8.h),
                          _textField(
                            controller: _phoneCtrl,
                            hint: '+1 (555) 000-1234',
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 20.h),
                          _label('Country'),
                          SizedBox(height: 8.h),
                          _countryDropdown(),
                          SizedBox(height: 20.h),
                          _label('Date of Birth'),
                          SizedBox(height: 8.h),
                          _dateField(),
                          SizedBox(height: 32.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.navy,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r)),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2),
                                    )
                                  : Text('Save Changes',
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600)),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Center(
                            child: TextButton(
                              onPressed: () => _confirmDeactivate(context),
                              child: Text(
                                'Deactivate Account',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.errorRed,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDeactivate(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Deactivate Account'),
        content: const Text(
            'This will deactivate your account. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Deactivate',
                style: TextStyle(color: AppColors.errorRed)),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
              color: Color(0x0A0F172A),
              blurRadius: 30,
              offset: Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded,
                color: AppColors.onSurface),
            onPressed: () => context.pop(),
          ),
          Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );

  InputDecoration _decoration({String? hint}) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.outlineVariant, fontSize: 15.sp),
        filled: true,
        fillColor: AppColors.surfaceLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.navy, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      );

  Widget _textField({
    required TextEditingController controller,
    String? hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: TextStyle(
          fontSize: 15.sp,
          color: AppColors.onSurface,
          fontWeight: FontWeight.w500),
      decoration: _decoration(hint: hint),
    );
  }

  Widget _disabledField(String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        value,
        style: TextStyle(fontSize: 15.sp, color: AppColors.outline),
      ),
    );
  }

  Widget _countryDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _country,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: AppColors.outline),
      hint: Text('Select country',
          style: TextStyle(color: AppColors.outlineVariant, fontSize: 15.sp)),
      style: TextStyle(
          fontSize: 15.sp,
          color: AppColors.onSurface,
          fontWeight: FontWeight.w500),
      decoration: _decoration(),
      items: _countries
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: (v) => setState(() => _country = v),
    );
  }

  Widget _dateField() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _dob != null ? _fmtDate(_dob!) : 'Select date of birth',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: _dob != null
                      ? AppColors.onSurface
                      : AppColors.outlineVariant,
                ),
              ),
            ),
            Icon(Icons.calendar_today_rounded,
                size: 18.sp, color: AppColors.outline),
          ],
        ),
      ),
    );
  }
}
