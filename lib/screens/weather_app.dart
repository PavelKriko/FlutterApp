import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


import '/delegates/SearchDelegate.dart';
import '/events/WeatherEvent.dart';
import '/states/WeatherState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/WeatherBloc.dart';
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

  static var month = {

  };


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(),
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoadSuccess) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading:  IconButton(
                  icon: Icon(Icons.my_location,size: 30,color: Colors.white,),
                  onPressed: () {
                    BlocProvider.of<WeatherBloc>(context).add(WeatherCurrentPositionRequested());
                  },
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: IconButton(
                      icon: Icon(Icons.search,size: 30,color: Colors.white,),
                      onPressed: () {
                        showSearch(
                            context: context, delegate: MySearchDelegate((query) {
                          BlocProvider.of<WeatherBloc>(context).add(WeatherRequested(city: query));
                        }));
                      },
                    ),
                  )
                ],
              ),
              body: Center(
                child: Container(
                    child:
                    Stack(
                      children: [
                        (state.weather.time.hour >=22 ||state.weather.time.hour<=5)?
                        Image.asset('assets/${state.weather.description}Night.jpg',fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ):Image.asset('assets/${state.weather.description}Light.jpg',fit: BoxFit.cover,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //for space between the top and bottom
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 80,),
                                          Text('${state.weather.cityName}', style: GoogleFonts.dancingScript(
                                              fontSize: 35, fontWeight: FontWeight.bold,color: Colors.white),),
                                          SizedBox(height: 5),
                                          Text('${state.weather.time.day} - ${weekdaymap[state.weather.time.weekday]} - ${monthmap[state.weather.time.month]} - ${state.weather.time.year}',style: GoogleFonts.dancingScript(
                                              fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Now - ${state.weather.time.hour}:${state.weather.time.minute}', style: GoogleFonts.dancingScript(
                                              fontSize: 44, fontWeight: FontWeight.w400,color: Colors.white),),
                                          Text('${state.weather.temperature}\u2103', style: GoogleFonts.dancingScript(
                                              fontSize: 85, fontWeight: FontWeight.w400,color: Colors.white),),
                                          Row(
                                            children: [
                                              Image.network("http://openweathermap.org/img/wn/${state.weather.iconCode}@2x.png", scale: 2),
                                              SizedBox(width: 10,),
                                              Text('${state.weather.description}',style: GoogleFonts.dancingScript(
                                                  fontSize: 25, fontWeight: FontWeight.w500,color: Colors.white)),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(children: [
                                                  Text('Wind',style: GoogleFonts.dancingScript(
                                                      fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white)),
                                                  Text('${state.weather.windspeed}',style: GoogleFonts.dancingScript(
                                                      fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white)),
                                                  Text('m/s',style: GoogleFonts.dancingScript(
                                                      fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white)),
                                                ],),
                                                Column(children: [
                                                  Text('Pressure',style: GoogleFonts.dancingScript(
                                                      fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white)),
                                                  Text('${state.weather.pressure}',style: GoogleFonts.dancingScript(
                                                      fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white)),
                                                  Text('hPa',style: GoogleFonts.dancingScript(
                                                      fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white)),
                                                ],),
                                                Column(children: [
                                                  Text('Humidity',style: GoogleFonts.dancingScript(
                                                      fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white)),
                                                  Text('${state.weather.humidity}',style: GoogleFonts.dancingScript(
                                                      fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white)),
                                                  Text('%',style: GoogleFonts.dancingScript(
                                                      fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white)),
                                                ],)
                                              ],),
                                          )
                                        ],
                                      ),
                                    ),
                                        Container(child: HourlyWeather(hourlyWeather: state.hourlyWeather),color: Colors.black54,)
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
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                actions: [
                  IconButton(
                    icon: Icon(Icons.my_location),
                    onPressed: () {
                      BlocProvider.of<WeatherBloc>(context).add(WeatherCurrentPositionRequested());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                          context: context, delegate: MySearchDelegate((query) {
                        BlocProvider.of<WeatherBloc>(context).add(WeatherRequested(city: query));
                      }));
                    },
                  )
                ],
              ),
              body: Center(
                child: CircularProgressIndicator(),
              )
          );
        },
      ),
    );
  }
}
