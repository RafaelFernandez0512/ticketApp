import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_app/data/model/company.dart';
import 'package:ticket_app/data/service/api_service.dart';

class PaymentService {
  Future createPaymentIntent(
      {required String name,
      required String address,
      required String zipcode,
      required String city,
      required String state,
      required String country,
      required String currency,
      required String description,
      required double amount}) async {
    var configurations = await Get.find<ApiService>()
        .configurations(['ApiKey', 'StripeApi']);
    final url = Uri.parse(
        '${configurations.where((x) => x.idConfiguracion == 'StripeApi').first.descripcion}payment_intents');
    final secretKey = configurations
        .where((x) => x.idConfiguracion == 'ApiKey')
        .first
        .descripcion;
    final body = {
      'amount': (amount * 100).toStringAsFixed(0),
      'currency': currency.toLowerCase(),
      'description': description,
      'shipping[name]': name,
      'shipping[address][line1]': address,
      'shipping[address][postal_code]': zipcode,
      'shipping[address][city]': city,
      'shipping[address][state]': state,
      'shipping[address][country]': country
    };

    final response = await http.post(url,
        headers: {
          "Authorization": "Bearer $secretKey",
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body);

    print(body);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      print(json);
      return json;
    } else {
        var json = jsonDecode(response.body);
            print(json);
      print("error in calling payment intent");
    }
  }
}
