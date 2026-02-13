class MatchModel {
  // Required (never null in DB)
  final String id;
  final String sport;
  final String homeTeam;
  final String awayTeam;

  // Nullable fields (can be null in Supabase)
  final String? homeLogo;
  final String? awayLogo;
  final String? venue;
  final String? time;
  final String? date;
  final String? league;
  final String? finalScore;
  final String? finalWinner;

  // Prediction / history fields
  final int? predictedHomeScore;
  final int? predictedAwayScore;
  final int? actualHomeScore;
  final int? actualAwayScore;
  final bool? isPredictionCorrect;

  MatchModel({
    required this.id,
    required this.sport,
    required this.homeTeam,
    required this.awayTeam,
    this.homeLogo,
    this.awayLogo,
    this.venue,
    this.time,
    this.date,
    this.league,
    this.finalScore,
    this.finalWinner,
    this.predictedHomeScore,
    this.predictedAwayScore,
    this.actualHomeScore,
    this.actualAwayScore,
    this.isPredictionCorrect,
  });

  factory MatchModel.fromJson(Map<String, dynamic> row) {
    return MatchModel(
      id: row['id'] as String,
      sport: row['sport'] as String,
      homeTeam: row['home_team'] as String,
      awayTeam: row['away_team'] as String,
      league: row['league'],
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
  }

  /// Safe getters (UI will never crash)
  String get safeHomeLogo => homeLogo ?? 'assets/images/default_team.png';
  String get safeAwayLogo => awayLogo ?? 'assets/images/default_team.png';
  String get safeVenue => venue ?? 'TBD';
  String get safeDate => date ?? 'TBD';
  String get safeTime => time ?? 'TBD';
  String get safeLeague => league ?? 'Unknown League';
}