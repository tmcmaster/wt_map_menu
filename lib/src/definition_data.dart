class DefinitionData {
  static final none = DefinitionData.empty();

  final String title;
  final Map<String, dynamic> map;

  const DefinitionData({
    required this.title,
    required this.map,
  });

  factory DefinitionData.empty() => const DefinitionData(
        title: '',
        map: {},
      );
}
