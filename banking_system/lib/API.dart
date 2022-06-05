import 'package:http/http.dart' as http;

Future Getdata(url) async {
  http.Response Response = await http.post(Uri.parse(url));
  return Response.body;
}