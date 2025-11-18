import 'dart:convert';
import 'dart:io';

import 'package:fluent_validation/models/validation_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/controller/payment_controller.dart';
import 'package:ticket_app/data/model/Item_type.dart';
import 'package:ticket_app/data/model/city.dart';
import 'package:ticket_app/data/model/create_reservation.dart';
import 'package:ticket_app/data/model/customer_address.dart';
import 'package:ticket_app/data/model/price_online_request.dart';
import 'package:ticket_app/data/model/reservation.dart';
import 'package:ticket_app/data/model/schedule.dart';
import 'package:ticket_app/data/model/service_type.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/zipcode.dart';
import 'package:ticket_app/data/service/api_service.dart';
import 'package:ticket_app/data/service/session_service.dart';
import 'package:ticket_app/routes/app_pages.dart';
import 'package:ticket_app/ui/bookings/payments/payment_sheet_modal.dart';
import 'package:ticket_app/ui/widgets/custom_button.dart';
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
  var citiesFrom = <City>[];
  var citiesTo = <City>[];
    var zipcodesFrom = <ZipCode>[];
  var zipcodesTo = <ZipCode>[];
  var schedule = <Schedule>[];
  var items = <ItemType>[];
  var addressLine1From = '';
  var toAddressLine1 = '';

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
  bool fromValueComplete(){
    return  createReservation.value.fromSate != null &&
      createReservation.value.fromCity != null &&
      createReservation.value.fromZipCode != null;
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
          final items = apiService.getItems();
        final zipcodesFromFuture = apiService.getZipCodeById(createReservation.value.fromZipCode??0);
          // Wait for all in parallel
          final results = await Future.wait<dynamic>([
            addressFromFuture,
            addressToFuture,
            citiesFromFuture,
            citiesToFuture,
            items,
            zipcodesFromFuture
          ]);
  
          customerAddressFrom = results[0];
          customerAddressTo = results[1];
          citiesFrom = results[2];
          citiesTo = results[3];
          this.items = results[4];
          zipcodesFrom = results[5];

        }
      }

      // Run both in parallel
      await Future.wait([
        statesFuture,
        fetchCitiesAndAddresses(),
      ]);
      var username = Get.find<SessionService>().getSession()?.username;
      var customer = await apiService.getCustomer(username ?? '');
      if (customer != null &&
          customer.state ==
              createReservation.value.travel?.stateFrom?.idState) {
        addressLine1From = customer.addressLine1 ?? '';
        createReservation.value.toZipCode = customer.zipCode;
        var city =
            citiesFrom.where((x) => x.idCity == customer.city).firstOrNull;
        if (city != null) {
          await onChangeFromCity(city);
        }
      }
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
    citiesFrom.clear();
    citiesFrom = await getCities(idstate!.idState);
    createReservation.update((val) {
      val!.fromSate = idstate;
      val.fromCity = null;
    });
  }

  onChangeFromCity(City? idCity) async {
    zipcodesFrom = await apiService.getZipCode(idCity!.idCity);
    createReservation.update((val) {
      val!.fromCity = idCity;
    });
  }

  onChangeToCity(City? idCity) async {
    zipcodesTo = await apiService.getZipCode(idCity!.idCity);
    createReservation.update((val) {
      val!.toCity = idCity;
    });
  }

  onChangeItem(int? id) async {
    createReservation.update((val) {
      val!.items = id;
    });
  }

  onChangeToState(StateModel? idstate) async {
    citiesTo.clear();
    citiesTo = await getCities(idstate!.idState);
    createReservation.update((val) {
      val!.toState = idstate;
      val.toCity = null;
    });
  }

  onChangedDate(DateTime? date) {
    createReservation.update((val) {
      val!.date = date;
    });
  }

  onFromChangedAddressLine1(String p1) {
    addressLine1From = p1;
        createReservation.value.fromAddressLine1 = addressLine1From;
  }

  onFromChangedAddressLine2(String p1) {
  }

  onFromZipCode(ZipCode? p1) async {
    if(p1 == null) {
      return;
    }
          createReservation.value.fromAddressLine1 = addressLine1From;
      createReservation.value.fromZipCode = p1.idZipCode;
    update();

  }

  onToChangedAddressLine1(String? p1) {
    toAddressLine1 = p1 ?? '';
         createReservation.value.toAddressLine1 = toAddressLine1;
  }

  onToChangedAddressLine2(String? p1) {
  }

  onToZipCode(ZipCode? p1) async {
        if(p1 == null) {
      return;
    }
    createReservation.value.toZipCode = p1?.idZipCode;
          createReservation.value.toAddressLine1 = toAddressLine1;
          if(p1.price <= 0){
            createReservation.value.comment ='';
            return;

          }
      if (!validReservation(ignoreAddress: true)) {
          createReservation.value.toZipCode = null;
            update();
        return;
      }

      var value = await calculatePrice();
      if(value){
  var param =  await apiService.configurations(['CommentReservation']);

      createReservation.value.comment =param.firstOrNull?.nota?.replaceAll(r'{CityTo.Name}', createReservation.value.toCity?.name ?? '').replaceAll(r'${precioZipCode}.', formatMoney(p1.price)) ?? '';
      totalAmount = (createReservation.value.price ?? 0.0).obs;
  
      update();
      }
      if (!value) {
        return;
      }
  }
 String formatMoney(num? value) {
    final v = value ?? 0;
    final f = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return f.format(v);
  }
  Future onChangedBagsCount(num x) async {
     createReservation.value.bagsCount = x.toInt();

     var zipcode = zipcodesTo.where((t)=>
          t.idZipCode == createReservation.value.toZipCode ).firstOrNull;
          if(zipcode == null || zipcode.price <= 0){
            createReservation.value.comment ='';
            return; 

          }
     if(validReservation(ignoreAddress: true)){
          var value = await calculatePrice();
      if(value){
  var param =  await apiService.configurations(['CommentReservation']);

      createReservation.value.comment =param.firstOrNull?.nota?.replaceAll(r'{CityTo.Name}', createReservation.value.toCity?.name ?? '').replaceAll(r'${precioZipCode}.', formatMoney(zipcode.price)) ?? '';
      totalAmount = (createReservation.value.price ?? 0.0).obs;
      }
    createReservation.update((val) {
      val!.bagsCount = x.toInt();
    });
  }
  }

var totalAmount = 0.0.obs;
  void onChangedPassengerCount(num x) {
    createReservation.update((val) {
      val!.passengerCount = x.toInt();
    });
  }

  void onChangedItemsCount(num x) {
    createReservation.update((val) {
      val!.quantity = x.toInt();
    });
  }

  void nextStep(BuildContext context) async {
    if (activeStep.value == 1) {
      await complete(context);
      return;
    }
    if (activeStep.value == 0) {
      createReservation.value.fromAddressLine1 = addressLine1From;
      createReservation.value.toAddressLine1 = toAddressLine1;

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
      if (kIsWeb) {
   var value = (await Get.toNamed(Routes.PAYMENT, arguments: reservation));
   if(value != null && value is Reservation ) {
    change([], status: RxStatus.loading());
          var description = reservation!.serviceType == 0
          ? 'Payment for reservation number: ${reservation!.reservationNumber}'
          : 'Payment for service number: ${reservation!.reservationNumber}';
        await Get.find<PaymentController>()
            .onSubmit(reservation!, description,value.reference);
    Get.offAllNamed(Routes.HOME);
   }
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
      String? message = '';
      if (createReservation.value.serviceType == 0) {
        message = await apiService.validReservation(
            createReservation.value.travel!.travelNumber,
            createReservation.value.customerId);
      } else {
        message = await apiService.validService(
            createReservation.value.travel!.travelNumber,
            createReservation.value.customerId);
      }
      if (message != null && message.isNotEmpty) {
          EasyLoading.dismiss(animation: true);
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
      

        return null;
      }
      var result = createReservation.value.serviceType == 0
          ? await apiService.createReservation(createReservation.value)
          : await apiService.createServiceReservation(createReservation.value);
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
      createReservation.value.id = result.reservationNumber;
      if (createReservation.value.serviceType == 0) {
        await apiService.changeStatusReservation(
            result.reservationNumber, 'CO', 'Reservation');
      } else {
        await apiService.changeStatusReservation(
            result.reservationNumber, 'I', 'Service');
        await apiService.postImageToService(
            result.reservationNumber, createReservation.value.photo!);
      }

      EasyLoading.dismiss(animation: true);
      return result;
    } catch (e) {

      EasyLoading.dismiss(animation: true);
      Get.dialog(AlertDialog(
        title: const Text('Alert'),
        content: Text("Check your internet connection and try again."),
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
     var zipcodeToModel = zipcodesTo.where((x)=>
          x.idZipCode == createReservation.value.toZipCode ).firstOrNull;
      var zipcodeFromModel = zipcodesFrom.where((x)=>
          x.idZipCode == createReservation.value.fromZipCode ).firstOrNull;
      final priceOnlineRequest = PriceOnlineRequest(
        travel: createReservation.value.travel!.travelNumber,
        customer: createReservation.value.customerId,
        passengerNumber: createReservation.value.passengerCount!,
        stateFrom: createReservation.value.fromSate!.idState,
        cityFrom: createReservation.value.fromCity!.idCity,
        zipCodeFrom: zipcodeFromModel?.zipCodeT,
        stateTo: createReservation.value.toState!.idState,
        cityTo: createReservation.value.toCity!.idCity,
        zipCodeTo: zipcodeToModel?.zipCodeT,
        bag: createReservation.value.bagsCount!,
        additional: additional.value,
        quantity:createReservation.value.quantity
      );
      var price = createReservation.value.serviceType == 0
          ? await apiService.calculatePrice(priceOnlineRequest)
          : await apiService.calculatePriceService(priceOnlineRequest);
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
        val!.price = (price.priceWithDiscount ?? 0) > 0
            ? price.priceWithDiscount
            : price.priceWithoutDiscount;
        val.fromFullAddress =
            '${val.fromAddressLine1},  ${val.fromZipCode}';
        val.toFullAddress =
            '${val.toAddressLine1}. , ${val.toZipCode}';
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

  bool validReservation({bool ignoreAddress = false}) {
    var createReservationValidator = createReservation.value.serviceType == 0
        ? CreateReservationValidator()
        : CreateServiceReservationValidator();
    final ValidationResult validationResult =
        createReservationValidator.validate(createReservation.value);

    if (validationResult.hasError) {
      if(ignoreAddress){
        var filteredErrors = validationResult.errors.where((error) =>
            error.key != 'fromAddressLine1' &&
            error.key != 'toAddressLine1');
        if (filteredErrors.isEmpty) {
          return true;
        }
        EasyLoading.dismiss();
        Get.dialog(AlertDialog(
          title: const Text('Alert'),
          content:
              Text(filteredErrors.map((x) => x.message).join('\n')),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        ));
        return false;
      }
      Get.dialog(AlertDialog(
        title: const Text('Alert'),
        content: Text(validationResult.errors.map((x) => x.message).join('\n')),
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

  var additional = false.obs;

  onDescription(String? p1) {
    createReservation.value.description = p1 ?? '';
  }

  Future pickPhoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    var action = await Get.dialog<String?>(AlertDialog(
      title: Text(
        'Select an Action',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            label: 'Take Photo',
            fullSize: true,
            iconAlignment: IconAlignment.start,
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: () => Get.back<String>(result: '0'),
          ),
          const Divider(),
          CustomButton(
            label: 'Choose from Gallery',
            fullSize: true,
            iconAlignment: IconAlignment.start,
            icon: const Icon(Icons.photo_album, color: Colors.white),
            onPressed: () => Get.back<String>(result: '1'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Close'),
        ),
      ],
    ));
    if (action?.isNotEmpty ?? false) {
      final XFile? image = await picker.pickImage(
          source: action == "0" ? ImageSource.camera : ImageSource.gallery);
      if (image != null) {
        final bytes = await File(image.path).readAsBytes();
        final base64String = base64Encode(bytes);
        createReservation.update((val) {
          val!.photo = base64String;
        });
        update();
      }
    }
  }

  Future onFromCustomerAddress(CustomerAddress? x) async {
    if(x == null) {
      return;

    }
    createReservation.value.fromCity =
        citiesFrom.where((d) => d.idCity == x.city?.idCity).firstOrNull;
    createReservation.value.idCustomerAddress = x.idCustomerAddress;
    addressLine1From = x.addressLine1 ?? '';
     zipcodesFrom= await apiService.getZipCode(createReservation.value.fromCity!.idCity);
     createReservation.value.fromZipCode =zipcodesFrom.where((t)=>"${t.idZipCode}" == x.zipCode).firstOrNull?.idZipCode;
    disableAddress.value = (x.idCustomerAddress ?? 0) > 0 ? true : false;
    update();
  }

  Future onToCustomerAddress(CustomerAddress? x) async {

    if(x == null) {
      return;

    }
    createReservation.value.toCity =
        citiesTo.where((x) => x.idCity == x.idCity).firstOrNull;
    createReservation.value.idCustomerAddressTo = x.idCustomerAddress;
    toAddressLine1 = x.addressLine1 ?? '';
     zipcodesTo = await apiService.getZipCode(createReservation.value.fromCity!.idCity);
    
     createReservation.value.toZipCode =zipcodesTo.where((t)=>"${t.idZipCode}" == x.zipCode).firstOrNull?.idZipCode;
    disableAddressTo.value = (x.idCustomerAddress ?? 0) > 0 ? true : false;
    update();
  }

  void cleanCustomerAddressFrom() {
    addressLine1From = '';
    createReservation.value.fromCity = null;
    createReservation.value.fromAddressLine1 = null;
    createReservation.value.fromAddressLine2 = null;
    createReservation.value.fromZipCode = null;
    createReservation.value.idCustomerAddress = null;
    disableAddress.value = false;

    change(null, status: RxStatus.success());
  }

  void cleanCustomerAddressTo() {
    toAddressLine1 = '';
    createReservation.value.toCity = null;
    createReservation.value.toAddressLine1 = null;
    createReservation.value.toAddressLine2 = null;
    createReservation.value.toZipCode = null;
    createReservation.value.idCustomerAddressTo = null;
    disableAddressTo.value = false;
    change(null, status: RxStatus.success());
  }

  Future onChangeAdditional(bool value) async {
    additional = value.obs;
    createReservation.value.additional = value;
    var zipcode = zipcodesTo.where((t)=>
          t.idZipCode == createReservation.value.toZipCode ).firstOrNull;
          var valuePrice = await calculatePrice();
      if(valuePrice){
  var param =  await apiService.configurations(['CommentReservation']);

      createReservation.value.comment =param.firstOrNull?.nota?.replaceAll(r'{CityTo.Name}', createReservation.value.toCity?.name ?? '').replaceAll(r'${precioZipCode}.', formatMoney(zipcode?.price??0)) ?? '';
      totalAmount = (createReservation.value.price ?? 0.0).obs;
      }
    change(null, status: RxStatus.success());
  }
}
