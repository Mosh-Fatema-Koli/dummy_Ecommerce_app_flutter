// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:dio/io.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/io_client.dart';
//
// class SecureSSL {
//
//   static late final _dio;
//   static Future<Dio> getDio() async {
//     if (_dio != null) {
//       return _dio!;
//     }
//     // Load certificate
//     final sslCert = await rootBundle.load('assets/certificates/sectigo_r46.crt');
//     SecurityContext sc = SecurityContext(withTrustedRoots: false);
//     sc.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
//
//     // Attach certificate to HTTP client
//     (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
//         (HttpClient client) {
//       //client.securityContext = sc;
//
//       client.badCertificateCallback =
//           (X509Certificate cert, String host, int port) {
//         return host == "jononimis.scibd.info"; // Domain address without https & slash
//       };
//       return client;
//     };
//
//     return _dio;
//   }
//
//   static HttpClient? _client;
//   static Future<http.Client> getHttp() async {
//
//     if (_client != null) {
//       return IOClient(_client!);
//     }
//
//     // Load your server certificate
//     final bytes =
//     (await rootBundle.load('assets/certificates/sectigo_r46.crt')).buffer.asUint8List();
//
//     SecurityContext sc = SecurityContext(withTrustedRoots: false);
//     sc.setTrustedCertificatesBytes(bytes);
//
//     _client = HttpClient(context: sc);
//
//     // Optional: certificate callback for domain validation
//     _client!.badCertificateCallback =
//         (X509Certificate cert, String host, int port) {
//       return host == AppUrl.apiBaseURL; // এখানে আপনার ডোমেইন
//     };
//
//     return IOClient(_client!);
//   }
//
//   howToUseHTTP() async {
//     String bearer = "";
//     final headers = {"content-type": "application/json","accept-language": "en", 'Authorization': 'Bearer ${bearer}'};
//     var uri = Uri.parse("https://jononimis.scibd.info/api/login");
//     var body = {
//       "DeviceUniqueId": "963a5ef80129a9d5",
//       "Password": "12345",
//       "UserName": "dep"
//     };
//     final client = await SecureSSL.getHttp();
//     var response = await client.post(uri, body: jsonEncode(body), headers: headers);
//
//     if(response.statusCode == 200) {
//
//     }
//   }
//
//   howToUseDio() async {
//     String bearer = "";
//     final headers = {"content-type": "application/json","accept-language": "en", 'Authorization': 'Bearer ${bearer}'};
//     var url = "https://jononimis.scibd.info/api/login";
//     var body = {
//       "DeviceUniqueId": "963a5ef80129a9d5",
//       "Password": "12345",
//       "UserName": "dep"
//     };
//     final client = await SecureSSL.getDio();
//     var response = await client.post(url, data: jsonEncode(body), queryParameters: headers);
//     if(response.statusCode == 200) {
//
//     }
//   }
//
//
// }