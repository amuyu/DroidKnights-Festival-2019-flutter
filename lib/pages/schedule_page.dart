import 'package:droidknights/models/schedule_service.dart';
import 'package:droidknights/models/track_schedule.dart';
import 'package:droidknights/pages/session_detail_dialog.dart';
import 'package:droidknights/res/strings.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class SchedulePage extends StatelessWidget {
  static final int ITEMVIEW_TYPE_NORMAL = 0;
  static final int ITEMVIEW_TYPE_SESSTION = 1;

  Widget scheduleAppbar() {
    return TabBar(
        labelColor: Color(0xff40d225),
        unselectedLabelColor: Colors.grey,
        indicatorColor: Color(0xff40d225),
        tabs: <Widget>[
          Tab(text: Strings.SCHEDULE_TAB_TRACK1),
          Tab(text: Strings.SCHEDULE_TAB_TRACK2),
          Tab(text: Strings.SCHEDULE_TAB_TRACK3),
        ]
    );
  }

  Widget androidAppBarTitle() => Image.asset(
      Strings.SCHEDULE_TAB_IMAGES_APP_BAR,
      fit: BoxFit.fitHeight,
      height: 25,
    );

  Widget iosAppBarTitle() => Text(Strings.SCHEDULE_TAB_APPBAR_TITLE);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Platform.isAndroid ? androidAppBarTitle() : iosAppBarTitle(),
                bottom: scheduleAppbar()),
            body: TabBarView(
              children: <Widget>[
                trackScreen(Strings.SCHEDULE_TAB_JSON_TRACK_SCREEN1),
                trackScreen(Strings.SCHEDULE_TAB_JSON_TRACK_SCREEN2),
                trackScreen(Strings.SCHEDULE_TAB_JSON_TRACK_SCREEN3),
              ],
            )
        )
    );
  }

  Widget trackScreen(String filePath) {
    return FutureBuilder(
        future: loadSchedule(filePath),
        builder: (BuildContext context,
            AsyncSnapshot<List<ScheduleModel>> snapshot) {
          if (!snapshot.hasData) return Container(color: Colors.black);
          return Container(
            color: Colors.black,
            child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) => Column(
                    children: <Widget>[_itemView(context, snapshot.data[i])])),
          );
        });
  }

  Widget _itemView(context, data) {
    if (data.type == ITEMVIEW_TYPE_SESSTION) {
      return _showItemSection(context, data);
    } else {
      return _showItemNormal(context, data);
    }
  }

  Widget _showItemSection(context, data) {
    return ListTile(
      leading: Text(
        data.time,
        style: TextStyle(
            color: Theme.of(context).primaryColorLight, fontSize: 12.0),
      ),
      title: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(
            const Radius.circular(4.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFE9EEF6),
              blurRadius: 4.0,
              offset: Offset(0, 2.0),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              maxRadius: 28.0,
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
              backgroundImage: data.avatarUrl == ""
                  ? new Image.asset(Strings.IMAGES_DK_PROFILE).image
                  : new NetworkImage(
                      data.avatarUrl,
                    ),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 6.0)),
            Flexible(
              child: Container(
                constraints: BoxConstraints(minHeight: 60.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      data.name,
                      style:
                          TextStyle(color: Color(0xffa5b495), fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => showDetailPage(context, data),
    );
  }

  Widget _showItemNormal(context, data) {
    return ListTile(
      leading: Text(
        data.time,
        style: TextStyle(
            color: Theme.of(context).primaryColorLight, fontSize: 12.0),
      ),
      title: Text(
        data.title,
        style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16.0),
      ),
    );
  }

  showDetailPage(BuildContext context, data) {
    Navigator.of(context).push(SessionDetailDialog(data));
  }
}
