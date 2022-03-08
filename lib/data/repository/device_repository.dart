import 'package:tialink/data/models.dart';
import 'package:tialink/data/provider/device_provider.dart';
import 'package:tialink/data/repository/repository.dart';

class DeviceRepository extends DataRepository<DeviceProvider> {
  DeviceRepository() : super(DeviceProvider());

  Future<List<Device>> getDevice() async => provider.getDevice();

  Future<APIResultWithCallBack> addDevice({required String macAddress, required String secret}) async 
    => provider.addDevice(macAddress, secret);
}
