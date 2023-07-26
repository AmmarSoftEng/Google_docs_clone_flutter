import 'package:docs_clon_flutter/clients/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository{
  
final _socktClient = SocketClient.instance.socket!;

Socket get socketClient =>_socktClient;

void joinRoom(String documentId){
  _socktClient.emit('join',documentId);
}

void typing(Map<String,dynamic>data){
  _socktClient.emit('typing',data);
}

// void autoSave(Map<String, dynamic> data){
//   _socktClient.emit('save',data);
// }

 void autoSave(Map<String, dynamic> data) {
    _socktClient.emit('save', data);
  }
  
void changeListener(Function(Map<String,dynamic>)fun){
  _socktClient.on('changes', (data) => fun(data));
}

}