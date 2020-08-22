import 'dart:math';

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
  //火爆专区页面
  int page = 1;
  List hotGoodsList = [];

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
                    RecommendUI(recommendList: recommendList),
                    FloorPic(
                      floorPic: fp1,
                    ),
                    FloorBottom(
                      floor: floor1,
                    ),
                    _hotGoods(),
                  ],
                ),
                loadMore: () async {
                  print('开始加载更多');
                  _getHotGoods();
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

  void _getHotGoods() {
    var formPage = {'page': page};
    request('getHotGoods', formData: formPage).then((value) {
      var data = json.decode(value.toString());
      print(data);

      List<Map> newGoodsList = (data['data'] as List).cast();
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
  }

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
          bottom: BorderSide(width: 0.5, color: KColor.defaultBorderColor)),
    ),
    child: Text(
      '火爆专区',
      style: TextStyle(color: KColor.homeSubTitleTextColor),
    ),
  );

//火爆专区
  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((value) {
        return InkWell(
          onTap: () {},
          child: Container(
            width: ScreenUtil().setWidth(492),
            color: Colors.white,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 3),
            child: Column(
              children: [
                Image.network(
                  value['image'],
                  width: ScreenUtil().setWidth(475),
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Text(
                  value['name'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: [
                    Text(
                      '￥${value['presentPrice']}',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '￥${value['oriPrice']}',
                      style: KFont.oriPriceStyle,
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 3,
        children: listWidget,
      );
    } else {
      return Text('没有火爆数据');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: [
          hotTitle,
          _wrapList(),
        ],
      ),
    );
  }
}

//轮播
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
            width: ScreenUtil().setWidth(50),
            height: ScreenUtil().setHeight(50),
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
      height: ScreenUtil().setHeight(300),
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

class RecommendUI extends StatelessWidget {
  final List recommendList;
  const RecommendUI({Key key, this.recommendList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList(context),
        ],
      ),
    );
  }

//商品标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 2, 0, 5),
      //装饰器
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: KColor.defaultBorderColor),
        ),
      ),
      child: Text(
        KString.recommendText,
        style: TextStyle(color: KColor.homeSubTitleTextColor),
      ),
    );
  }

  //商品推荐列表
  Widget _recommendList(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(380),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recommendList.length,
          itemBuilder: (context, index) {
            return _item(context, index);
          }),
    );
  }

  Widget _item(context, index) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: ScreenUtil().setWidth(280),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                left:
                    BorderSide(width: 0.5, color: KColor.defaultBorderColor))),
        child: Column(
          children: [
            //防止溢出
            Expanded(
              child: Image.network(
                recommendList[index]['image'],
                fit: BoxFit.cover,
              ),
            ),
            Text(
              '￥${recommendList[index]['presentPrice']}',
              style: KFont.presentStyle,
            ),
            Text(
              '￥${recommendList[index]['oriPrice']}',
              style: KFont.oriPriceStyle,
            ),
          ],
        ),
      ),
    );
  }
}

//商品推荐中间广告
class FloorPic extends StatelessWidget {
  final Map floorPic;
  const FloorPic({Key key, this.floorPic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(220),
      margin: EdgeInsets.only(top: 10),
      child: InkWell(
        child: Image.network(
          floorPic['PICTURE_ADRESS'],
          fit: BoxFit.cover,
        ),
        onTap: () {
          //跳转到新页面
        },
      ),
    );
  }
}

//商品推荐下层
class FloorBottom extends StatelessWidget {
  final List floor;
  const FloorBottom({Key key, this.floor}) : super(key: key);

  void jumpDetail(context, String goodId) {
//
  }
  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil.screenWidth;
    return Container(
      child: Row(
        //水平均等布局
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        // //交叉轴的布局方式，对于column来说就是水平方向的布局方式
        // crossAxisAlignment: CrossAxisAlignment.center,
        // //就是字child的垂直布局方向，向上还是向下
        // verticalDirection: VerticalDirection.down,
        children: [
          //谁平均分
          Expanded(
              child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 4),
                height: ScreenUtil().setHeight(400),
                width: width / 2,
                child: InkWell(
                  child: Image.network(
                    floor[0]['image'],
                    fit: BoxFit.fill,
                  ),
                  onTap: () {
                    jumpDetail(context, floor[0]['goodsId']);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 1),
                width: width / 2,
                height: ScreenUtil().setHeight(200),
                child: InkWell(
                  child: Image.network(
                    floor[1]['image'],
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    jumpDetail(context, floor[1]['goodsId']);
                  },
                ),
              ),
            ],
          )),

          //右侧商品
          Expanded(
              child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 4),
                width: width / 2,
                height: ScreenUtil().setHeight(200),
                child: InkWell(
                  child: Image.network(
                    floor[2]['image'],
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    jumpDetail(context, floor[2]['goodsId']);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 1),
                width: width / 2,
                height: ScreenUtil().setHeight(200),
                child: InkWell(
                  child: Image.network(
                    floor[3]['image'],
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    jumpDetail(context, floor[3]['goodsId']);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 1),
                width: width / 2,
                height: ScreenUtil().setHeight(200),
                child: InkWell(
                  child: Image.network(
                    floor[4]['image'],
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    jumpDetail(context, floor[4]['goodsId']);
                  },
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
