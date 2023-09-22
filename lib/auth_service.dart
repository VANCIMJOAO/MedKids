import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para fazer login
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Método para fazer cadastro
  Future<User?> signUp(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Agora, você pode atualizar o perfil do usuário com o nome
      await userCredential.user?.updateProfile(displayName: name);

      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Método para verificar se o usuário está logado
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Método para sair da conta
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
