
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:snakegame/main.dart';
import 'package:snakegame/screens/register_scr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snakegame/screens/home_scr.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_scr.dart';

//form key
final _formKey=GlobalKey<FormState>();



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {




  //editing controller
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();


  @override
  Widget build(BuildContext context) {

    final _auth = FirebaseAuth.instance;

    void signIn(String username, String password) async
    {
      if(_formKey.currentState!.validate()){
        await _auth.signInWithEmailAndPassword(email: username, password: password).then((uid) =>
        {
          Fluttertoast.showToast(msg: "login successful!"),
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) => HomePage())),
        }).catchError((e){
          Fluttertoast.showToast(msg: e!.message);
        });
      }
    }


    //username field
    final usernameField = TextFormField(
      autofocus: false,
      controller: usernameController,
      keyboardType: TextInputType.name,

      validator: (value){
        if(value!.isEmpty){
          return ("email required!");
        }
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+").hasMatch(value)){
          return ("Please enter a valid email");

        }

      },
      onSaved: (value){
        usernameController.text = value!;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.person,

        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      textInputAction: TextInputAction.next,
    );






    //passw field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,

      obscureText: true,

      onSaved: (value){
        passwordController.text = value!;
      },
      validator: (value){

        if(value!.isEmpty){
          return ("password is required!");
        }



      },

      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.key,

        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "passsword",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      textInputAction: TextInputAction.done,
    );


    //loginbuttton
    final loginButton= Material(

      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.indigo,
      child: MaterialButton(
        onPressed: (){
          signIn(usernameController.text, passwordController.text);
        },
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),


        child: Text("login",
        style: TextStyle(
          color: Colors.white,
        ),),

      ),

    );


    return Scaffold(
      backgroundColor: Colors.white,


      body:Center(
        child:SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [SizedBox(
                    height: 200,
                    child: Image.network('https://camo.githubusercontent.com/c7ea618811e97887f25193528328af70b5fa902c2cb22c4559eee62606745cf2/687474703a2f2f72656d626f756e642e636f6d2f66696c65732f6372656174696e672d612d736e616b652d67616d652d7475746f7269616c2d776974682d68746d6c352f736e616b652e706e67'),

                  ),



                    SizedBox(height: 10,),


                    usernameField,
                    SizedBox(height: 10,),
                    passwordField,
                    SizedBox(height: 10,),
                    loginButton,
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("new user?  "),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context) => RegistrationScreen()));
                          },
                          child: Text("SIGN UP",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}






