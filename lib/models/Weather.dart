
class Weather {
  final String cityName;
  final int temperature;
  final String iconCode;
  final String description;
  final DateTime time;
  final double windspeed;
  final int pressure;
  final double humidity;
  final int timezone;

  Weather(
  { this.cityName,
    this.temperature,
    this.iconCode,
    this.description, //sunny, snow , rainy ....
    this.time,
    this.windspeed,
    this.pressure,
    this.humidity,
    this.timezone});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        temperature: double.parse(json['main']['temp'].toString()).toInt(),
        iconCode: json['weather'][0]['icon'],
        description: json['weather'][0]['main'],
        time: DateTime.now().add(Duration(seconds: json['timezone'] - DateTime.now().timeZoneOffset.inSeconds)),
        windspeed: double.parse(json['wind']['speed'].toString()).toDouble(),
        pressure: int.parse(json['main']['pressure'].toString()).toInt(),
        humidity: double.parse(json['main']['humidity'].toString()).toDouble(),
        timezone: json['timezone']
    );
  }
}

class WeatherHourly{
  final int temperature;
  final String iconCode;
  final DateTime time;

  WeatherHourly({
    this.temperature,
    this.time,
    this.iconCode
});

  factory WeatherHourly.fromJson(Map<String, dynamic> json, int timezone) {
    return WeatherHourly(
      temperature: double.parse(json['main']['temp'].toString()).toInt(),
      iconCode: json['weather'][0]['icon'],
      time: DateTime.parse(json['dt_txt']).add(Duration(seconds: timezone - DateTime.parse(json['dt_txt']).timeZoneOffset.inSeconds)),
    );
  }

}
