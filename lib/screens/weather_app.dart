import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled2/models/Weather.dart';
import 'package:http/http.dart' as http;
import '/states/WeatherState.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import '/components/WeatherHours.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static var weekdaymap = {
    1:'Monday',
    2:'Tuesday',
    3:'Wednesday',
    4:'Thursday',
    5:'Friday',
    6:'Saturday',
    7:'Sunday'
  };

  static var monthmap = {
    1:'January',
    2:'February',
    3:'March',
    4:'April',
    5:'May',
    6:'June',
    7:'July',
    8:'August',
    9:'September',
    10:'October',
    11:'November',
    12:'December',
  };

  static String _apiKey = "71bad617d11ec4d59a1ee45f7b8f7e36";//API key from openweathermap.org

  WeatherState state;
  Weather _currentWeather;
  List<WeatherHourly> _currentHourlyWeather;
  String _lat ;
  String _lon ;

  void updatePos() async {

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always){
      Position lastKnownPosition = await Geolocator.getLastKnownPosition();
      if (lastKnownPosition != null) {
          _lat = lastKnownPosition.latitude.toString();
          _lon = lastKnownPosition.longitude.toString();
      } else {
        Position position =
        await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        _lat = position.latitude.toString();
        _lon = position.longitude.toString();
      }
    }
    else{
      print('NO PERMISSION');
    }
  }

  void updateWeather({String lat, String lon}) async{
    var url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?&lat=$lat&lon=$lon&appid=$_apiKey&units=metric');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      _currentWeather = Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  void updateHourlyWeather({String lat , String lon, int timezone}) async{
    var url = Uri.parse('https://api.openweathermap.org/data/2.5/forecast?&lat=$lat&lon=$lon&appid=$_apiKey&units=metric');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<WeatherHourly> data = (jsonData['list'] as List<dynamic>)
          .map((item) {
        return WeatherHourly.fromJson(item,timezone);
      }).toList();
      _currentHourlyWeather = data;
    } else {
      throw Exception('Failed to load weather');
    }
  }


  void updateWeatherState() async{
    await updatePos();
    await updateWeather(lat: _lat,lon: _lon);
    await updateHourlyWeather(lat: _lat,lon: _lon,timezone: _currentWeather.timezone);
    state = WeatherState(_currentWeather, _currentHourlyWeather);

  }

  @override
  void initState() {
    updateWeatherState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_lat!=null && _lat!=null) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Container(
              child:
              Stack(
                children: [
                  (state.weather.time.hour >= 22 ||
                      state.weather.time.hour <= 5) ?
                  Image.asset('assets/${state.weather.description}Night.jpg',
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ) : Image.asset(
                    'assets/${state.weather.description}Light.jpg',
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.black26),
                  ),
                  Container(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //for space between the top and bottom
                            children: [
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 80,),
                                    Text('${state.weather.cityName}',
                                      style: GoogleFonts.dancingScript(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),),
                                    SizedBox(height: 5),
                                    Text('${state.weather.time
                                        .day} - ${weekdaymap[state.weather.time
                                        .weekday]} - ${monthmap[state.weather
                                        .time.month]} - ${state.weather.time
                                        .year}',
                                        style: GoogleFonts.dancingScript(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Now - ${state.weather.time.hour}:${state
                                          .weather.time.minute}',
                                      style: GoogleFonts.dancingScript(
                                          fontSize: 44,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),),
                                    Text('${state.weather.temperature}\u2103',
                                      style: GoogleFonts.dancingScript(
                                          fontSize: 85,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),),
                                    Row(
                                      children: [
                                        Image.network(
                                            "http://openweathermap.org/img/wn/${state
                                                .weather.iconCode}@2x.png",
                                            scale: 2),
                                        SizedBox(width: 10,),
                                        Text('${state.weather.description}',
                                            style: GoogleFonts.dancingScript(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white)),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Column(children: [
                                            Text('Wind', style: GoogleFonts
                                                .dancingScript(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                            Text('${state.weather.windspeed}',
                                                style: GoogleFonts
                                                    .dancingScript(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            Text('m/s', style: GoogleFonts
                                                .dancingScript(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                          ],),
                                          Column(children: [
                                            Text('Pressure', style: GoogleFonts
                                                .dancingScript(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                            Text('${state.weather.pressure}',
                                                style: GoogleFonts
                                                    .dancingScript(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            Text('hPa', style: GoogleFonts
                                                .dancingScript(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                          ],),
                                          Column(children: [
                                            Text('Humidity', style: GoogleFonts
                                                .dancingScript(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                            Text('${state.weather.humidity}',
                                                style: GoogleFonts
                                                    .dancingScript(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            Text('%', style: GoogleFonts
                                                .dancingScript(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                          ],)
                                        ],),
                                    )
                                  ],
                                ),
                              ),
                              Container(child: HourlyWeather(
                                  hourlyWeather: state.hourlyWeather),
                                color: Colors.black54,)
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              )
          ),
        ),
      );
    }
    else{
      return Center(
        child: Text("Can't find you"),
      );
    }
  }
}


