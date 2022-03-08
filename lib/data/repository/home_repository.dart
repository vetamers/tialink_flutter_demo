import 'package:auth/model/api_result.dart';
import 'package:tialink/data/models.dart';
import 'package:tialink/data/provider/home_provider.dart';
import 'package:tialink/data/repository/repository.dart';

class HomeRepository extends DataRepository<HomeProviders> {
  HomeRepository() : super(HomeProviders());

  Future<List<Home>> getHomes() async => provider.getHomes();

  Future<APIResultWithCallBack<String>> addHome(
          {required String label, required String deviceId}) =>
      provider.addHome(label, deviceId);

  Future<APIResult> quickAdd(
          {required String homeLabel,
          required String doorLabel,
          required String deviceMacAddress,
          required String deviceSecret,
          required int buttonMode}) async =>
      provider.quickSave(
          homeLabel, doorLabel, deviceMacAddress, deviceSecret, buttonMode.toString());
}
