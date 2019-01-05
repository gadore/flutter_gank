import 'package:flutter/material.dart';
import '../model/today_indfo.dart';
import '../model/gank_info.dart';
import '../util/data_util.dart';
import '../widget/gank_title_item.dart';
import '../widget/gank_list_item.dart';
import '../widget/gank_pic_item.dart';

class NewsPage extends StatefulWidget {
  final String date;
  NewsPage({this.date = ''});
  @override
  State<StatefulWidget> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with AutomaticKeepAliveClientMixin {
  String _girlImage;
  Map<String, List<GankInfo>> _itemData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadData() async {
    if (widget.date.isEmpty) {
      await DataUtil.getLastDayData()
          .then((todayInfo) => _setTodayInfo(todayInfo));
    } else {
      await DataUtil.getSpecialDayData(widget.date)
          .then((todayInfo) => _setTodayInfo(todayInfo));
    }
  }

  Future<void> _onRefresh() async {
    _itemData.clear();
    await _loadData();
    return null;
  }

  void _setTodayInfo(TodayInfo todayInfo) {
    setState(() {
      _girlImage = todayInfo.girlImage;
      _itemData = todayInfo.itemData;
    });
  }

  List<Widget> _buildItem() {
    List<Widget> _widgets = [];
    _widgets.add(new GankPicItem(_girlImage));
    _itemData.forEach((title, gankInfos) {
      _widgets.add(new GankTitleItem(title));
      gankInfos.forEach((gankInfo) {
        _widgets.add(new GankListItem(gankInfo));
      });
    });
    return _widgets;
  }

  @override
  Widget build(BuildContext context) {
    return _itemData == null
        ? new Center(child: const CircularProgressIndicator())
        : new Container(
            color: Theme.of(context).backgroundColor,
            child: new RefreshIndicator(
                child: new ListView(children: _buildItem()),
                onRefresh: _onRefresh));
  }

  @override
  bool get wantKeepAlive => true;
}