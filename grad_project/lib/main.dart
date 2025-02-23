import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project/repositories/accepted_offers_repository.dart';
import 'package:grad_project/repositories/accepted_offersworker_repository.dart';
import 'package:grad_project/repositories/offer_repository.dart';

import 'package:grad_project/repositories/service_repository.dart';

import 'package:grad_project/screens/log_in_screen.dart';
import 'package:grad_project/state_management/cubits/home_cubit/home_cubit.dart';
import 'package:grad_project/state_management/cubits/layout_cubit/layout_cubit.dart';
import 'package:grad_project/state_management/providers/offer_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_functions/offer_service.dart';
import 'state_management/providers/media_provider.dart';

// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug, // Use 'debug' for testing, 'playIntegrity' for production
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => MediaProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LayoutCubit()),
        BlocProvider(create: (context) => HomeCubit(ServiceRepository())),
        ChangeNotifierProvider(
            create: (_) => OfferProvider( OfferRepository(
                    currentUserId: FirebaseAuth.instance.currentUser!.uid),AcceptedOfferRepository(),AcceptedOfferWorkerRepository())),
      ],
      child: MaterialApp(
        theme: ThemeData.light(),  // Light theme
        darkTheme:  ThemeData.dark(),  // Dark theme
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const LogInScreen(),
      ),
    );
  }
}
