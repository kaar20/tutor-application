class Evaluate {
  String sb;
   double mk;

  Evaluate({required this.sb, required this.mk});

  Map toJson() {
    return {
      'sb': sb,
      'mk': mk,
    };
  }
}

class EvaluateList {
  List<dynamic> evaluateList = [];

  EvaluateList({required this.evaluateList});
}

List<Evaluate> extractEvaluation(var evMap) {
List<Evaluate> evData = List.filled(evMap.length, Evaluate(sb: '', mk: 0.0));
for (int i = 0; i < evMap.length; i++) {    evData[i] = Evaluate(
      sb: evMap[i]['sb'].toString(),
      mk: double.parse(evMap[i]['mk'].toString()),
    );
  }

  return evData;
}
