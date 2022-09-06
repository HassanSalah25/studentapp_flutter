class studentmodel{
  String _name;
  String _describion;
  int _pass;
  String _date;
  int _id;

  studentmodel(this._name, this._describion, this._pass, this._date);

  studentmodel.newConst(this._id,this._name, this._describion, this._pass, this._date);

  int get id => _id;

  String get date => _date;

  int get pass => _pass;

  String get describion => _describion;

  String get name => _name;

  set date(String value) {
    if(value.length <=255)
      _date = value;
  }

  set pass(int value) {
    if(value >=1 && value <=2)
     _pass = value;
  }

  set describion(String value) {
    if(value.length <=255)
      _describion = value;
  }

  set name(String value) {
    if(value.length <=255)
      _name = value;
  }

  Map<String, dynamic>  toMap(){
    var map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = this._name;
    map['describion'] = this._describion;
    map['pass'] = this._pass;
    map['date'] = this._date;
    return map;

  }
  studentmodel.getMap(Map<String, dynamic>  map){
    this._id = map['id'];
    this._name = map['name'];
    this._describion = map['describion'];
    this._pass = map['pass'];
    this._date = map['date'];
  }
}