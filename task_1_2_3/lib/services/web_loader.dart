import 'package:flutter_application_pw16/models/html_model.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

Future<HtmlModel> loadHTML(String url) async {
  if (url.isNotEmpty) {
    try {
      var res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return HtmlModel(
            url: url,
            htmlBody: res.body, //res.headers.keys.toList().toString(),
            htmlTitle:
                html_parser.parse(res.body).querySelector('title')!.text.trim(),
            corsHeader:
                'CORS Header: ${res.headers.keys.contains("access-control-allow-origin") ? "${res.headers['access-control-allow-origin']}" : "none"}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('aa $e');
    }
  }

  return HtmlModel(url: '', htmlTitle: '', htmlBody: '', corsHeader: '');
}
