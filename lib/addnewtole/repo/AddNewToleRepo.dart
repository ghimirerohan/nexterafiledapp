
import 'package:server_repository/models.dart';
import 'package:server_repository/repository.dart';

class AddNewToleRepo{

  CreateToleApiRepo createToleApiRepo = CreateToleApiRepo();

  Future<bool> postNewTole(
  {required int ne_qrtole_add_id , required String toleName,
      required String toleHeadName , required String toleHeadPhoneNumber ,
  required String ward}
      )async{
    NECreateTole newToleToPost = NECreateTole(<String, dynamic>{});
    newToleToPost.ward = Ward(id: ward , identifier: ward);
    newToleToPost.name = toleName;
    newToleToPost.neToleheadName = toleHeadName;
    newToleToPost.neToleheadPhoneno = toleHeadPhoneNumber;
    newToleToPost.neQrtoleAddID=NeQrtoleAddID(id: ne_qrtole_add_id);

    NECreateTole? posted = await createToleApiRepo.postNewToleDraft(newToleToPost);
    if(posted != null){
      return true;
    }else{
      return false;
    }
  }
}