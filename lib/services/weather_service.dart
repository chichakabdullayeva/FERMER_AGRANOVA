import 'dart:async';
import '../models/weather_model.dart';

class WeatherService {
  static final WeatherService _instance = WeatherService._internal();

  factory WeatherService() => _instance;

  WeatherService._internal();

  Future<WeatherReport> fetchWeather(String location) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return WeatherReport(
      location: location,
      currentTemperature: 23,
      currentCondition: 'Qismən Buludlu',
      humidity: 65,
      windSpeed: 12,
      rainfall: 0,
      lowTemperature: 18,
      highTemperature: 24,
      advice: 'Bu həftə yağışa ehtiyacınız var. Sulamaq üçün səhər və ya axşam vaxtını seçin.',
      forecast: const [
        WeatherForecast(day: 'Bazar', emoji: '⛅', temperature: 18, condition: 'Buludlu'),
        WeatherForecast(day: 'B.E', emoji: '☁️', temperature: 20, condition: 'Buludlu'),
        WeatherForecast(day: 'Çərş', emoji: '🌧️', temperature: 19, condition: 'Yağışlı'),
        WeatherForecast(day: 'Cümə', emoji: '⛅', temperature: 21, condition: 'Qismən Buludlu'),
        WeatherForecast(day: 'Cümə A', emoji: '☀️', temperature: 22, condition: 'Günəşli'),
        WeatherForecast(day: 'Şənb', emoji: '⛅', temperature: 20, condition: 'Qismən Buludlu'),
        WeatherForecast(day: 'Bazar', emoji: '☁️', temperature: 19, condition: 'Buludlu'),
      ],
    );
  }
}
