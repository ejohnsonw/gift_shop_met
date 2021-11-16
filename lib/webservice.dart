import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Webservice {
  static String authorityApi = "collectionapi.metmuseum.org";
  static String authorityWebsocket = "";
  static String authorityUI = "";
  static String baseUrl = "https://collectionapi.metmuseum.org/public/collection/v1";
  static String uiUrl = "";
  static String baseUrlTravelAssist = "";
  static String websocketBaseUrl = "";
  static String clientId = "quos_mobile";
  static final dateFormatter = DateFormat('yyyy-MM-dd');
  static late Map tripInfo;
  static late String _deviceId;

  Webservice() {
    //getInfo();
  }

  static Uri uriForPath(String path) {
    if (baseUrl.startsWith("https")) {
      return Uri.https(authorityApi, path);
    } else {
      return Uri.http(authorityApi, path);
    }
  }

  static Future<http.Response> departments() async {
    Map itineraryRequest = new Map();
    itineraryRequest['forDashboard'] = true;
    var bodyEncoded = json.encode(itineraryRequest);
    Map<String, String> headers = new Map();
    headers["Content-Type"] = "application/json";
    headers["clientId"] = clientId;
    //headers["deviceId"] = _deviceId;
    return http.get(uriForPath("public/collection/v1/departments"), headers: headers);
  }

  static Future<http.Response> search(String query) async {
    Map<String, String> headers = new Map();
    headers["Content-Type"] = "application/json";
    headers["clientId"] = clientId;
    Uri url = Uri.parse("${baseUrl}/search?hasImages=true&q=${query}");
    print(url.toString());
    return http.get(url, headers: headers);
  }

  static Future<http.Response> retrieveObject(String objectID) async {
    Map<String, String> headers = new Map();
    headers["Content-Type"] = "application/json";
    headers["clientId"] = clientId;
    Uri url = Uri.parse("${baseUrl}/objects/${objectID}");
    print(url.toString());
    return http.get(url, headers: headers);
  }

  static Future<http.Response> catalogs(Map business) async {
    Map request = new Map();
    if (business['locationId'] != null) {
      request['locationId'] = business['locationId'];
    } else {
      if ((business['locations'] as List).length == 1) {
        request['locationId'] = (business['locations'] as List)[0]['publicId'];
      }
    }
    request['enabledOnly'] = true;
    request['noCache'] = true;

    var bodyEncoded = json.encode(request);
    Map<String, String> headers = new Map();
    headers["Content-Type"] = "application/json";
    headers["clientId"] = clientId;

    //headers["deviceId"] = _deviceId;
    return http.post(uriForPath("/catalog/catalogsForBusiness"), body: bodyEncoded, headers: headers);
  }

  static Future<http.Response> productOrderingInfo(Map product) async {
    Map request = new Map();
    request['enabledOnly'] = true;
    request['noCache'] = true;

    var bodyEncoded = json.encode(product);
    Map<String, String> headers = new Map();
    headers["Content-Type"] = "application/json";
    headers["clientId"] = clientId;

    //headers["deviceId"] = _deviceId;
    return http.post(uriForPath("/catalog/productOrderingInfo"), body: bodyEncoded, headers: headers);
  }

  static Future<http.Response> ordersForDevice() async {
    Map request = new Map();
    request['deviceId'] = _deviceId;
    var bodyEncoded = json.encode(request);
    Map<String, String> headers = new Map();
    headers["Content-Type"] = "application/json";
    headers["clientId"] = clientId;

    //headers["deviceId"] = _deviceId;
    return http.post(uriForPath("/order/ordersForDevice"), body: bodyEncoded, headers: headers);
  }

  static Future<http.Response> retrieveOrderWithDeviceId(Map request) async {
    Map<String, String> headers = new Map();
    headers["Content-Type"] = "application/json";
    headers["clientId"] = clientId;
    request['deviceId'] = _deviceId;
    var bodyEncoded = json.encode(request);
    return http.post(uriForPath("/order/retrieveOrderWithDeviceId"), body: bodyEncoded, headers: headers);
  }

  static Future<http.Response> orderStatuses() async {
    Map<String, String> headers = new Map();
    headers["Content-Type"] = "application/json";
    headers["clientId"] = clientId;
    //headers["deviceId"] = _deviceId;
    return http.get(uriForPath("/order/statuses"), headers: headers);
  }

  static Future<http.Response> orderFinancials(Map request) async {
    var bodyEncoded = json.encode(request);
    Map<String, String> headers = new Map();
    headers["Content-Type"] = "application/json";
    headers["clientId"] = clientId;
    headers["deviceId"] = _deviceId;
    return http.post(uriForPath("/order/orderFinancials"), body: bodyEncoded, headers: headers);
  }

  static Future<http.Response> businesses(Map request) async {
    var bodyEncoded = json.encode(request);
    Map<String, String> headers = new Map();
    headers["Content-Type"] = "application/json";
    headers["clientId"] = clientId;
    headers["deviceId"] = _deviceId;
    return http.post(uriForPath("/business/search"), body: bodyEncoded, headers: headers);
  }

  static Future<http.Response> randomString(length) {
    //var bodyEncoded = json.encode(deviceId);
    Map<String, String> headers = new Map();
    return http.get(uriForPath("/util/randomCode/" + length.toString()), headers: headers);
  }
}
