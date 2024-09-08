class ResultModel {
  final String id;
  final Map<String, dynamic> result;
  final Map exersice;

  ResultModel({
    required this.id,
    required this.result,
    required this.exersice,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'result': result, 'exersice': exersice};
  }
}
