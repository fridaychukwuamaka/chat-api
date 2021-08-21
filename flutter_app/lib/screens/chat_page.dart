import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/socket_controller.dart';
import 'package:flutter_app/models/chat.dart';
import 'package:flutter_app/models/socketStream.dart';
import 'package:flutter_app/widgets/chat_app_bar.dart';
import 'package:flutter_app/widgets/chat_box.dart';
import 'package:flutter_app/widgets/user_avatar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    @required this.name,
    @required this.friendId,
    this.type: 'one-to-one',
    @required this.userId,
  });

  final String name;
  final String friendId;
  final String type;
  final String userId;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final SocketController socketController = Get.put(SocketController());
  StreamSocket chatStreamSocket = StreamSocket();
  StreamSocket typingStreamSocket = StreamSocket();
  Socket socket;

  PageController _pageController;
  int _tabIndex = 0;

  String status = 'Online';

  TextEditingController _messageController = TextEditingController(text: '');

  List tab = [
    'Chat',
    'Files',
  ];

  bool _inputFocused = false;

  void _sendMessage() {
    var date = DateFormat.Hm().format(DateTime.now());
    var message = _messageController.value.text;
    Chat chat = Chat(
      senderId: widget.userId,
      msg: message,
      time: date.toString(),
      recipientId: widget.friendId,
      type: widget.type,
      sent: true,
    );

    print(chat.runtimeType);
    if (message.trim() != '') {
      setState(() {
        _messageController.clear();
        _inputFocused = false;
      });

      socket.emit('chat-message', chat);
    }
  }

  @override
  void initState() {
    super.initState();
    socket = socketController.socket;
    connect();
    setState(() {
      _pageController = PageController();
    });
  }

  Future<void> connect() async {
    print(socket.id);

    var query = {
      "recepient": widget.friendId,
      "sender": widget.userId,
      "type": widget.type,
    };

    socket.emit('join-friends-room', query);

    socket.on('chat-message', (data) => chatStreamSocket.addResponse(data));

    socket.on('typing', (data) => typingStreamSocket.addResponse(data));
  }

  leaveRoom() {
    var query = {"recepient": widget.friendId, "sender": widget.userId};
    socket.emit('leave-friends-room', query);
  }

  @override
  void dispose() {
    leaveRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        left: Row(
          children: [
            UserAvatar(
              backgroundColor: Colors.white,
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                StreamBuilder(
                    stream: typingStreamSocket.getResponse,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        status = snapshot.data;
                      }
                      // if(_messageController){}
                      return Text(
                        status,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      );
                    }),
              ],
            )
          ],
        ),
        tab: tab,
        pageController: _pageController,
        tabIndex: _tabIndex,
        right: [
          Icon(FeatherIcons.phone),
          SizedBox(
            width: 10,
          ),
          Icon(FeatherIcons.moreVertical),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<Object>(
                  stream: chatStreamSocket.getResponse,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active) {
                      List data = json.decode(snapshot.data);
                      return ListView(
                        reverse: true,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 25,
                        ),
                        children: data
                            .map((e) => ChatBox(
                                    chat: Chat(
                                  msg: e['msg'],
                                  recipientId: '',
                                  time:
                                      '${DateFormat('hh:mm a').format(DateTime.parse(e['date']))}',
                                  sent: widget.userId == e['sender'],
                                  senderId: widget.userId,
                                )))
                            .toList()
                            .reversed
                            .toList(),
                      );
                    } else {
                      return ListView(
                        reverse: true,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 25,
                        ),
                        children: [],
                      );
                    }
                  })),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 15,
            ),
            height: 57,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    onChanged: (val) {
                      if (val.trim() == '') {
                        setState(() {
                          _inputFocused = false;
                        });
                      } else {
                        setState(() {
                          _inputFocused = true;
                        });
                      }
                      socket.emit('typing', 'typing');

                      Future.delayed(Duration(seconds: 2), () {
                        socket.emit('typing', 'Online');
                      });
                    },
                    controller: _messageController,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                    ),
                    cursorColor: Colors.black45,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.only(left: 15),
                      hintText: 'Write something for Mary Jane',
                      hintStyle: TextStyle(
                        color: Colors.black45,
                        fontFamily: 'Montserrat',
                      ),
                      suffixIcon: Icon(
                        FeatherIcons.image,
                        color: Colors.black45,
                      ),
                      filled: true,
                      fillColor: Color(0xFFDCEDF9),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  height: double.infinity,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFFDCEDF9)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)))),
                    onPressed: _sendMessage,
                    child: Icon(
                      !_inputFocused ? FeatherIcons.mic : FeatherIcons.send,
                      size: 21,
                      color: Colors.black45,
                    ),
                    // label: SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
