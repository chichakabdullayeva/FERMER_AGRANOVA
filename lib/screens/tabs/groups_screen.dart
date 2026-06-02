import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/theme.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.groupsTitle),
        elevation: 4,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Qrupları axtar...',
                prefixIcon: const Icon(Icons.search, color: AppColors.darkGreen),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.darkGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.darkGreen, width: 2),
                ),
                filled: true,
                fillColor: AppColors.lightGray,
              ),
            ),
          ),

          // Groups Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return GroupCard(index: index, loc: loc);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create group screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final int index;
  final AppLocalizations loc;

  const GroupCard({
    Key? key,
    required this.index,
    required this.loc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupNames = [
      'Gəncə Fermerləri',
      'Buğday Uchunlar',
      'Biotexnologiya',
      'Kənd Sərgi Qrupları',
      'Toxum Mübadilə',
      'Heyvandarlıq'
    ];
    
    final memberCounts = [145, 89, 234, 67, 123, 156];

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to group details
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.forestGreen.withOpacity(0.8),
                AppColors.sageGreen.withOpacity(0.6),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Group Avatar Area
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkGreen.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Text(
                      ['👥', '🌾', '🧬', '🎪', '🌱', '🐄'][index % 6],
                      style: const TextStyle(fontSize: 56),
                    ),
                  ),
                ),
              ),
              // Group Info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groupNames[index % 6],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${memberCounts[index % 6]} üzv',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.sandBeige,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.warmYellow,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          index % 3 == 0 ? 'Qatıl' : 'Qrupda',
                          style: const TextStyle(
                            color: AppColors.darkGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
