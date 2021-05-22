import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mem_vl/Util/Keys.dart';

Future<dynamic> getDetailYoutube(String idYoutube) async {
  var link = "https://www.googleapis.com/youtube/v3/videos?part=snippet&id=" +
      idYoutube +
      "&key=" +
      YoutubeAPI;
  var res = await http
      .get(Uri.parse(link), headers: {"Accept": "application/json"});
  try {
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else
      return null;
  } on FormatException catch (e) {
    print("Invalid json" + e.toString());
    return null;
  }
}

Future<String> getTitleYoutube(String idYoutube) async {
  var json = await getDetailYoutube(idYoutube);
  try {
    return json['items'][0]['snippet']['title'];
  } catch (e) {
    return "error";
  }
}