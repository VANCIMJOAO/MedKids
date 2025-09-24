import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cached_network_image/cached_network_image.dart';
import 'peso_paciente_model.dart';
import 'categorias.dart';

class PesoPacientePage extends StatefulWidget {
  @override
  _PesoPacientePageState createState() => _PesoPacientePageState();
}

class _PesoPacientePageState extends State<PesoPacientePage> {
  final pesoController = TextEditingController();
  final idadeController = TextEditingController();

  @override
  void dispose() {
    pesoController.dispose();
    idadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
        String userName = userData['name'];
        String profileImageUrl = userData['profileImageUrl'] ?? '';

        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                            if (image != null) {
                              final storage = firebase_storage.FirebaseStorage.instance;
                              final ref = storage.ref().child('profile_images/${user?.uid}');
                              final Uint8List data = await image.readAsBytes();
                              await ref.putData(data);
                              final imageUrl = await ref.getDownloadURL();
                              FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
                                'profileImageUrl': imageUrl,
                              });
                            }
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: profileImageUrl,
                              imageBuilder: (context, imageProvider) => CircleAvatar(
                                radius: 50,
                                backgroundImage: imageProvider,
                              ),
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Bem-vindo, Dr. $userName',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Quais os dados do paciente?',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: TextField(
                            controller: idadeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Idade do paciente (anos)",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: TextField(
                            controller: pesoController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Peso do paciente (kg)",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.orange),
                          child: Text("Calcular", style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            if (pesoController.text.isNotEmpty && idadeController.text.isNotEmpty) {
                              double? peso = double.tryParse(pesoController.text);
                              int? idade = int.tryParse(idadeController.text);

                              if (peso != null && idade != null && peso > 0 && idade > 0) {
                                Provider.of<PesoPacienteModel>(context, listen: false).setPeso(peso);
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PaginaInicial()));
                              } else {
                                mostrarErro("Por favor, insira valores válidos.");
                              }
                            } else {
                              mostrarErro("Por favor, preencha todos os campos.");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void mostrarErro(String erro) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erro"),
          content: Text(erro),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
