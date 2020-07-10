import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuel_cost_statistics/date_util.dart';
import 'package:fuel_cost_statistics/db/refueling_record_sql_util.dart';
import 'package:fuel_cost_statistics/easyLoding/easy_loading.dart';
import 'package:fuel_cost_statistics/event_bus.dart';
import 'package:fuel_cost_statistics/my_tools.dart';
import 'package:fuel_cost_statistics/my_views.dart';
import 'package:fuel_cost_statistics/refueling_record_bean.dart';
import 'package:fuel_cost_statistics/refueling_record_data.dart';

import 'MoneyTextInputFormatter.dart';

class AddRecordPage extends StatefulWidget {
  @override
  _AddRecordPageState createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  String refuelingTime;
  TextEditingController _oilVolumeController = TextEditingController();
  TextEditingController _moneyController = TextEditingController();
  TextEditingController _kilometersController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refuelingTime = DateUtil.getDateStrByDateTime(DateTime.now(),
        format: DateFormat.YEAR_MONTH_DAY);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: MyViews().returnAndMoreAppBar('添加加油记录', context, []),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: <Widget>[
                  Text(
                    '加油时间',
                    style: TextStyle(fontSize: 18),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        child: Text(
                          refuelingTime,
                          style: TextStyle(fontSize: 18),
                        ),
                        alignment: Alignment.centerRight,
                      ),
                      onTap: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (c) {
                              return Container(
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (dateTime) {
                                    if (dateTime == null) {
                                      return;
                                    }
                                    setState(() {
                                      refuelingTime =
                                          DateUtil.getDateStrByDateTime(
                                              dateTime,
                                              format:
                                                  DateFormat.YEAR_MONTH_DAY);
                                    });
                                  },
                                  initialDateTime: DateTime.now(),
                                  minimumYear: DateTime.now().year - 1,
                                  maximumYear: DateTime.now().year + 1,
                                ),
                                height: 200,
                              );
                            });
                      },
                      behavior: HitTestBehavior.translucent,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: Row(
                children: <Widget>[
                  Text(
                    '加油升数',
                    style: TextStyle(fontSize: 18),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _oilVolumeController,
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.numberWithOptions(),
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                        LengthLimitingTextInputFormatter(9),
                        MoneyTextInputFormatter()
                      ],
                      decoration: InputDecoration(
                          hintText: '加油升数',
                          hintStyle: TextStyle(fontSize: 18),
                          border: InputBorder.none),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: Row(
                children: <Widget>[
                  Text(
                    '加油金额',
                    style: TextStyle(fontSize: 18),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _moneyController,
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.numberWithOptions(),
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                        LengthLimitingTextInputFormatter(9),
                        MoneyTextInputFormatter()
                      ],
                      decoration: InputDecoration(
                          hintText: '加油金额',
                          hintStyle: TextStyle(fontSize: 18),
                          border: InputBorder.none),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: Row(
                children: <Widget>[
                  Text(
                    '里程数',
                    style: TextStyle(fontSize: 18),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _kilometersController,
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.numberWithOptions(),
                      inputFormatters: [
                        WhitelistingTextInputFormatter(
                          RegExp("[0-9.]"),
                        ),
                        LengthLimitingTextInputFormatter(9),
                        MoneyTextInputFormatter(),
                      ],
                      decoration: InputDecoration(
                          hintText: '里程数',
                          hintStyle: TextStyle(fontSize: 18),
                          border: InputBorder.none),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Container(
              height: 20,
            ),
            FlatButton(
              onPressed: () async {
                MyTools().hideSoftKeyboard(context);
                RefuelingRecordBean bean = RefuelingRecordBean(
                    refuelingTime,
                    _moneyController.text,
                    _kilometersController.text,
                    _oilVolumeController.text);
                await RefuelingRecordSqlUtil().addRefuelingRecord(bean);
                EventBus().emit('add');
                EasyLoading.showToast('添加成功');
                Navigator.pop(context);
              },
              child: Container(
                child: Text(
                  '确定',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        MyTools().hideSoftKeyboard(context);
      },
      behavior: HitTestBehavior.translucent,
    );
  }
}
