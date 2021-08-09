import 'package:flutter/foundation.dart';

class UserChat {
  final String userId;
  final String name;
  final String lastMsg;
  final int missedMsg;

  const UserChat({
    @required this.name,
    @required this.lastMsg,
    @required this.userId,
    @required this.missedMsg,
  });

  fromJson(jsonData) => UserChat(
        name: jsonData['username'],
        lastMsg: 'lastMsg',
        userId: jsonData['_id'],
        missedMsg: 1,
      );
}
