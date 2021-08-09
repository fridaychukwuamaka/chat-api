import 'package:flutter/material.dart';
import 'package:flutter_app/models/chat.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../constant.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({
    @required this.chat,
  });

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return !chat.sent
        ? Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                       chat.msg,
                        style: TextStyle(
                          height: 1.5,
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Color(0xFFDCEDF9),
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      chat.time,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
              Spacer()
            ],
          )
        : Row(
            children: [
              Spacer(),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        chat.msg,
                        style: TextStyle(height: 1.5, color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                          color: kMainBlue,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                         chat.time,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        Icon(
                          FeatherIcons.check,
                          color: kMainBlue,
                          size: 16,
                        ),
                        Icon(
                          FeatherIcons.check,
                          color: kMainBlue,
                          size: 16,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ],
          );
  }
}
