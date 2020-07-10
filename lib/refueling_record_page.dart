import 'package:flutter/material.dart';
import 'package:fuel_cost_statistics/db/refueling_record_sql_util.dart';
import 'package:fuel_cost_statistics/event_bus.dart';
import 'package:fuel_cost_statistics/my_views.dart';
import 'package:fuel_cost_statistics/refueling_record_data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefuelingRecordPage extends StatefulWidget {
  @override
  _RefuelingRecordPageState createState() => _RefuelingRecordPageState();
}

class _RefuelingRecordPageState extends State<RefuelingRecordPage> {
  RefreshController controller = RefreshController(initialRefresh: true);

  int page = 1;

  bool isDel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyViews().returnAndMoreAppBar('加油记录', context, [
        Container(
          child: GestureDetector(
            child: Container(
              height: 34,
              width: 80,
              margin: EdgeInsets.only(right: 12),
              child: Text(isDel ? '删除' : '编辑'),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(17),
                  ),
                  color: isDel ? Colors.redAccent : Colors.lightBlue),
              alignment: Alignment.center,
            ),
            onTap: () async {
              if(isDel){
                String ids = '';
                RefuelingRecordData().refuelingRecordData.forEach((bean) {
                  if (bean.isDel) {
                    ids += '${bean.id},';
                  }
                });
                if (ids.endsWith(',')) {
                  ids = ids.substring(0, ids.length - 1);
                }
                await RefuelingRecordSqlUtil().delRefuelingRecords(ids);
                EventBus().emit('add');
              }
              setState(() {
                if (isDel) {
                  RefuelingRecordData().refuelingRecordData.removeWhere((e) {
                    return e.isDel;
                  });
                }
                isDel = !isDel;
              });
            },
          ),
          alignment: Alignment.center,
        )
      ]),
      backgroundColor: Colors.grey[200],
      body: SmartRefresher(
        controller: controller,
        child: ListView.builder(
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                RefuelingRecordData()
                                    .refuelingRecordData[index]
                                    .time,
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${RefuelingRecordData().refuelingRecordData[index].kilometers} KM',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          Container(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '${RefuelingRecordData().refuelingRecordData[index].money} RMB',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${RefuelingRecordData().refuelingRecordData[index].volume} L',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      child: Checkbox(
                          value: RefuelingRecordData()
                              .refuelingRecordData[index]
                              .isDel,
                          onChanged: (b) {
                            setState(() {
                              RefuelingRecordData()
                                      .refuelingRecordData[index]
                                      .isDel =
                                  !RefuelingRecordData()
                                      .refuelingRecordData[index]
                                      .isDel;
                            });
                          }),
                      visible: isDel,
                    )
                  ],
                ),
                padding: EdgeInsets.all(12),
              ),
            );
          },
          itemCount: RefuelingRecordData().refuelingRecordData.length,
        ),
        onRefresh: onRefresh,
        onLoading: onLoading,
        enablePullUp: true,
        enablePullDown: true,
      ),
    );
  }

  onRefresh() async {
    await RefuelingRecordData().getRefuelingRecordData(page);
    setState(() {
      controller.refreshCompleted();
    });
  }

  onLoading() async {
    page++;
    await RefuelingRecordData().getRefuelingRecordData(page);
    setState(() {
      controller.loadComplete();
    });
  }
}
