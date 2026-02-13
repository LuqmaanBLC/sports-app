import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/match_model.dart';

class MatchesService {
  static final supabase = Supabase.instance.client;

  /// Fetch matches by a list of IDs
  static Future<List<MatchModel>> fetchMatchesByIds(List<String> matchIds) async {
    if (matchIds.isEmpty) return [];

    final response = await supabase
        .from('matches')
        .select()
        .inFilter('id', matchIds);

    return response.map<MatchModel>((row) => MatchModel.fromJson(row)).toList();
  }

  /// Fetch all matches from the database
  static Future<List<MatchModel>> fetchAllMatches() async {
    final response = await supabase
        .from('matches')
        .select()
        .order('date', ascending: true);

    return response.map<MatchModel>((row) => MatchModel.fromJson(row)).toList();
  }

  /// Fetch matches filtered by sport (optional)
  static Future<List<MatchModel>> fetchMatchesBySport(String sport) async {
    final response = await supabase
        .from('matches')
        .select()
        .eq('sport', sport)
        .order('date', ascending: true);

    return response.map<MatchModel>((row) => MatchModel.fromJson(row)).toList();
  }
}
