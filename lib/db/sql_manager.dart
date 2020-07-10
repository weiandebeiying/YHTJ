import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlManager{

  static const _VERSION=1;

  static const _NAME="hdq.db";

  static Database _database;


  ///初始化
  static init() async {
    var databasesPath=await getDatabasesPath();

    String path = join(databasesPath, _NAME);

    _database=await openDatabase(path,version: _VERSION,onCreate: (Database db,int version) async{});
  }

  ///判断表是否存在
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res=await _database.rawQuery("select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res!=null && res.length >0;
  }

  ///获取当前数据库对象
  static Future<Database> getCurrentDatabase() async {
    if(_database == null){
      await init();
    }
    return _database;
  }

  ///关闭
  static close() {
    _database?.close();
    _database = null;
  }
}


abstract class BaseDbProvider   {
  bool isTableExits = false;

  createTableString();

  index();

  tableName();

  ///创建表sql语句
  tableBaseString(String sql) {
    return sql;
  }

  Future<Database> getDataBase() async {
    return await open();
  }

  ///super 函数对父类进行初始化
  @mustCallSuper
  prepare(name, String createSql) async {
    isTableExits = await SqlManager.isTableExits(name);
    if (!isTableExits) {
      Database db = await SqlManager.getCurrentDatabase();
      var e = await db.execute(createSql);
      await db.execute(index());
      return e;
    }
  }

  @mustCallSuper
  open() async {
    if (!isTableExits) {
      await prepare(tableName(), createTableString());
    }
    return await SqlManager.getCurrentDatabase();
  }

}