import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/custom_theme.dart';
import 'package:ticket_app/ui/widgets/LayoutBuilderWidget.dart';
import 'package:ticket_app/ui/widgets/circle_shape.dart';
import 'package:ticket_app/utils/gaps.dart';
import 'package:ticket_app/utils/utils.dart';

class TicketView extends StatelessWidget {
  final Map<String, dynamic> ticket;

  const TicketView({super.key, required this.ticket});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 20.sp),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(ticket['StateFrom'],
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                RoundShape(
                  shapeColor: CustomTheme.secondColor,
                ),
                Expanded(
                    child: Stack(
                  children: [
                    const SizedBox(
                      height: 24,
                      child: LayoutBuilderWidget(
                        sections: 6,
                        color: Colors.black,
                        width: 5,
                      ),
                    ),
                    Transform.rotate(
                        angle: 0,
                        child: Center(
                            child: Icon(
                          Icons.airport_shuttle,
                          color: CustomTheme.primaryLightColor,
                        ))),
                  ],
                )),
                RoundShape(
                  shapeColor: CustomTheme.secondColor,
                ),
                Spacer(),
                Text(ticket['StateTo'],
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(
                height: 20.sp,
                width: 15.sp,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: CustomTheme.secondColor,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10))),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext buildContext,
                      BoxConstraints boxConstraints) {
                    return Flex(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        direction: Axis.horizontal,
                        children: List.generate(
                            (boxConstraints.constrainWidth() / 15).floor(),
                            (index) => SizedBox(
                                width: 5,
                                height: 1,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: CustomTheme.primaryLightColor),
                                ))));
                  },
                ),
              ),
              SizedBox(
                height: 20.sp,
                width: 15.sp,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: CustomTheme.secondColor,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10))),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(formatDate(ticket['DepartureDate']),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          Text('Depearture Date',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Text(formatTime(ticket['DepartureDate']),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          Text('Depearture time',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.black26,
                        ),
                        Text(ticket['Employee'],
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.directions_bus, color: Colors.black26),
                        Text(ticket['Vehicle'],
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.local_activity, color: Colors.redAccent),
                        Text(ticket['SeatsAvailable'],
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.redAccent)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
