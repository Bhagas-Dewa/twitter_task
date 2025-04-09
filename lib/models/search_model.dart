class SearchModel {
  final String name;
  final String username;
  final String imagePath;

  SearchModel({
    required this.name,
    required this.username,
    required this.imagePath,
  });
}

final List<SearchModel> suggestedUsers = [
  SearchModel(name: "Sab Khasanova", username: "@s_khasanova", imagePath: "assets/images/suggestion_pp1.png"),
  SearchModel(name: "Martha", username: "@craig_love", imagePath: "assets/images/suggestion_pp2.png"),
  SearchModel(name: "Tibitha Potter", username: "@mis_potter", imagePath: "assets/images/suggestion_pp3.png"),
  SearchModel(name: "Figma", username: "@figmadesign", imagePath: "assets/images/suggestion_pp4.png"),
  SearchModel(name: "Figma Plugins", username: "@FigmaPlugins", imagePath: "assets/images/suggestion_pp5.png"),
  SearchModel(name: "Reihan Nabibie", username: "@reihan_nb", imagePath: "assets/images/suggestion_pp6.png"),
];

