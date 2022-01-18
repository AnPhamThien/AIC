import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/routes.dart';
import '../../controller/auth/auth_bloc.dart';
import '../../controller/registration/registration_bloc.dart';
import '../../utils/func.dart';
import '../../utils/validations.dart';
import '../theme/style.dart';
import '../widgets/get_user_input_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<RegistrationBloc, RegistrationState>(
      listenWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
      listener: (context, state) {
        final status = state.formStatus;
        if (status is ErrorStatus) {
          String errorMessage = getErrorMessage(status.exception.toString());
        } else if (state.formStatus is FormSubmissionSuccess) {
          context
              .read<AuthBloc>()
              .add(NavigateToPageEvent(route: AppRouter.verificationScreen));
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("assets/images/bg1.jpg"),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.black12,
          body: SingleChildScrollView(
            child: Container(
              height: size.height,
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: size.width * .07),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getRegisterHeadline(),
                  getRegisterForm(),
                  getLoginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container getLoginButton() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .1,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: bgWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: TextButton(
        onPressed: () {
          context
              .read<AuthBloc>()
              .add(NavigateToPageEvent(route: AppRouter.loginScreen));
        },
        child: RichText(
          text: const TextSpan(
            style: TextStyle(
                color: Colors.grey, fontSize: 17, fontWeight: FontWeight.w700),
            children: [
              TextSpan(
                text: "Already have an account ? ",
              ),
              TextSpan(
                  text: "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }

  Container getRegisterForm() {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
      decoration: const BoxDecoration(
        color: bgWhite,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GetUserInput(
              controller: _usernameController,
              validator: Validation.usernameValidation,
              label: 'Username',
              hint: 'Your username',
              isPassword: false,
            ),
            SizedBox(
              height: 15.h,
            ),
            GetUserInput(
              controller: _emailController,
              validator: Validation.emailValidation,
              label: 'Email',
              hint: 'Ex : thisisanemail@email.email',
              isPassword: false,
            ),
            SizedBox(
              height: 15.h,
            ),
            GetUserInput(
              controller: _passwordController,
              validator: Validation.passwordValidation,
              label: 'Password',
              hint: 'Your account password',
              isPassword: true,
            ),
            SizedBox(
              height: 15.h,
            ),
            GetUserInput(
              validator: (value) => value == _passwordController.text
                  ? null
                  : "Passwords do not match",
              label: 'Confirm password',
              hint: 'Re-type your password',
              isPassword: true,
            ),
            SizedBox(
              height: 30.h,
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<RegistrationBloc>().add(RegistrationSubmitted(
                      _usernameController.text,
                      _passwordController.text,
                      _emailController.text));
                }
              },
              style: TextButton.styleFrom(
                  fixedSize: Size(size.width * .94, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: Colors.black87,
                  alignment: Alignment.center,
                  primary: Colors.white,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              child: const Text(
                "Register",
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding getRegisterHeadline() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: size.height * .07),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 40,
              color: Colors.black.withOpacity(0.8)),
          children: const [
            TextSpan(text: "Let's start with\n"),
            TextSpan(
              text: "Register!",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 42),
            )
          ],
        ),
      ),
    );
  }
}
