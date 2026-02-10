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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          "Prediction History",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final history = snapshot.data!;

          if (history.isEmpty) {
            return Center(
              child: Text(
                "No prediction history found.",
                style: TextStyle(
                  color: theme.hintColor,
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];

              return Card(
                color: isDark
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isDark
                        ? Colors.grey.shade800
                        : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item['homeTeam']} vs ${item['awayTeam']}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme
                              .colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${item['date']} • ${item['time']}",
                        style: TextStyle(
                          color: theme.hintColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        "Your Prediction: ${item['predictedHomeScore']} - ${item['predictedAwayScore']}",
                        style: TextStyle(
                          color: theme
                              .colorScheme.onBackground,
                        ),
                      ),
                      Text(
                        "Winner: ${item['predictedWinner']}",
                        style: TextStyle(
                          color: theme
                              .colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2A2A2A)
                              : Colors.grey.shade100,
                          borderRadius:
                          BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          item["isPredictionCorrect"] ==
                              null
                              ? "Match not completed yet"
                              : item["isPredictionCorrect"] ==
                              true
                              ? "Correct Prediction ✔️"
                              : "Incorrect Prediction ❌",
                          style: TextStyle(
                            fontSize: 14,
                            color: item[
                            "isPredictionCorrect"] ==
                                null
                                ? theme.hintColor
                                : item["isPredictionCorrect"] ==
                                true
                                ? Colors.green
                                : Colors.red,
                            fontWeight:
                            FontWeight.bold,
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
