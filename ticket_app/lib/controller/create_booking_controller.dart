//create controller for create booking
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_app/data/model/create_reservation.dart';
import 'package:ticket_app/data/model/customer_address.dart';
import 'package:ticket_app/data/model/schedule.dart';
import 'package:ticket_app/data/model/service_type.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/town.dart';
import 'package:ticket_app/data/model/travel.dart';
import 'package:ticket_app/data/service/api_service.dart';

class CreateBookingController extends GetxController with StateMixin {
  final ApiService apiService = Get.find<ApiService>();
  var service = [
    ServiceType(id: 1, name: 'Travels'),
    ServiceType(id: 2, name: 'Services'),
  ];
  var states = <StateModel>[];
  var customerAddress = <CustomerAddress>[];
  var towns = <Town>[];
  var schedule = <Schedule>[];
  var activeStep = 0.obs;

  var createReservation = CreateReservation().obs;

  var summaries = <MapEntry<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.success());
    createReservation = ((Get.arguments as CreateReservation)).obs;
    loadData();
  }

  void loadData() async {
    change(null, status: RxStatus.loading());
    try {
      await getStates();
      await getTowns(createReservation.value.idFromSate!);
      await getTowns(createReservation.value.idToSate!);
      await getCustomerAddress(createReservation.value.customerId!);
    } catch (e) {
      //print(e.toString());
    }
    change(null, status: RxStatus.success());
  }

  Future<void> createBooking() async {}
  Future<void> getStates() async {
    var states = await apiService.getStates();
    this.states = states;
  }

  Future<void> getTowns(String idState) async {
    var towns = await apiService.getTown(idState);
    this.towns = towns;
  }

  Future<void> zipCode(String zipCode) async {
    await apiService.getZipCode(zipCode);
  }

  Future<void> getCustomerAddress(String customerId) async {
    await apiService.getCustomerAddress(customerId);
  }

  onChangeServiceType(int p1) {
    createReservation.update((val) {
      val!.serviceType = p1;
    });
  }

  onChangeHour(String p1) {
    createReservation.update((val) {
      val!.hour = p1;
    });
  }

  onChangeFromState(String? idstate) {
    createReservation.update((val) {
      val!.idFromSate = idstate;
    });
  }

  onChangeToState(String? idstate) {
    createReservation.update((val) {
      val!.idToSate = idstate;
    });
  }

  onChangedDate(DateTime? date) {
    createReservation.update((val) {
      val!.date = date;
    });
  }

  onFromChangedAddressLine1(String p1) {
    createReservation.update((val) {
      val!.fromAddressLine1 = p1;
    });
  }

  onFromChangedAddressLine2(String p1) {
    createReservation.update((val) {
      val!.fromAddressLine2 = p1;
    });
  }

  onFromTown(String? p1) {
    createReservation.update((val) {
      val!.idFromTown = p1;
    });
  }

  onFromZipCode(String? p1) {
    createReservation.update((val) {
      val!.fromZipCode = p1;
    });
  }

  onToChangedAddressLine1(String? p1) {
    createReservation.update((val) {
      val!.toAddressLine1 = p1;
    });
  }

  onToChangedAddressLine2(String? p1) {
    createReservation.update((val) {
      val!.toAddressLine2 = p1;
    });
  }

  onToTown(String? p1) {
    createReservation.update((val) {
      val!.idToTown = p1;
    });
  }

  onToZipCode(String? p1) {
    createReservation.update((val) {
      val!.toZipCode = p1;
    });
  }

  void onChangedBagsCount(num x) {
    createReservation.update((val) {
      val!.bagsCount = x.toInt();
    });
  }

  void onChangedPassengerCount(num x) {
    createReservation.update((val) {
      val!.passengerCount = x.toInt();
    });
  }

  void nextStep() {
    if (activeStep.value == 0) {
      activeStep.value++;
    }
  }
}
