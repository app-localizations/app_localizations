import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

late Database kDatabase;

class CustomStorage extends Storage {
  final store = StoreRef<String, dynamic>('hydrated_bloc_storage');

  @override
  Future<void> clear() {
    return kDatabase.transaction((transaction) async {
      await store.delete(transaction);
    });
  }

  @override
  Future<void> close() {
    return kDatabase.close();
  }

  @override
  Future<void> delete(String key) {
    return kDatabase.transaction((transaction) async {
      final record = store.record(key);
      await record.delete(transaction);
    });
  }

  @override
  read(String key) {
    return kDatabase.transaction((transaction) async {
      final record = store.record(key);
      final result = await record.get(transaction);
      return result;
    });
  }

  @override
  Future<void> write(String key, value) {
    return kDatabase.transaction((transaction) async {
      final record = store.record(key);
      await record.put(transaction, value);
    });
  }
}

Future<void> setupHydratedBlocStorage() async {
  if (kIsWeb) {
    kDatabase = await databaseFactoryWeb.openDatabase('hydrated_bloc');
    HydratedBloc.storage = CustomStorage();
  } else {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
    );
  }
}
