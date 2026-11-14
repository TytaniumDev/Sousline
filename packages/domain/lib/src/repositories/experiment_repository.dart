// An interface has no code to run; only its empty primary constructor
// would show up, as an uncovered line.
// coverage:ignore-file

import 'package:domain/src/entities/experiment.dart';
import 'package:domain/src/entities/recipe_snapshot.dart';
import 'package:domain/src/entities/recipe_version.dart';
import 'package:domain/src/value_objects/ids.dart';

/// A recipe's history: past versions and experiments (PRD 7.11).
abstract interface class ExperimentRepository() {
  /// Newest first.
  Stream<List<RecipeVersion>> watchVersions(RecipeId recipeId);

  /// Newest first.
  Stream<List<Experiment>> watchExperiments(RecipeId recipeId);

  Future<RecipeVersion?> getVersion(RecipeVersionId id);

  Future<Experiment?> getExperiment(ExperimentId id);

  Future<void> saveVersion(RecipeVersion version);

  Future<void> saveExperiment(Experiment experiment);

  Future<void> deleteExperiment(ExperimentId id);

  /// The recipe as it was at version [id], decoded from its snapshot.
  /// Null when the version does not exist.
  Future<RecipeSnapshot?> getVersionSnapshot(RecipeVersionId id);

  /// Starts an experiment on [recipeId] in one transaction: saves the
  /// current recipe as a version, copies it to a new working recipe, and
  /// creates an open experiment pointing at both.
  Future<Experiment> startExperiment(RecipeId recipeId);

  /// Makes experiment [id] the recipe in one transaction: saves the current
  /// recipe as a version, replaces the recipe's contents with the working
  /// recipe's, and marks the experiment adopted.
  Future<void> promoteExperiment(ExperimentId id);

  /// Restores version [id] in one transaction: saves the current recipe as
  /// a version, so the restore can itself be undone from history, then
  /// replaces the recipe's contents with the version's.
  Future<void> restoreVersion(RecipeVersionId id);
}
