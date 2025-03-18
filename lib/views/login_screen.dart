import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/views/register_screen.dart';
import 'package:test_app/widgets/custom_text.dart';
import '../core/viewmodels/auth_viewmodel.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPass = true;
  String? alert;
  final RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Image.asset(
                  'assets/images/foto1.png',
                  height: 100,
                ),
                const SizedBox(height: 32),
                if (alert != null)
                  CustomText(
                    text: "$alert",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                CustomTextField(
                  controller: _emailController,
                  hintText: "Email",
                  icon: const Icon(Icons.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => (value == null || value.isEmpty)
                      ? "Email is required"
                      : (!emailRegex.hasMatch(value)
                          ? "Enter a valid email"
                          : null),
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _passwordController,
                  hintText: "Password",
                  icon: const Icon(Icons.lock),
                  buttonIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPass = !isPass;
                        });
                      },
                      icon: Icon(
                          isPass ? Icons.visibility : Icons.visibility_off)),
                  isPassword: isPass,
                  validator: (value) =>
                      value!.isEmpty ? "Enter password" : null,
                ),
                const SizedBox(height: 14),
                CustomButton(
                  text: "Login",
                  isLoading: authViewModel.isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool success = await authViewModel.login(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DashboardScreen()),
                        );
                      } else {
                        alert = "Email atau Password salah!";
                      }
                    }
                  },
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  height: 50,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text("Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
