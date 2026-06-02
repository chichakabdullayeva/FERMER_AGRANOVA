import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/weather_model.dart';
import '../../services/weather_service.dart';
import '../../models/app_localizations_stub.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _locationController = TextEditingController(text: 'Gəncə, AZ');
  WeatherReport? _weatherReport;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWeather(_locationController.text);
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  AppLocalizations _localizations(BuildContext context) {
    return AppLocalizations.of(context) ?? AppLocalizationsEn();
  }

  Future<void> _loadWeather(String location) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final report = await WeatherService().fetchWeather(location);
      setState(() {
        _weatherReport = report;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Hava məlumatı yüklənərkən xəta baş verdi.';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshWeather() async {
    await _loadWeather(_locationController.text);
  }

  @override
  Widget build(BuildContext context) {
    final loc = _localizations(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(loc.weatherTitle),
          elevation: 4,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _weatherReport == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(loc.weatherTitle),
          elevation: 4,
        ),
        body: Center(
          child: Text(_error ?? 'Hava məlumatı mövcud deyil.'),
        ),
      );
    }

    final report = _weatherReport!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.weatherTitle),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: 'Şəhər və ya bölgə daxil edin',
                        prefixIcon: const Icon(Icons.location_on, color: AppColors.darkGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.darkGreen),
                        ),
                        filled: true,
                        fillColor: AppColors.lightGray,
                      ),
                      onSubmitted: (_) => _refreshWeather(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: _refreshWeather,
                    icon: const Icon(Icons.refresh, color: AppColors.darkGreen),
                    tooltip: 'Yenilə',
                  ),
                ],
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _error!,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.skyBlue, AppColors.lightBlue],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.weatherToday,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.darkGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.location,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.darkGreen,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${report.currentTemperature}°C',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreen,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        report.forecast.first.emoji,
                        style: const TextStyle(fontSize: 80),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    report.currentCondition,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.darkGreen,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  WeatherDetailCard(
                    title: loc.temperature,
                    value: '${report.lowTemperature}-${report.highTemperature}°C',
                    icon: Icons.thermostat,
                  ),
                  WeatherDetailCard(
                    title: loc.humidity,
                    value: '${report.humidity}%',
                    icon: Icons.opacity,
                  ),
                  WeatherDetailCard(
                    title: loc.windSpeed,
                    value: '${report.windSpeed} km/s',
                    icon: Icons.air,
                  ),
                  WeatherDetailCard(
                    title: loc.rainfall,
                    value: '${report.rainfall} mm',
                    icon: Icons.cloud_download,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '7 Günlük Proqnoz',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: report.forecast.length,
                      itemBuilder: (context, index) {
                        final day = report.forecast[index];

                        return Card(
                          margin: const EdgeInsets.only(right: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: 100,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.skyBlue.withOpacity(0.6),
                                  AppColors.lightBlue,
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  day.day,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkGreen,
                                  ),
                                ),
                                Text(
                                  day.emoji,
                                  style: const TextStyle(fontSize: 32),
                                ),
                                Text(
                                  '${day.temperature}°C',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.sandBeige,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '💡 Kənd Təsərrüfatı İpuçları',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        report.advice,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.darkGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class WeatherDetailCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const WeatherDetailCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.darkGreen, size: 24),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.darkGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.darkGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
