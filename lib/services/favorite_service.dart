import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/match_model.dart';

class FavoriteService {
  static final supabase = Supabase.instance.client;

  // Get all favorites for the current user
  static Future<List<String>> getFavoriteMatchIds(String? userId) async {
    if (userId == null) return []; // guard against null

    final response = await supabase
        .from('favorites')
        .select('match_id')
        .eq('user_id', userId);

    return List<String>.from(response.map((row) => row['match_id']));
  }

  // Check if a match is favorited
  static Future<bool> isFavorite(String matchId, String? userId) async {
    if (userId == null) return false; // guard against null

    final response = await supabase
        .from('favorites')
        .select()
        .eq('user_id', userId)
        .eq('match_id', matchId)
        .maybeSingle();

    return response != null;
  }

  // Toggle favorite (add/remove)
  static Future<void> toggleFavorite(MatchModel match, String? userId) async {
    if (userId == null) return; // guard against null

    final isFav = await isFavorite(match.id, userId);

    if (isFav) {
      await supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('match_id', match.id);
    } else {
      await supabase.from('favorites').insert({
        'user_id': userId,
        'match_id': match.id,
      });
    }
  }
}
