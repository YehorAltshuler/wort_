import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/citizenship_test/view/citizenship_exam_page.dart';
import 'package:wort_flutter/citizenship_test/view/citizenship_result_page.dart';
import 'package:wort_flutter/citizenship_test/view/citizenship_test_home_page.dart';
import 'package:wort_flutter/citizenship_test/view/citizenship_training_page.dart';
import 'package:wort_flutter/citizenship_test/view/citizenship_training_setup_page.dart';
import 'package:wort_flutter/collections/view/collection_page.dart';
import 'package:wort_flutter/exercises/view/exercise_setup_page.dart';
import 'package:wort_flutter/exercises/view/exercise_training_page.dart';
import 'package:wort_flutter/exercises/view/exercise_words_page.dart';
import 'package:wort_flutter/exercises/view/exercises_page.dart';
import 'package:wort_flutter/learning/view/coursebooks_page.dart';
import 'package:wort_flutter/learning/view/module_page.dart';
import 'package:wort_flutter/learning/view/module_words_page.dart';
import 'package:wort_flutter/learning/view/modules_page.dart';
import 'package:wort_flutter/learning/view/session_page.dart';
import 'package:wort_flutter/learning/view/session_setup_page.dart';
import 'package:wort_flutter/navigation/view/navigation_page.dart';
import 'package:wort_flutter/word_details/view/word_details_page.dart';

final appRouter = GoRouter(
  initialLocation: AppRoute.learning,
  routes: [
    for (var index = 0; index < AppRoute.paths.length; index++)
      GoRoute(
        path: AppRoute.paths[index],
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: const ValueKey('navigation-page'),
          child: NavigationPage(initialIndex: index),
        ),
      ),
    GoRoute(
      path: AppRoute.coursebooks,
      builder: (context, state) => const CoursebooksPage(),
    ),
    GoRoute(
      path: AppRoute.exercises,
      builder: (context, state) => const ExercisesPage(),
    ),
    GoRoute(
      path: AppRoute.exerciseSetupPattern,
      builder: (context, state) => ExerciseSetupPage(
        exerciseId: state.pathParameters['exerciseId']!,
        initialFilter: state.uri.queryParameters['filter'] ?? 'all',
      ),
    ),
    GoRoute(
      path: AppRoute.exerciseTrainingPattern,
      builder: (context, state) => ExerciseTrainingPage(
        exerciseId: state.pathParameters['exerciseId']!,
        difficulty: state.uri.queryParameters['difficulty'] ?? 'easy',
        filter: state.uri.queryParameters['filter'] ?? 'all',
      ),
    ),
    GoRoute(
      path: AppRoute.exerciseWordListPattern,
      builder: (context, state) => ExerciseWordListPage(
        filter: state.uri.queryParameters['filter'] ?? 'all',
      ),
    ),
    GoRoute(
      path: AppRoute.exerciseWordsPattern,
      builder: (context, state) => ExerciseWordsPage(
        exerciseId: state.pathParameters['exerciseId']!,
      ),
    ),
    GoRoute(
      path: AppRoute.citizenshipTest,
      builder: (context, state) => const CitizenshipTestHomePage(),
    ),
    GoRoute(
      path: AppRoute.wordDetailsPattern,
      builder: (context, state) => WordDetailsPage(
        lexemeId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: AppRoute.modulesPattern,
      builder: (context, state) => ModulesPage(
        bookId: state.pathParameters['bookId']!,
      ),
    ),
    GoRoute(
      path: AppRoute.modulePattern,
      builder: (context, state) => ModulePage(
        bookId: state.pathParameters['bookId']!,
        moduleFile: state.pathParameters['moduleFile']!,
      ),
    ),
    GoRoute(
      path: AppRoute.moduleWordsPattern,
      builder: (context, state) => ModuleWordsPage(
        bookId: state.pathParameters['bookId'],
        moduleFile: state.pathParameters['moduleFile'],
        initialFilter: state.uri.queryParameters['type'] ?? 'all',
      ),
    ),
    GoRoute(
      path: AppRoute.sessionSetupPattern,
      builder: (context, state) => SessionSetupPage(
        bookId: state.pathParameters['bookId'],
        moduleFile: state.pathParameters['moduleFile'],
        initialFilter: state.uri.queryParameters['type'] ?? 'all',
      ),
    ),
    GoRoute(
      path: AppRoute.sessionPattern,
      builder: (context, state) => SessionPage(
        bookId: state.pathParameters['bookId'],
        moduleFile: state.pathParameters['moduleFile'],
        type: state.uri.queryParameters['type'] ?? 'all',
        difficulty: state.uri.queryParameters['difficulty'] ?? 'easy',
      ),
    ),
    GoRoute(
      path: AppRoute.collectionWordsPattern,
      builder: (context, state) => ModuleWordsPage.collection(
        collectionId: state.pathParameters['collectionId'],
        initialFilter: state.uri.queryParameters['type'] ?? 'all',
      ),
    ),
    GoRoute(
      path: AppRoute.collectionSetupPattern,
      builder: (context, state) => SessionSetupPage.collection(
        collectionId: state.pathParameters['collectionId'],
        initialFilter: state.uri.queryParameters['type'] ?? 'all',
      ),
    ),
    GoRoute(
      path: AppRoute.collectionSessionPattern,
      builder: (context, state) => SessionPage.collection(
        collectionId: state.pathParameters['collectionId'],
        type: state.uri.queryParameters['type'] ?? 'all',
        difficulty: state.uri.queryParameters['difficulty'] ?? 'easy',
      ),
    ),
    GoRoute(
      path: AppRoute.collectionPattern,
      builder: (context, state) => CollectionPage(
        collectionId: state.pathParameters['collectionId']!,
      ),
    ),
    GoRoute(
      path: AppRoute.citizenshipTrainingSetup,
      builder: (context, state) => const CitizenshipTrainingSetupPage(),
    ),
    GoRoute(
      path: AppRoute.citizenshipTraining,
      builder: (context, state) => CitizenshipTrainingPage(
        filter: state.uri.queryParameters['filter'] ?? 'all',
        randomOrder: state.uri.queryParameters['random'] == 'true',
        sessionId: state.uri.queryParameters['sessionId'],
        startNew: state.uri.queryParameters['startNew'] == 'true',
      ),
    ),
    GoRoute(
      path: AppRoute.citizenshipExam,
      builder: (context, state) => CitizenshipExamPage(
        startNew: state.uri.queryParameters['startNew'] == 'true',
      ),
    ),
    GoRoute(
      path: AppRoute.citizenshipResultPattern,
      builder: (context, state) => CitizenshipResultPage(
        sessionId: state.pathParameters['sessionId']!,
      ),
    ),
  ],
);
