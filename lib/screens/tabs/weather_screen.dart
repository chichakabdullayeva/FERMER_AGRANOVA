import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/theme.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.weatherTitle),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Current Weather Card
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
                            'Gəncə, AZ',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.darkGreen,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '23°C',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreen,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '⛅',
                        style: const TextStyle(fontSize: 80),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Qismən Bulud',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.darkGreen,
                    ),
                  ),
                ],
              ),
            ),

            // Weather Details Grid
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
                    value: '18-24°C',
                    icon: Icons.thermometer,
                  ),
                  WeatherDetailCard(
                    title: loc.humidity,
                    value: '65%',
                    icon: Icons.opacity,
                  ),
                  WeatherDetailCard(
                    title: loc.windSpeed,
                    value: '12 km/s',
                    icon: Icons.air,
                  ),
                  WeatherDetailCard(
                    title: loc.rainfall,
                    value: '0 mm',
                    icon: Icons.cloud_download,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 7-Day Forecast
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
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        final days = ['Bazar', 'B.E', 'Çərş', 'Cümə', 'Cümə A', 'Şənb', 'Bazar'];
                        final temps = [18, 20, 19, 21, 22, 20, 19];
                        final icons = ['⛅', '☁️', '🌧️', '⛅', '☀️', '⛅', '☁️'];

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
                                  days[index],
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkGreen,
                                  ),
                                ),
                                Text(
                                  icons[index],
                                  style: const TextStyle(fontSize: 32),
                                ),
                                Text(
                                  '${temps[index]}°C',
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

            // Agricultural Tips
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
                        'Bu həftə yağışa ehtiyacınız var. Sulamaq üçün əlverişli hava olacaq. Pestisid sprotlamaqdan əvvəl 2 gün gözləyin.',
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.forestGreen.withOpacity(0.1),
              AppColors.skyBlue.withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.darkGreen, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.mediumGray,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
