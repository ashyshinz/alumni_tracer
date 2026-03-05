import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // List sa roles nga parehas sa imong MySQL enum
  final List<String> _roles = ['Alumni', 'Dean', 'Admin'];
  String _selectedRole = 'Alumni'; // Default value

  bool _isLoading = false;
  String? message;
  bool isError = false;

  Future<void> _handleSignUp() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        message = "All fields are required";
        isError = true;
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:80/alumni_api/register.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "full_name": _nameController.text,
          "email": _emailController.text,
          "password": _passwordController.text,
          "role": _selectedRole
              .toLowerCase(), // I-send ang role (alumni, dean, or admin)
        }),
      );

      final result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        setState(() {
          message = "Account Created! Redirecting...";
          isError = false;
        });
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pop(context);
      } else {
        setState(() {
          message = result['message'];
          isError = true;
        });
      }
    } catch (e) {
      setState(() {
        message = "Connection error. Check XAMPP.";
        isError = true;
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFF420031);

    return Scaffold(
      backgroundColor: themeColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
                const SizedBox(height: 25),

                if (message != null) _buildStatusBanner(),

                _buildInputField(Icons.person, "Full Name", _nameController),
                const SizedBox(height: 15),
                _buildInputField(
                  Icons.email,
                  "Email Address",
                  _emailController,
                ),
                const SizedBox(height: 15),
                _buildInputField(
                  Icons.lock,
                  "Password",
                  _passwordController,
                  isPass: true,
                ),
                const SizedBox(height: 15),

                // --- ROLE DROPDOWN ---
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRole,
                      isExpanded: true,
                      items: _roles.map((String role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text("Register as: $role"),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() => _selectedRole = newValue!);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "SIGN UP",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: themeColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isError ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error : Icons.check_circle,
            color: isError ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message!,
              style: TextStyle(color: isError ? Colors.red : Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    IconData icon,
    String hint,
    TextEditingController controller, {
    bool isPass = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF420031)),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
