import 'package:flutter/material.dart';

class SplashAdidas extends StatefulWidget {
  const SplashAdidas({Key? key}) : super(key: key);

  @override
  _SplashAdidasState createState() => _SplashAdidasState();
}

class _SplashAdidasState extends State<SplashAdidas>
    with TickerProviderStateMixin {
  bool startShowLines = false;
  bool joinLines = false;
  bool hideLines = false;

  late AnimationController animationControllerIconAdidas;
  late Animation<double> sizeAnimationIconAdidas;

  void _configAnimations() {
    animationControllerIconAdidas = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    sizeAnimationIconAdidas = Tween<double>(
      begin: 30.0,
      end: 0.21,
    ).animate(
      CurvedAnimation(
        parent: animationControllerIconAdidas,
        curve: Curves.linearToEaseOut,
      ),
    );
  }

  void _initAnimations() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        startShowLines = true;
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        startShowLines = false;
        joinLines = true;
      });
    });

    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        hideLines = true;
      });
    });

    Future.delayed(const Duration(seconds: 5), () {
      animationControllerIconAdidas.forward();
    });
  }

  @override
  void initState() {
    super.initState();

    _configAnimations();
    _initAnimations();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: sizeAnimationIconAdidas,
            builder: (_, __) {
              return Transform(
                origin: sizeAnimationIconAdidas.value < 10
                    ? const Offset(0, -117.5)
                    : null,
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(sizeAnimationIconAdidas.value),
                child: Image.asset(
                  'assets/adidas.png',
                  color: Colors.black,
                ),
              );
            },
          ),
          Positioned(
            right: size.width / 2 - 3,
            bottom: 0,
            child: AnimatedContainer(
              curve: Curves.easeInCubic,
              duration: const Duration(milliseconds: 300),
              width: hideLines ? 0 : 6,
              height: startShowLines || joinLines ? size.height : 0,
              color: Colors.white,
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            top: 0,
            bottom: 0,
            left: startShowLines
                ? (size.width / 2 - 20)
                : joinLines
                    ? size.width / 2 - 3
                    : -10,
            child: Container(
              width: hideLines ? 0 : 6,
              height: double.infinity,
              color: Colors.white,
            ),
          ),
          AnimatedPositioned(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 600),
            top: 0,
            bottom: 0,
            right: startShowLines
                ? (size.width / 2 - 20)
                : joinLines
                    ? size.width / 2 - 3
                    : -10,
            child: Container(
              width: hideLines ? 0 : 6,
              height: double.infinity,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
