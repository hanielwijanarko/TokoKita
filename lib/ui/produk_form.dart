import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/produk.dart';

class ProdukForm extends StatefulWidget {
  Produk? produk;
  ProdukForm({super.key, this.produk});

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();

  String judul = "Tambah Produk Aulia";
  String tombolSubmit = "Simpan";

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.produk != null) {
      setState(() {
        judul = "Ubah Produk Aulia";
        tombolSubmit = "Ubah";

        _kodeProdukTextboxController.text = widget.produk!.kodeProduk!;
        _namaProdukTextboxController.text = widget.produk!.namaProduk!;
        _hargaProdukTextboxController.text =
            widget.produk!.hargaProduk.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _kodeProdukTextField(),
                _namaProdukTextField(),
                _hargaProdukTextField(),
                const SizedBox(height: 20),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kodeProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Kode Produk"),
      controller: _kodeProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) return "Kode Produk harus diisi";
        return null;
      },
    );
  }

  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Produk"),
      controller: _namaProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) return "Nama Produk harus diisi";
        return null;
      },
    );
  }

  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Harga"),
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) return "Harga harus diisi";
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (widget.produk != null) {
            // Mode UBAH
            ubah();
          } else {
            // Mode SIMPAN
            simpan();
          }
        }
      },
      child: Text(tombolSubmit),
    );
  }

  void simpan() {
    final Map<String, dynamic> data = {
      "kode_produk": _kodeProdukTextboxController.text,
      "nama_produk": _namaProdukTextboxController.text,
      "harga": int.parse(_hargaProdukTextboxController.text),
    };

    http.post(
      Uri.parse(ApiUrl.createProduk),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    ).then((response) {
      final responseData = json.decode(response.body);
      
      if (responseData['code'] == 200) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
            description: "Produk berhasil disimpan",
            okClick: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
            description: "Simpan produk gagal, silahkan coba lagi",
          ),
        );
      }
    }).catchError((error) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Simpan produk gagal, silahkan coba lagi",
        ),
      );
    });
  }

  void ubah() {
    final Map<String, dynamic> data = {
      "kode_produk": _kodeProdukTextboxController.text,
      "nama_produk": _namaProdukTextboxController.text,
      "harga": int.parse(_hargaProdukTextboxController.text),
    };

    http.put(
      Uri.parse(ApiUrl.updateProduk(int.parse(widget.produk!.id!))),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    ).then((response) {
      final responseData = json.decode(response.body);
      
      if (responseData['code'] == 200) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
            description: "Produk berhasil diubah",
            okClick: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
            description: "Ubah produk gagal, silahkan coba lagi",
          ),
        );
      }
    }).catchError((error) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Ubah produk gagal, silahkan coba lagi",
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