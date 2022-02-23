import 'package:flutter/material.dart';
import 'package:shoes/components/m_rec.dart';
import 'dart:math';

import 'package:shoes/model/shoe.dart';

// ignore: must_be_immutable
class BoxWidget extends StatelessWidget {
  BoxWidget({
    Key? key,
    required this.pageValue,
    required this.shoe,
  }) : super(key: key);

  final double pageValue;
  final Shoe shoe;

  Tween<double> animation = Tween<double>(begin: .35, end: 1);
  Tween<double> animationRow = Tween<double>(begin: .7, end: 1.5);
  double animationValue = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        buildBox(size),
        shoesInBox(size),
        buildBoxDoor(size),
        buildBoxDoorTop(size),
      ],
    );
  }

  Widget buildBox(Size size) {
    return CustomPaint(
      painter: MRec(),
      child: SizedBox(
        width: size.width,
        height: size.height,
      ),
    );
  }

  Widget shoesInBox(Size size) {
    return Stack(
      children: [
        Positioned(
          top: 250 + 50.0,
          left: size.width / 2 - 90,
          child: Image.asset(
            shoe.image,
            height: 90,
          ),
        ),
        Positioned(
          top: 255,
          left: size.width / 2 - 75,
          child: RotatedBox(
            quarterTurns: 2,
            child: Image.asset(
              shoe.image,
              height: 90,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBoxDoor(Size size) {
    animationValue = (shoe.index - pageValue).abs();
    return Positioned(
      top: 19,
      left: size.width / 2 - 232 / 2,
      child: Transform(
        origin: const Offset(0, 100),
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(1, 2, .001)
          ..rotateX(
            pi * animation.transform(animationValue),
          )
          ..scale(.9 + .1 * (1 - animationValue), 1.0),
        child: Center(
          child: Container(
            width: 232,
            height: 200,
            color: animation.transform(animationValue) < .5
                ? Colors.orange.shade200
                : Colors.orange,
            child: animation.transform(animationValue) < .5
                ? Container()
                : Center(
                    child: Transform(
                      transform: Matrix4.identity()
                        ..translate(0.0, 100.0)
                        ..rotateX(pi * 3),
                      child: Image.asset(
                        'assets/adidas.png',
                        height: 100,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildBoxDoorTop(Size size) {
    return Positioned(
      top: 50,
      left: size.width / 2 - 285 / 2,
      child: Transform(
        alignment: FractionalOffset.bottomCenter,
        transform: Matrix4.identity()
          ..setEntry(3, 2, .0008)
          ..translate(0.0, 380 * animationValue)
          ..scale(
              .9 + .1 * (1 - animationValue), .9 + .1 * (1 - animationValue))
          ..rotateX(pi * animationRow.transform(animationValue)),
        child: Center(
          child: Container(
            width: 285,
            height: 60,
            color: Colors.orange,
          ),
        ),
      ),
    );
  }
}
