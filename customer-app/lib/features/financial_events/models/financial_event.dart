class TodoItem {
  final String id;
  final String title;
  bool isCompleted;

  TodoItem({required this.id, required this.title, this.isCompleted = false});

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'isCompleted': isCompleted};
  }
}

class Guide {
  final String id;
  final String title;
  final String content;

  Guide({required this.id, required this.title, required this.content});

  factory Guide.fromJson(Map<String, dynamic> json) {
    return Guide(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'content': content};
  }
}

enum FinancialEventType {
  buyingHouse,
  havingBaby,
  gettingMarried,
  retirement,
  startingBusiness,
  university,
  startingSchool,
  christmas,
  anniversary,
  birthday,
  buyingCar,
  newJob,
  divorce,
  bereavement,
  gettingFit,
}

extension FinancialEventTypeExtension on FinancialEventType {
  String get displayName {
    switch (this) {
      case FinancialEventType.buyingHouse:
        return 'Buying a House';
      case FinancialEventType.havingBaby:
        return 'Having a Baby';
      case FinancialEventType.gettingMarried:
        return 'Getting Married';
      case FinancialEventType.retirement:
        return 'Retirement Planning';
      case FinancialEventType.startingBusiness:
        return 'Starting a Business';
      case FinancialEventType.university:
        return 'University';
      case FinancialEventType.startingSchool:
        return 'Starting School';
      case FinancialEventType.christmas:
        return 'Christmas';
      case FinancialEventType.anniversary:
        return 'Anniversary';
      case FinancialEventType.birthday:
        return 'Birthday';
      case FinancialEventType.buyingCar:
        return 'Buying a Car';
      case FinancialEventType.newJob:
        return 'New Job';
      case FinancialEventType.divorce:
        return 'Divorce';
      case FinancialEventType.bereavement:
        return 'Bereavement';
      case FinancialEventType.gettingFit:
        return 'Getting Fit';
    }
  }
}

class FinancialEvent {
  final String id;
  final String title;
  final FinancialEventType type;
  final DateTime date;
  final String location;
  final List<TodoItem> selectedTodos;
  final List<Guide> guides;

  // Common financial fields
  final double? budget;
  final double? depositAmount;

  // Scenario-specific fields stored as metadata for flexibility
  final Map<String, dynamic> metadata;

  FinancialEvent({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.location,
    required this.selectedTodos,
    required this.guides,
    this.budget,
    this.depositAmount,
    this.metadata = const {},
  });

  // Convenience getters for scenario-specific fields
  // Housing & Assets
  String? get propertyType => metadata['propertyType'] as String?;
  int? get bedrooms => metadata['bedrooms'] as int?;
  String? get vehicleType => metadata['vehicleType'] as String?;
  bool? get isNewVehicle => metadata['isNewVehicle'] as bool?;

  // Family & Relationships
  String? get hospitalName => metadata['hospitalName'] as String?;
  String? get venueName => metadata['venueName'] as String?;
  int? get guestCount => metadata['guestCount'] as int?;
  String? get personName => metadata['personName'] as String?;
  int? get personAge => metadata['personAge'] as int?;
  int? get anniversaryYears => metadata['anniversaryYears'] as int?;
  int? get recipientCount => metadata['recipientCount'] as int?;
  bool? get hasChildren => metadata['hasChildren'] as bool?;
  String? get relationship => metadata['relationship'] as String?;

  // Career & Education
  int? get targetRetirementAge => metadata['targetRetirementAge'] as int?;
  double? get currentPensionValue => metadata['currentPensionValue'] as double?;
  String? get businessType => metadata['businessType'] as String?;
  double? get startupCapital => metadata['startupCapital'] as double?;
  String? get institutionName => metadata['institutionName'] as String?;
  String? get courseName => metadata['courseName'] as String?;
  double? get tuitionFees => metadata['tuitionFees'] as double?;
  String? get childName => metadata['childName'] as String?;
  String? get schoolName => metadata['schoolName'] as String?;
  double? get newSalary => metadata['newSalary'] as double?;
  String? get companyName => metadata['companyName'] as String?;

  // Health & Wellness
  String? get fitnessGoal => metadata['fitnessGoal'] as String?;
  double? get targetWeight => metadata['targetWeight'] as double?;
  double? get targetDistance => metadata['targetDistance'] as double?;

  // Helper to create a copy with modified fields
  FinancialEvent copyWith({
    String? id,
    String? title,
    FinancialEventType? type,
    DateTime? date,
    String? location,
    List<TodoItem>? selectedTodos,
    List<Guide>? guides,
    double? budget,
    double? depositAmount,
    Map<String, dynamic>? metadata,
  }) {
    return FinancialEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      date: date ?? this.date,
      location: location ?? this.location,
      selectedTodos: selectedTodos ?? this.selectedTodos,
      guides: guides ?? this.guides,
      budget: budget ?? this.budget,
      depositAmount: depositAmount ?? this.depositAmount,
      metadata: metadata ?? this.metadata,
    );
  }

  // Helper to update a single metadata field
  FinancialEvent withMetadata(String key, dynamic value) {
    final newMetadata = Map<String, dynamic>.from(metadata);
    newMetadata[key] = value;
    return copyWith(metadata: newMetadata);
  }
}
