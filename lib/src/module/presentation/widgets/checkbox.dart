import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

import '../screens/dashboard.dart';

enum CheckboxState {
  todo,
  inprogress,
  completed,
}

@immutable
class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    required this.state,
    super.key,
  });

  final CheckboxState state;

  @override
  Widget build(BuildContext context) {
    const _height = 18.0;
    const _borderRadius = 6.0;
    const borderSmoothing = 1.0;

    final fillColor = state == CheckboxState.completed ? rosewater : null;
    final inProgress = state == CheckboxState.inprogress;

    return Stack(
      children: [
        Container(
          width: _height,
          height: _height,
          margin: const EdgeInsets.only(top: 4),
          decoration: ShapeDecoration(
            color: fillColor,
            shape: SmoothRectangleBorder(
              side: const BorderSide(
                color: rosewater,
                width: 1.5,
              ),
              borderRadius: SmoothBorderRadius(
                cornerRadius: _borderRadius,
                cornerSmoothing: borderSmoothing,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Visibility(
            visible: inProgress,
            child: Container(
              width: 18,
              height: _height / 2,
              margin: const EdgeInsets.only(top: 4),
              decoration: const ShapeDecoration(
                color: rosewater,
                shape: SmoothRectangleBorder(
                  side: BorderSide(
                    color: rosewater,
                    width: 1.5,
                  ),
                  borderRadius: SmoothBorderRadius.only(
                      bottomLeft: SmoothRadius(
                        cornerRadius: _borderRadius,
                        cornerSmoothing: borderSmoothing,
                      ),
                      bottomRight: SmoothRadius(
                        cornerRadius: _borderRadius,
                        cornerSmoothing: borderSmoothing,
                      )),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
