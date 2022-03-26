import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';
import 'package:imagecaptioning/src/controller/email_confirmation/email_confirmation_bloc.dart';
import 'package:imagecaptioning/src/utils/validations.dart';

import '../../app/routes.dart';
import '../theme/style.dart';

class EmailConfirmationScreen extends StatefulWidget {
  const EmailConfirmationScreen({Key? key}) : super(key: key);

  @override
  _EmailConfirmationScreenState createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen> {
  final _codeController = TextEditingController();
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
        body: BlocListener<EmailConfirmationBloc, EmailConfirmationState>(
          listener: (context, state) {
            if (state.formStatus is FormSubmissionSuccess) {
              Map<String, dynamic> args = {
                "userId": state.userId,
              };
              Navigator.pushNamed(context, AppRouter.resetPasswordScreen, arguments: args);
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
                  getEmailConfirmationHeadline(),
                  getEmailConfirmationForm(),
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

  Container getEmailConfirmationForm() {
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
                'An activation code will be sent',
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
            TextFormField(
              controller: _codeController,
              validator: Validation.blankValidation,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                hintText: 'XXXXXX',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            //verify button
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<EmailConfirmationBloc>().add(
                      EmailConfirmationSubmitted(_codeController.value.text));
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
                "Verify",
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            //Resend button
            BlocBuilder<EmailConfirmationBloc, EmailConfirmationState>(
              builder: (context, state) {
                return AbsorbPointer(
                          absorbing: state.absorbing,
                          child: TextButton(
                            onPressed: () {
                              context.read<EmailConfirmationBloc>().add(const EmailConfirmationResendButtonPushed());
                            },
                            style: TextButton.styleFrom(
                                fixedSize: Size(size.width * .94, 55),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                backgroundColor: Colors.grey.shade200,
                                alignment: Alignment.center,
                                primary: Colors.black87,
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            child: Text(
                              state.absorbing ? "Please wait for a few seconds" : "Resend code",
                            ),
                          ),
                        );
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding getEmailConfirmationHeadline() {
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
            TextSpan(text: "Confirming your\n"),
            TextSpan(
              text: "Account!",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 42),
            )
          ],
        ),
      ),
    );
  }
}
