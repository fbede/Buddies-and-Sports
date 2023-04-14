import 'package:buddies_and_sports/router/route_names.dart';
import 'package:buddies_and_sports/utils/exceptions/exception_handler.dart';
import 'package:buddies_and_sports/utils/functions.dart';
import 'package:buddies_and_sports/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(children: [
          const SizedBox(height: 16),
          buildIcon(),
          const SizedBox(height: 16),
          _buildTitle(),
          const SizedBox(height: 32),
          _buildForm(),
          const SizedBox(height: 24),
          _buildSignUpButton(),
          const SizedBox(height: 32),
          _buildBottomText()
        ]),
      ),
    );
  }

  Widget buildIcon() => SizedBox.square(
        dimension: 128,
        child: Image.asset('assets/images/sports.png'),
      );

  Widget _buildTitle() => Center(
        child: Text(
          UserText.Register,
          style: Theme.of(context).textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
      );

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
                label: Text(UserText.Password),
                prefixIcon: Icon(Icons.key),
              ),
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              validator: (v) => UtilFunctions.checkPasswordLength(v!),
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text(UserText.Confirm_Password),
                prefixIcon: Icon(Icons.key),
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              controller: confirmPasswordController,
              validator: (v) => UtilFunctions.confirmPasswordsAreTheSame(
                password: passwordController.text,
                confirmPassword: confirmPasswordController.text,
              ),
            )
          ],
        ),
      );

  Widget _buildSignUpButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(40),
        ),
        onPressed: () => signUpWithEmail(),
        child: !isLoading
            ? const Text(UserText.Register)
            : const CircularProgressIndicator(color: Colors.white),
      );

  Widget _buildBottomText() => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyLarge,
          text: UserText.Have_Account_Qmark_,
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => context.goNamed(Routes.signIn),
              text: UserText.Sign_In,
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      );

  void signUpWithEmail() async {
    final isValid = _formKey.currentState!.validate();
    final router = GoRouter.of(context);

    if (!isValid) return;
    isLoading = true;
    setState(() {});

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      router.pushNamed(Routes.verify);
    } on Exception catch (e) {
      final errorMessage = ExceptionHandler.errorMessageFromError(exception: e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      setState(() {});
    } finally {
      isLoading = false;
    }
  }
}
