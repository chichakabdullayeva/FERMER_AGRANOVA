import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/premium_service.dart';

class ExpertCallScreen extends StatefulWidget {
  const ExpertCallScreen({Key? key}) : super(key: key);

  @override
  State<ExpertCallScreen> createState() => _ExpertCallScreenState();
}

class _ExpertCallScreenState extends State<ExpertCallScreen> {
  final _topicController = TextEditingController();
  bool _isPremium = false;
  bool _loading = true;
  bool _booked = false;

  @override
  void initState() {
    super.initState();
    _checkPremium();
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _checkPremium() async {
    final premium = await PremiumService().isPremium();
    setState(() {
      _isPremium = premium;
      _loading = false;
    });
  }

  void _bookCall() {
    if (_topicController.text.trim().isEmpty) return;

    setState(() {
      _booked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ekspert Zəngi'),
        elevation: 4,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: _isPremium
                  ? _buildBookingForm(context)
                  : _buildUpgradePrompt(context),
            ),
    );
  }

  Widget _buildBookingForm(BuildContext context) {
    if (_booked) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.video_call, size: 76, color: AppColors.darkGreen),
            const SizedBox(height: 18),
            const Text(
              'Zəng təyin edildi!',
              style: TextStyle(
                color: AppColors.darkGreen,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ekspertlə 30 dəqiqəlik video zənginiz üçün vaxt təyin edildi. Sizə yaxın zamanda bildiriş göndəriləcək.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.darkGreen),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Ekspertlə danışmaq üçün qısa mövzunu yazın və zəngi planlaşdırın.',
          style: TextStyle(color: AppColors.darkGreen, fontSize: 16),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _topicController,
          decoration: InputDecoration(
            labelText: 'Mövzu',
            hintText: 'Məsələn: buğda xəstəlikləri, gübrələmə',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          minLines: 2,
          maxLines: 4,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _bookCall,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.warmYellow,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Zəngi Planlaşdır',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpgradePrompt(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock, size: 80, color: AppColors.error),
        const SizedBox(height: 20),
        const Text(
          'Ekspert zəngi yalnız Premium istifadəçilər üçün mövcuddur.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.darkGreen,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Premium-a keçid edərək video zənglərə, prioritet dəstəyə və ekspert məsləhətlərinə çıxış əldə edin.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.darkGreen),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.warmYellow,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Premium-ə yüksəlt',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
