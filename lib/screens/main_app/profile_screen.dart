import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String surname = "";
  String email = "";
  String phone = "";
  String dob = "";
  String province = "";
  String country = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No logged-in user found")),
      );
      return;
    }

    final response = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response != null) {
      setState(() {
        name = response['name'] ?? "";
        surname = response['surname'] ?? "";
        email = response['email'] ?? user.email ?? "";
        phone = response['phone'] ?? "";
        dob = response['dob'] ?? "";
        province = response['province'] ?? "";
        country = response['country'] ?? "";
      });
    }
  }

  Future<void> signOut() async {
    final supabase = Supabase.instance.client;
    await supabase.auth.signOut();

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  Future<void> deleteAccount() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    await supabase.from('users').delete().eq('id', user.id);
    await supabase.auth.signOut();

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/signup', (_) => false);
  }

  Future<void> _showConfirmationDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        title: Text(
          title,
          style: TextStyle(color: theme.colorScheme.onBackground),
        ),
        content: Text(
          message,
          style: TextStyle(color: theme.colorScheme.onBackground),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Cancel",
              style: TextStyle(color: theme.hintColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text(
              "Confirm",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoTile(String label, String value) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.hintColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value.isEmpty ? "-" : value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        Divider(
          color: theme.dividerColor,
          height: 20,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: theme.colorScheme.onBackground,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            infoTile("Name", name),
            infoTile("Surname", surname),
            infoTile("Email", email),
            infoTile("Phone Number", phone),
            infoTile("Date of Birth", dob),
            infoTile("Province", province),
            infoTile("Country", country),

            const SizedBox(height: 40),

            OutlinedButton(
              onPressed: () {
                _showConfirmationDialog(
                  title: "Sign Out",
                  message: "Are you sure you want to sign out?",
                  onConfirm: signOut,
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.red, width: 2),
                backgroundColor: theme.scaffoldBackgroundColor,
              ),
              child: const Text(
                "Sign Out",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog(
                  title: "Delete Account",
                  message:
                  "Are you sure you want to delete your account? This action cannot be undone.",
                  onConfirm: deleteAccount,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Delete Account",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
