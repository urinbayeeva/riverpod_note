import 'dart:convert';
import 'package:http/http.dart';

class NetworkService {
  // baseUrl
  static const baseURL = '64c9fb26b2980cec85c2ab9c.mockapi.io';

  static String apiGetAllProducts = '/todos';
  static String apiDeleteProduct = '/todos/';
  static String apiUpdateProduct = '/todos/';

  // headers
  static Map<String, String>? headers = {
    'Content-Type': 'application/json',
  };

  //methods
  static Future<String> getData(String api) async {
    final url = Uri.https(baseURL, api);
    Response response = await get(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      return '\nError occurred on Status Code ${response.statusCode}\n';
    }
  }

  static Future<String?> postData(String api, Map<String, dynamic> body) async {
    Uri url = Uri.https(baseURL, api);
    Response response =
        await post(url, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return response.reasonPhrase;
  }

  static Future<String?> putData(
      String api, Map<String, dynamic> body, String id) async {
    final url = Uri.https(baseURL, "$api$id");
    final response = await put(url, body: jsonEncode(body), headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  static Future<String?> deleteData(String api, int id) async {
    final url = Uri.https(baseURL, "$api${id.toString()}");
    final response = await delete(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  /// params
  static Map<String, String> emptyParams() => <String, String>{};

  /// body
  static Map<String, dynamic> bodyEmpty() => <String, dynamic>{};
}
