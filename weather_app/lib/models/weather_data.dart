class WeatherData {
  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  WeatherData({
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      current: CurrentWeather.fromJson(json['current']),
      hourly:
          (json['hourly'] as List)
              .map((e) => HourlyForecast.fromJson(e))
              .toList(),
      daily:
          (json['daily'] as List)
              .map((e) => DailyForecast.fromJson(e))
              .toList(),
    );
  }
}

class CurrentWeather {
  final double temp;
  final double feelsLike;
  final String description;
  final String icon;

  CurrentWeather({
    required this.temp,
    required this.feelsLike,
    required this.description,
    required this.icon,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temp: json['temp'].toDouble(),
      feelsLike: json['feels_like'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}

class HourlyForecast {
  final DateTime dt;
  final double temp;
  final String icon;

  HourlyForecast({required this.dt, required this.temp, required this.icon});

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      dt: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temp: json['temp'].toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }
}

class DailyForecast {
  final DateTime dt;
  final double tempMax;
  final double tempMin;
  final String icon;

  DailyForecast({
    required this.dt,
    required this.tempMax,
    required this.tempMin,
    required this.icon,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      dt: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      tempMax: json['temp']['max'].toDouble(),
      tempMin: json['temp']['min'].toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }
}
