enum Gene {
  dom,
  codom,
  supercodom,
  resVisual,
  resHet,
  resPossHet,
  lineLocality,
}

class Genetic {
  final String geneID;
  final String name;
  final Gene trait;

  Genetic({required this.geneID, required this.name, required this.trait});

  String get geneName {
    if (trait == Gene.dom ||
        trait == Gene.lineLocality ||
        trait == Gene.codom ||
        trait == Gene.resVisual) {
      return name;
    } else {
      String hetText = '';
      if (trait == Gene.supercodom) {
        hetText = 'super';
      } else if (trait == Gene.resHet) {
        hetText = 'het';
      } else if (trait == Gene.resPossHet) {
        hetText = 'poss het';
      }
      return '$name [$hetText]';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'trait': trait.toString(),
    };
  }

  factory Genetic.fromMap(String id, Map<String, dynamic> data) {
    Gene gene = Gene.values.firstWhere(
      (element) => element.toString() == data['trait'],
      orElse: () => Gene.codom,
    );
    return Genetic(geneID: id, name: data['name'], trait: gene);
  }
}
