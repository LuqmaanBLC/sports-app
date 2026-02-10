import 'package:flutter/material.dart';
import '../../models/match_model.dart';
import '../../services/prediction_service.dart';
import '../../../data/dummy_matches.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          "Predictions",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false, // Removes the back arrow
      ),
      body: ListView.builder(
        itemCount: dummyMatches.length,
        itemBuilder: (context, index) {
          final MatchModel match = dummyMatches[index];

          final user = Supabase.instance.client.auth.currentUser;

          return FutureBuilder<Map<String, dynamic>?>(
            future: user == null
                ? Future.value(null) // no logged-in user
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
                  child: Text("Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red)),
                );
              }

              final prediction = snapshot.data;

              return Card(
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade700, width: 1), // subtle border added
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =======================
                      //    MATCH INFORMATION
                      // =======================
                      Text(
                        "${match.homeTeam} vs ${match.awayTeam}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Match Date: ${match.safeDate}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // =======================
                      //   USER PREDICTION BLOCK
                      // =======================
                      const Text(
                        "Your Prediction:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      prediction == null
                          ? const Text(
                        "No prediction made yet",
                        style: TextStyle(color: Colors.red),
                      )
                          : _buildPredictionDetails(prediction, match),

                      const SizedBox(height: 16),

                      // =======================
                      //   OTHER USERS (Mock)
                      // =======================
                      const Text(
                        "Other People's Predictions:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
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

                      // =======================
                      //   BUTTON (Make/Update)
                      // =======================
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PredictionScreen(match: match),
                              ),
                            );
                            setState(() {}); // Refresh after returning
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
      ),
    );
  }

  // =======================
  //   FORMATTED PREDICTION BLOCK (OPTION C)
  // =======================
  Widget _buildPredictionDetails(Map<String, dynamic> prediction, MatchModel match) {
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
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Winner: $winnerReadable",
              style: const TextStyle(fontSize: 14, color: Colors.white)),
          const SizedBox(height: 4),
          Text("Score: $homeScore - $awayScore",
              style: const TextStyle(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }


  // =======================
  //   MOCK OTHER USERS
  // =======================
  String _getMockOtherPredictions(String matchId) {
    Map<String, String> mockData = {
      "1": "60% say Manchester United wins",
      "2": "55% say Draw",
      "3": "70% say Australia wins",
    };
    return mockData[matchId] ?? "No data yet";
  }
}
