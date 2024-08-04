class Profile {
  String userId;
  String email;
  bool completedOnboarding;
  Map<String, dynamic> personalInformation;
  Map<String, dynamic> physicalMeasurements;
  Map<String, dynamic> activityLevel;
  Map<String, dynamic> goal;
  Map<String, dynamic> dietaryPreferences;
  Map<String, dynamic> nutritionalGoals;
  Map<String, dynamic> fitnessEnvironment;
  Map<String, dynamic> trainingStyle;
  String? other;

  Profile({
    required this.userId,
    required this.email,
    this.completedOnboarding = false,
    Map<String, dynamic>? personalInformation,
    Map<String, dynamic>? physicalMeasurements,
    Map<String, dynamic>? activityLevel,
    Map<String, dynamic>? goal,
    Map<String, dynamic>? dietaryPreferences,
    Map<String, dynamic>? nutritionalGoals,
    Map<String, dynamic>? fitnessEnvironment,
    Map<String, dynamic>? trainingStyle,
    this.other,
  })  : personalInformation = personalInformation ??
            {
              'name': null,
              'age': null,
              'gender': null,
            },
        physicalMeasurements = physicalMeasurements ??
            {
              'currentWeight': null,
              'targetWeight': null,
              'height': null,
            },
        activityLevel = activityLevel ??
            {
              'activityLevel': null,
              'customActivityLevel': null,
            },
        goal = goal ??
            {
              'goal': null,
              'customGoal': null,
            },
        dietaryPreferences = dietaryPreferences ??
            {
              'dietaryPreferences': null,
              'customDietaryPreferences': null,
            },
        nutritionalGoals = nutritionalGoals ??
            {
              'nutritionalGoals': null,
              'customNutritionalGoals': null,
            },
        fitnessEnvironment = fitnessEnvironment ??
            {
              'fitnessEnvironment': null,
              'customFitnessEnvironment': null,
            },
        trainingStyle = trainingStyle ??
            {
              'trainingStyle': null,
              'customTrainingStyle': null,
            };

  factory Profile.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> initializeMap(
        Map<String, dynamic>? map, Map<String, dynamic> defaultValues) {
      if (map == null) {
        return defaultValues;
      }
      defaultValues.forEach((key, value) {
        if (!map.containsKey(key)) {
          map[key] = value;
        }
      });
      return map;
    }

    return Profile(
      userId: map['userId'] ?? '',
      email: map['email'] ?? '',
      completedOnboarding: map['completedOnboarding'] ?? false,
      personalInformation: initializeMap(map['personalInformation'], {
        'name': null,
        'age': null,
        'gender': null,
      }),
      physicalMeasurements: initializeMap(map['physicalMeasurements'], {
        'currentWeight': null,
        'targetWeight': null,
        'height': null,
      }),
      activityLevel: initializeMap(map['activityLevel'], {
        'activityLevel': null,
        'customActivityLevel': null,
      }),
      goal: initializeMap(map['goal'], {
        'goal': null,
        'customGoal': null,
      }),
      dietaryPreferences: initializeMap(map['dietaryPreferences'], {
        'dietaryPreferences': null,
        'customDietaryPreferences': null,
      }),
      nutritionalGoals: initializeMap(map['nutritionalGoals'], {
        'nutritionalGoals': null,
        'customNutritionalGoals': null,
      }),
      fitnessEnvironment: initializeMap(map['fitnessEnvironment'], {
        'fitnessEnvironment': null,
        'customFitnessEnvironment': null,
      }),
      trainingStyle: initializeMap(map['trainingStyle'], {
        'trainingStyle': null,
        'customTrainingStyle': null,
      }),
      other: map['other'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'completedOnboarding': completedOnboarding,
      'personalInformation': personalInformation,
      'physicalMeasurements': physicalMeasurements,
      'activityLevel': activityLevel,
      'goal': goal,
      'dietaryPreferences': dietaryPreferences,
      'nutritionalGoals': nutritionalGoals,
      'fitnessEnvironment': fitnessEnvironment,
      'trainingStyle': trainingStyle,
      'other': other,
    };
  }

  Map get allFields {
    return {
      "personalInformation": ["name", "age", "gender"],
      "physicalMeasurements": ["currentWeight", "targetWeight", "height"],
      "activityLevel": ["activityLevel", "customActivityLevel"],
      "goal": ["goal", "customGoal"],
      "dietaryPreferences": ["dietaryPreferences", "customDietaryPreferences"],
      "nutritionalGoals": ["nutritionalGoals", "customNutritionalGoals"],
      "fitnessEnvironment": ["fitnessEnvironment", "customFitnessEnvironment"],
      "trainingStyle": ["trainingStyle", "customTrainingStyle"],
      "other": null
    };
  }

  // Dynamic setter
  void operator []=(String key, Map<String, dynamic> value) {
    switch (key) {
      case 'personalInformation':
        personalInformation = value;
        break;
      case 'physicalMeasurements':
        physicalMeasurements = value;
        break;
      case 'activityLevel':
        activityLevel = value;
        break;
      case 'goal':
        goal = value;
        break;
      case 'dietaryPreferences':
        dietaryPreferences = value;
        break;
      case 'nutritionalGoals':
        nutritionalGoals = value;
        break;
      case 'fitnessEnvironment':
        fitnessEnvironment = value;
        break;
      case 'trainingStyle':
        trainingStyle = value;
        break;
      case 'other':
        other = value.toString();
        break;
      default:
        throw ArgumentError('Invalid key: $key');
    }
  }

  @override
  String toString() {
    return 'Profile(userId: $userId, email: $email, completedOnboarding: $completedOnboarding, personalInformation: $personalInformation, physicalMeasurements: $physicalMeasurements, activityLevel: $activityLevel, goal: $goal, dietaryPreferences: $dietaryPreferences, nutritionalGoals: $nutritionalGoals, fitnessEnvironment: $fitnessEnvironment, trainingStyle: $trainingStyle, other: $other)';
  }
}
