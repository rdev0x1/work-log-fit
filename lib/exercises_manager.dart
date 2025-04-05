import 'package:work_log_fit/models/exercise.dart';

class MuscleGroups {
  static const String abs = 'abs';
  static const String biceps = 'biceps';
  static const String triceps = 'triceps';
  static const String legs = 'legs';
  static const String chest = 'chest';
  static const String shoulder = 'shoulder';
  static const String back = 'back';
  static const String other = 'other';
}

class ExerciseManager {
// Singleton instance
  static final ExerciseManager _instance = ExerciseManager._internal();

  // Factory constructor
  factory ExerciseManager() {
    return _instance;
  }

  // Internal constructor
  ExerciseManager._internal() {
    // Initialize your data here
  }

  // Predefined categories and exercises
  final Map<String, List<Exercise>> categories = {
    'Abs': [
      Exercise(name: 'Crunches', muscleGroup: MuscleGroups.abs),
      Exercise(
          name: 'Flat bench leg raises',
          muscleGroup: MuscleGroups.abs),
      Exercise(name: 'Rotary torso', muscleGroup: MuscleGroups.abs),
      Exercise(name: 'Abdo crunch machine', muscleGroup: MuscleGroups.abs),
      Exercise(name: 'Stand leg raise', muscleGroup: MuscleGroups.abs),
    ],
    'Biceps': [
      Exercise(
          name: 'Preacher curl with machine',
          muscleGroup: MuscleGroups.biceps),
      Exercise(
          name: 'Standing biceps curl with cable',
          muscleGroup: MuscleGroups.biceps),
      Exercise(
          name: 'Preacher curl with barbell',
          muscleGroup: MuscleGroups.biceps),
      Exercise(
          name: 'Biceps curl with barbell',
          muscleGroup: MuscleGroups.biceps),
    ],
    'Triceps': [
      Exercise(
          name: 'Triceps dips using body weight',
          muscleGroup: MuscleGroups.triceps),
      Exercise(
          name: 'Triceps dips machine', muscleGroup: MuscleGroups.triceps),
      Exercise(
          name: 'Triceps extensions machine', muscleGroup: MuscleGroups.triceps),
      Exercise(
          name: 'Triceps pushdown with rope and cable',
          muscleGroup: MuscleGroups.triceps),
      Exercise(
          name: 'Triceps pushdown with cable',
          muscleGroup: MuscleGroups.triceps),
      Exercise(
          name: 'Straight Arm Push down',
          muscleGroup: MuscleGroups.triceps),
    ],
    'Legs': [
      Exercise(name: 'Leg press', muscleGroup: MuscleGroups.legs),
      Exercise(name: 'Barbell squat', muscleGroup: MuscleGroups.legs),
      Exercise(
          name: 'Leg extensions', muscleGroup: MuscleGroups.legs),
      Exercise(
          name: 'Lying leg curl machine',
          muscleGroup: MuscleGroups.legs),
      Exercise(
          name: 'Seated leg curl', muscleGroup: MuscleGroups.legs),
      Exercise(
          name: 'Smith machine squats',
          muscleGroup: MuscleGroups.legs),
      Exercise(
          name: 'Thigh abductor', muscleGroup: MuscleGroups.legs),
    ],
    'Chest': [
      Exercise(
          name: 'Butterfly machine', muscleGroup: MuscleGroups.chest),
      Exercise(
          name: 'Machine bench press',
          muscleGroup: MuscleGroups.chest),
      Exercise(
          name: 'Inclined bench press',
          muscleGroup: MuscleGroups.chest),
      Exercise(
          name: 'Smith machine bench press',
          muscleGroup: MuscleGroups.chest),
      Exercise(name: 'Push ups', muscleGroup: MuscleGroups.chest),
      Exercise(
          name: 'Smith machine inclined bench press',
          muscleGroup: MuscleGroups.chest),
      Exercise(name: 'Bench press', muscleGroup: MuscleGroups.chest),
    ],
    'Shoulder': [
      Exercise(
          name: 'Seated Shoulder press machine',
          muscleGroup: MuscleGroups.shoulder),
      Exercise(
          name: 'Lateral dumbbell raises',
          muscleGroup: MuscleGroups.shoulder),
    ],
    'Back': [
      Exercise(
          name: 'Wide grip lat pull down',
          muscleGroup: MuscleGroups.back),
      Exercise(
          name: 'Seated cable rows', muscleGroup: MuscleGroups.back),
      Exercise(name: 'Pull ups', muscleGroup: MuscleGroups.back),
      Exercise(
          name: 'Hyperextensions', muscleGroup: MuscleGroups.back),
    ],
    'Other': [],
  };
}
