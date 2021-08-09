import 'package:flutter/material.dart';
import 'package:flutter_app/constant.dart';
import 'package:flutter_app/controllers/socket_controller.dart';
import 'package:flutter_app/controllers/user_controller.dart';
import 'package:flutter_app/screens/all_message_page.dart';
import 'package:flutter_app/screens/providers/auth.dart';
import 'package:flutter_app/utils/ip_address.dart';
import 'package:flutter_app/widgets/chat_app_bar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final SocketController socketController = Get.put(SocketController());
  final UserController userController = Get.put(UserController());
  AuthProvider _authProvider = AuthProvider();

  String userId;

  PageController _pageController;
  int _tabIndex = 0;
  Socket socket;

  List tab = [
    'All Messages',
    'Stories',
    'Private',
    'Groups',
  ];

  @override
  initState() {
    super.initState();
    getCurrentUser();
    setState(() {
      _pageController = PageController();
    });
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

  connect() async {
    socketController.socket = io(
        kAddress,
        // '10.0.2.16:8080'
        OptionBuilder()
            .setTransports(['websocket']).setQuery({'foo': userId}).build());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: ChatAppBar(
          left: Row(
            children: [
              Text(
                'IdeateChat',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          right: [
            Icon(FeatherIcons.search),
            SizedBox(
              width: 15,
            ),
            Icon(FeatherIcons.bell),
            SizedBox(
              width: 15,
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
            ),
          ],
          tab: tab,
          pageController: _pageController,
          tabIndex: _tabIndex,
        ),
        body: PageView(
          children: [
            AllMessagePage(
              userId: userId,
            ),
            AllMessagePage(
              userId: userId,
            ),
            AllMessagePage(
              userId: userId,
            ),
            AllMessagePage(
              userId: userId,
            ),
          ],
          onPageChanged: (index) {
            setState(() {
              _tabIndex = index;
            });
          },
          controller: _pageController,
        ),
        //    floatingActionButtonLocation: FloatingActionButtonLocation.,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            print(box.read('authToken'));
          },
          child: Icon(
            FeatherIcons.edit,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
