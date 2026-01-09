import 'package:hive/hive.dart';
import '../models/record.dart';

class Boxes {
  static const records = 'records_box';
  static Box<Record> getRecords() => Hive.box<Record>(records);
}
