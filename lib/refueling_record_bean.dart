class RefuelingRecordBean{
  String time;
  String money;
  String kilometers;
  String volume;
  int id;
  bool isDel = false;

  RefuelingRecordBean(this.time, this.money, this.kilometers, this.volume);

  RefuelingRecordBean.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    money = json['money'];
    id = json['id'];
    kilometers = json['kilometers'];
    volume = json['volume'];
  }

}