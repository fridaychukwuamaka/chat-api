import 'package:flutter/cupertino.dart';

class Chat {
  const Chat( {
    @required this.senderId,
    @required this.msg,
    this.type: 'one-to-one',
    @required this.time,
    @required this.sent,
    @required this.recipientId,
  });

  final String msg;
  final String time;
  final bool sent;
  final String recipientId;
  final String type;
  final String senderId;

  toJson() {
    return {
      'msg': msg,
      'time': time,
      'sent': sent,
      'recipientId': recipientId,
      'type':type,
      'senderId': senderId
    };
  }
}
