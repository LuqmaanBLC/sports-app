import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Forgot Password Screen'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
