import 'package:ecommerceapp/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
 _SignInState createState() => _SignInState();

}

class _SignInState extends State<SignIn>{
  final  AuthService _auth = AuthService();
  final _formKey= GlobalKey<FormState>();

  //text fiels state
  String email= '';
  String password ='';
  String error= '';


  @override
 Widget build(BuildContext context){

      return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text('sign in '),
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('Sign up'),
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
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);

                  if(result==null){
                     setState(()=>error='Wrong email or password');
                   }
                  }
                },
                child: Text('Sign In'),
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