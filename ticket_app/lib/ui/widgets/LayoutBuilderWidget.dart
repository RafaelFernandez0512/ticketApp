import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LayoutBuilderWidget extends StatelessWidget {
  const LayoutBuilderWidget(
      {super.key, this.sections = 1, this.color, this.width = 3});
  final int sections;
  final Color? color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // print("he width is ${constraints.constrainWidth()}");
      return Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              (constraints.constrainWidth() / sections).floor(),
              (index) => SizedBox(
                    height: 1,
                    width: width,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: color ?? Colors.black,
                      ),
                    ),
                  )));
    });
  }
}
