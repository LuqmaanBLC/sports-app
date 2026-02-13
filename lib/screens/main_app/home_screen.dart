import 'package:flutter/material.dart';
import '../../services/matches_service.dart';
import '../../models/match_model.dart';
import '../../widgets/match_card.dart';
import '../../widgets/sport_filter_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedSport = "All";

  final List<Map<String, dynamic>> sports = [
    {"label": "All", "icon": Icons.sports},
    {"label": "Soccer", "icon": Icons.sports_soccer},
    {"label": "Basketball", "icon": Icons.sports_basketball},
    {"label": "Ice Hockey", "icon": Icons.sports_hockey},
    {"label": "Golf", "icon": Icons.sports_golf},
    {"label": "Rugby", "icon": Icons.sports_rugby},
    {"label": "Tennis", "icon": Icons.sports_tennis},
    {"label": "Cricket", "icon": Icons.sports_cricket},
    {"label": "Volleyball", "icon": Icons.sports_volleyball},
    {"label": "Table Tennis", "icon": Icons.sports_tennis},
  ];


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sports Filter Row
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: sports.length,
              itemBuilder: (context, index) {
                final item = sports[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SportFilterItem(
                    label: item["label"],
                    icon: item["icon"],
                    isSelected: selectedSport == item["label"],
                    onTap: () {
                      setState(() {
                        selectedSport = item["label"];
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Matches List from Supabase
          Expanded(
            child: FutureBuilder<List<MatchModel>>(
              future: MatchesService.fetchAllMatches(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final matches = snapshot.data!;
                final filteredMatches = selectedSport == "All"
                    ? matches
                    : matches.where((m) => m.sport == selectedSport).toList();

                if (filteredMatches.isEmpty) {
                  return const Center(child: Text("No matches found."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredMatches.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: MatchCard(match: filteredMatches[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
