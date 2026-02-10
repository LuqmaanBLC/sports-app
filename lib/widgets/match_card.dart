import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/match_model.dart';
import '../screens/match_details_screen.dart';
import '../services/favorite_service.dart';

class MatchCard extends StatefulWidget {
  final MatchModel match;

  const MatchCard({super.key, required this.match});

  @override
  State<MatchCard> createState() =>
      _MatchCardState();
}

class _MatchCardState
    extends State<MatchCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final userId = Supabase
        .instance.client.auth.currentUser?.id;

    if (userId == null) {
      setState(() => _isFavorite = false);
      return;
    }

    final fav = await FavoriteService
        .isFavorite(
        widget.match.id, userId);

    setState(() {
      _isFavorite = fav;
    });
  }

  Future<void> _toggleFavorite() async {
    final userId = Supabase
        .instance.client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
            content: Text(
                "Please log in to use favorites")),
      );
      return;
    }

    await FavoriteService
        .toggleFavorite(
        widget.match, userId);

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _openDetails(
      BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            MatchDetailsScreen(
                match: widget.match),
      ),
    );
  }

  /// Supports URL or local asset
  Widget _teamLogo(String logoPath,
      {double height = 44}) {
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
    final isDark =
        theme.brightness ==
            Brightness.dark;

    return InkWell(
      onTap: () => _openDetails(context),
      borderRadius:
      BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1E1E1E)
              : Colors.white,
          borderRadius:
          BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.grey.shade800
                : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(
                  isDark ? 0.4 : 0.08),
              blurRadius: 8,
              offset:
              const Offset(0, 4),
            ),
          ],
        ),
        padding:
        const EdgeInsets.all(16),
        child: Column(
          children: [
            // Favorite star
            Row(
              mainAxisAlignment:
              MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    _isFavorite
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed:
                  _toggleFavorite,
                ),
              ],
            ),

            // Teams row
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _teamLogo(
                          widget.match
                              .safeHomeLogo),
                      const SizedBox(
                          height: 8),
                      Text(
                        widget.match
                            .homeTeam,
                        style:
                        TextStyle(
                          color: theme
                              .colorScheme
                              .onBackground,
                          fontWeight:
                          FontWeight
                              .bold,
                          fontSize: 14,
                        ),
                        textAlign:
                        TextAlign.center,
                      ),
                      const SizedBox(
                          height: 2),
                      Text(
                        "Home",
                        style:
                        TextStyle(
                          fontSize: 11,
                          color: theme
                              .hintColor,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  "VS",
                  style:
                  TextStyle(
                    color: theme
                        .colorScheme
                        .onBackground
                        .withOpacity(
                        0.7),
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [
                      _teamLogo(
                          widget.match
                              .safeAwayLogo),
                      const SizedBox(
                          height: 8),
                      Text(
                        widget.match
                            .awayTeam,
                        style:
                        TextStyle(
                          color: theme
                              .colorScheme
                              .onBackground,
                          fontWeight:
                          FontWeight
                              .bold,
                          fontSize: 14,
                        ),
                        textAlign:
                        TextAlign.center,
                      ),
                      const SizedBox(
                          height: 2),
                      Text(
                        "Away",
                        style:
                        TextStyle(
                          fontSize: 11,
                          color: theme
                              .hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Column(
              children: [
                Text(
                  "${widget.match.safeDate} • ${widget.match.safeTime}",
                  style:
                  TextStyle(
                    color: theme
                        .colorScheme
                        .onBackground
                        .withOpacity(
                        0.7),
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
                const SizedBox(
                    height: 4),
                Text(
                  widget.match
                      .safeLeague,
                  style:
                  TextStyle(
                    color:
                    theme.hintColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                    height: 4),
                Text(
                  widget.match
                      .safeVenue,
                  style:
                  TextStyle(
                    color:
                    theme.hintColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    _openDetails(context),
                style:
                ElevatedButton
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
                      12),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius
                        .circular(
                        12),
                  ),
                ),
                child: const Text(
                  "Predict Now",
                  style: TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
