import 'package:flutter/material.dart';
import 'package:flutter_app/constant.dart';
import 'package:flutter_app/models/user_chat.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/widgets/chat_list_item.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage();

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  AuthProvider _authProvider = AuthProvider();

  var friendsList;
  String _groupName = 'New Group';

  @override
  void initState() {
    super.initState();
    getFriends();
  }

  getFriends() async {
    var val = await _authProvider.friends();
    if (val.statusCode == 200) {
      setState(() {
        friendsList = val.body;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainBlue,
        title: Text(
          _groupName,
          style: TextStyle(
            fontFamily: 'Montserrat',
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.black26,
                    radius: 25,
                    child: Icon(
                      FeatherIcons.camera,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    cursorColor: kMainBlue,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (val) {
                      if (val.isEmpty) {
                        setState(() {
                          _groupName = 'New Group';
                        });
                      } else {
                        setState(() {
                          _groupName = val;
                        });
                      }
                    },
                    onSubmitted: (val) {
                      print(val);
                    },
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kMainBlue, width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kMainBlue, width: 2),
                      ),
                      hintText: 'Group name',
                      hintStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<Response<dynamic>>(
                future: _authProvider.friends(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && friendsList.isNotEmpty) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 20),
                      itemCount: friendsList.length ?? 0,
                      itemBuilder: (context, index) {
                        List data = snapshot.data.body['friendList'];

                        data = data
                            .map((e) => UserChat(
                                  name: e['username'],
                                  lastMsg: 'Hello',
                                  userId: e['_id'],
                                  missedMsg: 2,
                                ))
                            .toList();
                        final UserChat userChat = data[index];
                        return ChatListItem(
                          leading: '',
                          title: userChat.name,
                          isGeneric: true,
                          subTitle: userChat.lastMsg,
                          missedMsg: userChat.missedMsg.toString(),
                          onTap: () {},
                        );
                      },
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: kMainBlue,
                        ),
                      ],
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
