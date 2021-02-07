import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventrack/config/constants.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert' show utf8;

class HMac {
  createHmac(http.Request request, String rest, DateTime date) {
    var toSign = request.method + "\n" + rest;

    var hmac_headers = [
      'content-type',
      'content-md5',
      'nep-application-key',
      'nep-correlation-id',
      'nep-organization',
      'nep-service-version',
    ];

    for (var header in request.headers.keys) {
      if (hmac_headers.contains(header)) {
        toSign += '\n' + request.headers[header];
      }
    }
    List<int> key = utf8.encode(
        Constants.SECRET_KEY + _format_round_date(date.toIso8601String()));

    List<int> message = utf8.encode(toSign);
    var hmacSha512 = new Hmac(sha512, key);
    Digest sha512Digest = hmacSha512.convert(message);
    var signature = base64Encode(sha512Digest.bytes);

    return ("AccessKey " +
        Constants.SHARED_KEY +
        ":" +
        AsciiCodec().decode(signature.codeUnits));
  }

  _format_round_date(String date) {
    var newDate = date.substring(0, date.length - 7);
    return newDate + "000Z";
  }
}
