import 'package:flutter_shop/config/index.dart';
import 'package:flutter_shop/service/http_service.dart';
import 'package:provide/provide.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  // 不刷新，保持状态
  bool get wantKeepAlive => true;

  //用key记录，有变化的组件才渲染
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  //diff

  @override
  void initState() {
    super.initState();
    print('首页刷新了');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
        appBar: AppBar(
          title: Text(KString.homeTitle),
        ),

        //防止重绘
        body: FutureBuilder(
          future: request('getHomePageContent', formData: null),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());
              print(data);
              List<Map> swiperDataList =
                  (data['data']['slides'] as List).cast();
              List<Map> category = (data['data']['category'] as List).cast();
              List<Map> recommendList =
                  (data['data']['recommend'] as List).cast();
              List<Map> floor1 = (data['data']['floor1'] as List).cast();
              Map fp1 = data['data']['floorPic']; //广告

              return EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.white,
                  textColor: KColor.refreshTextColor,
                  moreInfoColor: KColor.refreshTextColor,
                  showMore: true,
                  noMoreText: '',
                  moreInfo: KString.loading,
                  loadReadyText: KString.loadReadyText,
                ),
                child: ListView(
                  children: <Widget>[],
                ),
                loadMore: () async {
                  print('开始加载更多');
                },
              );
            } else {
              return Container(
                child: Text('加载错误'),
              );
            }
          },
        ));
  }
}
