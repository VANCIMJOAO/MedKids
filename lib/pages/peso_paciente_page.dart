import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_service.dart';
import 'antibioticos_page.dart';
import 'peso_paciente_model.dart';
import 'categorias.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class PesoPacientePage extends StatelessWidget {
  final pesoController = TextEditingController();
  final idadeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // Aguarde até obter os dados do usuário.
        }

        Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
        String userName = userData['name'];
        String profileImageUrl = userData['profileImageUrl'] ?? '';

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      final storage = firebase_storage.FirebaseStorage.instance;
                      final ref = storage.ref().child('profile_images/${user?.uid}');
                      await ref.putFile(File(image.path));
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
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profileImageUrl),
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
                Center(
                  child: SizedBox(
                    width: 200,
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
                ),
                SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    width: 200,
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
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange, // Cor do botão laranja
                  ),
                  child: Text("Calcular", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Provider.of<PesoPacienteModel>(context, listen: false)
                        .setPeso(double.tryParse(pesoController.text));
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => PaginaInicial()),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
