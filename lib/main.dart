import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab7 Registration',
      routes: {
        UserInfoPage.routeName: (ctx) => const UserInfoPage(),
      },
      home: const RegistrationPage(),
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
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmFocus = FocusNode();
  final _phoneFocus = FocusNode();

  bool _showPassword = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _phoneCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _confirmFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  String? _validateName(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Name must not be empty' : null;

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email must not be empty';
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');
    if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password must not be empty';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != _passCtrl.text) return 'Passwords do not match';
    return null;
  }

  InputDecoration _dec(String label, {Widget? suffix}) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: suffix,
      );

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pushNamed(
      UserInfoPage.routeName,
      arguments: UserInfoArgs(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration Page')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  focusNode: _nameFocus,
                  textInputAction: TextInputAction.next,
                  decoration: _dec('Name'),
                  validator: _validateName,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_emailFocus),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailCtrl,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: _dec('Email'),
                  validator: _validateEmail,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passFocus),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passCtrl,
                  focusNode: _passFocus,
                  textInputAction: TextInputAction.next,
                  obscureText: !_showPassword,
                  decoration: _dec(
                    'Password',
                    suffix: IconButton(
                      onPressed: () =>
                          setState(() => _showPassword = !_showPassword),
                      icon: Icon(_showPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                  validator: _validatePassword,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_confirmFocus),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmCtrl,
                  focusNode: _confirmFocus,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  decoration: _dec('Confirm Password'),
                  validator: _validateConfirm,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_phoneFocus),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneCtrl,
                  focusNode: _phoneFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.done,
                  decoration: _dec('Phone (digits only)'),
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Register'),
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

class UserInfoArgs {
  final String name;
  final String email;
  final String phone;
  UserInfoArgs({required this.name, required this.email, required this.phone});
}

class UserInfoPage extends StatelessWidget {
  static const routeName = '/user-info';
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserInfoArgs;
    return Scaffold(
      appBar: AppBar(title: const Text('User Info')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${args.name}'),
            Text('Email: ${args.email}'),
            Text('Phone: ${args.phone.isEmpty ? "-" : args.phone}'),
          ],
        ),
      ),
    );
  }
}
