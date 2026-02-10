// lib/screens/match_details_screen.dart
import 'package:flutter/material.dart';
import '../models/match_model.dart';
import 'main_app/prediction_screen.dart';

class MatchDetailsScreen extends StatelessWidget {
  final MatchModel match;

  const MatchDetailsScreen({super.key, required this.match});

  // Dummy head-to-head values (Option B: same for all matches)
  final int _homeWins = 2;
  final int _awayWins = 2;
  final int _draws = 1;

  /// Helper to load either a Supabase URL or a local asset
  Widget _teamLogo(String logoPath, {double height = 72}) {
    if (logoPath.startsWith("http")) {
      return Image.network(
        logoPath,
        height: height,
        errorBuilder: (_, __, ___) =>
            Image.asset('assets/images/default_team.png', height: height),
      );
    } else {
      return Image.asset(
        logoPath,
        height: height,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E10),
        elevation: 0,
        title: Text(
          "${match.homeTeam} vs ${match.awayTeam}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Teams Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _teamLogo(match.safeHomeLogo, height: 72),
                      const SizedBox(height: 8),
                      Text(
                        match.homeTeam,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Home",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                const Text(
                  "VS",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [
                      _teamLogo(match.safeAwayLogo, height: 72),
                      const SizedBox(height: 8),
                      Text(
                        match.awayTeam,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Away",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Match Info Section
            _DarkInfoCard(
              children: [
                _InfoRow(label: "Date", value: match.safeDate),
                _InfoRow(label: "Time", value: match.safeTime),
                _InfoRow(label: "League", value: match.safeLeague),
                _InfoRow(label: "Venue", value: match.safeVenue),
              ],
            ),

            const SizedBox(height: 16),

            // Head-to-Head Section
            _DarkInfoCard(
              children: [
                const Text(
                  "Head-to-Head (Last 5 Matches)",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatColumn(
                      title: match.homeTeam,
                      value: "Wins: $_homeWins",
                    ),
                    _StatColumn(
                      title: "Draws",
                      value: "$_draws",
                    ),
                    _StatColumn(
                      title: match.awayTeam,
                      value: "Wins: $_awayWins",
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Predict CTA
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PredictionScreen(match: match),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Make Prediction",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DarkInfoCard extends StatelessWidget {
  final List<Widget> children;

  const _DarkInfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1D),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade700, width: 1), // Subtle Border
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String title;
  final String value;

  const _StatColumn({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
