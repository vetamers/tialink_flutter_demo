import 'package:tialink/features/main/domain/entities/base_main_entities.dart';

enum DataSource { remote, local }

abstract class Home extends BaseEntity {
  String get label;
  Device get device;
  List<Door> get doors;

  @override
  List<Object?> get props => [uuid, label, doors, device];
}

abstract class Device extends BaseEntity {
  String get macAddress;
  String get secret; //TODO: Implement other method
  String get masterId;

  @override
  List<Object?> get props => [uuid, macAddress];
}

abstract class Door extends BaseEntity {
  String get label;
  String get homeId;
  int get buttonMode;

  @override
  List<Object?> get props => [uuid,label];
}
