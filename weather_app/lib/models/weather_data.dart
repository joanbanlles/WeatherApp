import 'package:weather_app/services/location_services.dart';
import 'package:flutter/material.dart';

class WeatherData {
  final Location location;
  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  WeatherData({
    required this.location,
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: Location.fromJson(json['location']),
      current: CurrentWeather.fromJson(json['current']),
      hourly:
          (json['forecast']['forecastday'][0]['hour'] as List)
              .map((e) => HourlyForecast.fromJson(e))
              .toList(),
      daily:
          (json['forecast']['forecastday'] as List)
              .map((e) => DailyForecast.fromJson(e))
              .toList(),
    );
  }

  static Future<String> getCurrentLocationName() async {
    final locationService = LocationService();
    try {
      final coordinates = await locationService.getCurrentLocation();
      final double latitude = coordinates['latitude'] ?? 0.0;
      final double longitude = coordinates['longitude'] ?? 0.0;

      if (latitude == 0.0 && longitude == 0.0) {
        throw Exception('Invalid coordinates received.');
      }

      final locationName = await locationService.getLocationName(
        latitude,
        longitude,
      );
      return locationName;
    } catch (e) {
      return 'Error: $e';
    }
  }
}

class Location {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}

class WeatherCondition {
  final String text;
  final String icon;

  WeatherCondition({required this.text, required this.icon});

  factory WeatherCondition.fromJson(Map<String, dynamic> json) {
    return WeatherCondition(text: json['text'], icon: json['icon']);
  }
}

class CurrentWeather {
  final double tempC;
  final double feelslikeC;
  final WeatherCondition condition;
  final double windKph;
  final int humidity;
  final double uv;

  CurrentWeather({
    required this.tempC,
    required this.feelslikeC,
    required this.condition,
    required this.windKph,
    required this.humidity,
    required this.uv,
  });

  String get conditionIcon => condition.icon;
  String get conditionText => condition.text;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      tempC: json['temp_c'],
      feelslikeC: json['feelslike_c'],
      condition: WeatherCondition.fromJson(json['condition']),
      windKph: json['wind_kph'],
      humidity: json['humidity'],
      uv: json['uv'],
    );
  }
}

class DailyDay {
  final double maxtempC;
  final double mintempC;
  final WeatherCondition condition;

  DailyDay({
    required this.maxtempC,
    required this.mintempC,
    required this.condition,
  });

  factory DailyDay.fromJson(Map<String, dynamic> json) {
    return DailyDay(
      maxtempC: json['maxtemp_c'],
      mintempC: json['mintemp_c'],
      condition: WeatherCondition.fromJson(json['condition']),
    );
  }
}

class DailyForecast {
  final DateTime date;
  final DailyDay day;

  DailyForecast({required this.date, required this.day});

  String get conditionIcon => day.condition.icon;
  double get maxTempC => day.maxtempC;
  double get minTempC => day.mintempC;

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.parse(json['date']),
      day: DailyDay.fromJson(json['day']),
    );
  }
}

class HourlyForecast {
  final DateTime time;
  final double tempC;
  final WeatherCondition condition;

  HourlyForecast({
    required this.time,
    required this.tempC,
    required this.condition,
  });

  String get conditionIcon => condition.icon;

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: DateTime.parse(json['time']),
      tempC: json['temp_c'],
      condition: WeatherCondition.fromJson(json['condition']),
    );
  }
}
