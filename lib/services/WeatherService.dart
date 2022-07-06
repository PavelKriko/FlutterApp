import 'dart:convert';
import '../models/Weather.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static String _apiKey = "71bad617d11ec4d59a1ee45f7b8f7e36";//API key from openweathermap.org

  static Future<Weather> fetchCurrentWeather({query, String lat = "", String lon =""}) async {
    var url =
        'https://api.openweathermap.org/data/2.5/weather?q=$query&lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
    final response = await http.post(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  static Future<List<WeatherHourly>> fetchHourlyWeather({String query, String lat = "", String lon ="", int timezone}) async {
    var url =
        'https://api.openweathermap.org/data/2.5/forecast?q=$query&lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<WeatherHourly> data = (jsonData['list'] as List<dynamic>)
          .map((item) {
        return WeatherHourly.fromJson(item,timezone);
      }).toList();
      return data;
    } else {
      throw Exception('Failed to load weather');
    }
  }
}