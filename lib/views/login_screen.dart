import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/views/register_screen.dart';
import '../core/viewmodels/auth_viewmodel.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
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
      body: Stack(
        children: [
          Container(
            height: 280,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3A5A98), Color(0xFF1A3A72)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/foto1.png', height: 80),
                const SizedBox(height: 16),
                const CustomText(
                  text: "Login",
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomText(
                    text: "Masuk Ke Akun Anda Sekarang!",
                    fontSize: 14,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: _emailController,
                      hintText: "Email",
                      icon: const Icon(Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => (value == null || value.isEmpty)
                          ? "Email harus diisi"
                          : (!emailRegex.hasMatch(value)
                              ? "Masukkan email yang valid"
                              : null),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: "Password",
                      icon: const Icon(Icons.lock),
                      isPassword: isPass,
                      buttonIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPass = !isPass;
                          });
                        },
                        icon: Icon(
                            isPass ? Icons.visibility : Icons.visibility_off),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Password harus diisi" : null,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: CustomButton(
                        text: "Masuk",
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
                                  builder: (context) => const DashboardScreen(),
                                ),
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
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text("Register"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
