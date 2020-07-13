import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fuel_cost_statistics/add_record_page.dart';
import 'package:fuel_cost_statistics/easyLoding/easy_loading.dart';
import 'package:fuel_cost_statistics/event_bus.dart';
import 'package:fuel_cost_statistics/my_tools.dart';
import 'package:fuel_cost_statistics/refueling_record_data.dart';
import 'package:fuel_cost_statistics/refueling_record_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'easyLoding/loading.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: FlutterEasyLoading(
              child: child,
            ),
          );
        },
        home: MyHomePage(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          RefreshLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
        ],
        locale: Locale('zh'),
      ),
      footerBuilder: () {
        return ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double allMoney = 0.0;
  double allKilometers = 0.0;
  double allVolume = 0.0;
  double fuelConsumption = 0.0;
  double fuelConsumptionPerHundredKilometers = 0.0;
  RefreshController _controller = RefreshController();

  void _incrementCounter() {
    MyTools().toPage(context, AddRecordPage(), (then) {});
  }

  @override
  void initState() {
    super.initState();
    initData();
    EventBus().on('add', (f) {
      initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('油费统计'),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(right: 12),
              child: Text('加油记录'),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              height: 40,
              alignment: Alignment.center,
            ),
            onTap: () {
              MyTools().toPage(context, RefuelingRecordPage(), (then) {});
            },
            behavior: HitTestBehavior.translucent,
          )
        ],
      ),
      body: SmartRefresher(
        controller: _controller,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 12,
              ),
              Padding(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                child: Icon(
                                  Icons.attach_money,
                                  color: Color(0x50FFFFFF),
                                  size: 50,
                                ),
                                margin: EdgeInsets.only(top: 5),
                              ),
                              Center(
                                child: Text(
                                  '$allMoney',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          height: 80,
                        ),
                        onTap: () {
                          EasyLoading.showToast('油费');
                        },
                        behavior: HitTestBehavior.translucent,
                      ),
                    ),
                    Container(
                      width: 12,
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                child: Icon(
                                  Icons.access_time,
                                  color: Color(0x50FFFFFF),
                                  size: 50,
                                ),
                                margin: EdgeInsets.only(top: 5),
                              ),
                              Center(
                                child: Text(
                                  '$allKilometers',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          height: 80,
                        ),
                        onTap: () {
                          EasyLoading.showToast('里程数');
                        },
                        behavior: HitTestBehavior.translucent,
                      ),
                    ),
                    Container(
                      width: 12,
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                child: Icon(
                                  Icons.whatshot,
                                  color: Color(0x50FFFFFF),
                                  size: 50,
                                ),
                                margin: EdgeInsets.only(top: 5),
                              ),
                              Center(
                                child: Text(
                                  '$allVolume',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          height: 80,
                        ),
                        onTap: () {
                          EasyLoading.showToast('油耗');
                        },
                        behavior: HitTestBehavior.translucent,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                height: 50,
                margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                padding: EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  children: <Widget>[
                    Text(
                      '每公里油钱',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          '$fuelConsumption ¥',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                height: 50,
                margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                padding: EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  children: <Widget>[
                    Text(
                      '百公里油耗',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          '$fuelConsumptionPerHundredKilometers L',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    color: const Color(0xff2c4260),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 450,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.transparent,
                            tooltipPadding: const EdgeInsets.all(0),
                            tooltipBottomMargin: 8,
                            getTooltipItem: (
                              BarChartGroupData group,
                              int groupIndex,
                              BarChartRodData rod,
                              int rodIndex,
                            ) {
                              return BarTooltipItem(
                                rod.y.round().toString(),
                                TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: SideTitles(
                            showTitles: true,
                            textStyle: TextStyle(
                                color: const Color(0xff7589a2),
                                fontWeight: FontWeight.normal,
                                fontSize: 8),
                            margin: 20,
                            getTitles: (double value) {
                              return RefuelingRecordData()
                                  .refuelingRecordData[value.toInt()]
                                  .time
                                  .substring(5);
                            },
                          ),
                          leftTitles: SideTitles(showTitles: false),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: initBarData(),
                      ),
                    ),
                  ),
                ),
                margin: EdgeInsets.only(left: 8, right: 8, top: 8),
              )
            ],
          ),
        ),
        onRefresh: onRefresh,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  initData() async {
    allKilometers = 0.0;
    allMoney = 0.0;
    allVolume = 0.0;
    fuelConsumption = 0.0;
    await RefuelingRecordData().getRefuelingRecordData(1);
    RefuelingRecordData().refuelingRecordData.forEach((f) {
      allMoney += double.parse(f.money);

      allVolume += double.parse(f.volume);
    });
    if (RefuelingRecordData().refuelingRecordData.length > 1) {
      allKilometers = double.parse(RefuelingRecordData()
              .refuelingRecordData[
                  RefuelingRecordData().refuelingRecordData.length - 1]
              .kilometers) -
          double.parse(RefuelingRecordData().refuelingRecordData[0].kilometers);
      fuelConsumption = ((allMoney -
                      double.parse(RefuelingRecordData()
                          .refuelingRecordData[
                              RefuelingRecordData().refuelingRecordData.length -
                                  1]
                          .money)) /
                  (double.parse(RefuelingRecordData()
                          .refuelingRecordData[
                              RefuelingRecordData().refuelingRecordData.length -
                                  1]
                          .kilometers) -
                      double.parse(RefuelingRecordData()
                          .refuelingRecordData[0]
                          .kilometers)) *
                  100)
              .round() /
          100;
      fuelConsumptionPerHundredKilometers = ((allVolume -
                      double.parse(RefuelingRecordData()
                          .refuelingRecordData[
                              RefuelingRecordData().refuelingRecordData.length -
                                  1]
                          .volume)) /
                  (double.parse(RefuelingRecordData()
                          .refuelingRecordData[
                              RefuelingRecordData().refuelingRecordData.length -
                                  1]
                          .kilometers) -
                      double.parse(RefuelingRecordData()
                          .refuelingRecordData[0]
                          .kilometers)) *
                  10000)
              .round() /
          100;
    }
    setState(() {});
  }

  initBarData() {
    List<BarChartGroupData> items = [];
    for (int i = 0;
        i < (RefuelingRecordData().refuelingRecordData.length);
        i++) {
      items.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(
            y: double.parse(RefuelingRecordData().refuelingRecordData[i].money),
            color: Colors.lightBlueAccent)
      ], showingTooltipIndicators: [
        0
      ]));
    }
    return items;
  }

  onRefresh() {
    initData();
    _controller.refreshCompleted();
  }
}
