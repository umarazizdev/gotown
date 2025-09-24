import 'package:flutter/material.dart';
import 'package:gotown/main.dart';
import 'package:gotown/utilities/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  List<String> cities = [];
  bool _isLoading = true;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _loadSelectedCity();
    _fetchCities();
  }

  void _loadSelectedCity() {
    _selectedCity = box.read('selectedCity');
  }

  Future<void> _fetchCities() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('event_city')
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        if (data.containsKey('city') && data['city'] is List) {
          final List<dynamic> cityList = data['city'];
          final List<String> fetchedCities = cityList
              .whereType<String>()
              .where((city) => city.isNotEmpty)
              .toList();

          if (fetchedCities.isNotEmpty) {
            setState(() {
              cities = fetchedCities;
              // If no city is selected yet, select the first one
              if (_selectedCity == null && cities.isNotEmpty) {
                _selectedCity = cities.first;
                box.write('selectedCity', _selectedCity);
              }
              _isLoading = false;
            });
            return;
          }
        }
      }

      // Fallback if no cities found
      setState(() {
        cities = ['Wroclaw'];
        if (_selectedCity == null) {
          _selectedCity = 'Wroclaw';
          box.write('selectedCity', _selectedCity);
        }
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching cities: $e');
      // Fallback on error
      setState(() {
        cities = ['Wroclaw'];
        if (_selectedCity == null) {
          _selectedCity = 'Wroclaw';
          box.write('selectedCity', _selectedCity);
        }
        _isLoading = false;
      });
    }
  }

  void _selectCity(String city) {
    setState(() {
      _selectedCity = city;
    });
    box.write('selectedCity', city);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final displayCityName = _selectedCity?.split(',').first ?? 'Wroclaw';

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: h * 0.055),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Hello ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cwhite,
                        fontSize: 22,
                      ),
                    ),
                    TextSpan(
                      text: displayCityName,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: cwhitetext,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            const Text(
              "City",
              style: TextStyle(
                  color: cwhitetext, fontSize: 26, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: h * 0.005),

            // Loading indicator or city list
            _isLoading
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: h * 0.02),
                      child: const CircularProgressIndicator(
                        color: corange,
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        final city = cities[index];
                        final isSelected = _selectedCity == city;

                        return Container(
                          margin: const EdgeInsets.all(4),
                          height: h * 0.06,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: clbg,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  _selectCity(city);
                                },
                                side:
                                    const BorderSide(color: corange, width: 2),
                                activeColor: corange,
                                checkColor: Colors.white,
                              ),
                              Text(
                                city,
                                style: const TextStyle(
                                  color: cwhitetext,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

            const Spacer(),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                "More cities coming soon",
                style: TextStyle(
                  color: Color(0xff7896cc),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: h * 0.04),
          ],
        ),
      ),
    );
  }
}
