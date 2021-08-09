import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/socket_controller.dart';
import 'package:flutter_app/controllers/user_controller.dart';
import 'package:flutter_app/models/socketStream.dart';
import 'package:flutter_app/screens/providers/auth.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter_app/models/user_chat.dart';
import 'package:flutter_app/screens/chat_page.dart';
import 'package:flutter_app/widgets/chat_list_item.dart';
import 'package:get/get.dart';

class AllMessagePage extends StatefulWidget {
  const AllMessagePage({@required this.userId});
  final String userId;

  @override
  _AllMessagePageState createState() => _AllMessagePageState();
}

class _AllMessagePageState extends State<AllMessagePage> {
  final SocketController socketController = Get.put(SocketController());
  final UserController userController = Get.put(UserController());
  StreamSocket friendStreamSocket = StreamSocket();
  AuthProvider _authProvider = AuthProvider();

  String userId = '';

  Socket socket;

  List<UserChat> users = [
    UserChat(
      name: 'Jane Doe',
      lastMsg: 'Hi !!!',
      userId: '',
      missedMsg: 4,
    ),
    UserChat(
      name: 'Juliet John',
      lastMsg: 'Hello !!!',
      userId: '',
      missedMsg: 2,
    ),
  ];

  @override
  void initState() {
    getCurrentUser();

    super.initState();
  }

  getCurrentUser() async {
    Response response = await _authProvider.currentUser();
    if (response.statusCode == 200) {
      userController.currentUser = response.body;

      userId = response.body['_id'];

      print('sdsdd $userId');

      // box.write('user', response.body);
    }
    await connect();
  }

  Future<void> connect() async {
    socket = socketController.socket;

    socket.emit('get-friends', userId);

    socket.on('get-friends', (data) {
      return friendStreamSocket.addResponse(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Response<dynamic>>(
        stream: Stream.fromFuture(_authProvider.friends()),
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            List data = snapshot.data.body['friendList'];
            print(data);

            data = data
                .map((e) => UserChat(
                      name: e['username'],
                      lastMsg: 'Hello',
                      userId: e['_id'],
                      missedMsg: 2,
                    ))
                .toList();

            return ListView.builder(
              padding: EdgeInsets.only(top: 20),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final UserChat userChat = data[index];
                return ChatListItem(
                  leading: '',
                  title: userChat.name,
                  subTitle: userChat.lastMsg,
                  missedMsg: userChat.missedMsg.toString(),
                  onTap: () {
                    Get.to(() => ChatPage(
                          name: userChat.name,
                          userId: userId,
                          friendId: userChat.userId,
                        ));
                  },
                );
              },
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ],
            );
          }
        });
  }
}
