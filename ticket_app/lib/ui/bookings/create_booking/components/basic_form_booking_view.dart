import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/data/model/city.dart';
import 'package:ticket_app/data/model/customer_address.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/zipcode.dart';
import 'package:ticket_app/ui/widgets/custom_dropdown.dart';
import 'package:ticket_app/ui/widgets/custom_text_field.dart';

class BasicFormBookingView extends StatelessWidget {
  final String? addressLine1;
  final String? addressLine2;
  final String? idState;
  final String title;
  final int? idCustomerAddress;
  final List<StateModel> states;
  final List<City> cities;
  final List<ZipCode> zipCodes;
  final List<CustomerAddress> customerAddress;
  final int? zipCode;
  final int? city;
  final bool? activeState;
  final Function(String) onChangedAddressLine1;
  final Function(String) onChangedAddressLine2;
  final Function(StateModel?) onChangedState;
  final Function(ZipCode?) onChangedZipCode;
  final Function(CustomerAddress?) onChangedCustomerAddress;
  final bool disableAddress;
  final VoidCallback? cleanCustomerAddress;

  final Function(City?) onChangedCity;

  const BasicFormBookingView(
      {super.key,
      required this.title,
      required this.addressLine1,
      required this.addressLine2,
      required this.idState,
      required this.states,
      required this.onChangedAddressLine1,
      required this.onChangedAddressLine2,
      required this.onChangedState,
      required this.onChangedZipCode,
      required this.zipCode,
      required this.city,
      required this.cities,
      required this.onChangedCity,
      required this.idCustomerAddress,
      required this.customerAddress,
      required this.onChangedCustomerAddress,
      this.activeState = true,
      this.disableAddress = false,
      this.zipCodes = const [],
      this.cleanCustomerAddress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            spacing: 10,
            children: [
              CustomDropdown<StateModel, String?>(
                items: states,
                onChanged: (x) async {
                  await onChangedState(
                      states.where((y) => y.idState == x).firstOrNull);
                },
                labelText: 'State',
                enabled: activeState ?? true,
                selectedItem: states
                    .where((x) => x.idState == idState)
                    .firstOrNull
                    ?.idState,
                showSearchBox: true,
                textEditingController: TextEditingController(),
                valueProperty: "Id_State",
                labelProperty: "Name",
                labelBuilder: (item) {
                  return '${item!["Name"]}';
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomDropdown<CustomerAddress, int?>(
                      items: customerAddress,
                      onChanged: (x) {
                        onChangedCustomerAddress(customerAddress
                            .where((y) => y.idCustomerAddress == x)
                            .firstOrNull);
                      },
                      labelText: 'Your Previous Addresses',
                      selectedItem: customerAddress
                          .where(
                              (x) => x.idCustomerAddress == idCustomerAddress)
                          .firstOrNull
                          ?.idCustomerAddress,
                      showSearchBox: true,
                      textEditingController: TextEditingController(),
                      valueProperty: "Id_CustomerAddress",
                      labelProperty: "FullAddress",
                      labelBuilder: (item) {
                        return '${item!["FullAddress"]}';
                      },
                    ),
                  ),
                  Visibility(
                    visible: idCustomerAddress != null,
                    child: IconButton(
                        onPressed: cleanCustomerAddress,
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.red,
                        )),
                  ),
                ],
              ),
                            CustomTextField(
                  controller: TextEditingController(text: addressLine1),
                  keyboard: TextInputType.streetAddress,
                  labelText: 'Current Address ',
                  maxLength: 250,
                  onChanged: onChangedAddressLine1),
              CustomDropdown<City, int?>(
                items: cities,
                onChanged: (x) async {
                  await onChangedCity(
                      cities.where((y) => y.idCity == x).firstOrNull);
                },
                labelText: 'City',
                enabled: !disableAddress,
                selectedItem:
                    cities.where((x) => x.idCity == city).firstOrNull?.idCity,
                showSearchBox: true,
                textEditingController: TextEditingController(),
                valueProperty: "Id_City",
                labelProperty: "Name",
                labelBuilder: (item) {
                  return '${item!["Name"]}';
                },
              ),
               CustomDropdown<ZipCode, int?>(
                items: zipCodes,
                onChanged: (x) async {
                  await onChangedZipCode(
                      zipCodes.where((y) => y.idZipCode == x).firstOrNull);
                },
                labelText: 'Zip Code',
                selectedItem:
                    zipCodes.where((x) => x.idZipCode == zipCode).firstOrNull?.idZipCode,
                showSearchBox: true,
                textEditingController: TextEditingController(),
                valueProperty: "Id_ZipCode",
                labelProperty: "ZipCodeT",
                labelBuilder: (item) {
                  return '${item!["ZipCodeT"]} Price: ${item["Price"]}';
                },
              ),

  
            ],
          ),
        ),
        Positioned(
            top: -10, // para superponerlo encima del borde
            right: 16,
            child: Container(
              color: Colors
                  .white, // el fondo debe coincidir con el fondo del cuadro
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
              ),
            )),
      ],
    );
  }
}