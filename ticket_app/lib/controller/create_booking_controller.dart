import 'package:fluent_validation/models/validation_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_app/data/model/city.dart';
import 'package:ticket_app/data/model/create_reservation.dart';
import 'package:ticket_app/data/model/customer_address.dart';
import 'package:ticket_app/data/model/price_online_request.dart';
import 'package:ticket_app/data/model/reservation.dart';
import 'package:ticket_app/data/model/schedule.dart';
import 'package:ticket_app/data/model/service_type.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/town.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/routes/app_pages.dart';
import 'package:ticket_app/utils/Validators/create_reservation_validator.dart';

class CreateBookingController extends GetxController with StateMixin {
  final ApiService apiService = Get.find<ApiService>();
  var service = [
    ServiceType(id: 1, name: 'Travels'),
    ServiceType(id: 2, name: 'Services'),
  ];
  var states = <StateModel>[];
  var customerAddressTo = <CustomerAddress>[];
  var customerAddressFrom = <CustomerAddress>[];
  var townsFrom = <Town>[];
  var townsTo = <Town>[];
  var citiesFrom = <City>[];
  var citiesTo = <City>[];
  var schedule = <Schedule>[];
  var activeStep = 0.obs;
  var title = 'Create Booking';
  Rx<CreateReservation> createReservation =
      CreateReservation(customerId: 0).obs;
  var active = true.obs;
  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.success());
    createReservation = ((Get.arguments as CreateReservation)).obs;
    if (createReservation.value.travel != null) {
      title = '${createReservation.value.travel?.route}';
    }
    loadData();
  }

  void loadData() async {
    change(null, status: RxStatus.loading());
    try {
      await getStates();
      if (createReservation.value.travel != null) {
        active = false.obs;
        await getCities(createReservation.value.fromSate!.idState)
            .then((value) {
          citiesFrom = value;
        });
        await getCities(createReservation.value.toState!.idState).then((value) {
          citiesTo = value;
        });
      }
      await getSchedule();
    } catch (e) {
      //print(e.toString());
    }
    change(null, status: RxStatus.success());
  }

  Future<void> getSchedule() async {
    var schedule = await apiService.getSchedule();
    this.schedule = schedule;
  }

  Future<void> createBooking() async {}
  Future<void> getStates() async {
    var fetchedStates = await apiService.getStates();
    states = fetchedStates.toSet().toList();
  }

  Future<List<Town>> getTowns(int idTown) async {
    var fetchedTowns = await apiService.getTown(idTown);

    // Eliminar duplicados basados en el ID
    return fetchedTowns.toSet().toList();
  }

  Future<List<City>> getCities(String idState) async {
    var fetchedCities = await apiService.getCity(idState);

    // Eliminar duplicados basados en el ID
    return fetchedCities.toSet().toList();
  }

  Future<void> getCustomerAddress(String customerId) async {
    await apiService.getCustomerAddress(customerId);
  }

  onChangeServiceType(int p1) {
    createReservation.update((val) {
      val!.serviceType = p1;
    });
  }

  onChangeHour(Schedule? p1) {
    createReservation.update((val) {
      val!.hour = p1;
    });
  }

  onChangeFromState(StateModel? idstate) async {
    townsFrom.clear();
    citiesFrom.clear();
    citiesFrom = await getCities(idstate!.idState);
    createReservation.update((val) {
      val!.fromSate = idstate;
      val.fromCity = null;
      val.fromTown = null;
    });
  }

  onChangeFromCity(City? idCity) async {
    townsFrom.clear();
    townsFrom = await getTowns(idCity!.idCity);
    createReservation.update((val) {
      val!.fromCity = idCity;
      val.fromTown = null;
    });
  }

  onChangeToCity(City? idCity) async {
    townsTo.clear();
    townsTo = await getTowns(idCity!.idCity);

    createReservation.update((val) {
      val!.toCity = idCity;
      val.toTown = null;
    });
  }

  onChangeToState(StateModel? idstate) async {
    townsTo.clear();
    citiesTo.clear();
    citiesTo = await getCities(idstate!.idState);
    createReservation.update((val) {
      val!.toState = idstate;
      val.toCity = null;
      val.toTown = null;
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

  onFromTown(Town? p1) {
    createReservation.update((val) {
      val!.fromTown = p1;
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

  onToTown(Town? p1) {
    createReservation.update((val) {
      val!.toTown = p1;
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

  void nextStep() async {
    if (activeStep.value == 1) {
      await complete();
      return;
    }
    if (activeStep.value == 0) {
      if (!validReservation()) {
        return;
      }

      var value = await calculatePrice();
      if (!value) {
        return;
      }
      activeStep.value++;
    }
  }

  void backStep() {
    if (activeStep.value > 0) {
      activeStep.value--;
    }
  }

  Future<void> complete() async {
    var complete = await tryCreateReservation();
    if (complete == null) {
      return;
    }
    var pay = await Get.dialog<bool>(AlertDialog(
      title: const Text('Alert'),
      content: const Text('Do you want to pay now?'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: false);
          },
          child: const Text('Pay later'),
        ),
        TextButton(
          onPressed: () => {
            Get.back(result: true),
          },
          child: const Text('Pay now'),
        ),
      ],
    ));
    if (pay == null) {
      return;
    }
    if (pay) {
      var result = await Get.toNamed(Routes.PAYMENT, arguments: complete);
      if (result != null) {
        if (result) {
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.offAllNamed(Routes.HOME);
        }
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }

  Future<Reservation?> tryCreateReservation() async {
    try {
      EasyLoading.show(status: 'Loading...');
      var result = await apiService.createReservation(createReservation.value);
      if (result == null) {
        EasyLoading.dismiss(animation: true);
        Get.dialog(AlertDialog(
          title: const Text('Alert'),
          content:
              const Text('Unable to create the reservation, please try again'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        ));
        return null;
      }
      EasyLoading.dismiss(animation: true);
      return result;
    } catch (e) {
      EasyLoading.dismiss(animation: true);
      Get.dialog(AlertDialog(
        title: const Text('Alert'),
        content:
            const Text('Unable to complete the operation, please try again'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ));
      return null;
    }
  }

  Future<bool> calculatePrice() async {
    try {
      EasyLoading.show(status: 'Loading...');
      final priceOnlineRequest = PriceOnlineRequest(
        travel: createReservation.value.travel!.travelNumber,
        townFrom: createReservation.value.fromTown!.idTown,
        townTo: createReservation.value.toTown!.idTown,
        customer: createReservation.value.customerId,
        passengerNumber: createReservation.value.passengerCount!,
        stateFrom: createReservation.value.fromSate!.idState,
        cityFrom: createReservation.value.fromCity!.idCity,
        zipCodeFrom: createReservation.value.fromZipCode!,
        stateTo: createReservation.value.toState!.idState,
        cityTo: createReservation.value.toCity!.idCity,
        zipCodeTo: createReservation.value.toZipCode!,
        bag: createReservation.value.bagsCount!,
      );
      var price = await apiService.calculatePrice(priceOnlineRequest);
      if (price == null) {
        EasyLoading.dismiss(animation: true);
        Get.dialog(AlertDialog(
          title: const Text('Alert'),
          content:
              const Text('Unable to calculate the price, please try again'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        ));
        return false;
      }
      createReservation.update((val) {
        val!.price = price.priceWithDiscount;
        val.fromFullAddress =
            '${val.fromAddressLine1}, ${val.fromAddressLine2} ${val.fromZipCode}';
        val.toFullAddress =
            '${val.toAddressLine1}. ${val.toAddressLine2}, ${val.toZipCode}';
      });
      EasyLoading.dismiss(animation: true);
      return true;
    } catch (e) {
      EasyLoading.dismiss(animation: true);
      Get.dialog(AlertDialog(
        title: const Text('Alert'),
        content:
            const Text('Unable to complete the operation, please try again'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ));
      return false;
    }
  }

  bool validReservation() {
    final CreateReservationValidator createReservationValidator =
        CreateReservationValidator();
    final ValidationResult validationResult =
        createReservationValidator.validate(createReservation.value);

    if (validationResult.hasError) {
      Get.dialog(AlertDialog(
        title: const Text('Alert'),
        content: Text(validationResult.errors
            .map((x) => '${x.key} ${x.message}')
            .join('\n')),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ));
      return false;
    } else {
      return true;
    }
  }

  var disableAddress = false.obs;
  void onFromCustomerAddress(CustomerAddress? x) {
    disableAddress = (x?.idCustomerAddress ?? 0) > 0 ? false.obs : true.obs;
    createReservation.update((val) {
      val!.idCustomerAddress = x?.idCustomerAddress;
      val.fromAddressLine1 = x?.addressLine1;
      val.fromAddressLine2 = x?.addressLine2;
    });
  }

  void onToCustomerAddress(CustomerAddress? x) {
    createReservation.update((val) {
      val!.idCustomerAddressTo = x?.idCustomerAddress;
      val.toAddressLine1 = x?.addressLine1;
      val.toAddressLine2 = x?.addressLine2;
    });
  }
}
