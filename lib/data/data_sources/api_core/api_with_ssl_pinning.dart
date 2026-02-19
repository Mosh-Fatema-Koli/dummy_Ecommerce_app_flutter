
import 'package:boilerplate_of_cubit/library.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';


class APIServiceWithSSLPining {
  final Dio _dio = Dio();

  APIServiceWithSSLPining() {
    _dio.options = BaseOptions(
      baseUrl: Constant.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
    );

    _dio.interceptors.add(PrettyDioLogger());

    _setupSslPinning();
  }

  /// Setup SSL pinning
  Future<void> _setupSslPinning() async {
    final sslCert = await rootBundle.load('assets/ssl_certificate/sectigo_r46.crt');
    final securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());

    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
      final httpClient = HttpClient(context: securityContext);
      httpClient.badCertificateCallback = (cert, host, port) {
        return host == "frmapi.scibd.info"; // Accept only this domain
      };
      return httpClient;
    };
  }

  Dio get client => _dio;

  /// Core API method for all requests
  Future<Response> apiCore({
    required String address,
    required String method,
    String? token,
    dynamic jsonData,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Token $token',
    };

    _dio.options.headers = headers;
    _dio.options.method = method;

    try {
      return await _dio.request(address, data: jsonData);
    } on DioException catch (dioError) {
      // You can handle Dio errors here
      rethrow;
    } on SocketException {
      // No internet
      rethrow;
    } catch (ex) {
      rethrow;
    }
  }
  /// **Login API**
  login({String? endpoint, required String username, required String password,}) async {
    final String httpAddress = '/login';
    var loginRequest = {
      "username": username,
      "password": password,
    };

    var jsonRequest = json.encode(loginRequest);
    print(jsonRequest);

    var loginResponse = {
      "Success": false,
      "Message": "Login failed, please try again",
      "Packet": {},
    };
    var message = '';

    try {
      var apiResponse = await apiCore(address: httpAddress, method: 'POST', jsonData: jsonRequest,);
      print(apiResponse.statusCode );
      if (apiResponse.statusCode == 200) {
        Map response = apiResponse.data;
        if (response.isNotEmpty) {
          message = 'Login Successful';
          loginResponse['Success'] = true;
          loginResponse['Message'] = "Login Successfully";
          loginResponse['Packet'] = response["ApiPacket"]["Packet"];
          return json.encode(loginResponse);
        } else {
          loginResponse['Success'] = false;
          loginResponse['Message'] = message;
          loginResponse['Packet'] = '';
          return json.encode(loginResponse);
        }
      }
      else {
        return handleErrorResponse(apiResponse.statusCode!, loginResponse);
      }
    } on SocketException {
      return handleSocketException(loginResponse);
    } on DioException catch (dioError) {
      return handleDioError(dioError, loginResponse);
    } catch (ex) {
      return handleGenericError(ex, loginResponse);
    }
  }

  /// **Fetch List Data (GET Request)**
  fetchListData({required String endpoint, String? token,}) async {
    var fetchResponse = {
      "Success": false,
      "Message": "",
      "PacketList": [],
    };

    try {
      Response? apiResponse = await apiCore(address: endpoint, method: 'GET', token: token);

      if (apiResponse.statusCode == 200) {
        var response = apiResponse.data;
        bool success = true;
        fetchResponse['Success'] = success;
        var packetList = response;
        if (packetList.isNotEmpty) {
          fetchResponse['Message'] = 'Data fetched successfully';
          fetchResponse['PacketList'] = packetList;
        }
        return json.encode(fetchResponse);
      }  else {
        return handleErrorResponse(apiResponse.statusCode!, fetchResponse);
      }
    } on SocketException {
      return handleSocketException(fetchResponse);
    } on DioException catch (dioError) {
      return handleDioError(dioError, fetchResponse);
    } catch (ex) {
      return handleGenericError(ex, fetchResponse);
    }
  }

  /// **Fetch Data (GET Request)**
  fetchData({required String endpoint, String? token,}) async {
    var fetchResponse = {
      "Success": false,
      "Message": "",
      "Packet": {},
    };
    try {
      Response? apiResponse = await apiCore(address: endpoint, method: 'GET', token: token);

      if (apiResponse.statusCode == 200) {
        var response = apiResponse.data;

        bool success = true;
        fetchResponse['Success'] = success;
        var packetList = response;
        if (packetList.isNotEmpty) {
          fetchResponse['Message'] = 'Data fetched successfully';
          fetchResponse['PacketList'] = packetList;
        }
        return json.encode(fetchResponse);

      }  else {
        return handleErrorResponse(apiResponse.statusCode!, fetchResponse);
      }
    } on SocketException {
      return handleSocketException(fetchResponse);
    } on DioException catch (dioError) {
      return handleDioError(dioError, fetchResponse);
    } catch (ex) {
      return handleGenericError(ex, fetchResponse);
    }
  }

  /// **Post Data (POST Request)**
  postData({
    required String endpoint,
    required dynamic data, // 🔥 Accepts both Map<String, dynamic> and FormData
    String? token,
  }) async {
    var fetchResponse = {
      "Success": false,
      "Message": "",
      "Packet": {},
    };

    try {
      // ✅ Pass `data` directly, it can now handle FormData or JSON
      Response apiResponse = await apiCore(
        address: endpoint,
        method: 'POST',
        token: token??"",
        jsonData: data, // 🔥 data can be either Map<String, dynamic> or FormData
      );

      if (apiResponse.statusCode == 200 ||apiResponse.statusCode == 201) {
        var response = apiResponse.data;
        fetchResponse['Success'] = true;
        fetchResponse['Message'] = 'Request added successfully';
        fetchResponse['Packet'] = response;
      }  else {
        return handleErrorResponse(apiResponse.statusCode!, fetchResponse);
      }
    } on SocketException {
      return handleSocketException(fetchResponse);
    } on DioException catch (dioError) {
      return handleDioError(dioError, fetchResponse);
    } catch (ex) {
      return handleGenericError(ex, fetchResponse);
    }
  }

  /// **Update Data (PUT Request)**
  updateData({required String endpoint, required dynamic data, String? token,}) async {

    var fetchResponse = {
      "Success": false,
      "Message": "",
      "Packet": {},
    };

    try {
      Response? apiResponse = await apiCore(
        address: endpoint,
        method: 'PUT',
        token: token,
        jsonData: data,
      );

      if (apiResponse.statusCode == 200 ||apiResponse.statusCode == 201) {
        var response = apiResponse.data;
        fetchResponse['Success'] = true;
        fetchResponse['Message'] = 'Request added successfully';
        fetchResponse['Packet'] = response;
      }  else {
        return handleErrorResponse(apiResponse.statusCode!, fetchResponse);
      }
    } on SocketException {
      return handleSocketException(fetchResponse);
    } on DioException catch (dioError) {
      return handleDioError(dioError, fetchResponse);
    } catch (ex) {
      return handleGenericError(ex, fetchResponse);
    }

    return json.encode(fetchResponse);
  }


  /// **Delete Data (DELETE Request)**
  deleteData({required String endpoint, String? token,}) async {

    var fetchResponse = {
      "Success": false,
      "Message": "",
      "Packet": {},
    };

    try {
      Response? apiResponse = await apiCore(
        address: endpoint,
        method: 'DELETE',
        token: token,
      );

      if (apiResponse.statusCode == 200 ||apiResponse.statusCode == 201) {
        var response = apiResponse.data;
        fetchResponse['Success'] = true;
        fetchResponse['Message'] = 'Request added successfully';
        fetchResponse['Packet'] = response;
      }  else {
        return handleErrorResponse(apiResponse.statusCode!, fetchResponse);
      }
    } on SocketException {
      return handleSocketException(fetchResponse);
    } on DioException catch (dioError) {
      return handleDioError(dioError, fetchResponse);
    } catch (ex) {
      return handleGenericError(ex, fetchResponse);
    }
  }

  logout({required String endpoint, String? token,}) async {
    var fetchResponse = {
      "Success": false,
      "Message": "",
      "Packet": {},
    };
    try {
      Response? apiResponse = await apiCore(address: endpoint, method: 'GET', token: token);

      if (apiResponse.statusCode == 200) {
        Map<String, dynamic> response = apiResponse.data;
        bool success = true;
        fetchResponse['Success'] = success;
        if (success) {
          return json.encode(fetchResponse);
        }
      }  else {
        return handleErrorResponse(apiResponse.statusCode!, fetchResponse);
      }
    } on SocketException {
      return handleSocketException(fetchResponse);
    } on DioException catch (dioError) {
      return handleDioError(dioError, fetchResponse);
    } catch (ex) {
      return handleGenericError(ex, fetchResponse);
    }
  }



  //region Shared Error Handlers
  String handleErrorResponse(int statusCode, Map response, {String modelName = ''}) {
    String message;
    switch (statusCode) {
      case 400: message = 'Bad Request'; break;
      case 401: message = 'Unauthorized'; break;
      case 403: message = 'Forbidden'; break;
      case 404: message = 'Not Found'; break;
      case 500: message = 'Internal Server Error'; break;
      case 504: message = 'Gateway Timeout'; break;
      default: message = 'Unexpected Error';
    }

    response['Success'] = false;
    response['Message'] = message;
    response['Packet'] = '';
    response['PacketList'] = '';
    response['RecordId'] = '';
    response['Status'] = 0;
    response['ModelName'] = modelName;

    return json.encode(response);
  }

  String handleSocketException(Map response, {String modelName = ''}) {
    response['Success'] = false;
    // response['Message'] = 'No Internet Connection';
    response['Packet'] = '';
    response['PacketList'] = '';
    response['RecordId'] = '';
    response['Status'] = 0;
    response['ModelName'] = modelName;
    return json.encode(response);
  }

  String handleDioError(DioException dioError, Map response, {String modelName = ''}) {
    print('DioException: ${dioError.message}');
    print('Status: ${dioError.response?.statusCode}');
    print('Data: ${dioError.response?.data}');

    response['Success'] = false;
    response['Message'] = '${dioError.response?.data ?? 'Unknown'}';
    response['Packet'] = '';
    response['PacketList'] = '';
    response['RecordId'] = '';
    response['Status'] = 0;
    response['ModelName'] = modelName;
    return json.encode(response);
  }

  String handleGenericError(dynamic ex, Map response, {String modelName = ''}) {
    response['Success'] = false;
    response['Message'] = 'API request failed: $ex';
    response['Packet'] = '';
    response['PacketList'] = '';
    response['RecordId'] = '';
    response['Status'] = 0;
    response['ModelName'] = modelName;
    return json.encode(response);
  }


//endregion
}

