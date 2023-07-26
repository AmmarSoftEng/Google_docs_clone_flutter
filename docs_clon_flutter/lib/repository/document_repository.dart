import 'dart:convert';
import 'dart:io';

import 'package:docs_clon_flutter/constants.dart';
import 'package:docs_clon_flutter/modles/document_modle.dart';
import 'package:docs_clon_flutter/modles/error_model.dart';
import 'package:http/http.dart';
import 'package:riverpod/riverpod.dart';


final documentRepositoryProvider = Provider((ref)=>DocumentRepository(client: Client(),),);

class DocumentRepository{
final Client _client;

DocumentRepository({required Client client}):_client=client;

// Future<ErrorModle> creatDocument(String token) async { 
// ErrorModle error=ErrorModle(error: "faile to create document", data: null); 

//  try{
//       var res = await _client.post(Uri.parse('$host/doc/create'),headers:{
//       'Content-Type': 'application/json; charset=UTF-8',
//       "Access-Control-Allow-Origin": "*",
//       'x-auth-token': token,

//      }, body: jsonEncode({'createdAt': DateTime.now().millisecondsSinceEpoch,},),

//      );
     

//      switch(res.statusCode){
//       case 200:
//        error = ErrorModle(error: null, data: DocumentModle.fromJson(res.body));
//       break;
//      }

    
//    }catch (e){
//       error = ErrorModle(error: e.toString(), data: null);
//       }
//       return error;}

// try{

//   var res = await _client.post(Uri.parse('$host/doc/create'),headers: {
//   'Content-Type' : 'application/json; charset=UTF-8',
//   'x-auth-token' : token, 
// },
// body: jsonEncode({ 'createdAt': DateTime.now().millisecondsSinceEpoch,}),

// );
// switch(res.statusCode){
//   case 200: 
//   error = ErrorModle(error: null, data: DocumentModle.fromJson(res.body));
//   break;
//   default:
//   error= ErrorModle(error:res.body, data: null);
//   print(res.body);
// }

// }catch (e){
//  error = ErrorModle(error: e.toString() ,data: null);
 
// }

// return error;

// }

  Future<ErrorModle> createDocument(String token) async {
    
    ErrorModle error = ErrorModle(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      var res = await _client.post(
        Uri.parse('$host/doc/create'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        }),

      );
      
      switch (res.statusCode) {
        case 200:
          error = ErrorModle(
            error: null,
            data: DocumentModel.fromJson(res.body),
          );
          break;
        default:
          error = ErrorModle(
            error: res.body,
            data: null,
          );
          break;
      }
    } catch (e) {
      error = ErrorModle(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

   Future<ErrorModle> getDocument(String token) async {
    
    ErrorModle error = ErrorModle(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      var res = await _client.get(
        Uri.parse('$host/docs/me'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
    
      );
      
      switch (res.statusCode) {
        case 200:
        List<DocumentModel> documents = [];
        for(int i=0; i< jsonDecode(res.body).length;i++){
          documents.add(DocumentModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
        }
          error = ErrorModle(
            error: null,
            data: documents,
          );
          break;
        default:
          error = ErrorModle(
            error: res.body,
            data: null,
          );
          break;
      }
    } catch (e) {
      error = ErrorModle(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

 void updateTitle({required String token, required String id, required String title}) async {
  
      var res = await _client.post(
        Uri.parse('$host/doc/title'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'id':id,
          'title':title,
        }),
        );
  }

   Future<ErrorModle> gettitle(String token,String id) async {
    
    ErrorModle error = ErrorModle(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      var res = await _client.get(
        Uri.parse('$host/doc/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );
      
      switch (res.statusCode) {
        case 200:
            error = ErrorModle(
            error: null,
            data:  DocumentModel.fromJson(res.body),
          );
          break;
          default:
          throw 'This Document dose not exist, please create new one';
    
      }
    } catch (e) {
      error = ErrorModle(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }


}