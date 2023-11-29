import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:weather_app/api/current_weather_api.dart';
import 'package:weather_app/modal/weather_modal.dart';
import '../helper/geo_location.dart';

class WeatherHomepage extends StatefulWidget {
  const WeatherHomepage({super.key});

  @override
  State<WeatherHomepage> createState() => _WeatherHomepageState();
}

class _WeatherHomepageState extends State<WeatherHomepage> {
  late WeatherModal weatherModal;
  List<WeatherModal> wm =[];
  GeoLocation data=GeoLocation();

  @override
  void initState() {
    super.initState();
    getData();
  }
  getData() async {
      if(data.currentPosition?.latitude != null){
        sendDataToApi();
      }else{ await GeoLocation().getCurrentPosition();}
      setState(() {});
  }
  sendDataToApi() async {
    if(wm.isEmpty) {
      weatherModal = await CurrentWeather.getWeather("${data.currentPosition?.latitude},${data.currentPosition?.longitude}");
      wm.add(weatherModal);
      setState(() {});
    }else{
      weatherModal = await CurrentWeather.getWeather("${data.currentPosition?.latitude},${data.currentPosition?.longitude}");
    }
  }
  
  handleWidget(){
    getData();
    if(wm.isNotEmpty){
      return SizedBox(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Text(weatherModal.location.name.toString(),style: TextStyle(fontSize: 20),),
            SizedBox(height: 50,),
            Text(weatherModal.location.localtime.toString(),style: TextStyle(fontSize: 20),),
            SizedBox(height: 10,),
            Image.network("https:${weatherModal.current.condition.icon}",height: 100,fit: BoxFit.fill,),
            Text(" Weather : ${weatherModal.current.condition.text}",style: TextStyle(fontSize: 18)),
            SizedBox(height: 60,),
            Text("${weatherModal.current.tempC.toString()}° C  ||   ${weatherModal.current.tempF.toString()}° F",style: TextStyle(fontSize: 38),),
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text("${weatherModal.location.country.toString()}"),
                          Text("Humidity : ${weatherModal.current.humidity.toString()}"),
                      ],),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${weatherModal.location.tzId.toString()}"),
                          Text("Wind :  ${weatherModal.current.windKph.toString()} Kph"),
                        ],),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            IconButton(
              iconSize: 40,
                tooltip: "Reload",
                onPressed: (){
              wm.clear();
              setState(() {});
              }, icon: Icon(Icons.cloud_circle))
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
