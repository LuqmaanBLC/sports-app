import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  Future<void> saveUserData() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No logged-in user found")),
      );
      return;
    }

    try {
      await supabase.from('users').upsert({
        'id': user.id,
        'email': user.email,
        'name': nameController.text.trim(),
        'surname': surnameController.text.trim(),
        'phone': phoneController.text.trim(),
        'dob': dobController.text.trim(),
        'province': provinceController.text.trim(),
        'country': countryController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved successfully!")),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/mainApp', (_) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: $e")),
      );
    }
  }

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
          "Complete Your Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: theme.colorScheme.onBackground,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              _buildTextField(nameController, "Name"),
              const SizedBox(height: 16),
              _buildTextField(surnameController, "Surname"),
              const SizedBox(height: 16),
              _buildTextField(phoneController, "Phone Number",
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 16),

              TextField(
                controller: dobController,
                readOnly: true,
                style: TextStyle(
                  color: theme.colorScheme.onBackground,
                ),
                decoration: InputDecoration(
                  labelText: "Date of Birth",
                  hintText: "Select your birth date",
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF1E1E1E)
                      : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onTap: () async {
                  FocusScope.of(context).unfocus();

                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2005, 1, 1),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    dobController.text =
                    "${pickedDate.day.toString().padLeft(2, '0')}/"
                        "${pickedDate.month.toString().padLeft(2, '0')}/"
                        "${pickedDate.year}";
                  }
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(provinceController, "Province"),
              const SizedBox(height: 16),
              _buildTextField(countryController, "Country"),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: saveUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Save & Continue",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        color: theme.colorScheme.onBackground,
      ),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor:
        isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
