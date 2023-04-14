import 'package:buddies_and_sports/utils/exceptions/exception_handler.dart';
import 'package:buddies_and_sports/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(UserText.Verify_Email)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                UserText.NotVerifiedMessage,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => resendVerificationEmail(),
                child: !isLoading
                    ? const Text(UserText.Send_Verification_Email)
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

  void resendVerificationEmail() async {
    isLoading = true;
    setState(() {});

    try {
      await FirebaseAuth.instance.currentUser!
          .sendEmailVerification()
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(UserText.Email_Sent)),
        );
      });
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
