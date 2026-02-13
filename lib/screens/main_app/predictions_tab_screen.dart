import 'package:flutter/material.dart';
import '../../models/match_model.dart';
import '../../services/prediction_service.dart';
import '../../services/matches_service.dart'; // ✅ use service instead of dummy
import 'prediction_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PredictionsTabScreen extends StatefulWidget {
  const PredictionsTabScreen({super.key});

  @override
  State<PredictionsTabScreen> createState() => _PredictionsTabScreenState();
}

class _PredictionsTabScreenState extends State<PredictionsTabScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          "Predictions",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<MatchModel>>(
        future: MatchesService.fetchAllMatches(), // ✅ load from Supabase
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final matches = snapshot.data!;
          if (matches.isEmpty) {
            return const Center(child: Text("No matches available."));
          }

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              final user = Supabase.instance.client.auth.currentUser;

              return FutureBuilder<Map<String, dynamic>?>(
                future: user == null
                    ? Future.value(null)
                    : PredictionService.getPredictionForMatch(match.id, user.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final prediction = snapshot.data;

                  return Card(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Match info
                          Text(
                            "${match.homeTeam} vs ${match.awayTeam}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Match Date: ${match.safeDate}",
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.hintColor,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Prediction block
                          Text(
                            "Your Prediction:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(height: 6),

                          prediction == null
                              ? const Text(
                            "No prediction made yet",
                            style: TextStyle(color: Colors.red),
                          )
                              : _buildPredictionDetails(prediction, match, context),

                          const SizedBox(height: 16),

                          // Other predictions (mock data for now)
                          Text(
                            "Other People's Predictions:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _getMockOtherPredictions(match.id),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Button
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PredictionScreen(match: match),
                                  ),
                                );
                                setState(() {});
                              },
                              child: Text(
                                prediction == null
                                    ? "Make Prediction"
                                    : "Update Prediction",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPredictionDetails(
      Map<String, dynamic> prediction, MatchModel match, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final String winner = prediction["predicted_winner"] ?? "";
    final int homeScore = prediction["predicted_home_score"] ?? 0;
    final int awayScore = prediction["predicted_away_score"] ?? 0;

    String winnerReadable;
    if (winner == "home") {
      winnerReadable = match.homeTeam;
    } else if (winner == "away") {
      winnerReadable = match.awayTeam;
    } else {
      winnerReadable = "Draw";
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Winner: $winnerReadable",
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Score: $homeScore - $awayScore",
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }

  String _getMockOtherPredictions(String matchId) {
    Map<String, String> mockData = {
      "1": "60% say Manchester United wins",
      "2": "55% say Draw",
      "3": "70% say Australia wins",
    };
    return mockData[matchId] ?? "No data yet";
  }
}
