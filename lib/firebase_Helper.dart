
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHelper{
  final FirebaseAuth auth=FirebaseAuth.instance;


  get user=>auth.currentUser;

  //usersignUp
  Future<String?>registerUser({required String email,required String pwd})async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pwd,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      print(e);
    }
  }

  Future<String?>loginUser({required String email,required String pwd})async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pwd,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return e.message;
    }
  }

}