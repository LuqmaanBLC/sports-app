import 'package:flutter/material.dart';
import '../../services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<dynamic>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = HistoryService.loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          "Prediction History",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false, // Removes the back arrow
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final history = snapshot.data!;

          if (history.isEmpty) {
            return const Center(
              child: Text(
                "No prediction history found.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];

              return Card(
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade700, width: 1), // Subtle Border
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Match info
                      Text(
                        "${item['homeTeam']} vs ${item['awayTeam']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${item['date']} • ${item['time']}",
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 16),

                      // Prediction details
                      Text(
                        "Your Prediction: ${item['predictedHomeScore']} - ${item['predictedAwayScore']}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Winner: ${item['predictedWinner']}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 12),

                      // Status block
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade700), // Subtle Border
                        ),
                        child: Text(
                          item["isPredictionCorrect"] == null
                              ? "Match not completed yet"
                              : item["isPredictionCorrect"] == true
                              ? "Correct Prediction ✔️"
                              : "Incorrect Prediction ❌",
                          style: TextStyle(
                            fontSize: 14,
                            color: item["isPredictionCorrect"] == null
                                ? Colors.grey
                                : item["isPredictionCorrect"] == true
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
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
}
