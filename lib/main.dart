import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ko')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab7 Registration',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const RegistrationPage(),
      routes: {
        UserInfoPage.routeName: (ctx) => const UserInfoPage(),
      },
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _hidePass = true;
  bool _isKorean = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name is required';
    if (v.trim().length < 2) return 'Name must be at least 2 characters';
    if (v.trim().length > 10) return 'Name cannot exceed 10 characters';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');
    if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone number is required';

    final phoneRegex = RegExp(r'^\(\d{3}\)\s\d{3}-\d{4}$');
    if (!phoneRegex.hasMatch(v.trim())) {
      return 'Phone must be in format: (XXX) XXX-XXXX';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password required';
    if (v.length < 6) return 'At least 6 characters';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Confirm password required';
    if (v != _passCtrl.text) return 'Passwords do not match';
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushNamed(
        UserInfoPage.routeName,
        arguments: UserInfoArgs(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
        ),
      );
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    String? helper,
    IconData? prefix,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helper,
      prefixIcon:
          prefix != null ? Icon(prefix, color: AppColors.secondary) : null,
      suffixIcon: suffix,
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        borderSide: BorderSide(color: Colors.black, width: 2.0),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('register_form'.tr()),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              focusNode: _nameFocus,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                label: 'full_name'.tr(),
                hint: 'What do people call you?',
                prefix: Icons.person,
                suffix: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _nameCtrl.clear(),
                ),
              ),
              validator: _validateName,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_phoneFocus),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _phoneCtrl,
              focusNode: _phoneFocus,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration(
                label: 'phone_number'.tr(),
                hint: 'Enter (XXX) XXX-XXXX',
                helper: 'Phone format: (XXX) XXX-XXXX',
                prefix: Icons.call,
                suffix: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _phoneCtrl.clear(),
                ),
              ),
              validator: _validatePhone,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_emailFocus),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailCtrl,
              focusNode: _emailFocus,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration(
                label: 'email_address'.tr(),
                prefix: Icons.email,
              ),
              validator: _validateEmail,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_passFocus),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passCtrl,
              focusNode: _passFocus,
              obscureText: _hidePass,
              maxLength: 8,
              decoration: _inputDecoration(
                label: 'password'.tr(),
                hint: 'Enter the password',
                prefix: Icons.lock,
                suffix: IconButton(
                  icon: Icon(
                    _hidePass ? Icons.visibility_off : Icons.visibility,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      _hidePass = !_hidePass;
                    });
                  },
                ),
              ),
              validator: _validatePassword,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_confirmFocus),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _confirmCtrl,
              focusNode: _confirmFocus,
              obscureText: true,
              decoration: _inputDecoration(
                label: 'confirm_password'.tr(),
                prefix: Icons.lock_outline,
              ),
              validator: _validateConfirm,
              onFieldSubmitted: (_) => _submitForm(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tertiary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _submitForm,
              child: Text(
                'submit_form'.tr(),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            // ✅ 언어 변경 버튼 추가
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await context.setLocale(const Locale('en'));
                    setState(() => _isKorean = false);
                  },
                  child: const Text('EN'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    await context.setLocale(const Locale('ko'));
                    setState(() => _isKorean = true);
                  },
                  child: const Text('KO'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoArgs {
  final String name;
  final String email;
  final String phone;
  UserInfoArgs({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class UserInfoPage extends StatelessWidget {
  static const routeName = '/user-info';
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserInfoArgs;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${args.name}', style: const TextStyle(fontSize: 18)),
            Text('Email: ${args.email}', style: const TextStyle(fontSize: 18)),
            Text('Phone: ${args.phone}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
