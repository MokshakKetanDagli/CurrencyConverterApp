import 'package:http/http.dart' as http;
import 'dart:convert';

class MyNetwork {
  static var client = http.Client();

  Future fetchPrice(String url) async {
    http.Response response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      String price = decodedData[0]['price'];
      double priceInNumber = double.parse(price);
      return priceInNumber.round();
    } else {
      print(response.statusCode);
      throw Exception('Couldn\'t fetch data.');
    }
  }
}
