import 'package:ecommerceapp/services/auth.dart';
import 'package:flutter/material.dart';
import'package:ecommerceapp/services/auth.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final  AuthService _auth = AuthService();
  final _formKey= GlobalKey<FormState>();


  //text fiels state
  String email= '';
  String password ='';
  String error= '';
  String name='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('sign up  '),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign in'),
            onPressed: () {
              // Define what happens when the 'Sign up' button is pressed
            widget.toggleView();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 30.0),
              TextFormField(
                validator: (val)=> val!.isEmpty ? 'Enter an Email' :null,
                onChanged: (val){
                  setState(()=> email =val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                validator: (val)=> val!.isEmpty ? 'enter your name ' :null,
                onChanged: (val){
                  setState(()=> name =val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                //you can check the length instead of empty string by val.length<6 ?
                validator: (val)=> val!.length<6 ? 'password should be at least 6 characters ' :null,
                onChanged: (val){
                  setState(()=> password =val);
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[400], // Button background color
                ),
                onPressed: () async {
               if(_formKey.currentState!.validate()){
                dynamic result = await _auth.registerWithEmailAndPassword(name, email, password);
              if(result==null){
                 setState(()=>error='please supply a valid email ');
              }
               }
                },
                child: Text('Sign Up'),
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize:14.0),
              )
            ],
          ),
        ),
      ),

    );
  }
}
