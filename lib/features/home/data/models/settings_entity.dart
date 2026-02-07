import 'package:objectbox/objectbox.dart';

@Entity()
class AppSettings {
  @Id()
  int id;

  final bool isDarkMode;
  final bool isSoundEnabled;

  AppSettings({
    this.id = 0,
    this.isDarkMode = true,
    this.isSoundEnabled = true,
  });
}
