
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:server_repository/models.dart';

import '../../constants.dart';
import '../../utils/LocalStorage.dart';

class AttachmentApi{

  final LocalStorage storage = LocalStorage();

  Future<AttachmentsFromRecordID> getAttachmentsFromRedorID({required String modelName,
  required int recordID}) async{
    String? restAuthToken = await storage.readValue("restauthtoken");
    var url = Uri.parse('${ApiConstants.baseUrl}/models/$modelName/'
        '$recordID/attachments');

    var response = await http.get(url,
        headers: <String , String>{
          'Content-Type': 'application/json',
          'Accept':'application/json',
          'Authorization': "Bearer $restAuthToken",
        }
    );
    if(response.statusCode ==  201 || response.statusCode ==  200) {
      AttachmentsFromRecordID model = AttachmentsFromRecordID.fromJson(jsonDecode(response.body));
      return model;
    }else{
      throw("Server error in attachment services");
  }


  }

  Future<bool> uploadAttachment(
  {required String modelName,
    required int recordID,
    required String dataBase64,
    required String fileName
  }
      ) async{

    String? restAuthToken = await storage.readValue("restauthtoken");

    var url = Uri.parse('${ApiConstants.baseUrl}/models/$modelName/'
        '$recordID/attachments');
    final msg  = jsonEncode({
      "name" : fileName,
      "data" : dataBase64
    });
    var response = await http.post(url,
        headers: <String , String>{
          'Content-Type': 'application/json',
          'Accept':'application/json',
          'Accept':'*/*',
          'Accept-Encoding':'gzip, deflate, br',
          'Authorization': "Bearer $restAuthToken",
        },
        body: msg
    );
    if(response.statusCode ==  201 || response.statusCode ==  200) {
      return true;
    }
    return false;
  }
}