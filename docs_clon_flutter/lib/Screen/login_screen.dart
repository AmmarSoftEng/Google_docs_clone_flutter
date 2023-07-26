import 'package:docs_clon_flutter/Screen/home_screen.dart';
import 'package:docs_clon_flutter/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:routemaster/routemaster.dart';
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       body: Center(
//         child: ElevatedButton.icon(
//           onPressed: () {},
//           icon: Icon(Icons.person),
//           label: Text("Sign in with google"),
          
//           ),
          
//           ),
//     );
    
//   }
// }

class LoginScreen extends ConsumerWidget {

  void signInWithGoogle(WidgetRef ref,BuildContext context) async{
    final sMessage= ScaffoldMessenger.of(context);
    final navgation = Routemaster.of(context);
   var errorModle = await ref.read(authRepositoryProvider).siginWithGoogle();

   if(errorModle.error==null){
   ref.read(userProvider.notifier).update((state) => errorModle.data);
   navgation.replace('/');
   }
   else{
    sMessage.showSnackBar(SnackBar(content: Text(errorModle.error!),),);
   }

  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            signInWithGoogle(ref,context);
          },
          icon: Icon(Icons.person),
          label: Text("Sign in with google"),
          ),
        ),
    );
  }
}