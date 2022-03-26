import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/constant/error_message.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import '../../prefs/app_prefs.dart';
import '../../app/routes.dart';
import '../../controller/auth/auth_bloc.dart';
import '../../controller/login/login_bloc.dart';
import '../../utils/func.dart';
import '../../utils/validations.dart';
import '../theme/style.dart';
import '../widgets/get_user_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
      listener: (context, state) {
        final status = state.formStatus;
        if (status is FormSubmitting) {
          _isLogin = true;
        }
        if (status is FormSubmissionSuccess) {
          context.read<AuthBloc>().add(AuthenticateEvent(state.user));
        } else if (status is ErrorStatus) {
          _isLogin = false;
          String errorMessage = getErrorMessage(status.exception.toString());
          if (errorMessage ==
              MessageCode.errorMap[MessageCode.userAccountInActivated]) {
                String userId = getIt<AppPref>().getUserID;
                getIt<AppPref>().setUserID('');
            _getDialog(MessageCode.errorMap[MessageCode.userAccountInActivated],
                () {
                  Navigator.of(context).pushNamed(AppRouter.verificationScreen, arguments: userId);
            });
          } else if (errorMessage == MessageCode.userNotFound) {
            _getDialog(MessageCode.errorMap[MessageCode.userPassWordInCorrect],
                () => Navigator.pop(context));
          } else {
            _getDialog(errorMessage, () => Navigator.pop(context));
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
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getLoginHeadline(),
                      const SizedBox(
                        height: 10,
                      ),
                      getLoginForm(_isLogin),
                      getForgotButton(),
                      const SizedBox(
                        height: 20,
                      ),
                      getSignupButton(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _getDialog(String? content, void Function()? func) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actionsAlignment: MainAxisAlignment.center,
        title: const Text('Error !',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25,
                color: Colors.black87,
                letterSpacing: 1.25,
                fontWeight: FontWeight.bold)),
        content: Text(content ?? 'Something went wrong',
            textAlign: TextAlign.left,
            style: const TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w600)),
        actions: <Widget>[
          TextButton(
            onPressed: func,
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Center getForgotButton() {
    return Center(
      child: TextButton(
        onPressed: () => context
            .read<AuthBloc>()
            .add(NavigateToPageEvent(route: AppRouter.forgotPasswordScreen)),
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
              .add(NavigateToPageEvent(route: AppRouter.registrationScreen));
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

  Container getLoginForm(bool isLogin) {
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
              validator: Validation.blankValidation,
            ),
            const SizedBox(
              height: 20,
            ),
            GetUserInput(
              controller: _passwordController,
              label: 'Password',
              hint: 'Your account password',
              isPassword: true,
              validator: Validation.blankValidation,
            ),
            const SizedBox(
              height: 30,
            ),
            AbsorbPointer(
              absorbing: isLogin,
              child: TextButton(
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
                child: isLogin
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text("Login"),
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
