import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:work_log_fit/models/exercise.dart';
import 'package:work_log_fit/exercises_manager.dart';
import 'list_screen_base.dart';

class ExerciseListScreen extends BaseListScreen<Exercise> {
  ExerciseListScreen()
      : super(
          title: 'Work Log Fit - Exercices',
          boxName: 'exercices',
          emptyList: 'No exercices available. Please add a new exercice.',
          button1Name: 'Custom exercise',
          button1Icon: 'fitness_center',
          enableDeleteButton: false,
        );

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends BaseListScreenState<Exercise> {
  // This box will store custom exercises added by the user
  late Box<dynamic> customExercisesBox;
  final exerciseManager = ExerciseManager();

  // The list of exercises selected by the user to add to the program
  List<String> selectedExercises = [];

  @override
  String getItemString(Exercise ex) {
    return ex.name;
  }

  @override
  List<Widget> buildItemList(BuildContext context) {
    List<Widget> categorySections = [];
    exerciseManager.categories.forEach((category, exercises) {
      // Add a section header for the category
      categorySections.add(
        Container(
          color: themeColor,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      );
      // Add a list tile for each exercise in the category
      categorySections.addAll(exercises.map((exercise) {
        return ListTile(
          leading: ClipOval(
            child: Container(
              color: Colors.transparent,
              width: 50.0,
              height: 50.0,
              child: Image.asset(
                exercise.getImageIcon(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(exercise.name),
          onTap: () {
            if (!showDelete) {
              itemSelected(context, exercise);
            }
          },
          trailing: showDelete
              ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {},
                )
              : null,
        );
      }).toList());
    });
    return categorySections;
  }

  @override
  void itemSelected(BuildContext context, Exercise item) {
    Navigator.pop(context, item);
  }
}
