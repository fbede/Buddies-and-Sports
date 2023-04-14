import 'package:buddies_and_sports/utils/exceptions/exception_handler.dart';
import 'package:buddies_and_sports/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  bool isLoading = false;
  bool showOtp = false;
  int numberOfTimesOTPIsSent = 0;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
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
              _buildPhoneNumberField(),
              Visibility(
                visible: !showOtp,
                child: const SizedBox(height: 16),
              ),
              _buildOTPField(),
              Visibility(
                visible: !showOtp,
                child: const SizedBox(height: 16),
              ),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () => updateUserName(),
          child: !isLoading
              ? const Text(UserText.Update_Username)
              : const CircularProgressIndicator(
                  color: Colors.white,
                ),
        ),
        ElevatedButton(
          onPressed: () => updateUserName(),
          child: !isLoading
              ? const Text(UserText.Update_Username)
              : const CircularProgressIndicator(
                  color: Colors.white,
                ),
        ),
      ],
    );
  }

  Widget _buildOTPField() {
    return TextFormField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text(UserText.OTP),
          prefixIcon: Icon(Icons.password)),
      controller: otpController,
      keyboardType: TextInputType.number,
    );
  }

  TextFormField _buildPhoneNumberField() {
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        label: Text(UserText.Phone),
        hintText: UserText.phone_hint,
        prefixIcon: Icon(Icons.phone),
      ),
      controller: phoneController,
      keyboardType: TextInputType.phone,
    );
  }

  void updateUserName() async {
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    isLoading = true;
    setState(() {});

    try {
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(phoneController.text);
      router.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text(UserText.Username_Updated)),
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
