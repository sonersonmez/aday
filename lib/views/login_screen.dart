
import 'package:aday/services/auth_service.dart';
import 'package:aday/views/main_screen.dart';
import 'package:aday/views/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
AuthService _authService = AuthService();
String errMsg="";




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDWcTgC_VP7gzrsmIlrhNwNI4OZH2td_lGEg&usqp=CAU'),
         
          Text(errMsg, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: txtFormField('E-Posta', _emailController),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: txtFormField('Şifre', _passwordController),
          ),
          SizedBox(height:15),
          loginButton('Giriş Yap'),
          SizedBox(height:10),
          signUpButton('Kayıt Ol')
          
        ],
      ),
    );
  }

  ElevatedButton loginButton(txt) {
    return ElevatedButton(
          onPressed: () {
            
            // _authService.login(email, password);

             FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
             if(FirebaseAuth.instance.currentUser?.uid==null){
               print("GİRİŞ YAP AMINOĞLU");
               setState(() {
                 errMsg="E-posta ve Şifrenizi tekrar deneyin.";
               });
               
             }else{

                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
             MainScreen()), (Route<dynamic> route) => false);
             }
           
           // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainScreen()), (Route<dynamic> route) => false);

    
          },
          child: Text(txt),
          style: ElevatedButton.styleFrom(
              primary: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              textStyle:
                  TextStyle(fontSize:20, fontWeight: FontWeight.w400)),
        );
  }
  ElevatedButton signUpButton(txt) {
    return ElevatedButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
          },
          child: Text(txt),
          style: ElevatedButton.styleFrom(
              primary: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              textStyle:
                  TextStyle(fontSize:20, fontWeight: FontWeight.w400)),
        );
  }
  TextFormField txtFormField(labelText, controller) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.red,
      style: TextStyle(fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.red, fontSize: 18),
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
