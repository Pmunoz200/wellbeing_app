class Profile {
  String userId;
  String? activityLevel;
  int? age;
  double? currentWeight;
  double? targetWeight;
  String? dietaryPreferences;
  List<String>? fitnessEnvironment;
  String? gender;
  List<String>? goal;
  double? height;
  String? name;
  String? nutritionalGoals;
  String? other;
  List<String>? trainingStyle;
  String? email;
  bool onboardingCompleted;

  Profile({
    required this.userId,
    this.activityLevel,
    this.age,
    this.currentWeight,
    this.targetWeight,
    this.dietaryPreferences,
    this.fitnessEnvironment,
    this.gender,
    this.goal,
    this.height,
    this.name,
    this.nutritionalGoals,
    this.other,
    this.trainingStyle,
    required this.email,
    required this.onboardingCompleted,
  });

  Profile.empty({
    required this.userId,
    required this.email,
  })  : onboardingCompleted = false,
        goal = [],
        fitnessEnvironment = [],
        trainingStyle = [];

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'activityLevel': activityLevel,
      'age': age,
      'currentWeight': currentWeight,
      'targetWeight': targetWeight,
      'dietaryPreferences': dietaryPreferences,
      'fitnessEnvironment': fitnessEnvironment,
      'gender': gender,
      'goal': goal,
      'height': height,
      'name': name,
      'nutritionalGoals': nutritionalGoals,
      'other': other,
      'trainingStyle': trainingStyle,
      'email': email,
      'onboardingCompleted': onboardingCompleted,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      userId: map['userId'],
      activityLevel: map['activityLevel'],
      age: map['age'],
      currentWeight: map['currentWeight'],
      targetWeight: map['targetWeight'],
      dietaryPreferences: map['dietaryPreferences'],
      fitnessEnvironment: List<String>.from(map['fitnessEnvironment']),
      gender: map['gender'],
      goal: List<String>.from(map['goal']),
      height: map['height'],
      name: map['name'],
      nutritionalGoals: map['nutritionalGoals'],
      other: map['other'],
      trainingStyle: List<String>.from(map['trainingStyle']),
      email: map['email'],
      onboardingCompleted: true,
    );
  }

  // Allows me to access the attributes of the object using strings
  dynamic operator [](String key) {
    switch (key) {
      case 'userId':
        return userId;
      case 'activityLevel':
        return activityLevel;
      case 'age':
        return age;
      case 'currentWeight':
        return currentWeight;
      case 'targetWeight':
        return targetWeight;
      case 'dietaryPreferences':
        return dietaryPreferences;
      case 'fitnessEnvironment':
        return fitnessEnvironment;
      case 'gender':
        return gender;
      case 'goal':
        return goal;
      case 'height':
        return height;
      case 'name':
        return name;
      case 'nutritionalGoals':
        return nutritionalGoals;
      case 'other':
        return other;
      case 'trainingStyle':
        return trainingStyle;
      case 'email':
        return email;
      case 'onboardingCompleted':
        return onboardingCompleted;
      default:
        throw ArgumentError('Invalid property name: $key');
    }
  }

  // Dynamic setter
  void operator []=(String key, dynamic value) {
    switch (key) {
      case 'userId':
        userId = value;
        break;
      case 'activityLevel':
        activityLevel = value;
        break;
      case 'age':
        age = int.parse(value);
        break;
      case 'currentWeight':
        currentWeight = double.parse(value);
        break;
      case 'targetWeight':
        targetWeight = double.parse(value);
        break;
      case 'dietaryPreferences':
        dietaryPreferences = value;
        break;
      case 'fitnessEnvironment':
        fitnessEnvironment = List<String>.from(value);
        break;
      case 'gender':
        gender = value;
        break;
      case 'goal':
        goal = List<String>.from(value);
        break;
      case 'height':
        height = double.parse(value);
        break;
      case 'name':
        name = value;
        break;
      case 'nutritionalGoals':
        nutritionalGoals = value;
        break;
      case 'other':
        other = value;
        break;
      case 'trainingStyle':
        trainingStyle = List<String>.from(value);
        break;
      case 'email':
        email = value;
        break;
      case 'onboardingCompleted':
        onboardingCompleted = value;
        break;
      default:
        throw ArgumentError('Invalid property name: $key');
    }
  }
}
