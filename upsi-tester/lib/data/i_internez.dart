import 'package:http/http.dart';

abstract class IInternez{
  Future<Response> post(String url, Object request);
}
