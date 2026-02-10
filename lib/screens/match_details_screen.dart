import 'package:flutter/material.dart';
import '../models/match_model.dart';
import 'main_app/prediction_screen.dart';

class MatchDetailsScreen extends StatelessWidget {
  final MatchModel match;

  const MatchDetailsScreen({super.key, required this.match});

  final int _homeWins = 2;
  final int _awayWins = 2;
  final int _draws = 1;

  Widget _teamLogo(String logoPath,
      {double height = 72}) {
    if (logoPath.startsWith("http")) {
      return Image.network(
        logoPath,
        height: height,
        errorBuilder: (_, __, ___) =>
            Image.asset(
              'assets/images/default_team.png',
              height: height,
            ),
      );
    } else {
      return Image.asset(
        logoPath,
        height: height,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
      theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
        theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          "${match.homeTeam} vs ${match.awayTeam}",
          style: TextStyle(
            color:
            theme.colorScheme.onBackground,
            fontWeight:
            FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color:
          theme.colorScheme.onBackground,
        ),
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _teamLogo(
                          match.safeHomeLogo),
                      const SizedBox(
                          height: 8),
                      Text(
                        match.homeTeam,
                        style: TextStyle(
                          color: theme
                              .colorScheme
                              .onBackground,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 15,
                        ),
                        textAlign:
                        TextAlign.center,
                      ),
                      const SizedBox(
                          height: 4),
                      Text(
                        "Home",
                        style: TextStyle(
                          color: theme
                              .hintColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  "VS",
                  style: TextStyle(
                    color: theme
                        .colorScheme
                        .onBackground
                        .withOpacity(
                        0.7),
                    fontSize: 20,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [
                      _teamLogo(
                          match.safeAwayLogo),
                      const SizedBox(
                          height: 8),
                      Text(
                        match.awayTeam,
                        style: TextStyle(
                          color: theme
                              .colorScheme
                              .onBackground,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 15,
                        ),
                        textAlign:
                        TextAlign.center,
                      ),
                      const SizedBox(
                          height: 4),
                      Text(
                        "Away",
                        style: TextStyle(
                          color: theme
                              .hintColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _InfoCard(
              children: [
                _InfoRow(
                    label: "Date",
                    value:
                    match.safeDate),
                _InfoRow(
                    label: "Time",
                    value:
                    match.safeTime),
                _InfoRow(
                    label: "League",
                    value:
                    match.safeLeague),
                _InfoRow(
                    label: "Venue",
                    value:
                    match.safeVenue),
              ],
            ),

            const SizedBox(height: 16),

            _InfoCard(
              children: [
                Text(
                  "Head-to-Head (Last 5 Matches)",
                  style: TextStyle(
                    color: theme
                        .colorScheme
                        .onBackground,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(
                    height: 14),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceAround,
                  children: [
                    _StatColumn(
                      title:
                      match.homeTeam,
                      value:
                      "Wins: $_homeWins",
                    ),
                    _StatColumn(
                      title: "Draws",
                      value:
                      "$_draws",
                    ),
                    _StatColumn(
                      title:
                      match.awayTeam,
                      value:
                      "Wins: $_awayWins",
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 28),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PredictionScreen(
                            match:
                            match),
                  ),
                );
              },
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
                    vertical: 14),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius
                      .circular(14),
                ),
              ),
              child: const Text(
                "Make Prediction",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard(
      {required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark =
        theme.brightness ==
            Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(
            0xFF1A1A1D)
            : Colors.white,
        borderRadius:
        BorderRadius.circular(
            14),
        border: Border.all(
          color: isDark
              ? Colors.grey
              .shade800
              : Colors.grey
              .shade300,
        ),
      ),
      padding:
      const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(
      {required this.label,
        required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding:
      const EdgeInsets.symmetric(
          vertical: 6),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment
            .spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color:
              theme.hintColor,
              fontWeight:
              FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: theme
                  .colorScheme
                  .onBackground,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn
    extends StatelessWidget {
  final String title;
  final String value;

  const _StatColumn(
      {required this.title,
        required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: theme
                .colorScheme
                .onBackground,
            fontWeight:
            FontWeight.w600,
          ),
          textAlign:
          TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color:
            theme.hintColor,
          ),
        ),
      ],
    );
  }
}
