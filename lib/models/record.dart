import 'package:hive/hive.dart';

part 'record.g.dart';

@HiveType(typeId: 2)
class Record extends HiveObject {
  @HiveField(0)
  final String input;

  @HiveField(1)
  final String hebrew;

  @HiveField(2)
  final String names;

  @HiveField(3)
  final String plSounds;

  @HiveField(4)
  final String polish;

  @HiveField(5)
  final int sum;

  @HiveField(6)
  final int reduced;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final bool favorite;

  Record({
    required this.input,
    required this.hebrew,
    required this.names,
    required this.plSounds,
    required this.polish,
    required this.sum,
    required this.reduced,
    required this.createdAt,
    this.favorite = false,
  });

  Record copyWith({bool? favorite}) => Record(
    input: input,
    hebrew: hebrew,
    names: names,
    plSounds: plSounds,
    polish: polish,
    sum: sum,
    reduced: reduced,
    createdAt: createdAt,
    favorite: favorite ?? this.favorite,
  );
}
