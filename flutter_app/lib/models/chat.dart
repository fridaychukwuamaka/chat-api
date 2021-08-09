import 'package:flutter/cupertino.dart';

class Chat {
  const Chat({
    @required this.senderId,
    @required this.msg,
    @required this.time,
    @required this.sent,
    @required this.recipientId,
  });

  final String msg;
  final String time;
  final bool sent;
  final String recipientId;
  final String senderId;

  toJson() {
    return {
      'msg': msg,
      'time': time,
      'sent': sent,
      'recipientId': recipientId,
      'senderId': senderId
    };
  }
}
