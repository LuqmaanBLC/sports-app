import 'package:flutter/material.dart';
import '../../data/dummy_matches.dart';
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
    {"label": "Rugby", "icon": Icons.sports_rugby},
    {"label": "Cricket", "icon": Icons.sports_cricket},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredMatches = selectedSport == "All"
        ? dummyMatches
        : dummyMatches.where((m) => m.sport == selectedSport).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10), // Dark betting background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E10),
        elevation: 0,
        title: const Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false, // Removes the back arrow
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

          // Matches List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredMatches.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: MatchCard(match: filteredMatches[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}