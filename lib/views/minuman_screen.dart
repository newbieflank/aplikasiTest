import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/core/models/minuman.dart';
import 'package:test_app/core/services/auth_service.dart';
import 'package:test_app/widgets/custom_text.dart';

class MinumanScreen extends StatefulWidget {
  const MinumanScreen({Key? key}) : super(key: key);

  @override
  _MinumanScreenState createState() => _MinumanScreenState();
}

class _MinumanScreenState extends State<MinumanScreen> {
  List<Minuman> minumanList = [];
  bool isLoading = true;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadMinumanData();
  }

  Future<void> _loadMinumanData() async {
    List<Minuman>? data = await _authService.fetchMinuman();
    setState(() {
      minumanList = data ?? [];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Minuman"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: minumanList.length,
              itemBuilder: (context, index) {
                final minuman = minumanList[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.asset("assets/images/drink.jpg",
                        height: 50, width: 50, fit: BoxFit.cover),
                    title: Text(minuman.nama,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: minuman.deskripsi,
                          fontSize: 14,
                        ),
                        const SizedBox(height: 5),
                        CustomText(
                          text:
                              "Harga: Rp ${NumberFormat("#,###", "id_ID").format(minuman.harga)}",
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        CustomText(
                            text:
                                "Status: ${minuman.status == 1 ? 'Tersedia' : 'Habis'}",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: minuman.status == 1
                                ? Colors.green
                                : Colors.red),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MinumanScreen(),
    theme: ThemeData(primarySwatch: Colors.brown),
  ));
}
