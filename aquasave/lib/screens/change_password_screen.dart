import 'package:aquasave/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
    bottomNavigationBar: BottomNavBar(currentIndex: 2), // Set index sesuai halaman
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: Text(
          "Pengaturan Kata Sandi",
          style: TextStyle(),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildPasswordField("Kata Sandi Lama", _oldPasswordController, _isOldPasswordVisible, () {
              setState(() {
                _isOldPasswordVisible = !_isOldPasswordVisible;
              });
            }),
            SizedBox(height: 16),
            _buildPasswordField("Kata Sandi Baru", _newPasswordController, _isNewPasswordVisible, () {
              setState(() {
                _isNewPasswordVisible = !_isNewPasswordVisible;
              });
            }),
            SizedBox(height: 16),
            _buildPasswordField("Konfirmasi Kata Sandi Baru", _confirmPasswordController, _isConfirmPasswordVisible, () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            }),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Logika untuk mengubah kata sandi
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              ),
              child: Text(
                "Konfirmasi",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool isVisible, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.blue.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}
