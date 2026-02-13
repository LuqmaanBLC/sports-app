import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryService {
  static final _client = Supabase.instance.client;

  /// Save a completed prediction entry into Supabase history table
  static Future<void> addToHistory({
    required String matchId,
    required String homeTeam,
    required String awayTeam,
    required String date,
    required String time,
    required int predictedHomeScore,
    required int predictedAwayScore,
    required String predictedWinner,
    required String sport,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client.from('history').insert({
      'match_id': matchId,
      'user_id': userId,
      'home_team': homeTeam,
      'away_team': awayTeam,
      'date': date, // stored as text like "Sat, 29 Nov 2025"
      'time': time,
      'predicted_home_score': predictedHomeScore,
      'predicted_away_score': predictedAwayScore,
      'predicted_winner': predictedWinner,
      'sport': sport,
      'actual_home_score': null,
      'actual_away_score': null,
      'final_winner': null,
      'is_prediction_correct': null,
    });
  }

  /// Load history entries with optional filters
  static Future<List<Map<String, dynamic>>> loadHistory({
    String? sport,
    String? team,
    String? date, // single date filter
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    var query = _client.from('history').select().eq('user_id', userId);

    if (sport != null) query = query.eq('sport', sport);
    if (team != null) {
      query = query.or('home_team.eq.$team,away_team.eq.$team');
    }
    if (date != null) query = query.eq('date', date);

    final response = await query.order('created_at', ascending: false);

    if (response == null) return [];

    return (response as List).map((item) {
      return {
        'matchId': item['match_id'],
        'homeTeam': item['home_team'],
        'awayTeam': item['away_team'],
        'date': item['date'],
        'time': item['time'],
        'predictedHomeScore': item['predicted_home_score'],
        'predictedAwayScore': item['predicted_away_score'],
        'predictedWinner': item['predicted_winner'],
        'actualHomeScore': item['actual_home_score'],
        'actualAwayScore': item['actual_away_score'],
        'finalWinner': item['final_winner'],
        'isPredictionCorrect': item['is_prediction_correct'],
      };
    }).toList();
  }
}
