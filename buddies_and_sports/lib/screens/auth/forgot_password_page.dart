import 'package:buddies_and_sports/utils/exceptions/exception_handler.dart';
import 'package:buddies_and_sports/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool isLoading = false;
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(UserText.Forgot_Password)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(UserText.Email),
                  prefixIcon: Icon(Icons.email),
                ),
                controller: controller,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => sendEmail(),
                child: !isLoading
                    ? const Text(UserText.Send_Email)
                    : const CircularProgressIndicator(
                        color: Colors.white,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendEmail() async {
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    isLoading = true;
    setState(() {});

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: controller.text,
      );
      router.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text(UserText.Email_Sent)),
      );
    } on Exception catch (e) {
      final errorMessage = ExceptionHandler.errorMessageFromError(exception: e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      isLoading = false;
      setState(() {});
    }
  }
}
