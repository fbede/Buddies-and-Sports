import 'package:buddies_and_sports/utils/exceptions/exception_handler.dart';
import 'package:buddies_and_sports/utils/functions.dart';
import 'package:buddies_and_sports/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({Key? key}) : super(key: key);
  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(UserText.Change_Password),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildForm(),
              const SizedBox(height: 24),
              _buildSumbitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() => Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text(UserText.Email),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              validator: (value) => UtilFunctions.validateEmail(value!),
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text(UserText.Old_Password),
                prefixIcon: Icon(Icons.key),
              ),
              controller: oldPasswordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text(UserText.New_Password),
                prefixIcon: Icon(Icons.key),
              ),
              controller: newPasswordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              validator: (v) => UtilFunctions.checkPasswordLength(v!),
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text(UserText.Confirm_New_Password),
                prefixIcon: Icon(Icons.key),
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              controller: confirmNewPasswordController,
              validator: (v) => UtilFunctions.confirmPasswordsAreTheSame(
                password: newPasswordController.text,
                confirmPassword: confirmNewPasswordController.text,
              ),
            )
          ],
        ),
      );

  Widget _buildSumbitButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(40),
        ),
        onPressed: () => changeEmail(),
        child: !isLoading
            ? const Text(UserText.Change_Password)
            : const CircularProgressIndicator(
                color: Colors.white,
              ),
      );

  void changeEmail() async {
    final isValid = _formKey.currentState!.validate();
    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);

    if (!isValid) return;
    isLoading = true;
    setState(() {});

    try {
      final credential = EmailAuthProvider.credential(
        email: emailController.text,
        password: oldPasswordController.text,
      );

      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);

      await FirebaseAuth.instance.currentUser!
          .updatePassword(newPasswordController.text);

      router.pop();

      messenger.showSnackBar(
        const SnackBar(content: Text(UserText.Password_Changed)),
      );
    } on Exception catch (e) {
      final errorMessage = ExceptionHandler.errorMessageFromError(exception: e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      isLoading = false;
      setState(() {});
    }
  }
}
