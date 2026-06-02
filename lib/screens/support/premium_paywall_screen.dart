import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/premium_service.dart';

class PremiumPaywallScreen extends StatefulWidget {
  const PremiumPaywallScreen({Key? key}) : super(key: key);

  @override
  State<PremiumPaywallScreen> createState() => _PremiumPaywallScreenState();
}

class _PremiumPaywallScreenState extends State<PremiumPaywallScreen> {
  bool _isPurchased = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final purchased = await PremiumService().isPremium();
    setState(() {
      _isPurchased = purchased;
      _loading = false;
    });
  }

  Future<void> _purchase() async {
    setState(() => _loading = true);
    await PremiumService().purchasePremium();
    setState(() {
      _isPurchased = true;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Xidmət'),
        elevation: 4,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [AppColors.warmYellow, AppColors.goldAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Aqro-Əvvəlcədən',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Ekspert zəngləri, dərhal məsləhətlər və prioritet dəstək ilə kənd təsərrüfatı fəaliyyətinizi irəli aparın.',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _BenefitTile(label: '30 dəqiqəlik mütəxəssis zəngi'),
                  _BenefitTile(label: 'Premium AQRO-BOT cavabları'),
                  _BenefitTile(label: 'Prioritet dəstək və təkliflər'),
                  const Spacer(),
                  if (_isPurchased)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Siz artıq Premium üzvüsünüz. Ekspert zənglərini və xüsusi məzmunu istifadə edə bilərsiniz.',
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: 16,
                        ),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: _purchase,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Premium-ə yüksəlt ₼50',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _BenefitTile extends StatelessWidget {
  final String label;

  const _BenefitTile({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.darkGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.darkGreen,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
