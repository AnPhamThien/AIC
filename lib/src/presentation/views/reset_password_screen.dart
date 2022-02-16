import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';
import 'package:imagecaptioning/src/controller/reset_password/reset_password_bloc.dart';
import 'package:imagecaptioning/src/utils/func.dart';
import 'package:imagecaptioning/src/utils/validations.dart';
import '../../app/routes.dart';
import '../theme/style.dart';
import '../widgets/get_user_input_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage("assets/images/bg1.jpg"),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black12,
        body: BlocListener<ResetPasswordBloc, ResetPasswordState>(
          listener: (context, state) {
            final status = state.formStatus;
            if (status is ErrorStatus) {
              String errorMessage =
                  getErrorMessage(status.exception.toString());
              _getDialog(errorMessage, 'Error !', () => Navigator.pop(context));
            } else if (status is FormSubmissionSuccess) {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  actionsAlignment: MainAxisAlignment.center,
                  title: const Text('Congratulation !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black87,
                          letterSpacing: 1.25,
                          fontWeight: FontWeight.bold)),
                  content: const Text('Your password has been changed',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600)),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                            NavigateToPageEvent(route: AppRouter.loginScreen));
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.black87, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          child: SingleChildScrollView(
            child: Container(
              height: size.height,
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: size.width * .07),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getResetPasswordHeadline(),
                  getResetPasswordForm(),
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
                text: "Remember your password ? ",
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

  Container getResetPasswordForm() {
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
          children: [
            Center(
              child: Text(
                'Input your new password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey.shade900,
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            GetUserInput(
                label: 'Password',
                hint: "You new password",
                isPassword: true,
                controller: _passwordController,
                validator: Validation.passwordValidation),
            SizedBox(
              height: 15.h,
            ),
            GetUserInput(
                label: 'Confirm Password',
                hint: "",
                isPassword: true,
                validator: (value) => value == _passwordController.text
                    ? null
                    : "Passwords do not match"),
            SizedBox(
              height: 20.h,
            ),
            //verify button
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<ResetPasswordBloc>().add(
                      ResetPasswordSubmitted(_passwordController.value.text));
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
                "Update password",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding getResetPasswordHeadline() {
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
            TextSpan(text: "Resetting your\n"),
            TextSpan(
              text: "Password !",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 42),
            )
          ],
        ),
      ),
    );
  }

  Future<String?> _getDialog(
      String? content, String? header, void Function()? func) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actionsAlignment: MainAxisAlignment.center,
        title: Text(header ?? 'Error !',
            textAlign: TextAlign.center,
            style: const TextStyle(
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
}
