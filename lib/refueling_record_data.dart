import 'package:fuel_cost_statistics/db/refueling_record_sql_util.dart';
import 'package:fuel_cost_statistics/refueling_record_bean.dart';

class RefuelingRecordData {
  RefuelingRecordData._internal();

  static RefuelingRecordData _singleton = RefuelingRecordData._internal();

  factory RefuelingRecordData() => _singleton;

  List<RefuelingRecordBean> refuelingRecordData = [];

  getRefuelingRecordData(int i) async {
    if (i == 1) {
      refuelingRecordData.clear();
    }
    List<Map<String, dynamic>> maps = [];
    maps = await RefuelingRecordSqlUtil().queryRefuelingRecord(i, 2000);
    maps.forEach((element){
      refuelingRecordData.add(RefuelingRecordBean.fromJson(element));
    });
  }
}
