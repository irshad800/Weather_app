import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/WeatherDataa.dart';
import 'package:weather_app/screens/searchPage.dart';
import 'package:weather_app/screens/waetherCard.dart';
import 'package:weather_app/widgets/weatherInfoColoumn.dart';

import '../controller/weatherController.dart';

class WeatherHomePage extends StatefulWidget {
  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  int _selectedIndex = 0;
  List<Widget> pages = [WeatherHomePage(), Placeholder(), SearchScreen()];

  void _onItemTapped(int index) {
    if (index == 1) {
      // Change index condition from 1 to 2
      _showBottomSheet(context); // Pass context to the method
    } else {
      setState(() {
        _selectedIndex = index;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(),
          ));
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent, // Make the bottom sheet background transparent
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(35.0),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              // Adjust the opacity for transparency
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Hourly Forecast",
                          style:
                              TextStyle(color: Colors.white.withOpacity(.5))),
                      Text(
                        "Weekly Forecast",
                        style: TextStyle(color: Colors.white.withOpacity(.5)),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 120, // Adjust height as needed
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        WeatherCard(
                            time: '12 AM',
                            temperature: '19',
                            chance: '30%',
                            icon:
                                'photo_2024-06-12_11-34-01-removebg-preview.png'),
                        WeatherCard(
                            time: 'Now',
                            temperature: '19',
                            chance: '50%',
                            icon:
                                'photo_2024-06-12_11-34-01-removebg-preview.png'),
                        WeatherCard(
                            time: '2 AM',
                            temperature: '18',
                            chance: '60%',
                            icon:
                                'photo_2024-06-12_11-34-01-removebg-preview.png'),
                        WeatherCard(
                            time: '3 AM',
                            temperature: '19',
                            chance: '80%',
                            icon:
                                'photo_2024-06-12_11-34-01-removebg-preview.png'),
                        WeatherCard(
                            time: '4 AM',
                            temperature: '19',
                            chance: '100%',
                            icon:
                                'photo_2024-06-12_11-34-01-removebg-preview.png'),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.blue.withOpacity(.7))),
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double? lat;
  double? longt;

  void getCurrentLocation() async {
    try {
      var position = await getlocation(context: context);
      setState(() {
        lat = position.latitude;
        longt = position.longitude;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  TextEditingController location = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<WeatherDataa>(
        future: WeatherS(lat: lat, longt: longt),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var weatherData = snapshot.data;
            return SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/img_6.png'))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 75),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                    )),
                                Center(
                                  child: Text(
                                    '${snapshot.data!.name}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Stack(
                                children: [
                                  Text(
                                    '${((snapshot.data!.main?.temp)! - 273.15).toStringAsFixed(0)}°',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 64,
                                    ),
                                  ),
                                  Positioned(
                                    top: 13,
                                    left: 95,
                                    right: 0,
                                    child: Text(
                                      'c',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                '${snapshot.data?.weather?[0].main.toString()}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Column(
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          height: 125,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color:
                                                  Colors.blue.withOpacity(0.7)),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  WeatherInfoColumn(
                                                    colort: Colors.black,
                                                    title: 'Temperature',
                                                    titlefontsze: 12,
                                                    valuefontsze: 25,
                                                    value:
                                                        '${((snapshot.data!.main?.temp)! - 273.15).toStringAsFixed(0)}°',
                                                  ),
                                                  WeatherInfoColumn(
                                                    title: 'Feel like',
                                                    titlefontsze: 12,
                                                    valuefontsze: 25,
                                                    value:
                                                        '${((snapshot.data!.main?.feelsLike)! - 273.15).toStringAsFixed(0)}°',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          height: 125,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color:
                                                  Colors.blue.withOpacity(0.7)),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Center(
                                                  child: Text(
                                                "on the day",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  WeatherInfoColumn(
                                                    icons: Icons.arrow_upward,
                                                  ),
                                                  SizedBox(width: 20),
                                                  WeatherInfoColumn(
                                                    title: 'Max',
                                                    titlefontsze: 12,
                                                  ),
                                                  SizedBox(width: 10),
                                                  WeatherInfoColumn(
                                                    value:
                                                        '${((snapshot.data!.main?.tempMax)! - 273.15).toStringAsFixed(0)}°',
                                                    valuefontsze: 25,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  WeatherInfoColumn(
                                                    icons: Icons.arrow_downward,
                                                  ),
                                                  SizedBox(width: 20),
                                                  WeatherInfoColumn(
                                                    title: 'Min',
                                                    titlefontsze: 12,
                                                  ),
                                                  SizedBox(width: 10),
                                                  WeatherInfoColumn(
                                                    value:
                                                        '${((snapshot.data!.main?.tempMin)! - 273.15).toStringAsFixed(0)}°',
                                                    valuefontsze: 25,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                                SizedBox(height: 15),
                                Container(
                                  height: 190,
                                  width: 303,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.blue.withOpacity(0.7)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          SizedBox(width: 20),
                                          WeatherInfoColumn(
                                            title: 'Humidity',
                                            titlefontsze: 14,
                                          ),
                                          SizedBox(width: 100),
                                          WeatherInfoColumn(
                                            value:
                                                '${((snapshot.data!.main?.humidity)!).toStringAsFixed(0)}%',
                                            valuefontsze: 22,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          SizedBox(width: 20),
                                          WeatherInfoColumn(
                                            title: 'Pressure',
                                            titlefontsze: 14,
                                          ),
                                          SizedBox(width: 100),
                                          WeatherInfoColumn(
                                            value:
                                                '${((snapshot.data!.main?.pressure)! - 273.15).toStringAsFixed(0)}mBar',
                                            valuefontsze: 22,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          SizedBox(width: 20),
                                          WeatherInfoColumn(
                                            title: 'Visibility',
                                            titlefontsze: 14,
                                          ),
                                          SizedBox(width: 100),
                                          WeatherInfoColumn(
                                            valuefontsze: 22,
                                            value:
                                                '${((snapshot.data!.visibility)! / 1000).toStringAsFixed(0)}km',
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          SizedBox(width: 20),
                                          WeatherInfoColumn(
                                            title: 'Wind Speed',
                                            titlefontsze: 14,
                                          ),
                                          SizedBox(width: 70),
                                          WeatherInfoColumn(
                                            value:
                                                '${((snapshot.data!.wind?.speed)! - 273.15).toStringAsFixed(1)}Km/h',
                                            valuefontsze: 22,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 14.0, right: 11),
                              child: Container(
                                height: 60,
                                width: 340,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue.withOpacity(0.7)),
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Text(
                                      '   Sunrise: ${DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch((snapshot.data!.sys?.sunrise ?? 0) * 1000))}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(
                                      Icons.sunny,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      '   Sunset: ${DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch((snapshot.data!.sys?.sunset ?? 0) * 1000))}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return CircularProgressIndicator();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue.withOpacity(0.4),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.blue,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
              label: "Add"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                color: Colors.blue,
              ),
              label: "Home"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white70,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
