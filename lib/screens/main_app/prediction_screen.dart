import 'package:flutter/material.dart';
import '../../models/match_model.dart';
import '../../services/prediction_service.dart';
import '../../services/history_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PredictionScreen extends StatefulWidget {
  final MatchModel match;

  const PredictionScreen({super.key, required this.match});

  @override
  State<PredictionScreen> createState() =>
      _PredictionScreenState();
}

class _PredictionScreenState
    extends State<PredictionScreen> {
  String? selectedWinner;

  final TextEditingController homeScoreController =
  TextEditingController();
  final TextEditingController awayScoreController =
  TextEditingController();

  @override
  void dispose() {
    homeScoreController.dispose();
    awayScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;

    final sport =
    widget.match.sport.toLowerCase();

    return Scaffold(
      backgroundColor:
      theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
        theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          "Make Prediction",
          style: TextStyle(
            color:
            theme.colorScheme.onBackground,
            fontWeight:
            FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color:
          theme.colorScheme.onBackground,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // Match title
            Text(
              "${widget.match.homeTeam} vs ${widget.match.awayTeam}",
              style: TextStyle(
                color: theme
                    .colorScheme.onBackground,
                fontSize: 22,
                fontWeight:
                FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "${widget.match.date} • ${widget.match.time}",
              style:
              TextStyle(color: theme.hintColor),
            ),

            const SizedBox(height: 30),

            // Winner selection
            Text(
              "Select Winner",
              style: TextStyle(
                color: theme
                    .colorScheme.onBackground,
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            radioButton(widget.match.homeTeam),
            if (sport == "soccer")
              radioButton("Draw"),
            radioButton(widget.match.awayTeam),

            const SizedBox(height: 30),

            // Score inputs
            Text(
              "Predicted Score",
              style: TextStyle(
                color: theme
                    .colorScheme.onBackground,
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                    homeScoreController,
                    keyboardType:
                    TextInputType.number,
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      color: theme
                          .colorScheme
                          .onBackground,
                    ),
                    decoration:
                    InputDecoration(
                      labelText: widget
                          .match.homeTeam,
                      filled: true,
                      fillColor: isDark
                          ? const Color(
                          0xFF1A1A1D)
                          : Colors
                          .grey.shade100,
                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                            12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller:
                    awayScoreController,
                    keyboardType:
                    TextInputType.number,
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      color: theme
                          .colorScheme
                          .onBackground,
                    ),
                    decoration:
                    InputDecoration(
                      labelText: widget
                          .match.awayTeam,
                      filled: true,
                      fillColor: isDark
                          ? const Color(
                          0xFF1A1A1D)
                          : Colors
                          .grey.shade100,
                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                            12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 36),

            // Save prediction
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton
                    .styleFrom(
                  backgroundColor:
                  const Color(
                      0xFF2ECC71),
                  foregroundColor:
                  Colors.white,
                  padding:
                  const EdgeInsets
                      .symmetric(
                      vertical:
                      16),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius
                        .circular(
                        14),
                  ),
                ),
                onPressed: () async {
                  if (selectedWinner ==
                      null) {
                    ScaffoldMessenger.of(
                        context)
                        .showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Select a winner first")),
                    );
                    return;
                  }

                  final homeScore =
                      int.tryParse(
                          homeScoreController
                              .text) ??
                          0;
                  final awayScore =
                      int.tryParse(
                          awayScoreController
                              .text) ??
                          0;

                  String winnerValue;
                  if (selectedWinner ==
                      widget.match
                          .homeTeam) {
                    winnerValue =
                    "home";
                  } else if (selectedWinner ==
                      widget.match
                          .awayTeam) {
                    winnerValue =
                    "away";
                  } else {
                    winnerValue =
                    "draw";
                  }

                  final user = Supabase
                      .instance
                      .client
                      .auth
                      .currentUser;

                  if (user == null) {
                    ScaffoldMessenger.of(
                        context)
                        .showSnackBar(
                      const SnackBar(
                          content: Text(
                              "You must be logged in to save a prediction")),
                    );
                    return;
                  }

                  try {
                    await PredictionService
                        .savePrediction(
                      matchId:
                      widget.match.id,
                      userId: user.id,
                      predictedHomeScore:
                      homeScore,
                      predictedAwayScore:
                      awayScore,
                      predictedWinner:
                      winnerValue,
                    );

                    await HistoryService
                        .addToHistory(
                      matchId:
                      widget.match.id,
                      homeTeam: widget
                          .match.homeTeam,
                      awayTeam: widget
                          .match.awayTeam,
                      date:
                      widget.match.date ??
                          "",
                      time:
                      widget.match.time ??
                          "",
                      predictedHomeScore:
                      homeScore,
                      predictedAwayScore:
                      awayScore,
                      predictedWinner:
                      winnerValue,
                      sport: widget.match.sport,
                    );

                    ScaffoldMessenger.of(
                        context)
                        .showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Prediction saved!")),
                    );

                    Navigator.pop(
                        context);
                  } catch (e) {
                    ScaffoldMessenger.of(
                        context)
                        .showSnackBar(
                      SnackBar(
                          content: Text(
                              "Error saving prediction: $e")),
                    );
                  }
                },
                child: const Text(
                  "Save Prediction",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget radioButton(String value) {
    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;

    return Container(
      margin:
      const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A1A1D)
            : Colors.grey.shade100,
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.grey.shade800
              : Colors.grey.shade300,
        ),
      ),
      child: RadioListTile<String>(
        title: Text(
          value,
          style: TextStyle(
            color: theme
                .colorScheme.onBackground,
          ),
        ),
        value: value,
        groupValue: selectedWinner,
        activeColor:
        const Color(0xFF2ECC71),
        onChanged: (val) =>
            setState(() =>
            selectedWinner = val),
      ),
    );
  }
}
