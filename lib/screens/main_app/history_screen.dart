import 'package:flutter/material.dart';
import '../../services/history_service.dart';
import '../../widgets/sport_filter_item.dart';
import 'package:intl/intl.dart'; // for formatting dates

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<dynamic>> _historyFuture;

  String? selectedSport;
  String? selectedTeam;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = HistoryService.loadHistory(
        sport: selectedSport,
        team: selectedTeam,
        date: selectedDate != null
            ? DateFormat("EEE, dd MMM yyyy").format(selectedDate!)
            : null,
      );
    });
  }

  final Map<String, List<String>> sportTeams = {
    "Soccer": ["Manchester United", "Liverpool", "Chelsea"],
    "Rugby": ["Springboks", "All Blacks", "England"],
    "Cricket": ["India", "Australia", "South Africa"],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          "Prediction History",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Sport filter row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                SportFilterItem(
                  label: "All",
                  icon: Icons.sports,
                  isSelected: selectedSport == null,
                  onTap: () {
                    selectedSport = null;
                    selectedTeam = null;
                    _loadHistory();
                  },
                ),
                const SizedBox(width: 8),
                SportFilterItem(
                  label: "Soccer",
                  icon: Icons.sports_soccer,
                  isSelected: selectedSport == "Soccer",
                  onTap: () {
                    selectedSport = "Soccer";
                    selectedTeam = null;
                    _loadHistory();
                  },
                ),
                const SizedBox(width: 8),
                SportFilterItem(
                  label: "Rugby",
                  icon: Icons.sports_rugby,
                  isSelected: selectedSport == "Rugby",
                  onTap: () {
                    selectedSport = "Rugby";
                    selectedTeam = null;
                    _loadHistory();
                  },
                ),
                const SizedBox(width: 8),
                SportFilterItem(
                  label: "Cricket",
                  icon: Icons.sports_cricket,
                  isSelected: selectedSport == "Cricket",
                  onTap: () {
                    selectedSport = "Cricket";
                    selectedTeam = null;
                    _loadHistory();
                  },
                ),
              ],
            ),
          ),

          // Team + Date filters beneath sport chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        hint: const Text("Select Sport"),
                        value: selectedSport,
                        onChanged: (value) {
                          setState(() {
                            selectedSport = value;
                            selectedTeam = null;
                            _loadHistory();
                          });
                        },
                        items: ["Soccer", "Rugby", "Cricket"]
                            .map((sport) => DropdownMenuItem(
                          value: sport,
                          child: Text(sport),
                        ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<String>(
                        hint: const Text("Select Team"),
                        value: selectedTeam,
                        onChanged: (value) {
                          setState(() {
                            selectedTeam = value;
                            _loadHistory();
                          });
                        },
                        items: selectedSport == null
                            ? []
                            : sportTeams[selectedSport]!
                            .map((team) => DropdownMenuItem(
                          value: team,
                          child: Text(team),
                        ))
                            .toList(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Date picker button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.date_range),
                        label: const Text("Pick Date"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2ECC71),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();

                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                              _loadHistory();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),

                if (selectedDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Selected: ${DateFormat("EEE, dd MMM yyyy").format(selectedDate!)}",
                      style: TextStyle(color: theme.hintColor),
                    ),
                  ),
              ],
            ),
          ),

          // History list
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _historyFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final history = snapshot.data!;
                if (history.isEmpty) {
                  return Center(
                    child: Text(
                      "No prediction history found.",
                      style: TextStyle(color: theme.hintColor),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      child: ListTile(
                        title: Text("${item['homeTeam']} vs ${item['awayTeam']}"),
                        subtitle: Text("${item['date']} • ${item['time']}"),
                        trailing: Text(
                          item["isPredictionCorrect"] == null
                              ? "Pending"
                              : item["isPredictionCorrect"] == true
                              ? "✔️"
                              : "❌",
                          style: TextStyle(
                            color: item["isPredictionCorrect"] == true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 12),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
