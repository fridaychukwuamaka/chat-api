import 'package:flutter/material.dart';
import 'package:flutter_app/constant.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ChatAppBar({
    @required this.tab,
    @required this.tabIndex,
    @required this.pageController,
    @required this.right,
    @required this.left,
  });

  final List tab;
  final PageController pageController;
  final int tabIndex;
  final List<Widget> right;
  final Widget left;
  // final Function onTap;

  @override
  _ChatAppBarState createState() => _ChatAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(143);
}

class _ChatAppBarState extends State<ChatAppBar> {
  // ignore: unused_field
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(143),
      child: Container(
        decoration: BoxDecoration(
          color: kMainBlue,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15)
                  .copyWith(top: 25),
              child: Row(
                children: [
                  widget.left,
                  Spacer(),
                  Row(
                    children: widget.right,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 10, left: 15),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    widget.tab.length,
                    (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _tabIndex = index;
                            });
                            widget.pageController.jumpToPage(index);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(right: 10),
                            child: Text(
                              widget.tab[index],
                              style: TextStyle(
                                color: widget.tabIndex == index
                                    ? kMainBlue
                                    : Colors.white70,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: widget.tabIndex == index
                                  ? Colors.white
                                  : kMainBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )),
                // controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
