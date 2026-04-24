class UserPersona {
  final String id;
  final String name;
  final String segment;
  final String description;
  final String avatarChar;
  final String preferredMarketplaceCategory;
  final bool showPersonalizedDashboard;

  const UserPersona({
    required this.id,
    required this.name,
    required this.segment,
    required this.description,
    required this.avatarChar,
    required this.preferredMarketplaceCategory,
    this.showPersonalizedDashboard = false,
  });

  UserPersona copyWith({
    String? id,
    String? name,
    String? segment,
    String? description,
    String? avatarChar,
    String? preferredMarketplaceCategory,
    bool? showPersonalizedDashboard,
  }) {
    return UserPersona(
      id: id ?? this.id,
      name: name ?? this.name,
      segment: segment ?? this.segment,
      description: description ?? this.description,
      avatarChar: avatarChar ?? this.avatarChar,
      preferredMarketplaceCategory:
          preferredMarketplaceCategory ?? this.preferredMarketplaceCategory,
      showPersonalizedDashboard:
          showPersonalizedDashboard ?? this.showPersonalizedDashboard,
    );
  }

  static const List<UserPersona> presets = [
    UserPersona(
      id: 'student',
      name: 'Alex',
      segment: 'Student',
      description: 'Budget-focused, tech-savvy, looking for deals.',
      avatarChar: 'A',
      preferredMarketplaceCategory: 'education',
    ),
    UserPersona(
      id: 'professional',
      name: 'Sarah',
      segment: 'Young Professional',
      description: 'Growing income, interested in investing & travel.',
      avatarChar: 'S',
      preferredMarketplaceCategory: 'travel',
    ),
    UserPersona(
      id: 'family',
      name: 'The Smiths',
      segment: 'Established Family',
      description: 'Mortgage, insurance, savings for children.',
      avatarChar: 'T',
      preferredMarketplaceCategory: 'housing',
    ),
    UserPersona(
      id: 'retiree',
      name: 'James',
      segment: 'Retiree',
      description: 'High wealth, pension management, leisure.',
      avatarChar: 'J',
      preferredMarketplaceCategory: 'retirement',
    ),
  ];
}
