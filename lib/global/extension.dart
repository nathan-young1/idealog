import 'package:idealog/Databases/idealog-db/idealog_Db.dart';
import 'package:sqflite/sqflite.dart';

extension Trigger on Database{
  Future<void> transactionAndTrigger(Future Function(Transaction) action) async {
    await this.transaction(action);
    IdealogDb.notifyListeners();
  }
}