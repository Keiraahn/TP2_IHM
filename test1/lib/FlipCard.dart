import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:math' as math;

class FlipCard extends StatefulWidget {
  final String cardNumber;
  final String cardName;
  final String year;
  final String month;
  final bool boolCvv;
  final String CVV;
  const FlipCard(this.cardNumber, this.cardName, this.year, this.month,
      this.boolCvv, this.CVV,
      {super.key});

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  final int fondCarte = math.Random().nextInt(15);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    if (widget.boolCvv) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.boolCvv != oldWidget.boolCvv) {
      _flipImage();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipImage() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  String formatCardNumber(String cardNumber) {
    StringBuffer formatted = StringBuffer();
    String cardNumberNoSpace = cardNumber.replaceAll(" ", "");
    if (getCardType(widget.cardNumber) == "amex") {
      var t = 0;
      for (var i = 0; i < cardNumberNoSpace.length; i++) {
        if (i == 4 || i == 10) {
          formatted.write(" ");
        }
        formatted.write(cardNumberNoSpace[i]);
        t++;
      }
      while (t < 15) {
        if (t == 4 || t == 10) {
          formatted.write(" ");
        }
        formatted.write("#");
        t++;
      }
    } else {
      var t = 0;
      for (var i = 0; i < cardNumberNoSpace.length; i++) {
        if (i % 4 == 0) {
          formatted.write(" ");
        }
        formatted.write(cardNumberNoSpace[i]);
        t++;
      }
      while (t < 16) {
        if (t % 4 == 0) {
          formatted.write(" ");
        }
        formatted.write("#");
        t++;
      }
    }
    return formatted.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        return Transform(
            // Appliquer l'effet miroir à 0.5 pour montrer l'autre image
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(math.pi * _flipAnimation.value),
            alignment: Alignment.center,
            child: _flipAnimation.value < 0.5
                ? Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset(
                          'assets/$fondCarte.jpeg',
                          width: 250,
                          height: 160,
                        ),
                      ),
                      Positioned(
                          left: 16,
                          right: 16,
                          top: 75,
                          bottom: 30,
                          child: Text(
                            formatCardNumber(
                                widget.cardNumber), //////////////////////////
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 19),
                          )),
                      Positioned(
                        left: 16,
                        top: 16,
                        child: Image.asset(
                          'assets/chip.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Positioned(
                          right: 16,
                          top: 12,
                          child: Image.asset(
                            'assets/${getCardType(widget.cardNumber)}.png',
                            width: 50,
                            height: 50,
                          )),
                      Positioned(
                          bottom: 16,
                          left: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Card Holder',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              Text(
                                widget.cardName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),

                              // Text
                            ],
                          )),
                      Positioned(
                          bottom: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Expiration date',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              Text(
                                '${widget.year}/${widget.month}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ))
                    ],
                  )
                : Transform(
                    transform: Matrix4.identity()..rotateY(math.pi),
                    alignment: Alignment.center,
                    child: Stack(clipBehavior: Clip.none, children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset(
                          'assets/$fondCarte.jpeg',
                          width: 250,
                          height: 160,
                        ),
                      ),
                      Positioned(
                          top: 20,
                          child: Container(
                            width: 250,
                            height: 25,
                            color: Colors.black,
                          )),
                      const Positioned(
                          top: 50,
                          right: 16,
                          child: Text(
                            'Cvv',
                            style: TextStyle(color: Colors.white),
                          )),
                      Positioned.fill(
                        child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 230,
                              height: 20,
                              color: Colors.white,
                              child: Text(
                                widget.CVV,
                                textAlign: TextAlign.right,
                              ),
                            )),
                      ),
                      Positioned(
                          right: 16,
                          bottom: 2,
                          child: Image.asset(
                            'assets/${getCardType(widget.cardNumber)}.png',
                            width: 60,
                            height: 60,
                          )),
                    ])));
      },
    );
  }
}

class CreditCardImage extends StatelessWidget {
  final String cardNumber;

  const CreditCardImage({Key? key, required this.cardNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String cardType = getCardType(cardNumber);
    String imagePath = 'assets/$cardType.png';

    return Stack(
      children: [
        Positioned(
          right: 16,
          top: 20,
          child: Image.asset(
            imagePath,
            width: 60,
            height: 40,
          ),
        ),
      ],
    );
  }
}
