
import 'Repo_controller.dart';


class DataController {

  final _repository = LocalDBRepository();


  Future delete({required String tableName, String? where, List<Object?>? whereArgs}) async {
    await _repository.delete(tableName: tableName, where: where, whereArgs: whereArgs);
  }

  Future add({required String tableName, required Map<String, dynamic> jsonMap}) async {
    await _repository.insertData(tableName: tableName, object: jsonMap);
  }

  Future update({required String tableName, required String primaryKey, required Map<String, dynamic> jsonMap}) async {
    await _repository.update(tableName: tableName, where: '$primaryKey = ?', whereArgs: ['${jsonMap[primaryKey]}'], object: jsonMap);
  }

  Future addOrUpdate({required String tableName, required String primaryKey, required Map<String, dynamic> jsonMap}) async {
    await _repository.ifExist(tableName: tableName, where: '$primaryKey = ?', whereArgs: ['${jsonMap[primaryKey]}'])
        ? await _repository.update(tableName: tableName, where: '$primaryKey = ?', whereArgs: ['${jsonMap[primaryKey]}'], object: jsonMap)
        : await _repository.insertData(tableName: tableName, object: jsonMap);
  }

  Future draft({required String tableName, required String primaryKey, required Map<String, dynamic> jsonMap}) async {
    //Map<String, dynamic> map = await addCommonValuesAndPK(primaryKey: primaryKey, jsonMap: jsonMap);
    await addOrUpdate(tableName: tableName, primaryKey: primaryKey, jsonMap: jsonMap);
  }


  Future<int> getDataCount({required String tableName, String? where}) async {
    int count = 0;
    count = await _repository.count(tableName: tableName, where: where);
    return count;
  }

}

