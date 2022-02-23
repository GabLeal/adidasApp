import 'package:flutter/material.dart';
import 'package:shoes/components/box_widget.dart';
import 'package:shoes/model/shoe.dart';
import 'package:shoes/pages/splash_adidas.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double pageValue = 0.0;
  PageController pageController = PageController();

  List<Shoe> shoes = [
    Shoe(
      index: 0,
      image: 'assets/nmd.png',
      name: 'NMD',
      color: 'R1 LOGO',
      price: 803.16,
      rate: 4.3,
    ),
    Shoe(
      index: 1,
      image: 'assets/ozweego.png',
      name: 'Ozweego',
      color: 'Chalk White',
      price: 599.99,
      rate: 4.6,
    ),
    Shoe(
      index: 2,
      image: 'assets/sand_taupe.png',
      name: 'Yeezy Bost 350',
      color: 'Sand Taupe',
      price: 1900.0,
      rate: 4.3,
    ),
  ];

  late Shoe currentShoe;
  int currentIndex = 0;
  double animation = 0.0, opacity = 0.0;

  var cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: const [.3, 1],
    colors: [
      Colors.grey.shade300.withOpacity(0.85),
      Colors.white,
    ],
  );

  late AnimationController animationController;
  late Animation<double> sizeAnimation;

  late Animation<Color?> colorsAnimation;

  bool status = false;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    sizeAnimation = TweenSequence(
      [
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 30, end: 50),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 50, end: 30),
          weight: 50,
        ),
      ],
    ).animate(animationController);

    colorsAnimation = ColorTween(begin: Colors.white, end: Colors.orange)
        .animate(animationController);

    animationController.addListener(() {
      if (animationController.status == AnimationStatus.completed) {
        status = true;
      } else {
        status = false;
      }
    });

    pageController.addListener(() {
      setState(() {
        pageValue = pageController.page!;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          buildCard(size),
          buildPagerView(),
          buildCartButton(size),
          const SplashAdidas()
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/adidas.png',
              width: 80,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPagerView() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: PageView(
        controller: pageController,
        children: shoes.map((shoe) {
          return BoxWidget(
            shoe: shoe,
            pageValue: pageValue,
          );
        }).toList(),
      ),
    );
  }

  Widget buildCard(Size size) {
    if ((currentIndex - pageValue).abs().toInt() > 0) {
      currentIndex = pageValue.toInt();
    }
    currentShoe = shoes[currentIndex];
    opacity = 0;
    opacity = 1 - animation.abs();
    animation = currentIndex - pageValue;
    if (animation.abs() > .5) {
      int sign = animation > 0 ? 1 : -1;
      animation = (1 - animation * sign) * -1 * sign;
      opacity = 1 - animation.abs();
      if (animation > 0) {
        currentShoe = shoes[currentIndex + 1];
      } else {
        currentShoe = shoes[currentIndex - 1];
      }
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.all(50),
        height: size.height - 300,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: cardGradient,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 300,
            ),
            Text(
              'SHOE',
              style: TextStyle(
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            animateWidget(
              distance: 200,
              child: Text(
                currentShoe.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            animateWidget(
              child: Text(
                currentShoe.color,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            animateWidget(
              child: Text(
                '\$ ${currentShoe.price}',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            buildRateFaceRow(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget animateWidget({required Widget child, double distance = 100}) {
    return Transform(
      transform: Matrix4.identity()..translate(distance * animation),
      child: Opacity(
        opacity: opacity,
        child: child,
      ),
    );
  }

  Widget buildRateFaceRow() {
    return Row(
      children: [
        const SizedBox(
          width: 20,
        ),
        buildContainerBorder(
          child: animateWidget(
            distance: 30,
            child: Text(
              currentShoe.rate.toString(),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Spacer(),
        buildContainerBorder(
          child: GestureDetector(
            onTap: () {
              //log('message');
            },
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: Colors.black54,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }

  Widget buildContainerBorder({required Widget child}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Center(
        child: child,
      ),
    );
  }

  buildCartButton(Size size) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        return Positioned(
          right: size.width / 2 - 35,
          bottom: 150 - 35,
          child: GestureDetector(
            onDoubleTap: () {
              status
                  ? animationController.reverse()
                  : animationController.forward();
            },
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
                color: Colors.black87,
              ),
              child: Center(
                child: Icon(
                  Icons.favorite_outlined,
                  color: colorsAnimation.value,
                  size: sizeAnimation.value,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
