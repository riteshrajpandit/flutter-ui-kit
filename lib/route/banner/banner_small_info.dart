import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:materialx_flutter/data/my_colors.dart';
import 'package:materialx_flutter/widget/my_text.dart';

class BannerSmallInfoRoute extends StatefulWidget {

  BannerSmallInfoRoute();

  @override
  BannerSmallInfoRouteState createState() => new BannerSmallInfoRouteState();
}

class BannerSmallInfoRouteState extends State<BannerSmallInfoRoute> with TickerProviderStateMixin{

  bool expand = false;
  late AnimationController controller;
  late Animation<double> animation, animationView;

  void onItemClick(int index, String obj) {
    togglePanel();
  }

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300),);

    animation = Tween(begin: 0.0, end: -0.5).animate(controller);
    animationView = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(milliseconds: 500), (){
        togglePanel();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        title: Text("Info", style: MyText.title(context)!.copyWith(
          color: MyColors.grey_60
        )), titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(color: MyColors.grey_60),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: Icon(Icons.call), onPressed: () {}),
          IconButton(icon: Icon(Icons.error_outline), onPressed: () {}),
        ]
      ),
      body: Stack(
        children: [
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Click button below to show\nor hide banner", textAlign: TextAlign.center, style: MyText.subhead(context)!.copyWith(
                    color: MyColors.grey_40
                )),
                Container(height: 15),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.transparent),
                  child: Text("SHOW / HIDE", style: TextStyle(color: Colors.blue),),
                  onPressed: (){
                    togglePanel();
                  },
                ),
              ],
            )
          ),
          SizeTransition(
            sizeFactor: animationView,
            child: Column(
              children: [
                Card(
                    margin: EdgeInsets.all(0),
                    elevation: 1, color: Colors.blue[400],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(width: 5),
                          Text("You are offline.", style: MyText.subhead(context)!.copyWith(color: Colors.white)),
                          Spacer(),
                          TextButton(
                            style: TextButton.styleFrom(foregroundColor: Colors.transparent),
                            child: Text("TURN ON WIFI", style: TextStyle(color: Colors.white),),
                            onPressed: (){
                              togglePanel();
                            },
                          ),
                        ],
                      ),
                    )
                ),
                Container(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void togglePanel(){
    if(!expand){
      controller.forward(from:0);
    } else {
      controller.reverse();
    }
    expand = !expand;
  }
}

