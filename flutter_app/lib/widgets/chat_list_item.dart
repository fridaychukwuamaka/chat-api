import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/user_avatar.dart';

import '../constant.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    @required this.leading,
    @required this.title,
    @required this.subTitle,
    @required this.missedMsg,
    @required this.onTap,
    this.isGeneric : false,
    this.trailing : const SizedBox.shrink(),
  });

  final String leading;
  final String title;
  final String subTitle;
  final String missedMsg;
  final bool isGeneric ;
  final Widget trailing ;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: UserAvatar(
        backgroundColor: kMainBlue,
      ),
      trailing: !isGeneric
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Text(
                    missedMsg,
                    textScaleFactor: 0.8,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  padding: EdgeInsets.all(5.8),
                  decoration: BoxDecoration(
                    color: kMainBlue,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Just now',
                  textScaleFactor: 0.85,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          : trailing,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Montserrat',
        ),
      ),
      subtitle: Text(
        subTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
