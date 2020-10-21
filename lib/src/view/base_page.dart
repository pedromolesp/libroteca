import 'package:flutter/material.dart';
import 'package:libroteca/src/helpers/screen_size.dart';
import 'package:libroteca/src/styles/colors.dart';
import 'package:libroteca/src/styles/fonts.dart';
import 'package:libroteca/src/view/book-list/book_list_page.dart';

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> with TickerProviderStateMixin {
  String search = "";
  int _currentIndex = 0;
  TabController _tabController;
  final List<Widget> _children = [
    BookListPage(),
    Container(),
    Container(),
  ];
  TextStyle ts;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = getMediaSize(context);
    ts = TextStyle(
      color: black,
      fontSize: size.width * 0.035,
    );
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: orangeDark,
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
          ),
          Container(
              width: size.width,
              height: size.height * 0.91,
              child:
                  TabBarView(controller: _tabController, children: _children)),
          Positioned(
            bottom: 0,
            child: getTabsRow(size),
          ),
        ],
      ),
    );
  }

  getTabsRow(Size size) {
    return Container(
        width: size.width,
        decoration: BoxDecoration(color: orangeDark, boxShadow: [
          BoxShadow(blurRadius: 7, color: black20, offset: Offset(0.0, 2.0))
        ]),
        child: TabBar(
          controller: _tabController,
          labelColor: black,
          indicatorColor: black,
          unselectedLabelColor: whiteRed,
          labelStyle: TextStyle(fontFamily: Fonts.muliBold),
          tabs: [
            Tab(
              icon: Icon(
                Icons.list,
              ),
              text: 'Mi biblioteca',
            ),
            Tab(
              icon: Icon(
                Icons.star,
              ),
              text: 'Valorados',
            ),
            Tab(
              icon: Icon(
                Icons.favorite,
              ),
              text: 'Lista de deseos',
            ),
          ],
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}