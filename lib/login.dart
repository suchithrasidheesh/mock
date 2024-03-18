import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Registration.dart';
import 'firebase_Helper.dart';
import 'home.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey:'AIzaSyCZDq8fwz_vCLJhztJZgBsG3p3bsv-2FWI' ,
        appId: '1:882725445877:android:ae4c0836a80f39c5ec65bc',
        messagingSenderId:'',
        projectId:'mock-8e0d9',
        storageBucket: 'mock-8e0d9.appspot.com'

    )
  );
  User? user=FirebaseAuth.instance.currentUser;
  runApp(MaterialApp(home: user==null ? Login() : Home(),));
}

class Login extends StatelessWidget{


  final email_controller=TextEditingController();
  final pass_controller=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: ListView(
        children: [
          Center(child: Text('Login Form',style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),)),
          SizedBox(height: 40,),
          TextField(
            controller: email_controller,
            decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                labelText: 'Email id'
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: pass_controller,
            decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                labelText: 'Password'
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed:(){
            String email=email_controller.text.trim();
            String pass=pass_controller.text.trim();


            FirebaseHelper()
                .loginUser(email:email,pwd:pass)
                .then((result){
              if(result==null){
                Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Home()));
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text((result)),
                  backgroundColor: Colors.blue, ));
              }
            });

          }, child:Text('Login')),
          SizedBox(height: 20,),
          TextButton(onPressed:(){
            Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Registration()));
          }, child:Text('Not a user Register here....'))
        ],
      ),
    );
  }

}