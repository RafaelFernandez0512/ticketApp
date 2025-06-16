import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/custom_theme.dart';
import 'package:ticket_app/data/model/reservation.dart';
import 'package:ticket_app/ui/bookings/payments/payment_sheet_modal.dart';
import 'package:ticket_app/ui/bookings/payments/payment_web.dart';
import 'package:ticket_app/ui/widgets/LayoutBuilderWidget.dart';
import 'package:ticket_app/ui/widgets/base_64_image_with_fallback.dart';
import 'package:ticket_app/ui/widgets/circle_shape.dart';
import 'package:ticket_app/ui/widgets/custom_button.dart';
import 'package:ticket_app/utils/gaps.dart';
import 'package:ticket_app/utils/notification_type.dart';
import 'package:ticket_app/utils/utils.dart';

class MyTicketReservationView extends StatelessWidget {
  final Reservation ticket;
  final void Function()? onTapPayment;
  final void Function()? onTapReceive;
  const MyTicketReservationView(
      {super.key,
      required this.ticket,
      required this.onTapPayment,
      required this.onTapReceive});

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
          if (ticket.status?.idReservationStatus == 'CO' ||
              ticket.status?.idReservationStatus == 'I')
            Column(
              children: [
                Text('Pending to pay',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700, color: Colors.redAccent)),
                Divider(
                  color: Colors.redAccent,
                  thickness: 2,
                )
              ],
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Text(ticket.stateFrom?.name ?? '',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      Text(ticket.cityFrom?.name ?? '',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: CustomTheme.primaryLightColor)),
                      Text(ticket.townFrom?.name ?? '',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontSize: 12,
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
                     SizedBox(
                      height: 24,
                      child: LayoutBuilderWidget(
                        sections: 6,
                        color: Colors.black,
                        width: 5.sp,
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
                      Text(ticket.stateTo?.name ?? '',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      Text(ticket.cityTo?.name ?? '',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: CustomTheme.primaryLightColor)),
                      Text(ticket.townTo?.name ?? '',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontSize: 12,
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
                    child: Text('\$${ticket.amount?.toStringAsFixed(2)}',
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
                          Text(
                              formatDate(
                                  ticket.departureDate!.toIso8601String()),
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
                          Text(
                              formatTime(
                                  ticket.departureDate!.toIso8601String()),
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
                        visible: ticket.description != null,
                        child: Row(
                          children: [
                            gapW8,
                            Text('Description:',
                                style: Theme.of(context).textTheme.titleMedium),
                            gapW12,
                            Text(ticket.description.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: ticket.items != null,
                        child: Row(
                          children: [
                            gapW8,
                            Text('Item:',
                                style: Theme.of(context).textTheme.titleMedium),
                            gapW12,
                            Text(ticket.items?.description ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: ticket.quantity != null,
                        child: Row(
                          children: [
                            gapW8,
                            Text('Quantity:',
                                style: Theme.of(context).textTheme.titleMedium),
                            gapW12,
                            Text(ticket.quantity.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: ticket.passengerNumber != null,
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
                            Text(ticket.passengerNumber.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: ticket.bag != null,
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
                            Text(ticket.bag.toString(),
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
                            child: Text(
                                '${ticket.addressLine1From},${ticket.addressLine2From}',
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
                            child: Text(
                                '${ticket.addressLine1To},${ticket.addressLine2To}',
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.black26,
                              ),
                              Text(ticket.travel?.employee?.fullName ?? '',
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
                              const Icon(Icons.directions_bus,
                                  color: Colors.black26),
                              Text(ticket.travel?.vehicle?.name ?? '',
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
                              const Icon(Icons.qr_code,
                                  color: Colors.redAccent),
                              Text(ticket.travel?.travelNumber.toString() ?? '',
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
                const Divider(),
                status(context, ticket),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget status(BuildContext context, Reservation reservation) {
    switch (reservation.status?.idReservationStatus) {
      case 'CA' || 'X':
        return Text('Canceled',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700, color: Colors.redAccent));
      case 'CO' || 'I':
        return Visibility(
          visible: reservation.amount != null &&
              reservation.amount! > 0,
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                    label: 'Pay',
                    type: NotificationType.success,
                    icon: const Icon(
                      Icons.payments,
                      color: Colors.white,
                    ),
                    onPressed: onTapPayment),
              ),
            ],
          ),
        );
      case 'PA' || 'P':
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('PAID',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF60C664))),
            Visibility(
              visible: reservation.serviceType == 0,
              child: Column(
                children: [
                  gapH12,
                  CustomButton(
                    label: 'Tap to view',
                    icon: const Icon(
                      Icons.receipt_long,
                      color: Colors.white,
                    ),
                    onPressed: onTapReceive,
                  )
                ],
              ),
            ),
          ],
        );
      default:
        return Text(reservation.status?.description ?? '',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700));
    }
  }
}
