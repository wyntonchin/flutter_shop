import 'package:flutter_shop/config/index.dart';
import 'package:flutter_shop/pages/cart_page.dart';
import 'package:flutter_shop/pages/category_page.dart';
import 'package:flutter_shop/pages/home_page.dart';
import 'package:flutter_shop/pages/memeber_page.dart';
import 'package:flutter_shop/provide/current_index_provide.dart';
import 'package:provide/provide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexPage extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
        icon: Icon(Icons.home), title: Text(KString.homeTitle)),
    BottomNavigationBarItem(
        icon: Icon(Icons.category), title: Text(KString.categoryTitle)),
    BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart), title: Text(KString.shopingCartTitle)),
    BottomNavigationBarItem(
        icon: Icon(Icons.person), title: Text(KString.memberTitle))
  ];

  final List<Widget> tabBodies = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage()
  ];

  @override
  Widget build(BuildContext context) {
    //一定在MaterialApp的home中的页面设置(即入口文件，只需设置一次),
    ScreenUtil.init(context);
    return Provide<CurrentIndexProvide>(
      builder: (context, child, value) {
        //取到当前索引状态值
        int currentIndex =
            Provide.value<CurrentIndexProvide>(context).currentIndex;
        return Scaffold(
          backgroundColor: Color.fromRGBO(244, 255, 245, 1.0),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            items: bottomTabs,
            onTap: (index) {
              Provide.value<CurrentIndexProvide>(context).changeIndex(index);
            },
          ),
          body: IndexedStack(
            index: currentIndex,
            children: tabBodies,
          ),
        );
      },
    );
  }
}
