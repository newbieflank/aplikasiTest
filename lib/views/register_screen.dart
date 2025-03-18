import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_app/core/viewmodels/auth_viewmodel.dart';
import 'package:test_app/views/login_screen.dart';
import 'package:test_app/widgets/custom_button.dart';
import 'package:test_app/widgets/custom_datepicker.dart';
import 'package:test_app/widgets/custom_dropdown.dart';
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
  final TextEditingController _no_telpController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final RegExp passwordRegex =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');

  _checknumber(String? value) {
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
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      hintText: "Name",
                      icon: const Icon(Icons.person_2),
                      keyboardType: TextInputType.name,
                      validator: (value) =>
                          value!.isEmpty ? "Masukkan nama" : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _usernameController,
                      hintText: "Username",
                      icon: const Icon(Icons.person),
                      keyboardType: TextInputType.name,
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
                      controller: _no_telpController,
                      hintText: "No Telepon",
                      icon: const Icon(Icons.phone),
                      keyboardType: TextInputType.number,
                      validator: (value) => _checknumber(value),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _alamatController,
                      maxLine: 3,
                      hintText: "Alamat",
                      icon: const Icon(Icons.home),
                      keyboardType: TextInputType.text,
                      validator: (value) =>
                          value!.isEmpty ? "Masukkan alamat" : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _emailController,
                      hintText: "Email",
                      icon: const Icon(Icons.email),
                      keyboardType: TextInputType.emailAddress,
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
                    const SizedBox(height: 24),
                    CustomButton(
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
                            _no_telpController.text.trim(),
                            _alamatController.text.trim(),
                            DateFormat('yyyy-MM-dd').format(selectedDate!),
                          );

                          if (success) {
                            showCustomDialog(
                              context,
                              "Registrasi Berhasil",
                              "Silakan login untuk melanjutkan.",
                              true,
                              () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                );
                              },
                            );
                          } else {
                            showCustomDialog(
                              context,
                              "Registrasi Gagal",
                              "Pastikan semua data telah diisi dengan benar.",
                              false,
                              () {},
                            );
                          }
                        }
                      },
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      height: 50,
                    ),
                    const SizedBox(height: 8.0),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showCustomDialog(BuildContext context, String title, String message,
    bool status, VoidCallback onPress) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: status ? Colors.green : Colors.red,
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onPress();
            },
            child: Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
