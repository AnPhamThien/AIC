import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/routes.dart';
import '../../controller/auth/auth_bloc.dart';
import '../../controller/auth/form_submission_status.dart';
import '../../controller/verification/verification_bloc.dart';
import '../../utils/func.dart';
import '../../utils/validations.dart';
import '../theme/style.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _codeController = TextEditingController();
  final _formFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<VerificationBloc, VerificationState>(
      listenWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
      listener: (context, state) {
        final status = state.formStatus;
        if (status is ErrorStatus) {
          //TODO: show error using status.exception.toString();
          String errorMessage = getErrorMessage(status.exception.toString());
        } else if (state.formStatus is FormSubmissionSuccess) {
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
              content: const Text('Your account has been verified',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600)),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    context
                        .read<AuthBloc>()
                        .add(NavigateToPageEvent(route: AppRouter.loginScreen));
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
                  getVerifycationHeadline(),
                  getVerificationForm(),
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

  Container getVerificationForm() {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
      decoration: const BoxDecoration(
        color: bgWhite,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
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
            key: _formFieldKey,
            controller: _codeController,
            validator: Validation.codeValidation,
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
            onPressed: () => _formFieldKey.currentState!.validate()
                ? context
                    .read<VerificationBloc>()
                    .add(VerificationSubmitted(_codeController.text))
                : "Must not be empty",
            style: TextButton.styleFrom(
                fixedSize: Size(size.width * .94, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.black87,
                alignment: Alignment.center,
                primary: Colors.white,
                textStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            child: const Text(
              "Verify",
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          //Resend button
          BlocBuilder<VerificationBloc, VerificationState>(
            builder: (context, state) {
              return AbsorbPointer(
                  absorbing: state.absorbing,
                  child: TextButton(
                    onPressed: () {
                      context
                          .read<VerificationBloc>()
                          .add(const VerificationResendButtonPushed());
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
                    child: const Text(
                      "Resend code",
                    ),
                  ));
            },
          )
        ],
      ),
    );
  }

  Padding getVerifycationHeadline() {
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
