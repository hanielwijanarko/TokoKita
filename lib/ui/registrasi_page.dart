import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/registrasi.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordKonfirmasiController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Registrasi Aulia"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _namaField(),
                const SizedBox(height: 10),
                _emailField(),
                const SizedBox(height: 10),
                _passwordField(),
                const SizedBox(height: 10),
                _passwordKonfirmasiField(),
                const SizedBox(height: 20),
                Center(child: _buttonRegistrasi()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
  Widget _namaField() {
    return TextFormField(
      controller: _namaController,
      decoration: const InputDecoration(
        labelText: "Nama",
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama harus diisi";
        }
        if (value.length < 3) {
          return "Nama minimal 3 karakter";
        }
        return null;
      },
    );
  }

  
  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: "Email",
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Email harus diisi";
        }
        return null;
      },
    );
  }


  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(
        labelText: "Password",
      ),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        if (value.length < 6) {
          return "Password minimal 6 karakter";
        }
        return null;
      },
    );
  }

  Widget _passwordKonfirmasiField() {
    return TextFormField(
      controller: _passwordKonfirmasiController,
      decoration: const InputDecoration(
        labelText: "Konfirmasi Password",
      ),
      obscureText: true,
      validator: (value) {
        if (value != _passwordController.text) {
          return "Konfirmasi password tidak sama";
        }
        return null;
      },
    );
  }

  Widget _buttonRegistrasi() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _submit();
        }
      },
      child: const Text("Registrasi"),
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    final Map<String, dynamic> data = {
      "nama": _namaController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    http.post(
      Uri.parse(ApiUrl.registrasi),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    ).then((response) {
      final responseData = json.decode(response.body);
      Registrasi registrasi = Registrasi.fromJson(responseData);

      if (registrasi.code == 200) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
            description: "Registrasi berhasil, silahkan login",
            okClick: () {
              Navigator.pop(context);
            },
          ),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
            description: "Registrasi gagal, silahkan coba lagi",
          ),
        );
      }
    }).catchError((error) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Registrasi gagal, silahkan coba lagi",
        ),
      );
    });
  }
}

// Dialog Success
class SuccessDialog extends StatelessWidget {
  final String? description;
  final VoidCallback? okClick;

  const SuccessDialog({Key? key, this.description, this.okClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Berhasil"),
      content: Text(description!),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            okClick!();
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}

// Dialog Warning
class WarningDialog extends StatelessWidget {
  final String? description;

  const WarningDialog({Key? key, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Peringatan"),
      content: Text(description!),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}