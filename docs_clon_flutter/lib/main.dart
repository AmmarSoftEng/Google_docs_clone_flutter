
import 'package:docs_clon_flutter/modles/error_model.dart';
import 'package:docs_clon_flutter/repository/auth_repository.dart';
import 'package:docs_clon_flutter/rouet.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:routemaster/routemaster.dart';

void main() {
  runApp( ProviderScope(child: MyApp()));
}



class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  ErrorModle? errorModle;

  @override
  void initState() {
    super.initState();
    getUserData();
  }
  
  void getUserData() async {
    errorModle = await  ref.read(authRepositoryProvider).getUserData();
    if(errorModle!=null && errorModle!.data!=null){
      ref.read(userProvider.notifier).update((state) => errorModle!.data);
    }
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
    
        primarySwatch: Colors.blue,
      ),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context){
        final user = ref.watch(userProvider);
        if(user!=null && user.token.isNotEmpty){
          return loggedInRout;
        }
      
        return loggedoutRout;
      }),
      routeInformationParser:  RoutemasterParser(),
  
    );
  }
}
