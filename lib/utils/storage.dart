import 'dart:async';
import 'dart:convert';

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
  dynamic read(String key) {
    // var completer = Completer();
    // return kDatabase.transaction((transaction) async {
    //   final record = store.record(key);
    //   final result = await record.get(transaction);
    //   return result;
    // });
    return Map.from(_values[key]);
  }

  @override
  Future<void> write(String key, value) {
    return kDatabase.transaction((transaction) async {
      final record = store.record(key);
      await record.put(transaction, value);
    });
  }

  final _values = <String, dynamic>{};

  Future<void> preloadValues() async {
    try {
      // load values
      final records = await store.find(kDatabase);
      for (final record in records) {
        final string = json.encode(record.value);
        _values[record.key] = json.decode(string);
        // _values[record.key] = record.value;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

Future<void> setupHydratedBlocStorage() async {
  if (kIsWeb) {
    kDatabase = await databaseFactoryWeb.openDatabase('hydrated_bloc');
    HydratedBloc.storage = CustomStorage();
    await (HydratedBloc.storage as CustomStorage).preloadValues();
  } else {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
    );
  }
}
