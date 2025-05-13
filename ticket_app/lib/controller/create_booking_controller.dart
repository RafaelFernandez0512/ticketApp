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
import 'package:ticket_app/ui/reservations/payment_sheet_modal.dart';
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
  var addressLine1From = '';
  var fromZipCode = '';
  var addressLine2From = '';
  var toAddressLine1 = '';
  var toAddressLine2 = '';
  var toZipCode = '';

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
    createReservation.value.bagsCount = 0;
    if (createReservation.value.travel != null) {
      title = '${createReservation.value.travel?.route}';
    }
    loadData();
  }

  void loadData() async {
    change(null, status: RxStatus.loading());
    try {
      // Start loading states in parallel
      final statesFuture = getStates();

      Future<void> fetchCitiesAndAddresses() async {
        if (createReservation.value.travel != null) {
          active = false.obs;

          final fromId = createReservation.value.fromSate!.idState;
          final toId = createReservation.value.toState!.idState;

          final addressFromFuture = apiService.getCustomerAddress(fromId);
          final addressToFuture = apiService.getCustomerAddress(toId);
          final citiesFromFuture = getCities(fromId);
          final citiesToFuture = getCities(toId);

          // Wait for all in parallel
          final results = await Future.wait<dynamic>([
            addressFromFuture,
            addressToFuture,
            citiesFromFuture,
            citiesToFuture,
          ]);

          customerAddressFrom = results[0];
          customerAddressTo = results[1];
          citiesFrom = results[2];
          citiesTo = results[3];
        }
      }

      // Run both in parallel
      await Future.wait([
        statesFuture,
        fetchCitiesAndAddresses(),
      ]);

      await getSchedule(); // This one depends on the others, so it's awaited after
    } catch (e) {
      // Optionally handle the error
      // print(e.toString());
    }
    change(null, status: RxStatus.success());
  }

  Future<void> getSchedule() async {
    schedule = [createReservation.value.travel!.schedule!];
    createReservation.value.hour = schedule.firstOrNull;
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

  onChangeServiceType(int p1) {
    createReservation.update((val) {
      val!.serviceType = p1;
    });
  }

  onChangeHour(Schedule? p1) {
    createReservation.update((val) {
      val!.hour = p1;
      if (val.date != null && p1 != null) {
        val.date = val.date!.add(p1.hourDumin.toLocal().timeZoneOffset);
      }
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
    addressLine1From = p1;
  }

  onFromChangedAddressLine2(String p1) {
    addressLine2From = p1;
  }

  onFromTown(Town? p1) {
    createReservation.update((val) {
      val!.fromTown = p1;
    });
  }

  onFromZipCode(String? p1) {
    fromZipCode = p1 ?? '';
  }

  onToChangedAddressLine1(String? p1) {
    toAddressLine1 = p1 ?? '';
  }

  onToChangedAddressLine2(String? p1) {
    toAddressLine2 = p1 ?? '';
  }

  onToTown(Town? p1) {
    createReservation.update((val) {
      val!.toTown = p1;
    });
  }

  onToZipCode(String? p1) {
    toZipCode = p1 ?? '';
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

  void nextStep(BuildContext context) async {
    if (activeStep.value == 1) {
      await complete(context);
      return;
    }
    if (activeStep.value == 0) {
      createReservation.value.fromAddressLine1 = addressLine1From;
      createReservation.value.fromAddressLine2 = addressLine2From;
      createReservation.value.fromZipCode = fromZipCode;
      createReservation.value.toAddressLine1 = toAddressLine1;
      createReservation.value.toAddressLine2 = toAddressLine2;
      createReservation.value.toZipCode = toZipCode;
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
    if (activeStep.value == 0) {
      Get.back();
    }
    if (activeStep.value > 0) {
      activeStep.value--;
    }
  }

  Future<void> complete(BuildContext context) async {
    if (reservation == null) {
      var reservation = await tryCreateReservation();
      this.reservation = reservation;
    }

    if (reservation != null) {
      //dialog esta pendiente de pago, que solo esta confirmando su vieja pero debe pagar  en el vehículo
      await Get.dialog(AlertDialog(
        title: const Text('Alert'),
        content: const Text(
            'Your reservation is pending payment. Please complete the payment in the vehicle.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ));
      Get.offAllNamed(Routes.HOME);
    }
  }

  Reservation? reservation;
  Future<void> completePayment(BuildContext context) async {
    if (reservation == null) {
      var reservation = await tryCreateReservation();
      this.reservation = reservation;
    }

    if (reservation == null) {
      return;
    }
    var canClose = await PaymentSheetModal.showModal(context, reservation!);
    if (canClose) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  Future<Reservation?> tryCreateReservation() async {
    try {
      EasyLoading.show(status: 'Loading...');
      var message = await apiService.validReservation(
          createReservation.value.travel!.travelNumber,
          createReservation.value.customerId);
      if (message != null && message.isNotEmpty) {
        await Get.dialog(AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ));
        EasyLoading.dismiss(animation: true);

        return null;
      }
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
      var confirm = await apiService.changeStatusReservation(
          result.reservationNumber, 'CO', 'Reservation');
      EasyLoading.dismiss(animation: true);
      return result;
    } catch (e) {
      EasyLoading.dismiss(animation: true);
      Get.dialog(AlertDialog(
        title: const Text('Alert'),
        content: Text(e.toString()),
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
  var disableAddressTo = false.obs;

  void onFromCustomerAddress(CustomerAddress? x) {
    townsFrom.clear();
    townsFrom.add(x!.town!);
    createReservation.value.fromCity =
        citiesFrom.where((x) => x.idCity == x.idCity).firstOrNull;
    createReservation.value.fromTown = x.town;
    createReservation.value.idCustomerAddress = x.idCustomerAddress;
    addressLine1From = x.addressLine1 ?? '';
    addressLine2From = x.addressLine2 ?? '';
    fromZipCode = x.zipCode ?? '';

    disableAddress.value = (x.idCustomerAddress ?? 0) > 0 ? true : false;
    update();
  }

  void onToCustomerAddress(CustomerAddress? x) {
    townsTo.clear();
    townsTo.add(x!.town!);
    createReservation.value.toCity =
        citiesTo.where((x) => x.idCity == x.idCity).firstOrNull;
    createReservation.value.toTown = x.town;
    createReservation.value.idCustomerAddressTo = x.idCustomerAddress;
    toAddressLine1 = x.addressLine1 ?? '';
    toAddressLine2 = x.addressLine2 ?? '';
    toZipCode = x.zipCode ?? '';

    disableAddressTo.value = (x.idCustomerAddress ?? 0) > 0 ? true : false;
    update();
  }

  void cleanCustomerAddressFrom() {
    addressLine1From = '';
    addressLine2From = '';
    fromZipCode = '';
    createReservation.value.fromCity = null;
    createReservation.value.fromTown = null;
    createReservation.value.fromAddressLine1 = null;
    createReservation.value.fromAddressLine2 = null;
    createReservation.value.fromZipCode = null;
    createReservation.value.idCustomerAddress = null;
    disableAddress.value = false;

    change(null, status: RxStatus.success());
  }

  void cleanCustomerAddressTo() {
    toAddressLine1 = '';
    toAddressLine2 = '';
    toZipCode = '';
    createReservation.value.toCity = null;
    createReservation.value.toTown = null;
    createReservation.value.toAddressLine1 = null;
    createReservation.value.toAddressLine2 = null;
    createReservation.value.toZipCode = null;
    createReservation.value.idCustomerAddressTo = null;
    disableAddressTo.value = false;
    change(null, status: RxStatus.success());
  }
}
