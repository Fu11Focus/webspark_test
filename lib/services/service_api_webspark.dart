import 'dart:convert';

import 'package:http/http.dart' as http;

class ServiceApiWebspark {
  Future<List> fetchExercise(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] as List;
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Request failed with error: $error');
    }
  }

  Future sendCountingResult(String url, Map body) async {
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: jsonEncode([body]));

      if (response.statusCode == 200) {
        print('Done!');
      } else {
        print('Error: ${response.body}');
      }
    } catch (error) {
      throw Exception('Failed for send result to server!');
    }
  }
}
