class WeatherForecast {
  final String day;
  final String emoji;
  final int temperature;
  final String condition;

  const WeatherForecast({
    required this.day,
    required this.emoji,
    required this.temperature,
    required this.condition,
  });
}

class WeatherReport {
  final String location;
  final int currentTemperature;
  final String currentCondition;
  final int humidity;
  final int windSpeed;
  final int rainfall;
  final int lowTemperature;
  final int highTemperature;
  final String advice;
  final List<WeatherForecast> forecast;

  const WeatherReport({
    required this.location,
    required this.currentTemperature,
    required this.currentCondition,
    required this.humidity,
    required this.windSpeed,
    required this.rainfall,
    required this.lowTemperature,
    required this.highTemperature,
    required this.advice,
    required this.forecast,
  });
}
