import 'package:ecommerceapp/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:ecommerceapp/models/user.dart';
import 'package:provider/provider.dart';

import 'layout_screen.dart';
class Wrapper extends StatelessWidget{
  @override
  Widget build(BuildContext context){
final user = Provider.of<AppUser?>(context);
if(user==null){
  return Authenticate();
}else{ return LayoutScreen();
}

  }
}