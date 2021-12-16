import 'package:flutter/material.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';

//* title của appbar
class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

//* 7 màu
class RadiantGradientMask extends StatelessWidget {
  const RadiantGradientMask({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: [0.2, 0.3, 0.35, 0.4, 0.5, 0.65, 0.8],
        colors: bgStoryColors,
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}

class SheetLine extends StatelessWidget {
  const SheetLine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 15,
      child: Center(
        child: Container(
          width: 45,
          height: 5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.black87.withOpacity(.7),
          ),
        ),
      ),
    );
  }
}
