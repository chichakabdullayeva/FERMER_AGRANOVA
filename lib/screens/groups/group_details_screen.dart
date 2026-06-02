import 'package:flutter/material.dart';
import '../../config/theme.dart';

class GroupDetailsScreen extends StatefulWidget {
  final String name;
  final String description;
  final int members;
  final String emoji;

  const GroupDetailsScreen({
    Key? key,
    required this.name,
    required this.description,
    required this.members,
    required this.emoji,
  }) : super(key: key);

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  bool _isJoined = false;

  void _toggleJoin() {
    setState(() {
      _isJoined = !_isJoined;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [AppColors.forestGreen, AppColors.sageGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.emoji,
                      style: const TextStyle(fontSize: 72),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${widget.members} üzv',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.sandBeige,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Qrup haqqında',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreen,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkGreen,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _toggleJoin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isJoined ? AppColors.error : AppColors.warmYellow,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _isJoined ? 'Qrupdan çıx' : 'Qrupa qoşul',
                  style: TextStyle(
                    color: _isJoined ? AppColors.white : AppColors.darkGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Qrup tapşırıqları',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _BulletItem(label: 'Aylıq məhsul mübadiləsi və məsləhət sessiyası'),
                      _BulletItem(label: 'Torpaq və gübrələmə üzrə kollektiv təkliflər'),
                      _BulletItem(label: 'Ehtiyac olduqda mütəxəssis zəngi planlaşdırın'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String label;

  const _BulletItem({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 20, color: AppColors.darkGreen)),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.darkGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
