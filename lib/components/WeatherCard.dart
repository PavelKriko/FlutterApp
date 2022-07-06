import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherCard extends StatelessWidget {
  final String date;
  final String title;
  final int temperature;
  final String iconCode;
  final double iconScale;

  const WeatherCard({Key key,this.date = '', this.title, this.temperature, this.iconCode, this.iconScale = 2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Выровним по центру
          children: [
            Text(this.date,style: GoogleFonts.dancingScript(height: 1,color: Colors.white,fontWeight: FontWeight.bold),),
            Text(this.title,style: GoogleFonts.dancingScript(height: 1,color: Colors.white,fontWeight: FontWeight.bold)),
            Image.network("http://openweathermap.org/img/wn/${this.iconCode}@2x.png", scale: this.iconScale),
            Text(
              '${this.temperature}°',
              style: GoogleFonts.dancingScript(height: 1,color: Colors.white,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}