import 'package:buddies_and_sports/utils/exceptions/exception_handler.dart';
import 'package:buddies_and_sports/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateUsernamePage extends StatefulWidget {
  const UpdateUsernamePage({super.key});

  @override
  State<UpdateUsernamePage> createState() => _UpdateUsernamePageState();
}

class _UpdateUsernamePageState extends State<UpdateUsernamePage> {
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
      appBar: AppBar(title: const Text(UserText.Update_Username)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(UserText.Username),
                  prefixIcon: Icon(Icons.account_circle),
                ),
                controller: controller,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => updateUserName(),
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

  void updateUserName() async {
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
