enum SyncOutcome { skipped, notModified, updated, partiallyUpdated }

class SyncResult {
  const SyncResult(this.outcome, {this.missingImages = 0});
  final SyncOutcome outcome;
  final int missingImages;
}
