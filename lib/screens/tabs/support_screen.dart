import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/theme.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.supportTitle),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // AGRO-BOT Main Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.darkGreen, AppColors.forestGreen],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Robot Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.warmYellow.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🤖', style: TextStyle(fontSize: 60)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    loc.agroBot,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    loc.agroBotQuestion,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.warmYellow,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Kənd təsərrüfatı ilə bağlı suallarınızı soruşun. AQRO-BOT sizə dərhal cavab verəcək.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.sandBeige,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Start Chat Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to AI chat screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warmYellow,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Söhbətə Başla',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.darkGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Premium Features Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Premium Xidmətlər',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Expert Video Call Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.warmYellow.withOpacity(0.8),
                            AppColors.goldAccent.withOpacity(0.6),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('📞', style: TextStyle(fontSize: 40)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.specialistCall,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkGreen,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Yalnız Premium',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₼50 / 30 dəqiqə',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.darkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Show premium paywall
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkGreen,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Əl At',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Expert Network Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.skyBlue.withOpacity(0.3),
                            AppColors.lightBlue,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.darkGreen.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('👨‍💼', style: TextStyle(fontSize: 40)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ekspert Şəbəkəsi',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkGreen,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '450+ sertifikəli ekspert',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.mediumGray,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Bitkiçilik, heyvandarlıq, texnologiya...',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.darkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // FAQ Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tez-tez Soruşulan Suallar',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FAQItem(
                    question: 'AQRO-BOT necə istifadə edəm?',
                    answer: 'Sadəcə sualınızı yazın və cavab alın.',
                  ),
                  FAQItem(
                    question: 'Premium xidmətə necə qeydiyyat keçəm?',
                    answer: 'Premium bölümünə daxil olaraq aboneliyi aktiv edə bilərsiniz.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        onExpansionChanged: (expanded) {
          setState(() => _isExpanded = expanded);
        },
        title: Text(
          widget.question,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreen,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.answer,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.mediumGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
