class ConversationModel {
  final List<ConversationEntry> conversation;

  // Constructor to initialize the ConversationModel
  ConversationModel({required this.conversation});

  // Factory method to create a ConversationModel from JSON data
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    var conversationJson = json['conversation'] as List;
    List<ConversationEntry> conversationList = conversationJson.map((i) => ConversationEntry.fromJson(i)).toList();

    return ConversationModel(
      conversation: conversationList,
    );
  }

  // Method to convert ConversationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'conversation': conversation.map((e) => e.toJson()).toList(),
    };
  }
}

class ConversationEntry {
  final String role;
  final Content content;

  // Constructor to initialize the ConversationEntry
  ConversationEntry({required this.role, required this.content});

  // Factory method to create a ConversationEntry from JSON data
  factory ConversationEntry.fromJson(Map<String, dynamic> json) {
    return ConversationEntry(
      role: json['role'],
      content: Content.fromJson(json['content']),
    );
  }

  // Method to convert ConversationEntry to JSON
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content.toJson(),
    };
  }
}

class Content {
  final String summary;
  final String suggestion;
  final Food food;
  final Exercise exercise;

  // Constructor to initialize the Content
  Content({
    required this.summary,
    required this.suggestion,
    required this.food,
    required this.exercise,
  });

  // Factory method to create Content from JSON data
  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      summary: json['summary'],
      suggestion: json['suggestion'],
      food: Food.fromJson(json['food']),
      exercise: Exercise.fromJson(json['exercise']),
    );
  }

  // Method to convert Content to JSON
  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'suggestion': suggestion,
      'food': food.toJson(),
      'exercise': exercise.toJson(),
    };
  }
}

class Food {
  final String summary;
  final int caloriesConsumed;
  final int carbs;
  final int protein;
  final int fat;
  final String suggestion;

  // Constructor to initialize the Food
  Food({
    required this.summary,
    required this.caloriesConsumed,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.suggestion,
  });

  // Factory method to create Food from JSON data
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      summary: json['summary'],
      caloriesConsumed: json['calories_consumed'],
      carbs: json['carbs'],
      protein: json['protein'],
      fat: json['fat'],
      suggestion: json['suggestion'],
    );
  }

  // Method to convert Food to JSON
  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'calories_consumed': caloriesConsumed,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'suggestion': suggestion,
    };
  }
}

class Exercise {
  final String summary;
  final int caloriesBurned;
  final String? type;
  final List<String> muscleGroups;
  final String suggestion;

  // Constructor to initialize the Exercise
  Exercise({
    required this.summary,
    required this.caloriesBurned,
    this.type,
    required this.muscleGroups,
    required this.suggestion,
  });

  // Factory method to create Exercise from JSON data
  factory Exercise.fromJson(Map<String, dynamic> json) {
    var muscleGroupsFromJson = json['muscle_groups'];
    List<String> muscleGroupsList = muscleGroupsFromJson != null ? List<String>.from(muscleGroupsFromJson) : [];

    return Exercise(
      summary: json['summary'],
      caloriesBurned: json['calories_burned'],
      type: json['type'],
      muscleGroups: muscleGroupsList,
      suggestion: json['suggestion'],
    );
  }

  // Method to convert Exercise to JSON
  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'calories_burned': caloriesBurned,
      'type': type,
      'muscle_groups': muscleGroups,
      'suggestion': suggestion,
    };
  }
}
