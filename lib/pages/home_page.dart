import 'package:flutter_shop/config/index.dart';
import 'package:flutter_shop/service/http_service.dart';
import 'package:provide/provide.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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
              List<Map> navigatorList =
                  (data['data']['category'] as List).cast();
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
                  children: <Widget>[
                    //轮播
                    SwiperDiy(
                      swiperDataList: swiperDataList,
                    ),
                    //分类
                    TopNavigator(
                      navigatorList: navigatorList,
                    ),
                  ],
                ),
                loadMore: () async {
                  print('开始加载更多');
                },
                // refreshHeader: ClassicsHeader(),
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

class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  const SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 122,
      width: 750,
      child: Swiper(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: Image.network(
              "${swiperDataList[index]['image']}",
              fit: BoxFit.cover,
            ),
          );
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(),
        autoplay: true,
        autoplayDelay: 3000,
      ),
    );
  }
}

//上部分类组件
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  const TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item, index) {
    return InkWell(
      onTap: () {
        //跳转到分类页面
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: 55,
            height: 50,
          ),
          Text(item['firstCategoryName']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (navigatorList.length > 10) {
      navigatorList.removeRange(10, navigatorList.length);
    }
    var tempIndex = -1;
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(3),
      height: 200,
      child: GridView.count(
        crossAxisCount: 5,
        //禁止滚动
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(3),
        children: navigatorList.map((item) {
          tempIndex++;
          return _gridViewItemUI(context, item, tempIndex);
        }).toList(),
      ),
    );
  }
}
