import 'package:flutter/material.dart';

class LoadScreen extends StatefulWidget {
  const LoadScreen({Key? key}) : super(key: key);

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/ISMAIA.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            children: const [
              CircularProgressIndicator(
                color: Colors.black87,
              ),
              Text(
                'Loading ...',
                style: TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          )),
    );
  }
}
