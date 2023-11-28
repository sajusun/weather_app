import 'package:flutter/material.dart';
import 'package:weather_app/api/current_weather_api.dart';
import 'package:weather_app/modal/weather_modal.dart';

class WeatherHomepage extends StatefulWidget {
  const WeatherHomepage({super.key});

  @override
  State<WeatherHomepage> createState() => _WeatherHomepageState();
}

class _WeatherHomepageState extends State<WeatherHomepage> {

  late WeatherModal weatherModal;
  List<WeatherModal> wm =[];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    weatherModal = await CurrentWeather.getWeather();
    wm.add(weatherModal);
    setState(() {
    });
  }
  
  handleWidget(){

    if(wm.isNotEmpty){
      return SizedBox(
        child: Column(
          children: [
            Text(" Country: ${weatherModal.location.country.toString()}"),
            Text(" Location: ${weatherModal.location.name.toString()}"),
            Text(" TimeZone: ${weatherModal.location.tzId.toString()}"),
            Text(" Temperature : ${weatherModal.current.feelslikeC.toString()}C  ||   ${weatherModal.current.feelslikeF.toString()}F"),
            Text(" Condition: ${weatherModal.current.condition.text}"),
            Image.network("https:${weatherModal.current.condition.icon}")

          ],
        ),
      );
    }else{
    return  Center(child: CircularProgressIndicator());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Android Weather"),centerTitle: true,),
      body: handleWidget(),
    );
  }
}
