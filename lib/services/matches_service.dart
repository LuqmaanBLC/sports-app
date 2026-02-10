import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/match_model.dart';

class MatchesService {
  static final supabase = Supabase.instance.client;

  // Fetch matches by a list of IDs
  static Future<List<MatchModel>> fetchMatchesByIds(List<String> matchIds) async {
    if (matchIds.isEmpty) return [];

    final response = await supabase
        .from('matches')
        .select()
        .inFilter('id', matchIds);

    return response.map<MatchModel>((row) {
      return MatchModel(
        id: row['id'] as String,
        sport: row['sport'] as String,
        homeTeam: row['home_team'] as String,
        awayTeam: row['away_team'] as String,
        league: row['league'] as String,

        homeLogo: row['home_logo'],
        awayLogo: row['away_logo'],
        venue: row['venue'],
        time: row['time'],
        date: row['date'],

        finalScore: row['final_score'],
        finalWinner: row['final_winner'],
        predictedHomeScore: row['predicted_home_score'],
        predictedAwayScore: row['predicted_away_score'],
        actualHomeScore: row['actual_home_score'],
        actualAwayScore: row['actual_away_score'],
        isPredictionCorrect: row['is_prediction_correct'],
      );
    }).toList();

  }
}
