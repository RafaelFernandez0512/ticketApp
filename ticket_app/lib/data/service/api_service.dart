import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_app/data/model/bag.dart';
import 'package:ticket_app/data/model/city.dart';
import 'package:ticket_app/data/model/company.dart';
import 'package:ticket_app/data/model/configuration.dart';
import 'package:ticket_app/data/model/create_reservation.dart';
import 'package:ticket_app/data/model/customer.dart';
import 'package:ticket_app/data/model/customer_address.dart';
import 'package:ticket_app/data/model/day.dart';
import 'package:ticket_app/data/model/message.dart';
import 'package:ticket_app/data/model/odata_reponse.dart';
import 'package:ticket_app/data/model/payment.dart';
import 'package:ticket_app/data/model/payment_method.dart';
import 'package:ticket_app/data/model/price_online.dart';
import 'package:ticket_app/data/model/price_online_request.dart';
import 'package:ticket_app/data/model/reservation.dart';
import 'package:ticket_app/data/model/schedule.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/town.dart';
import 'package:ticket_app/data/model/travel.dart';
import 'package:ticket_app/data/model/zipcode.dart';
import 'package:ticket_app/data/service/authentication_service.dart';
import 'package:ticket_app/data/service/session_service.dart';
import 'package:ticket_app/utils/utils.dart';

class ApiService extends GetxService {
  final String _baseUrl;
  final SessionService sessionService = Get.find<SessionService>();

  final AuthService authService = Get.find<AuthService>();
  ApiService(this._baseUrl);

  Future<String> getToken() async {
    var session = sessionService.getSession();
    if (session == null ||
        (session.isSessionTemporalExpired() && session.isSessionExpired())) {
      if (session?.expirationDate != null) {
        return await authService.authenticate(
            session?.username ?? '', session?.password ?? '');
      }
      return await authService.temporalToken();
    }
    return session.token ?? session.refreshToken ?? '';
  }

  Future<List<Day>> getDays() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/odata/Day'),
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ODataResponse<Day>.fromJson(
          jsonResponse, (json) => Day.fromJson(json)).value;
    } else {
      throw Exception('Error al obtener dias: ${response.statusCode}');
    }
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/odata/PaymentMethod'),
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ODataResponse<PaymentMethod>.fromJson(
          jsonResponse, (json) => PaymentMethod.fromJson(json)).value;
    } else {
      throw Exception(
          'Error al obtener métodos de pago: ${response.statusCode}');
    }
  }

  Future<List<StateModel>> getStates() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/odata/State'),
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ODataResponse<StateModel>.fromJson(
          jsonResponse, (json) => StateModel.fromJson(json)).value;
    } else {
      throw Exception('Error al obtener ciudades: ${response.statusCode}');
    }
  }

  Future<List<Bag>> getBags() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/odata/Bag'),
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ODataResponse<Bag>.fromJson(
          jsonResponse, (json) => Bag.fromJson(json)).value;
    } else {
      throw Exception('Error al obtener ciudades: ${response.statusCode}');
    }
  }

  Future<List<Town>> getTowns() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/odata/Town'),
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ODataResponse<Town>.fromJson(
          jsonResponse, (json) => Town.fromJson(json)).value;
    } else {
      throw Exception('Error al obtener town: ${response.statusCode}');
    }
  }

  Future<List<Town>> getTown(int idCity) async {
    //NombreCiudad
    var queryParams = "?\$filter=City/Id_City eq $idCity";
    final response = await http.get(
      Uri.parse('$_baseUrl/api/odata/Town$queryParams'),
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ODataResponse<Town>.fromJson(
          jsonResponse, (json) => Town.fromJson(json)).value;
    } else {
      throw Exception('Error al obtener town: ${response.statusCode}');
    }
  }

  Future<List<City>> getCity(String idState) async {
    var queryParams = "?\$filter=State/Id_state eq '$idState'";
    final response = await http.get(
      Uri.parse('$_baseUrl/api/odata/city$queryParams'),
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ODataResponse<City>.fromJson(
          jsonResponse, (json) => City.fromJson(json)).value;
    } else {
      throw Exception('Error al obtener town: ${response.statusCode}');
    }
  }

  Future<List<Travel>> getTravel() async {
    const queryParams =
        r"$expand=StateFrom,StateTo,Employee($select=FullName),Vehicle";

    final response = await http.get(
      Uri.parse('$_baseUrl/api/odata/Travel?$queryParams'),
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      var travels = ODataResponse<Travel>.fromJson(
          jsonResponse, (json) => Travel.fromJson(json)).value;

      travels.sort((a, b) => b.departureDate.compareTo(a.departureDate));
      return travels;
    } else {
      throw Exception('Error al obtener viajes: ${response.statusCode}');
    }
  }

  Future<List<Travel>> getFilteredTravel(
    String stateFromId,
    String stateToId,
    DateTime shortDepartureDate,
  ) async {
    final formattedDate = shortDepartureDate.toUtc().toIso8601String();
    final configurations = await this.configurations(['HoraLimiteViaje']);
    final horaLimiteConfig = configurations
        .where((config) => config.idConfiguracion == 'HoraLimiteViaje')
        .firstOrNull;

    final queryParams =
        r"$expand=StateFrom,StateTo,Employee($select=FullName),Vehicle,DepartureTime&"
                r"$filter=StateFrom/Id_State eq '" +
            stateFromId +
            r"' and StateTo/Id_State eq '" +
            stateToId +
            r"' and ShortDepartureDate eq " +
            formattedDate;

    final response = await http.get(
      Uri.parse('$_baseUrl/api/odata/Travel?$queryParams'),
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      var travels = ODataResponse<Travel>.fromJson(
          jsonResponse, (json) => Travel.fromJson(json)).value;

      travels.sort((a, b) => b.departureDate.compareTo(a.departureDate));
      return travels
          .where((x) => isTravelAvailable(x, horaLimiteConfig))
          .toList();
    } else {
      throw Exception(
          'Error al obtener viajes filtrados: ${response.statusCode}');
    }
  }

  bool isTravelAvailable(Travel travel, Configuration? horaLimiteConfig) {
    // Obtener la configuración de HoraLimiteViaje

    // Convertir la hora límite a un entero (en horas)
    final horaLimite = int.tryParse(horaLimiteConfig?.descripcion ?? '0') ?? 0;

    // Calcular el límite inferior
    final now = DateTime.now();
    final limiteInferior = now.subtract(Duration(hours: horaLimite));

    // Validar si la fecha de salida del viaje está dentro del límite permitido
    return travel.departureDate.isAfter(limiteInferior);
  }

  Future<List<Schedule>> getSchedule() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/odata/Schedule'),
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ODataResponse<Schedule>.fromJson(
          jsonResponse, (json) => Schedule.fromJson(json)).value;
    } else {
      throw Exception('Error al obtener horario: ${response.statusCode}');
    }
  }

  Future<Company> getCompany() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/odata/Company/'),
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Company.fromJson(jsonResponse);
    } else {
      throw Exception('Error al obtener compañia: ${response.statusCode}');
    }
  }

  Future<CustomerAddress> createCustomerAddress(CustomerAddress address) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/odata/CustomerAddress'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}',
      },
      body: jsonEncode(address.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return CustomerAddress.fromJson(jsonResponse);
    } else {
      throw Exception(
          'Error al crear dirección de cliente: ${response.statusCode} - ${response.body}');
    }
  }

  Future<CreateUserRequest?> createCustomer(CreateUserRequest customer) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/odata/Customer'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}',
      },
      body: jsonEncode(customer.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return CreateUserRequest.fromJson(jsonResponse);
    } else {
      throw Exception(
          'Error al crear cliente: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Message?> getCode(String username) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/CustomEndpointCodigoValidacion'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}',
      },
      body: jsonEncode([
        {
          "userName": username,
        }
      ]),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return List<Message>.from(jsonResponse).first;
    } else {
      throw Exception(
          'Error al crear cliente: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Customer?> getCustomer(String username) async {
    var queryParams =
        "\$filter=email eq '$username'&\$expand=Town,City,State,Gender,CustomerType,Country";
    final response = await http.get(
      Uri.parse('$_baseUrl/api/odata/Customer?$queryParams'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      var customer = ODataResponse<Customer>.fromJson(
          jsonResponse, (json) => Customer.fromJson(json)).value.firstOrNull;
      var session = sessionService.getSession();
      if (session != null && customer != null) {
        session.customerId = customer.idCustomer;
        sessionService.saveSession(session);
      }

      return customer;
    } else {
      throw Exception(
          'Error al obtener cliente: ${response.statusCode} - ${response.body}');
    }
  }

  Future<bool?> validateEmail(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/CustomEndpointEmailValidacion?username=$email'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List) {
        final emailMessages = jsonResponse
            .map((e) => EmailMessage.fromJson(e as Map<String, dynamic>))
            .toList();

        return emailMessages.isNotEmpty &&
            emailMessages.first.message?.isNotEmpty == true;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<bool?> changePassword(String userName, String password) async {
    final response = await http.post(
      Uri.parse(
          '$_baseUrl/api/CustomEndpointCambioPassword?Username=$userName&Password=$password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse[0]['Mensaje'] == 'Password changed successfully'
          ? true
          : false;
    } else {
      throw Exception(
          'Error change pssword ${response.statusCode} - ${response.body}');
    }
  }

  Future<String?> sendCode(String username) async {
    final response = await http.post(
      Uri.parse(
          '$_baseUrl/api/CustomEndpointCodigoValidacion?Username=$username'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List) {
        final emailMessages = jsonResponse
            .map((e) => Message.fromJson(e as Map<String, dynamic>))
            .toList();

        return emailMessages.first.message;
      } else {
        return '';
      }
    } else {
      throw Exception(
          'Error change pssword ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<ZipCode>> getZipCode(String zipCode) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/odata/ZipCode'),
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ODataResponse<ZipCode>.fromJson(
          jsonResponse, (json) => ZipCode.fromJson(json)).value;
    } else {
      return <ZipCode>[];
    }
  }

  Future<List<CustomerAddress>> getCustomerAddress(String stateId) async {
    var id = Get.find<SessionService>().getSession()?.customerId;

    ///api/odata/CustomerAddress?$expand=State,Town,City&$filter=State/Id_State eq 'OH'
    var queryParams =
        "\$expand=State,Town,City&\$filter=Customer/Id_Customer eq $id and State/Id_State eq '$stateId'";
    final response = await http.get(
      Uri.parse('$_baseUrl/api/odata/CustomerAddress?$queryParams'),
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ODataResponse<CustomerAddress>.fromJson(
          jsonResponse, (json) => CustomerAddress.fromJson(json)).value;
    } else {
      return [];
    }
  }

  Future<PriceEngine?> calculatePrice(PriceOnlineRequest value) async {
    // Construye los parámetros de consulta
    final queryParams = {
      'Travel': value.travel.toString(),
      'Customer': value.customer.toString(),
      'PassengerNumber': value.passengerNumber.toString(),
      'StateFrom': value.stateFrom,
      'CityFrom': value.cityFrom.toString(),
      'TownFrom': value.townFrom.toString(),
      'ZipCodeFrom': value.zipCodeFrom,
      'StateTo': value.stateTo,
      'CityTo': value.cityTo.toString(),
      'TownTo': value.townTo.toString(),
      'ZipCodeTo': value.zipCodeTo,
      'Bag': value.bag.toString(),
    };

    // Construye la URL con los parámetros
    final uri = Uri.parse('$_baseUrl/api/CustomEndpointPrecioViaje')
        .replace(queryParameters: queryParams);

    // Realiza la solicitud HTTP
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}',
      },
    );

    // Manejo de la respuesta
    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List) {
        final prices = jsonResponse
            .map((e) => PriceEngine.fromJson(e as Map<String, dynamic>))
            .toList();

        return prices.first;
      } else {
        return null;
      }
    } else {
      throw Exception(
          'Error calculating price ${response.statusCode} - ${response.body}');
    }
  }

  Future<bool> removeAddress(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/api/odata/CustomerAddress($id)'),
      headers: {
        'Authorization': 'Bearer ${await getToken()}',
      },
    );

    if (response.statusCode != 204) {
      return false;
    }
    return true;
  }

  ///api/CustomEndpointValidaTravel
  Future<Reservation?> createReservation(CreateReservation value) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/odata/Reservation'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}',
      },
      body: jsonEncode(value.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Reservation.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

  Future<String?> validReservation(
      int reservationNumber, int reservationCustomer) async {
    final response = await http.post(
      Uri.parse(
          '$_baseUrl/api/CustomEndpointValidaTravel?ReservationTravel=$reservationNumber&ReservationCustomer=$reservationCustomer'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}',
      },
      body: null,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse[0]['Travel'] as String?;
    } else {
      return null;
    }
  }

  Future<List<Reservation>> getReservations([DateTime? selectedDate]) async {
    var id = Get.find<SessionService>().getSession()?.customerId;

    var parameters =
        r'?$expand=StateFrom,StateTo,CityFrom,CityTo,TownTo,TownFrom,Payments,Travel($expand=Employee($select=FullName),Vehicle($select=Name),),ReservationStatus,Customer&$filter=Customer/Id_Customer eq ' +
            id.toString();
    final response = await http.get(
      Uri.parse('$_baseUrl/api/odata/Reservation$parameters'),
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      var reservations = ODataResponse<Reservation>.fromJson(
          jsonResponse, (json) => Reservation.fromJson(json)).value;
      reservations.sort((a, b) => a.departureDate!.compareTo(b.departureDate!));
      return reservations
          .where((x) =>
              selectedDate == null ||
              x.departureDate?.isSameDate(selectedDate) == true)
          .toList();
    } else {
      throw Exception('Error request reservation: ${response.statusCode}');
    }
  }

  Future<String?> getReservationPdf(String report, int parameter) async {
    final response = await http.post(
        Uri.parse(
            '$_baseUrl/api/CustomEndpointVerPdf?reporte=$report&parametro=$parameter'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await getToken()}',
        },
        body: null);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse[0]['Imagen'] as String?;
    } else {
      return null;
    }
  }

  Future<Payment?> payment(Payment payment) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/odata/Payment'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}',
      },
      body: jsonEncode(payment.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Payment.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

  Future<String?> changeStatusReservation(
      int number, String status, String serviceName) async {
    final response = await http.post(
        Uri.parse(
            '$_baseUrl/api/CustomEndpointCambioEstatus?ReservationService=$number&estatus=$status&TipProceso=$serviceName'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await getToken()}',
        },
        body: null);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse[0]['Mensaje'] as String?;
    } else {
      return null;
    }
  }

  Future<List<Configuration>> configurations(List<String> configs) async {
    try {
      var parameters =
          '?\$filter=Id_Configuracion in (\'' '${configs.join("','")}' '\')';
      final response = await http.get(
        Uri.parse('$_baseUrl/api/odata/Configuracion$parameters'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await getToken()}',
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return ODataResponse<Configuration>.fromJson(
            jsonResponse, (json) => Configuration.fromJson(json)).value;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<CustomerAddress?> updateCustomerAddress(CustomerAddress value) async {
    final response = await http.put(
      Uri.parse(
          '$_baseUrl/api/odata/CustomerAddress(${value.idCustomerAddress})'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}',
      },
      body: jsonEncode(value.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      final jsonResponse = jsonDecode(response.body);
      return CustomerAddress.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

 Future<bool> updateCustomer(Customer customer) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/api/odata/Customer(${customer.idCustomer})'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}',
      },
      body: jsonEncode(customer.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteAccount(String username) async {
    var id = Get.find<SessionService>().getSession()?.customerId;
    final response = await http.post(
      Uri.parse(
          '$_baseUrl/api/CustomEndpointEliminarCuenta?cliente=$id&Email=$username'),
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future verifyStatusReservation(int number) async {
       final response = await http.post(
        Uri.parse(
            '$_baseUrl/api/CustomEndpointValidateTicketBeforeBoarding?Reservation=$number'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await getToken()}',
        },
        body: null);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse[0]['Mensaje'] as String?;
    } else {
      return null;
    }
  }
}
