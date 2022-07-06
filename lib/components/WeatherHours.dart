import '/models/Weather.dart';
import 'package:flutter/widgets.dart';

import 'WeatherCard.dart';



class HourlyWeather extends StatelessWidget {
  final List<WeatherHourly> hourlyWeather;

  static var map = {
    1:'Mo',
    2:'Tu',
    3:'We',
    4:'Th',
    5:'Fr',
    6:'Sa',
    7:'Su'
  };

  const HourlyWeather({Key key, this.hourlyWeather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyWeather.length,
            itemBuilder: (context, i) {
              return WeatherCard(
                date: '${map[hourlyWeather[i].time.weekday]} ${hourlyWeather[i].time.month}',
                title:
                '${hourlyWeather[i].time.hour}:${hourlyWeather[i].time.minute}0',
                temperature: hourlyWeather[i].temperature.toInt(),
                iconCode: hourlyWeather[i].iconCode
              );
            }));
  }
}
