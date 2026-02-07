import 'package:lexi_guess/features/game/data/models/level_entities.dart';
import 'package:lexi_guess/features/home/data/models/settings_entity.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import '../../objectbox.g.dart';

class ObjectBoxManager {
  late final Store store;
  late final Box<LevelProgress> levelBox;
  late final Box<DiscoveredWord> wordBox;
  late final Box<AppSettings> settingsBox;

  ObjectBoxManager._create(this.store) {
    levelBox = Box<LevelProgress>(store);
    wordBox = Box<DiscoveredWord>(store);
    settingsBox = Box<AppSettings>(store);
  }

  static Future<ObjectBoxManager> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: '${docsDir.path}/lexi_guess_db');
    return ObjectBoxManager._create(store);
  }
}
