import 'package:location/location.dart' as loc;
import 'package:weather_app/modal/weather_modal.dart';
import 'package:http/http.dart';

class CurrentWeather {
  static Future<Map<String, dynamic>> getWeather(String data) async {
    String apiLink =
        "http://api.weatherapi.com/v1/current.json?key=978b1bfcf7c04a189e9134050232811&q=$data&aqi=yes";
    Uri url = Uri.parse(apiLink);

    loc.Location location =  loc.Location();
    if(await location.serviceEnabled()!=true){
      await location.requestService();
    }
    Response response;
    try {
      response = await get(url);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        //print(response.body.toString());
        final weather = weatherModalFromJson(response.body);
        return {"status": true, "data": weather};
      } else {
        return {"status": false, "data": "failed to load data!"};
      }
    } catch (e) {
      return {"status": false, "data": "A connection has occurs!"};
    }
  }
}
