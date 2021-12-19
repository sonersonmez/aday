import 'package:firebase_auth/firebase_auth.dart';

class AuthService{




Future<void> login (email, password) async{
try {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email:email,
    password: password
  );
} on FirebaseAuthException catch  (e) {

  print(e.message);
}
 


}

}