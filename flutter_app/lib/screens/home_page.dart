import 'package:flutter/material.dart';
import 'package:flutter_app/constant.dart';
import 'package:flutter_app/controllers/socket_controller.dart';
import 'package:flutter_app/controllers/user_controller.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/screens/all_groups_page.dart';
import 'package:flutter_app/screens/all_message_page.dart';
import 'package:flutter_app/screens/create_group_page.dart';
import 'package:flutter_app/widgets/chat_app_bar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final SocketController socketController = Get.put(SocketController());
  final UserController userController = Get.put(UserController());
  GetStorage box = GetStorage();

  AuthProvider _authProvider = AuthProvider();

  String userId;

  PageController _pageController;
  int _tabIndex = 0;
  Socket socket;

  List tab = [
    'All Messages',
    /* 'Stories',
    'Private', */
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
      OptionBuilder()
          .setTransports(['websocket']).setQuery({'foo': userId}).build(),
    );
  }

  onPressFab() {
    if (_tabIndex == 0) {
      print(box.read('authToken'));
    } else if (_tabIndex == 3) {
      Get.to(() => CreateGroupPage());
    } else {
      print(box.read('authToken'));
    }
  }

  IconData selectFabIcon() {
    if (_tabIndex == 0) {
      return FeatherIcons.edit;
    } else {
      return FeatherIcons.userPlus;
     
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
       /*    AllMessagePage(
            userId: userId,
          ),
          AllMessagePage(
            userId: userId,
          ), */
          AllGroupPage(
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
        onPressed: onPressFab,
        child: Icon(
          selectFabIcon(),
          color: Colors.white70,
        ),
      ),
    );
  }
}
