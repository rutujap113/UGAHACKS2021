import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventrack/config/constants.dart';
import 'package:http/http.dart' as http;
import 'package:inventrack/services/hmac.dart';

class RestaurantService {
  static String latitude = Constants.geo_point['lat'].toString();
  static String longitude = Constants.geo_point['long'].toString();
  static String siteId = '815195ff68974fddbfa90e72ed59d4c6';
  DateTime date = DateTime.now().toUtc();

  /// This method requests the a specific sitge based on the the site's id
  /// by using NCR's find-site-by-id API.
  ///
  /// @param [None]
  /// @return A map that encapsulates the store's meta data.
  ///
  Future<Map<String, dynamic>> request_site_by_id() async {
    String _get_store_by_id_url =
        Constants.requestUrl + '/site/sites/${siteId}';
    var request = http.Request('GET', Uri.parse(_get_store_by_id_url));
    Map<String, String> headers = {
      'date': _substring_to_utc(HttpDate.format(date)),
      'accept': 'application/json',
      'content-type': 'application/json'
    };
    request.headers.addAll(headers);
    HMac hMac = new HMac();
    request.headers['Authorization'] =
        hMac.createHmac(request, '/site/sites/${siteId}', date);
    http.Response response =
        await http.Response.fromStream(await request.send());

    var jsonString = response.body;
    var jsonMap = json.decode(jsonString);
    return jsonMap;
  }

  /// This method requests the nearby sites based on geolocation
  /// using NCR's find-nearby API.
  ///
  /// @param [None]
  /// @return A map that encapsulates the all store's meta data.
  ///
  Future<Map<String, dynamic>> request_nearby_sites() async {
    String _get_stores_url = Constants.requestUrl +
        '/site/sites/find-nearby/${latitude},${longitude}';
    var request = http.Request('GET', Uri.parse(_get_stores_url));
    Map<String, String> headers = {
      'date': _substring_to_utc(HttpDate.format(date)),
      'accept': 'application/json',
      'content-type': 'application/json'
    };
    request.headers.addAll(headers);
    HMac hMac = new HMac();
    request.headers['Authorization'] = hMac.createHmac(
        request, '/site/sites/find-nearby/${latitude},${longitude}', date);
    http.Response response =
        await http.Response.fromStream(await request.send());

    var jsonString = response.body;
    var jsonMap = json.decode(jsonString);

    return jsonMap;
  }

  /// This method converts a RFC 1123 date format in GMT to UTC
  /// by cropping the 'GMT' part and replacing it with 'UTC' part
  /// using substring.
  ///
  /// @param [date] The date string in RFC 1123 GMT date format.
  _substring_to_utc(String date) {
    var newString = date.substring(0, date.length - 3);
    return newString + " UTC";
  }
}
