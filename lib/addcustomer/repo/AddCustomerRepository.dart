
import 'dart:convert';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:server_repository/models.dart';
import 'package:server_repository/server_repository.dart';

class AddCustomerRepository{

  final CBPGroupApiRepostory _apiRepostory = CBPGroupApiRepostory();
  final CreateCustomerApiRepository _createCustomerApiRepository = CreateCustomerApiRepository();
  final AttachmentApi _attachmentApi = AttachmentApi();
  final ImagePicker _picker = ImagePicker();


  Future<String?> getCardPhoto() async{
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if(photo != null){
      var result = await FlutterImageCompress.compressWithList(
        await photo.readAsBytes(),
        minWidth: 810,
        minHeight: 810,
        quality: 66,
      );
      if(result != null){
        String img64 = base64Encode(result);
        return img64;
      }

    }
  }
  Future<bool> postAttachment({required modelName, required int recordID , required String dataBase64}) async{
    return await _attachmentApi.uploadAttachment
      (modelName: modelName,
        recordID: recordID,
        dataBase64: dataBase64,
        fileName: "Card.jpeg");
  }
  Future<List<CBPGroup>> getCBPGroups() async{
      ApiResponse<List<CBPGroup>> response = await _apiRepostory.getCBPGroups();
      if(response.data != null){
        return response.data!;
      }else{
        throw("Could not Fetch Data");
      }
  }

  Future<NECreateCustomer> postCustomer({required int cBPGroupID ,required int cLocationID,
  required String name , required String phone ,
    required int ne_qrcustomeradd_id, required String billName,
    double? housestorynumber,String? email ,String? taxId, String? businessNo ,
    bool? hasCard , String? cardBase64}) async{
    hasCard = hasCard ?? false;
    NECreateCustomer toPost = NECreateCustomer(<String,dynamic>{});
    toPost.name = name;
    toPost.billName = billName;
    toPost.phone = phone;
    toPost.eMail = email;
    CBPGroupID groupID = CBPGroupID.copyWith(id: cBPGroupID);
    CBPGroupID locationID =CBPGroupID.copyWith(id: cLocationID);
    toPost.cLocationID = locationID;
    toPost.cBPGroupID= groupID;
    toPost.houseStoreyNumber = housestorynumber;
    toPost.hasCard = hasCard;
    toPost.taxId = taxId;
    if(businessNo != null){
      toPost.businessNo = businessNo;
    }
    toPost.neQrcustomerAddID = NeQrcustomerAddID(id: ne_qrcustomeradd_id);
    ApiResponse<NECreateCustomer> response = await _createCustomerApiRepository.postCreateCustomer(toPost);
    if(response.data == null){
      throw("Couldn't post data");
    }else{
      if(hasCard && cardBase64 != null){
        bool? isAttached = await postAttachment(
            modelName: NECreateCustomer.model
            , recordID: response.data!.id!,
            dataBase64: cardBase64);
      }
      return response.data!;
    }
  }

}