import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app_project/user_landing_screen.dart';
import 'SignupPage.dart';
import 'UserInfo.dart';
import 'admin_landing_screen.dart'; // Import the AdminLandingScreen widget

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false; // Track loading state
  String? userId; // Store user ID
  String? username; // Store username
  String? fullnames; // Store full names
  String? phoneNumber; // Store phone number
  String? email; // Store email

  Future<void> _login(BuildContext context, String username, String password) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final url = Uri.parse('http://192.168.1.68:8080/login'); // Update with your API URL
    final response = await http.post(
      url,
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    setState(() {
      _isLoading = false; // Hide loading indicator
    });

    if (response.statusCode == 200) {
      // Successful login
      final responseData = jsonDecode(response.body);
      String redirectMessage = responseData['message'];

      if (redirectMessage == "Redirect to admin dashboard" || redirectMessage == "Redirect to user dashboard") {
        userId = responseData['user_id'].toString(); // Use 'user_id' key
        username = responseData['username'];
        fullnames = responseData['fullnames']; // Retrieve full names
        phoneNumber = responseData['phonenumber']; // Retrieve phone number
        email = responseData['email']; // Retrieve email

        // Set user details using UserInfo singleton
        UserInfo().setUserDetails(userId!, username!, fullnames!, phoneNumber!, email!);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => redirectMessage == "Redirect to admin dashboard"
                ? AdminLandingScreen()
                : UserLandingScreen(),
          ),
        );
      }
      else {
        _showErrorDialog("Invalid credentials");
      }
    } else if (response.statusCode == 401) {
      _showErrorDialog("Invalid credentials");
    } else {
      _showErrorDialog("Error: ${response.statusCode}");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(),
              _inputField(
                usernameController,
                passwordController,
                    () => _login(context, usernameController.text, passwordController.text),
              ),
              _forgotPassword(),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credentials to login"),
      ],
    );
  }

  Widget _inputField(
      TextEditingController usernameController,
      TextEditingController passwordController,
      void Function() onPressed,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            hintText: "Username",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.purple,
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }

  Widget _forgotPassword() {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Colors.purple),
      ),
    );
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignupPage()),
            );
          },
          child: const Text("Sign Up", style: TextStyle(color: Colors.purple)),
        )
      ],
    );
  }
}
