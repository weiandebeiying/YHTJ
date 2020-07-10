import 'package:fuel_cost_statistics/db/sql_manager.dart';
import 'package:fuel_cost_statistics/refueling_record_bean.dart';
import 'package:sqflite/sqflite.dart';

class RefuelingRecordSqlUtil extends BaseDbProvider{

  final String name = 'MyRefuelingRecordSql';

  final String id = 'id';
  final String time = 'time';
  final String money = 'money';
  final String kilometers = 'kilometers';
  final String volume = 'volume';

  @override
  createTableString() {
     return '''
        create table $name (
        $id INTEGER PRIMARY KEY,
        $time TEXT,
        $money TEXT,
        $kilometers TEXT,
        $volume TEXT
        )
      ''';
  }

  @override
  index() {
    return '''
    CREATE INDEX idx_$name ON $name(
    ${this.time},
    ${this.money},
    ${this.kilometers},
    ${this.volume})
    ''';
  }

  @override
  tableName() {
    return name;
  }

  queryRefuelingRecord(int page, int count) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "select distinct ${this.time},"
            "${this.money},"
            "${this.id},"
            "${this.kilometers},"
            "${this.volume}"
            " from $name ORDER BY ${this.time} LIMIT ${count * (page - 1)},$count");
    return maps;
  }

  delRefuelingRecord(int id) async {
    Database db = await getDataBase();
    int count =
        await db.rawDelete('DELETE FROM $name WHERE ${this.id} = $id');
    return count == 1;
  }

  delRefuelingRecords(String ids) async {
    Database db = await getDataBase();
    int count =
    await db.rawDelete('DELETE FROM $name WHERE $id IN ($ids);');
    return count == 1;
  }

  addRefuelingRecord(RefuelingRecordBean bean) async {
    Database db = await getDataBase();
    try {
      int count = await db.rawInsert('''INSERT INTO $name (
        ${this.time},
        ${this.money},
        ${this.kilometers},
        ${this.volume}) 
        VALUES (
        \'${bean.time}\',
        \'${bean.money}\',
        \'${bean.kilometers}\',
        \'${bean.volume}\')''');
      return count;
    } catch (e) {
      print(e);
      return 1;
    }
  }
}