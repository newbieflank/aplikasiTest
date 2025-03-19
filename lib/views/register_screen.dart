import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_app/core/viewmodels/auth_viewmodel.dart';
import 'package:test_app/views/login_screen.dart';
import 'package:test_app/widgets/custom_button.dart';
import 'package:test_app/widgets/custom_datepicker.dart';
import 'package:test_app/widgets/custom_dropdown.dart';
import 'package:test_app/widgets/custom_text.dart';
import 'package:test_app/widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String? selectedGender;
  DateTime? selectedDate;
  final TextEditingController _noTelpController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final RegExp passwordRegex =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');

  _checkNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Masukkan no telepon";
    }

    String pattern = r'^(?:\+62|62|0)[0-9]{9,13}$';
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value) || value.length > 13) {
      return "Masukkan nomor telepon yang valid";
    }

    return null;
  }

  void handleDateSelection(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 250,
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
                  text: "Buat Akun Baru",
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomText(
                    text: "Daftarkan Akun Anda.",
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
              height: MediaQuery.of(context).size.height * 0.72,
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        hintText: "Nama Lengkap",
                        keyboardType: TextInputType.name,
                        icon: const Icon(Icons.person),
                        validator: (value) =>
                            value!.isEmpty ? "Masukkan nama" : null,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _usernameController,
                        hintText: "Username",
                        keyboardType: TextInputType.name,
                        icon: const Icon(Icons.account_circle),
                        validator: (value) =>
                            value!.isEmpty ? "Masukkan username" : null,
                      ),
                      const SizedBox(height: 12),
                      CustomDropdown(
                        items: ["Laki-Laki", "Perempuan"],
                        value: selectedGender,
                        hint: "Jenis Kelamin",
                        itemLabel: (item) => item,
                        itemIcon: (item) =>
                            item == "Laki-Laki" ? Icons.male : Icons.female,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? "Pilih jenis kelamin" : null,
                      ),
                      const SizedBox(height: 12),
                      CustomDatePicker(
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        onDateSelected: handleDateSelection,
                        validator: (date) =>
                            date == null ? "Masukkan tanggal lahir" : null,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _noTelpController,
                        hintText: "No Telepon",
                        keyboardType: TextInputType.phone,
                        icon: const Icon(Icons.phone),
                        validator: (value) => _checkNumber(value),
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _alamatController,
                        hintText: "Alamat",
                        keyboardType: TextInputType.text,
                        icon: const Icon(Icons.home),
                        maxLine: 3,
                        validator: (value) =>
                            value!.isEmpty ? "Masukkan alamat" : null,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _emailController,
                        hintText: "Email",
                        keyboardType: TextInputType.emailAddress,
                        icon: const Icon(Icons.email),
                        validator: (value) => (value == null || value.isEmpty)
                            ? "Email wajib diisi"
                            : (!emailRegex.hasMatch(value)
                                ? "Format email tidak valid"
                                : null),
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: "Password",
                        icon: const Icon(Icons.lock),
                        isPassword: true,
                        validator: (value) => value!.isEmpty
                            ? "Masukkan password"
                            : value.length < 8
                                ? "Password minimal 8 karakter"
                                : (!passwordRegex.hasMatch(value))
                                    ? "Password harus berisi angka dan huruf"
                                    : null,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: CustomButton(
                          text: "Register",
                          isLoading: authViewModel.isLoading,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              bool success = await authViewModel.register(
                                _nameController.text.trim(),
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                _usernameController.text.trim(),
                                selectedGender!,
                                _noTelpController.text.trim(),
                                _alamatController.text.trim(),
                                DateFormat('yyyy-MM-dd').format(selectedDate!),
                              );

                              if (success) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text("Login"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
