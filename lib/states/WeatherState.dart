import '../models/Weather.dart';

class WeatherState {
  Weather weather;
  List<WeatherHourly> hourlyWeather;

  WeatherState(this.weather,this.hourlyWeather);


  List<Object> get props => [weather, hourlyWeather];
}
