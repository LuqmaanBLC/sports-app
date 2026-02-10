import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/favorite_service.dart';
import '../../widgets/match_card.dart';
import '../../models/match_model.dart';
import '../../services/matches_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<MatchModel>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    _favoritesFuture = _loadFavorites(userId);
  }

  Future<List<MatchModel>> _loadFavorites(String? userId) async {
    if (userId == null) return []; // guard against null

    final matchIds = await FavoriteService.getFavoriteMatchIds(userId);
    final matches = await MatchesService.fetchMatchesByIds(matchIds);
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          "Favorites",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<MatchModel>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final favorites = snapshot.data ?? [];
          if (favorites.isEmpty) {
            return _buildEmptyState(context);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: favorites.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return MatchCard(match: favorites[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.star_border, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No favorite matches yet",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
