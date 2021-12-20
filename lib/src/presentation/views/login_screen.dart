import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constanct/error_message.dart';
import 'package:imagecaptioning/src/controller/auth/form_submission_status.dart';
import 'package:imagecaptioning/src/controller/login/login_bloc.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/presentation/widgets/get_user_input_field.dart';
import 'package:imagecaptioning/src/utils/func.dart';
import 'package:imagecaptioning/src/utils/validations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
      listener: (context, state) {
        final status = state.formStatus;
        if (status is FormSubmissionSuccess) {
          context.read<AuthBloc>().add(AuthenticateEvent());
        } else if (status is FormSubmissionFailed) {
          String errorMessage = getErrorMessage(status.exception.toString());
          print(errorMessage);
          if (errorMessage ==
              MessageCode.errorMap[MessageCode.userAccountInActivated]) {
            context
                .read<AuthBloc>()
                .add(NavigateToPageEvent(AppRouter.verificationScreen));
            //Navigator.of(context).pushNamed(AppRouter.verificationScreen);
          }
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
                  getLoginHeadline(),
                  const SizedBox(
                    height: 10,
                  ),
                  getLoginForm(),
                  getForgotButton(),
                  const SizedBox(
                    height: 20,
                  ),
                  getSignupButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Center getForgotButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          context
              .read<AuthBloc>()
              .add(NavigateToPageEvent(AppRouter.forgotPasswordScreen));
          //Navigator.of(context).pushNamed(AppRouter.forgotPasswordScreen);
        },
        child: const Text(
          "Forgot password ?",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Container getSignupButton() {
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
              .add(NavigateToPageEvent(AppRouter.registrationScreen));
          //Navigator.of(context).pushNamed(AppRouter.registrationScreen);
        },
        child: RichText(
          text: const TextSpan(
            style: TextStyle(
                color: Colors.grey, fontSize: 17, fontWeight: FontWeight.w700),
            children: [
              TextSpan(
                text: "Don't have an account ? ",
              ),
              TextSpan(
                  text: "SignUp",
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }

  Container getLoginForm() {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              height: 10,
            ),
            GetUserInput(
              controller: _usernameController,
              label: 'Username',
              hint: 'Email, Username or Phone number',
              isPassword: false,
              validator: Validation.loginValidation,
            ),
            const SizedBox(
              height: 20,
            ),
            GetUserInput(
              controller: _passwordController,
              label: 'Password',
              hint: 'Your account password',
              isPassword: true,
              validator: Validation.loginValidation,
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<LoginBloc>().add(LoginSubmitted(
                      _usernameController.text, _passwordController.text));
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
                "Login",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding getLoginHeadline() {
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
            TextSpan(text: "Hello,\n"),
            TextSpan(
              text: "Wellcome Back!",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 40),
            )
          ],
        ),
      ),
    );
  }
}
