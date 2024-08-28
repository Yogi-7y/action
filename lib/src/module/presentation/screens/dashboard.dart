import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _backgroundColor = Color(0xff1e1e2e);
const _blue = Color(0xff89b4fa);
const _maroon = Color(0xffeba0ac);
const _mauve = Color(0xffcba6f7);
const _rosewater = Color(0xfff5e0dc);
const _surface0 = Color(0xff313244);
const _textColor = Color(0xffcdd6f4);
const _subText0Color = Color(0xffa6adc8);
const _subText1Color = Color(0xffbac2de);
const _yellow = Color(0xfff9e2af);

@immutable
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(top: mediaQuery.padding.top),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Text(
                  'Inbox',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 12),
                  children: const [
                    TodoTile(isCompleted: false),
                    SizedBox(height: 20),
                    TodoTile(isCompleted: true),
                  ],
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: _surface0,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: List.generate(
                          5,
                          (index) => Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: _surface0,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                'A',
                                style: TextStyle(
                                  color: _textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  ClipPath(
                    clipper: ShapeBorderClipper(
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(36),
                      ),
                    ),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        // color: _mauve,
                        // color: _yellow,
                        // color: _blue,
                        color: _maroon,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class TodoTile extends StatelessWidget {
  const TodoTile({
    required this.isCompleted,
    super.key,
  });

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            margin: const EdgeInsets.only(top: 4),
            decoration: ShapeDecoration(
              color: isCompleted ? _rosewater : null,
              shape: SmoothRectangleBorder(
                side: const BorderSide(
                  color: _rosewater,
                  width: 1.5,
                ),
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 6,
                  cornerSmoothing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Call John and ask about X',
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.hardware_outlined,
                          color: _rosewater,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Project Name',
                          style: TextStyle(
                            color: _subText1Color,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.label_outline_rounded,
                          color: _rosewater,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Context',
                          style: TextStyle(
                            color: _subText1Color,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      '2d Ago',
                      style: TextStyle(
                        color: _subText1Color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
