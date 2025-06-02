import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper({required this.url});

  final String url;

  Future getData() async {
    final uri = Uri.tryParse(url);

    final response = await http.get(uri!);

    if (response.statusCode == 200) {
      final data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
