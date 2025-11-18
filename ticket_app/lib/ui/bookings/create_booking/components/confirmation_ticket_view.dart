import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/custom_theme.dart';
import 'package:ticket_app/data/model/create_reservation.dart';
import 'package:ticket_app/ui/widgets/LayoutBuilderWidget.dart';
import 'package:ticket_app/ui/widgets/base_64_image_with_fallback.dart';
import 'package:ticket_app/ui/widgets/circle_shape.dart';
import 'package:ticket_app/utils/gaps.dart';
import 'package:ticket_app/utils/utils.dart';

class ConfirmationTicketView extends StatelessWidget {
  final CreateReservation ticket;

  const ConfirmationTicketView({super.key, required this.ticket});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 20.sp),
      color: Colors.white,
      child: Column(
        children: [
          Visibility(
            visible: ticket.photo != null,
            child: Base64ImageWithFallback(
                base64String: ticket.photo, height: 45.sp, width: 70.sp),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Text(ticket.fromSate?.name ?? '',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      Text(ticket.fromCity?.name ?? '',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: CustomTheme.primaryLightColor)),

                    ],
                  ),
                ),
                gapW12,
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
                Flexible(
                  child: Column(
                    children: [
                      Text(ticket.toState?.name ?? '',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      Text(ticket.toCity?.name ?? '',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: CustomTheme.primaryLightColor)),

                    ],
                  ),
                ),
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
                //price
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: Center(
                    child: Text('\$${ticket.price?.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            )),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(formatDate(ticket.date!.toIso8601String()),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          Text('Depearture Date',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Text(formatTime(ticket.date!.toIso8601String()),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          Text('Depearture time',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 8,
                    children: [
                      Visibility(
                        visible: ticket.serviceType == 0,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.black26,
                            ),
                            gapW8,
                            Text('Passengers:',
                                style: Theme.of(context).textTheme.titleMedium),
                            gapW12,
                            Text(ticket.passengerCount.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: ticket.serviceType == 0,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.work,
                              color: Colors.brown,
                            ),
                            gapW8,
                            Text('Bags:',
                                style: Theme.of(context).textTheme.titleMedium),
                            gapW8,
                            Text(ticket.bagsCount.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: ticket.serviceType == 1,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_box,
                              color: Colors.grey,
                            ),
                            gapW8,
                            Text('Quantity:',
                                style: Theme.of(context).textTheme.titleMedium),
                            gapW8,
                            Text(ticket.quantity.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.person_pin,
                            color: Colors.red,
                          ),
                          gapW8,
                          Text('Address from:',
                              style: Theme.of(context).textTheme.titleMedium),
                          gapW8,
                          Flexible(
                            child: Text(ticket.fromFullAddress.toString(),
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.pin_drop,
                            color: Colors.red,
                          ),
                          gapW8,
                          Text('Address to:',
                              style: Theme.of(context).textTheme.titleMedium),
                          gapW8,
                          Flexible(
                            child: Text(ticket.toFullAddress.toString(),
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: ticket.serviceType == 1,
                        child: Row(
                          children: [
                            gapW8,
                            Text('Description:',
                                style: Theme.of(context).textTheme.titleMedium),
                            gapW8,
                            Text(ticket.description.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
