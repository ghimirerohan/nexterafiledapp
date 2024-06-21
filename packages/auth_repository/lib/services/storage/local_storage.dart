
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {

  final storage =  const FlutterSecureStorage();

  Future<bool> setValue(String keys, String values)async{
    await storage.write( key: keys , value:values);
    return true ;
  }

  Future<dynamic> readValue(String keys)async{
    return await storage.read( key: keys , ) ;
  }

  Future<bool> clearValue(String key)async{
    await storage.delete(key: key);
    return true;
  }

}