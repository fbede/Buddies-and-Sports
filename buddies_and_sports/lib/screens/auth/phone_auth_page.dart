import 'package:buddies_and_sports/utils/exceptions/exception_handler.dart';
import 'package:buddies_and_sports/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:otp_timer_button/otp_timer_button.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  bool isSendingOTP = false;
  bool showOtp = false;
  int numberOfTimesOTPIsSent = 0;
  int? resendToken;
  String verificationId = '';

  final phoneKey = GlobalKey<FormState>();
  final otpKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  late final otpButtonController = OtpTimerButtonController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () => otpButtonController.enableButton());
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(UserText.Sign_In_With_Phone),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPhoneNumberField(),
              const SizedBox(height: 16),
              _buildOTPButton(),
              _buildOTPField(),
              Visibility(
                visible: showOtp,
                child: const SizedBox(height: 16),
              ),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOTPButton() {
    return OtpTimerButton(
      duration: 180, //seconds
      controller: otpButtonController,
      onPressed: () => verifyPhone(),
      text: numberOfTimesOTPIsSent > 0
          ? const Text(UserText.Resend_OTP)
          : const Text(UserText.Get_OTP),
    );
  }

  Widget _buildSubmitButton() {
    return Visibility(
      visible: showOtp,
      child: ElevatedButton(
        onPressed: () => verifyPhone(),
        child: !isSendingOTP
            ? const Text(UserText.Update_Username)
            : const CircularProgressIndicator(
                color: Colors.white,
              ),
      ),
    );
  }

  Widget _buildOTPField() {
    return Visibility(
      visible: showOtp,
      child: Form(
        key: otpKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text(UserText.OTP),
              prefixIcon: Icon(Icons.password)),
          controller: otpController,
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null) {
              return UserText.OTP_is_6_digits;
            }
            if (v.length != 6) {
              return UserText.OTP_is_6_digits;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Form(
      key: phoneKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text(UserText.Phone),
          hintText: UserText.phone_hint,
          prefixIcon: Icon(Icons.phone),
        ),
        controller: phoneController,
        keyboardType: TextInputType.phone,
        validator: (v) {
          if (v == null) return UserText.Phone_Number_Too_Short;
          if (v.length < 12) {
            return UserText.Phone_Number_Too_Short;
          }
          if (v.length > 14) {
            return UserText.Phone_Number_Too_Long;
          }
          return null;
        },
      ),
    );
  }

  void verifyPhone() async {
    final messenger = ScaffoldMessenger.of(context);
    final isValid = phoneKey.currentState!.validate();

    if (numberOfTimesOTPIsSent > 5) {
      messenger.showSnackBar(
        const SnackBar(content: Text(UserText.OTP_sent)),
      );
    }

    if (!isValid) return;

    otpButtonController.startTimer();

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        forceResendingToken: resendToken,
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) => throw e,
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          this.resendToken = resendToken;
          showOtp = true;
          setState(() {});
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      messenger.showSnackBar(
        const SnackBar(content: Text(UserText.OTP_sent)),
      );
      numberOfTimesOTPIsSent++;
    } on Exception catch (e) {
      final errorMessage = ExceptionHandler.errorMessageFromError(exception: e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
}
