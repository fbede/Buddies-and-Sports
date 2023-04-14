import 'package:buddies_and_sports/router/route_names.dart';
import 'package:buddies_and_sports/utils/exceptions/exception_handler.dart';
import 'package:buddies_and_sports/utils/functions.dart';
import 'package:buddies_and_sports/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(children: [
          const SizedBox(height: 32),
          buildIcon(),
          const SizedBox(height: 32),
          _buildTitle(),
          const SizedBox(height: 32),
          _buildForm(),
          _buildSignInButton(),
          const SizedBox(height: 8),
          const Divider(color: Colors.grey, thickness: 1),
          const SizedBox(height: 8),
          _buildPhoneButton(),
          const SizedBox(height: 16),
          _buildForgotPassword(),
          const SizedBox(height: 16),
          _buildBottomText(),
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
          UserText.APPNAME,
          style: Theme.of(context).textTheme.displaySmall,
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
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
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
              obscureText: true,
            ),
            const SizedBox(height: 20),
          ],
        ),
      );

  Widget _buildSignInButton() => ElevatedButton(
        onPressed: () => signInWithEmail(),
        child: !isLoading
            ? const Text(UserText.Sign_In)
            : const CircularProgressIndicator(color: Colors.white),
      );

  Widget _buildPhoneButton() => ElevatedButton(
        onPressed: () => context.pushNamed(Routes.phoneAuth),
        child: const Text(UserText.Sign_In_With_Phone),
      );

  Widget _buildBottomText() => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyLarge,
          children: [
            const TextSpan(
              text: UserText.No_Account_Qmark_,
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => context.pushNamed(Routes.register),
              text: UserText.Register,
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      );

  Widget _buildForgotPassword() => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          recognizer: TapGestureRecognizer()
            ..onTap = () => context.pushNamed(Routes.forgotPassword),
          text: UserText.Forgot_Password,
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      );

  void signInWithEmail() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    final router = GoRouter.of(context);
    final prefs = GetIt.I<SharedPreferences>();
    final hasOnboarded = prefs.getBool(PrefKeys.onboardingKey) ?? false;

    isLoading = true;
    setState(() {});

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        router.pushNamed(Routes.verify);
      }

      if (hasOnboarded) {
        router.goNamed(Routes.home);
      } else {
        router.goNamed(Routes.selectInterest);
      }
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
