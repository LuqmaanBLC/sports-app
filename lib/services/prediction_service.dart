import 'package:supabase_flutter/supabase_flutter.dart';

class PredictionService {
  static final supabase = Supabase.instance.client;

  // Save or update prediction details for a match
  static Future<void> savePrediction({
    required String matchId,
    required String userId, // link prediction to a user
    required int predictedHomeScore,
    required int predictedAwayScore,
    required String predictedWinner, // "home", "away", "draw"
  }) async {
    await supabase.from('predictions').upsert({
      'match_id': matchId,
      'user_id': userId,
      'predicted_home_score': predictedHomeScore,
      'predicted_away_score': predictedAwayScore,
      'predicted_winner': predictedWinner,
      'actual_home_score': null,
      'actual_away_score': null,
      'final_winner': null,
      'is_prediction_correct': null,
    }, onConflict: 'user_id,match_id'); // <-- tell Supabase which unique key to use
  }

  // Get prediction object for a specific match (for a given user)
  static Future<Map<String, dynamic>?> getPredictionForMatch(
      String matchId, String userId) async {
    final response = await supabase
        .from('predictions')
        .select()
        .eq('match_id', matchId)
        .eq('user_id', userId)
        .maybeSingle(); // safe: returns null if no row, avoids multiple-row error

    return response;
  }

  // Load all predictions for a user
  static Future<List<Map<String, dynamic>>> loadAllPredictions(
      String userId) async {
    final response = await supabase
        .from('predictions')
        .select()
        .eq('user_id', userId);

    return List<Map<String, dynamic>>.from(response);
  }

  // Update actual match results (when real scores are added later)
  static Future<void> updateMatchResult({
    required String matchId,
    required int actualHomeScore,
    required int actualAwayScore,
  }) async {
    // Fetch prediction first
    final prediction = await supabase
        .from('predictions')
        .select()
        .eq('match_id', matchId)
        .maybeSingle();

    if (prediction == null) return;

    final predictedHomeScore = prediction['predicted_home_score'];
    final predictedAwayScore = prediction['predicted_away_score'];

    // Determine winner
    String finalWinner;
    if (actualHomeScore > actualAwayScore) {
      finalWinner = "home";
    } else if (actualAwayScore > actualHomeScore) {
      finalWinner = "away";
    } else {
      finalWinner = "draw";
    }

    // Determine if prediction was correct
    bool correctPrediction = (predictedHomeScore == actualHomeScore &&
        predictedAwayScore == actualAwayScore);

    await supabase.from('predictions').update({
      'actual_home_score': actualHomeScore,
      'actual_away_score': actualAwayScore,
      'final_winner': finalWinner,
      'is_prediction_correct': correctPrediction,
    }).eq('match_id', matchId).eq('user_id', prediction['user_id']);
  }
}
