import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/presentation/widgets/get_user_input_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
        body: SingleChildScrollView(
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
          Navigator.of(context).pushNamed(AppRouter.loginScreen);
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
          const GetUserInput(
              label: 'Password', hint: "You new password", isPassword: true),
          SizedBox(
            height: 15.h,
          ),
          const GetUserInput(
              label: 'Confirm Password', hint: "", isPassword: true),
          SizedBox(
            height: 20.h,
          ),
          //verify button
          TextButton(
            onPressed: () => showDialog<String>(
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
                      Navigator.of(context).pushNamed(AppRouter.loginScreen);
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
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
              "Update password",
            ),
          ),
        ],
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
}
