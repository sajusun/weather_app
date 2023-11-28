import 'package:weather_app/modal/weather_modal.dart';
import 'package:http/http.dart' as http;
class CurrentWeather{
  static Future<WeatherModal> getWeather() async{
    String apiLink="http://api.weatherapi.com/v1/current.json?key=978b1bfcf7c04a189e9134050232811&q=Dinajpur&aqi=yes";
    Uri url = Uri.parse(apiLink);
    var response = await http.get(url);
    //print(response.body.toString());
    final weather = weatherModalFromJson(response.body);
    return weather;
  }
}