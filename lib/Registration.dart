import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'firebase_Helper.dart';
import 'login.dart';

class Registration extends StatelessWidget{
  var email_controller=TextEditingController();
  var pass_controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(child: Text('Registration Form',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
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


          ElevatedButton(onPressed: (){
            String email=email_controller.text.trim();
            String pass=pass_controller.text.trim();

            FirebaseHelper().registerUser(email:email,pwd:pass).then((result){
              if(result==null){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>Login()));
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(result)));
              }
            });

          }, child:Text('Register')),
          SizedBox(height: 20,),

          TextButton(onPressed:(){
            Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Login()));
          }, child:Text('Registered User Login here')),
        ],
      ),
    );
  }

}