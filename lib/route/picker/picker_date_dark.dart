import 'package:flutter/material.dart';
import 'package:materialx_flutter/data/my_colors.dart';
import 'package:materialx_flutter/utils/tools.dart';
import 'package:materialx_flutter/widget/my_text.dart';
import 'package:materialx_flutter/widget/toolbar.dart';

class PickerDateDarkRoute extends StatefulWidget {

  PickerDateDarkRoute();

  @override
  PickerDateDarkRouteState createState() => new PickerDateDarkRouteState();
}


class PickerDateDarkRouteState extends State<PickerDateDarkRoute> {

  late Future<DateTime?> selectedDate;
  String date = "-";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar.getPrimarySettingAppbar(context, "Date Dark") as PreferredSizeWidget?,
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 45,
            color: Colors.grey[300],
            child: Text(date, style: MyText.title(context),),
          ),
          Align(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0, backgroundColor: MyColors.accent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(horizontal: 30)
              ),
              child: Text("PICK DATE", style: TextStyle(color: Colors.white)),
              onPressed: (){
                showDialogPicker(context);
              },
            ),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }



  void showDialogPicker(BuildContext context){
    selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );
    selectedDate.then((value) {
      setState(() {
        if(value == null) return;
        date = Tools.getFormattedDateSimple(value.millisecondsSinceEpoch);
      });
    }, onError: (error) {
      print(error);
    });
  }
}

