import 'package:flutter/material.dart';
import '../../models/match_model.dart';
import '../../services/prediction_service.dart';
import '../../services/history_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PredictionScreen extends StatefulWidget {
  final MatchModel match;

  const PredictionScreen({super.key, required this.match});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  String? selectedWinner;
  final TextEditingController homeScoreController = TextEditingController();
  final TextEditingController awayScoreController = TextEditingController();

  @override
  void dispose() {
    homeScoreController.dispose();
    awayScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sport = widget.match.sport.toLowerCase();

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E10),
        elevation: 0,
        title: const Text(
          "Make Prediction",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Match Title
            Text(
              "${widget.match.homeTeam} vs ${widget.match.awayTeam}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "${widget.match.date} • ${widget.match.time}",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // Winner Selection
            const Text(
              "Select Winner",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            radioButton(widget.match.homeTeam),
            if (sport == "soccer") radioButton("Draw"),
            radioButton(widget.match.awayTeam),

            const SizedBox(height: 30),

            // Score Inputs
            const Text(
              "Predicted Score",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: homeScoreController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: widget.match.homeTeam,
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF1A1A1D),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: awayScoreController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: widget.match.awayTeam,
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF1A1A1D),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 36),

            // Save Prediction CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedWinner == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Select a winner first")),
                    );
                    return;
                  }

                  final homeScore = int.tryParse(homeScoreController.text) ?? 0;
                  final awayScore = int.tryParse(awayScoreController.text) ?? 0;

                  String winnerValue;
                  if (selectedWinner == widget.match.homeTeam) {
                    winnerValue = "home";
                  } else if (selectedWinner == widget.match.awayTeam) {
                    winnerValue = "away";
                  } else {
                    winnerValue = "draw";
                  }

                  final user = Supabase.instance.client.auth.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("You must be logged in to save a prediction")),
                    );
                    return;
                  }

                  try {
                    // 🔹 Save prediction to Supabase
                    await PredictionService.savePrediction(
                      matchId: widget.match.id,
                      userId: user.id,
                      predictedHomeScore: homeScore,
                      predictedAwayScore: awayScore,
                      predictedWinner: winnerValue,
                    );

                    // 🔹 Save to local history
                    await HistoryService.addToHistory(
                      matchId: widget.match.id,
                      homeTeam: widget.match.homeTeam,
                      awayTeam: widget.match.awayTeam,
                      date: widget.match.date ?? "", // fixed,
                      time: widget.match.time ?? "", // fixed,
                      predictedHomeScore: homeScore,
                      predictedAwayScore: awayScore,
                      predictedWinner: winnerValue,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Prediction saved!")),
                    );

                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error saving prediction: $e")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Save Prediction",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: RadioListTile<String>(
        title: Text(
          value,
          style: const TextStyle(color: Colors.white),
        ),
        value: value,
        groupValue: selectedWinner,
        activeColor: const Color(0xFF2ECC71),
        onChanged: (val) => setState(() => selectedWinner = val),
      ),
    );
  }
}
