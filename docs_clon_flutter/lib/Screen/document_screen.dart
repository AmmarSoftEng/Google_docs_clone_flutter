import 'dart:async';

import 'package:docs_clon_flutter/common/widget/loder.dart';
import 'package:docs_clon_flutter/modles/document_modle.dart';
import 'package:docs_clon_flutter/modles/error_model.dart';
import 'package:docs_clon_flutter/repository/auth_repository.dart';
import 'package:docs_clon_flutter/repository/document_repository.dart';
import 'package:docs_clon_flutter/repository/socket_repositry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  DocumentScreen({required this.id,});
  String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {

TextEditingController titleController=TextEditingController(text: "Untitled Document");
 quill.QuillController? _controller;
ErrorModle? errorModle;
SocketRepository socketRepository = SocketRepository();


@override
  void initState() {
    super.initState();
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();

    socketRepository.changeListener((data) {
      _controller?.compose(quill.Delta.fromJson(data['delta']),
       _controller?.selection??const TextSelection.collapsed(offset: 0),
        quill.ChangeSource.REMOTE);
    });

  //  Timer.periodic(const Duration(seconds: 2), (timer){
  //     socketRepository.autoSave(<String,dynamic>{
  //     'delta':_controller!.document.toDelta(),
  //     'room': widget.id,
  //     });
  //   }); 
   Timer.periodic(const Duration(seconds: 2), (timer) {
      socketRepository.autoSave(<String, dynamic>{
        'delta': _controller!.document.toDelta(),
        'room': widget.id,
      });
    });
  }

@override
  void dispose() {
    titleController.dispose();
    super.dispose();
    
  }

void updateTitle(WidgetRef ref,String title){
  ref.read(documentRepositoryProvider).updateTitle(token: ref.read(userProvider)!.token, id: widget.id, title: title);
}

void fetchDocumentData()async {
  errorModle = await ref.read(documentRepositoryProvider).gettitle(ref.read(userProvider)!.token, widget.id);
  if(errorModle!.data!=null){
    titleController.text = (errorModle!.data as DocumentModel).title;
    _controller= quill.QuillController(document: errorModle!.data.content.isEmpty ? quill.Document():quill.Document.fromDelta(quill.Delta.fromJson(errorModle!.data.content),),
    selection: const TextSelection.collapsed(offset: 0));
    setState(() {
      
    });
  }
_controller!.document.changes.listen((event) {
  if(event.item3==quill.ChangeSource.LOCAL){
    Map<String,dynamic> map={
      'delta': event.item2,
      'room' : widget.id,
    };
    socketRepository.typing(map);
  }
});

}

  @override
  Widget build(BuildContext context) {

    if(_controller==null){
      return Scaffold(
        body:  Loder(),
      );
    }
    return Scaffold(
      appBar: AppBar(elevation: 0,backgroundColor: Colors.white,actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton.icon(onPressed: (){
            Clipboard.setData(ClipboardData(text: 'http://localhost:3000/#/document/${widget.id}')).then((value) =>{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('link copied!',),),)

            });
          }, icon: Icon(Icons.lock,), label: Text('Share'),),
        ),
      ],
      title: Row(children: [
       GestureDetector(
        onTap:(){
          Routemaster.of(context).replace('/');
        },
       child: const Icon(Icons.document_scanner,color: Colors.blue,)),
        SizedBox(
          width: 180,
          child: TextField(controller:titleController ,
          decoration: const InputDecoration(border: InputBorder.none,contentPadding: EdgeInsets.only(left: 10,
          ),focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
            )
          )),
          onSubmitted: (value){
            updateTitle(ref, value);

          },
          ),
        ),
      ],),
      bottom: PreferredSize(preferredSize: Size.fromHeight(1),child:Container(decoration: BoxDecoration(border: Border.all(
        color: Colors.grey.shade700,
        width: 0.1,
      ))),),
      ),
      body: Center(
        child: Column(
  children: [
    const SizedBox(height: 10,),
    quill.QuillToolbar.basic(controller: _controller!),
    const SizedBox(height: 10,),
    Expanded(
        child: SizedBox(
          width: 750,
          child: Card(
            color: Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: quill.QuillEditor.basic(
                  controller: _controller!,
                  readOnly: false, 
                ),
            ),
          ),
        ),
        
    )
  ],
),
      ),

    );
  }
}