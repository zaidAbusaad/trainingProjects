import 'package:ecommerceapp/layout_cubit/layout_cubit.dart';
import 'package:ecommerceapp/list_cubit/product_cubit.dart';
import 'package:ecommerceapp/screens/authenticate/authenticate.dart';
import 'package:ecommerceapp/screens/cart_screen.dart';
import 'package:ecommerceapp/screens/layout_screen.dart';
import 'package:ecommerceapp/screens/wrapper.dart';
import 'package:ecommerceapp/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import'package:provider/provider.dart';
import 'firebase_options.dart';
import 'models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductCubit(),
        ),
        BlocProvider(
          create: (context) => LayoutCubit(),
        ),
        StreamProvider<AppUser?>.value(
          value: AuthService().firebaseUser, // Use the correct stream here
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );

  }
}
//       BlocProvider<HomeCubit>(
//       create: (context) => HomeCubit()  ,
//       child: MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         home: const MyHomePage(title: 'Flutter Demo Home Page'),
//       ),
//     );
//   }
// }
//
// class MyHomePage extends StatelessWidget {
//   const  MyHomePage({super.key,required this.title});
// final String title;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             BlocBuilder<HomeCubit,HomeStates>(
//               builder: (_,state) {
//                 return Text(
//                  HomeCubit.get(context).counter.toString(),
//                   style: Theme.of(context).textTheme.headlineMedium,
//                 );
//               }
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: HomeCubit.get(context).incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
//}
