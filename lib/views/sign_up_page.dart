import 'package:aday/views/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();

  bool _isObscure = true;
  String _text = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDWcTgC_VP7gzrsmIlrhNwNI4OZH2td_lGEg&usqp=CAU'),
          Text(_text),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: txtFormField(
                'Ad', _nameController, TextInputType.name, false, SizedBox()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: txtFormField('Soyad', _surnameController, TextInputType.name,
                false, SizedBox()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: txtFormField('E-Posta', _emailController,
                TextInputType.emailAddress, false, SizedBox()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: txtFormField(
                'Şifre',
                _passwordController,
                TextInputType.visiblePassword,
                _isObscure,
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: _isObscure
                        ? Icon(
                            Icons.lock,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.visibility_off,
                            color: Colors.red,
                          ))),
          ),
          signUpButton('Kayıt Ol')
        ],
      ),
    );
  }

  TextFormField txtFormField(
      labelText, controller, keyboardType, obscureText, iconButton) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      cursorColor: Colors.red,
      style: TextStyle(fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        suffixIcon: iconButton,
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

  ElevatedButton signUpButton(txt) {
    return ElevatedButton(
      onPressed: () async {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            print('Şifre çok güçsüz. Büyük harf, sayı ve özel işaret kullanın.');
          } else if (e.code == 'email-already-in-use') {
            print('Bu E-Posta ile kayıtlı bir hesap zaten var.');
          }
        } catch (e) {
          print(e);
        }

        
         FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .set({
          'uid': FirebaseAuth.instance.currentUser?.uid,
          'name': _nameController.text,
          'surname': _surnameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'isVoted': false
        });
        setState(() {
          _text = "Kaydınız Gerçekleşti!";
        });
      //  Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder:(context)=>MainScreen()));
      },
      child: Text(txt),
      style: ElevatedButton.styleFrom(
          primary: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
    );
  }
}
