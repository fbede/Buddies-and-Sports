import 'package:buddies_and_sports/utils/exceptions/exception_handler.dart';
import 'package:buddies_and_sports/utils/functions.dart';
import 'package:buddies_and_sports/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmailChangePage extends StatefulWidget {
  const EmailChangePage({Key? key}) : super(key: key);
  @override
  State<EmailChangePage> createState() => _EmailChangePageState();
}

class _EmailChangePageState extends State<EmailChangePage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController oldEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newEmailController = TextEditingController();

  @override
  void dispose() {
    oldEmailController.dispose();
    passwordController.dispose();
    newEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(UserText.Change_Email),
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
                label: Text(UserText.Old_Email),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              controller: oldEmailController,
              validator: (value) => UtilFunctions.validateEmail(value!),
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text(UserText.Password),
                prefixIcon: Icon(Icons.key),
              ),
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text(UserText.New_Email),
                prefixIcon: Icon(Icons.key),
              ),
              keyboardType: TextInputType.emailAddress,
              controller: newEmailController,
              validator: (value) => UtilFunctions.validateEmail(value!),
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
            ? const Text(UserText.Change_Email)
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
        email: oldEmailController.text,
        password: passwordController.text,
      );

      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);

      await FirebaseAuth.instance.currentUser!
          .updateEmail(newEmailController.text);

      router.pop();

      messenger.showSnackBar(
        const SnackBar(content: Text(UserText.Email_Changed)),
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
