import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:upsi_tester/data/i_internez.dart';

class Internez extends IInternez{

  @override
  Future<Response> post(String url, Object request) async {
    const headers = {"Content-Type": "application/json"};
    final utf8 = Encoding.getByName("utf-8");
    final response = await http.post(Uri.parse(url), body: request, encoding: utf8, headers: headers);
    return response;
  }
}