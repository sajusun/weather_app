import 'package:weather_app/modal/weather_modal.dart';
import 'package:http/http.dart';
class CurrentWeather{
  static Future<Map<String,dynamic>> getWeather(String data) async{

    String apiLink="http://api.weatherapi.com/v1/current.json?key=978b1bfcf7c04a189e9134050232811&q=$data&aqi=yes";
    Uri url = Uri.parse(apiLink);
    print("object");
    print(data);
    Response response;
    try {
       response = await get(url);
      print(response..statusCode);
      if(response.statusCode >=200 && response.statusCode<=299) {
        //print(response.body.toString());
        final weather = weatherModalFromJson(response.body);
        print("true");
        return {"status":true,"data":weather};

      }else{
        print("false");
        return {"status":false,"data":"failed to load data!"};
      }
    }catch(e){
      print("handle data pls");
      return {"status":false,"data":"A connection has occurs!"};
    }
  }
}