import 'package:docs_clon_flutter/common/widget/loder.dart';
import 'package:docs_clon_flutter/modles/document_modle.dart';
import 'package:docs_clon_flutter/modles/error_model.dart';
import 'package:docs_clon_flutter/repository/auth_repository.dart';
import 'package:docs_clon_flutter/repository/document_repository.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:routemaster/routemaster.dart';

class HomeScree extends ConsumerWidget {
  const HomeScree({Key? key}) : super(key: key);

  void signOut(WidgetRef ref){
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  // void creatDocument(BuildContext context, WidgetRef ref) async{

  //   String token = ref.read(userProvider)!.token;
  //   final navigator = Routemaster.of(context);
  //   final snackbar = ScaffoldMessenger.of(context);

  //    final errorModel = await ref.read(documentRepositoryProvider).createDocument(token);
     
  //    if(errorModel.data!=null){
  //     navigator.push('/document/${errorModel.data.id}');
  //    }else{
  //     snackbar.showSnackBar(SnackBar(content: Text(errorModel.error!)));

  //    }

  // }

 void createDocument(BuildContext context, WidgetRef ref) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);

    final errorModel = await ref.read(documentRepositoryProvider).createDocument(token);

    if (errorModel.data != null) {
      navigator.push('/document/${errorModel.data.id}');
    } else {
      snackbar.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  void navigateToDoment(BuildContext context, String documentId){
    Routemaster.of(context).push('/document/$documentId');
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(onPressed: (){
          createDocument(context, ref);
          }, icon: Icon(Icons.add, color: Colors.black,),),
          IconButton(onPressed: (){
            signOut(ref);
          }, icon: Icon(Icons.logout, color: Colors.black,)),
        ],
      ),
      body: FutureBuilder<ErrorModle?>(
        future: ref.watch(documentRepositoryProvider).getDocument(ref.watch(userProvider)!.token),
        builder: (context,snapshort){
          if(snapshort.connectionState==ConnectionState.waiting){
            return const Loder();
          }
          return Center(
            child: Container(
              margin:const EdgeInsets.only(top: 10),
              width: 600,
              child: ListView.builder(itemCount: snapshort.data!.data.length ,itemBuilder:((context, index) {
                DocumentModel document = snapshort.data!.data[index];
                return InkWell(
                  onTap: (() {
                    navigateToDoment(context, document.id);
                  }),
                  child: SizedBox(
                    height: 60,
                    child: Card(
                      child: Center(child: Text(document.title,style: const TextStyle(fontSize: 17),)),
                    ),
                  ),
                );
              })),
            ),
          );
        },),
    );
    
  }
}