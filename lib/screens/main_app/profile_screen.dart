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

    // Delete from users table
    await supabase.from('users').delete().eq('id', user.id);

    // Sign out and remove auth user
    await supabase.auth.signOut();

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/signup', (_) => false);
  }

  Future<void> _showConfirmationDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 3),
        Text(
          value.isEmpty ? "-" : value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Divider(color: Colors.grey, height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false, // Removes the back arrow
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

            // ----------------------
            // SIGN OUT BUTTON
            // ----------------------
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
                backgroundColor: const Color(0xFF121212),
              ),
              child: const Text(
                "Sign Out",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            // ----------------------
            // DELETE ACCOUNT BUTTON
            // ----------------------
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog(
                  title: "Delete Account",
                  message: "Are you sure you want to delete your account? This action cannot be undone.",
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
