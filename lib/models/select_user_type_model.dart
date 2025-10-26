class SelectUserTypeModel {
  final String title;
  final String description;
  final String iconPath;
  final bool isSelected;

  SelectUserTypeModel({
    required this.title,
    required this.description,
    required this.iconPath,
    this.isSelected = false,
  });

  SelectUserTypeModel copyWith({
    String? title,
    String? description,
    String? iconPath,
    bool? isSelected,
  }) {
    return SelectUserTypeModel(
      title: title ?? this.title,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
