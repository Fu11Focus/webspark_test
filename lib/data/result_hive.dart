import 'package:hive/hive.dart';

part 'result_hive.g.dart';

@HiveType(typeId: 0)
class ResultModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final Map<String, dynamic> result;

  @HiveField(2)
  final String path;

  ResultModel({
    required this.id,
    required this.result,
    required this.path,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'result': result, 'path': path};
  }
}
