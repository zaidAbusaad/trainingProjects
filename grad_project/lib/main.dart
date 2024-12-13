import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grad_project/home_cubit/home_cubit.dart';
import 'package:grad_project/layout_cubit/layout_cubit.dart';
import 'package:grad_project/screens/home_screen.dart';
import 'package:grad_project/screens/layout_screen.dart';
import 'package:grad_project/screens/log_in_screen.dart';
import 'package:grad_project/screens/map_page.dart';
import 'package:grad_project/screens2/home_screen_employee.dart';

// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LayoutCubit()),
        BlocProvider(create: (context) => HomeCubit()),
      ],
      child:  const MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  LogInScreen(),
        ),



    );
  }
}
