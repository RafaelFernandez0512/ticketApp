import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_app/data/model/bag.dart';
import 'package:ticket_app/data/model/company.dart';
import 'package:ticket_app/data/model/customer.dart';
import 'package:ticket_app/data/model/customer_address.dart';
import 'package:ticket_app/data/model/day.dart';
import 'package:ticket_app/data/model/message.dart';
import 'package:ticket_app/data/model/odata_reponse.dart';
import 'package:ticket_app/data/model/payment_method.dart';
import 'package:ticket_app/data/model/schedule.dart';
import 'package:ticket_app/data/model/state.dart';
import 'package:ticket_app/data/model/town.dart';
import 'package:ticket_app/data/model/travel.dart';
import 'package:ticket_app/data/service/authentication_service.dart';
import 'package:ticket_app/data/service/session_service.dart';

class ApiService extends GetxService {
  final String _baseUrl;
  final SessionService sessionService = Get.find<SessionService>();

  final AuthService authService = Get.find<AuthService>();
  ApiService(this._baseUrl);

  Future<String> getToken() async {
    var session = sessionService.getSession();
    if (session == null || session.isSessionTemporalExpired()) {
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

  Future<List<Town>> getTown() async {
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

  Future<List<Travel>> getTravel() async {
    const queryParams =
        r"$expand=StateFrom,StateTo,Employee($select=FullName),Vehicle";

    final response = await http.get(
      Uri.parse('$_baseUrl/api/odata/Travel?$queryParams'),
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ODataResponse<Travel>.fromJson(
          jsonResponse, (json) => Travel.fromJson(json)).value;
    } else {
      throw Exception('Error al obtener viajes: ${response.statusCode}');
    }
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
    Future<bool?> validateEmail(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/CustomEndpointEmailValidacion'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}',
      },
      body: jsonEncode([
        {
          "email": email,
        }
      ]),);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
    return List<EmailMessage>.from(jsonResponse).first.message?.isNotEmpty??false;
    } else {
      throw Exception(
          'Error al crear cliente: ${response.statusCode} - ${response.body}');
    }
  }
    Future<bool?> changePassword(String userName,String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/CustomEndpointCambioPassword'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}',
      },
      body: jsonEncode([
        {
          "userName": userName,
          "password": password
        }
      ]),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return List<Message>.from(jsonResponse).first.message?.isNotEmpty??false;
    } else {
      throw Exception(
          'Error change pssword ${response.statusCode} - ${response.body}');
    }
  }
}
