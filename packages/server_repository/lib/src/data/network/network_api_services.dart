import 'dart:async';
import 'dart:io';
import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:server_repository/server_repository.dart';
import 'package:server_repository/src/models/generic_models/CLocation.dart';

import '../app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiService<ModelBase> implements BaseApiServices {
  @override
  Future getRecordApiResponse(int id) async {
    try {
      switch (ModelBase) {
        case MUser:
          MUser? response = await IdempiereClient()
              .getRecord<MUser>("/models/${MUser.model}", id, (json) => MUser(json))
              .timeout(const Duration(seconds: 20));
          return ApiResponse<MUser>.completed(response);
        case NEQrLocationAdd:
          NEQrLocationAdd? response = await IdempiereClient()
              .getRecord<NEQrLocationAdd>("/models/${NEQrLocationAdd.model}", id, (json) => NEQrLocationAdd(json))
              .timeout(const Duration(seconds: 20));
          return ApiResponse<NEQrLocationAdd>.completed(response);
        case NEQrCustomerAdd:
          NEQrCustomerAdd? response = await IdempiereClient()
              .getRecord<NEQrCustomerAdd>("/models/${NEQrCustomerAdd.model}", id, (json) => NEQrCustomerAdd(json))
              .timeout(const Duration(seconds: 20));
          return ApiResponse<NEQrCustomerAdd>.completed(response);
        case CLocation:
          CLocation? response = await IdempiereClient()
              .getRecord<CLocation>("/models/${CLocation.model}", id, (json) => CLocation(json))
              .timeout(const Duration(seconds: 20));
          return ApiResponse<CLocation>.completed(response);
        case CBpartner:
          CBpartner? response = await IdempiereClient()
              .getRecord<CBpartner>("/models/${CBpartner.model}", id, (json) => CBpartner(json))
              .timeout(const Duration(seconds: 20));
          return ApiResponse<CBpartner>.completed(response);
      }
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    } on APIException catch (e) {
      exceptionHandler(e.message, e.statusCode);
    } on Exception catch(e){
      exceptionHandler(e.toString() , 0);
    }
  }

  @override
  Future getDataApiResponse(
  {FilterBuilder? filter, List<String>? select , List<String>? orderBy}) async {
    try {
      switch (ModelBase) {
        case MUser:
      List<MUser> response = await IdempiereClient()
          .get<MUser>("/models/${MUser.model}", (json) => MUser(json),
      filter: filter, select: select ?? [] , orderBy : orderBy ?? []  )
          .timeout(const Duration(seconds: 20));
          return   ApiResponse<List<MUser>>.completed(response);
        case RestAuth:
          List<RestAuth> response = await IdempiereClient()
              .get<RestAuth>("/models/${RestAuth.model}", (json) => RestAuth(json),
              filter: filter, select: select ?? [] , orderBy : orderBy ?? [])
              .timeout(const Duration(seconds: 20));
          return   ApiResponse<List<RestAuth>>.completed(response);
        case CLocation:
          List<CLocation> response = await IdempiereClient()
              .get<CLocation>("/models/${CLocation.model}", (json) => CLocation(json),
              filter: filter, select: select ?? [] , orderBy : orderBy ?? [])
              .timeout(const Duration(seconds: 20));
          return   ApiResponse<List<CLocation>>.completed(response);
        case CBpartner:
          List<CBpartner> response = await IdempiereClient()
              .get<CBpartner>("/models/${CBpartner.model}", (json) => CBpartner(json),
              filter: filter, select: select ?? [] , orderBy : orderBy ?? [])
              .timeout(const Duration(seconds: 20));
          return   ApiResponse<List<CBpartner>>.completed(response);
        case CBPGroup:
          List<CBPGroup> response = await IdempiereClient()
              .get<CBPGroup>("/models/${CBPGroup.model}", (json) => CBPGroup(json),
              filter: filter , select: select ?? [] , orderBy : orderBy ?? [])
              .timeout(const Duration(seconds: 20));
          return   ApiResponse<List<CBPGroup>>.completed(response);
        case NECreateCustomer:
          List<NECreateCustomer> response = await IdempiereClient()
              .get<NECreateCustomer>("/models/${NECreateCustomer.model}", (json) => NECreateCustomer(json),
              filter: filter , select: select ?? [] , orderBy : orderBy ?? [])
              .timeout(const Duration(seconds: 20));
          return   ApiResponse<List<NECreateCustomer>>.completed(response);
        case CPeriod:
          List<CPeriod> response = await IdempiereClient()
              .get<CPeriod>("/models/${CPeriod.model}", (json) => CPeriod(json),
              filter: filter , select: select ?? [] , orderBy : orderBy ?? [])
              .timeout(const Duration(seconds: 20));
          return   ApiResponse<List<CPeriod>>.completed(response);
        case CPayment:
          List<CPayment> response = await IdempiereClient()
              .get<CPayment>("/models/${CPayment.model}", (json) => CPayment(json),
              filter: filter , select: select ?? [] , orderBy : orderBy ?? [])
              .timeout(const Duration(seconds: 20));
          return   ApiResponse<List<CPayment>>.completed(response);
      }
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    } on APIException catch (e) {
      exceptionHandler(e.message, e.statusCode);
    } on Exception catch(e){
      exceptionHandler(e.toString() , 0);
    }
  }

  @override
  Future getPutApiResponse( data) async{
    try {
      switch (ModelBase) {
        case MUser:
          MUser? response =await IdempiereClient().put<MUser>("/models/${MUser.model}", data)
              .timeout(const Duration(seconds: 20));
          return ApiResponse<MUser>.completed(response);
        case CLocation:
          CLocation? response =await IdempiereClient().put<CLocation>("/models/${CLocation.model}", data)
              .timeout(const Duration(seconds: 20));
          return ApiResponse<CLocation>.completed(response);
      }
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    } on APIException catch (e) {
      exceptionHandler(e.message, e.statusCode);
    } on Exception catch(e){
      exceptionHandler(e.toString() , 0);
    }
  }



  @override
  Future getPostApiResponse( dynamic data) async {
    try {
      switch (ModelBase) {
        case MUser:
          MUser? response =await IdempiereClient().post<MUser>("/models/${MUser.model}", data)
              .timeout(const Duration(seconds: 20));
          return ApiResponse<MUser>.completed(response);
        case CBpartner:
          CBpartner? response =await IdempiereClient().post<CBpartner>("/models/${CBpartner.model}", data)
              .timeout(const Duration(seconds: 20));
          return ApiResponse<CBpartner>.completed(response);
        case NECreateCustomer:
          NECreateCustomer? response =await IdempiereClient().post<NECreateCustomer>("/models/${NECreateCustomer.model}", data)
              .timeout(const Duration(seconds: 20));
          return ApiResponse<NECreateCustomer>.completed(response);
        case CPayment:
          CPayment? response =await IdempiereClient().post<CPayment>("/models/${CPayment.model}", data)
              .timeout(const Duration(seconds: 20));
          return ApiResponse<CPayment>.completed(response);
        case NECreateLocation:
          NECreateLocation? response =await IdempiereClient().post<NECreateLocation>("/models/${NECreateLocation.model}", data)
              .timeout(const Duration(seconds: 20));
          return ApiResponse<NECreateLocation>.completed(response);
      }
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    } on APIException catch (e) {
      exceptionHandler(e.message, e.statusCode);
    } on Exception catch(e){
      exceptionHandler(e.toString() , 0);
    }
  }

  @override
  Future<bool> authenticate({required String username, required String password,
    required int clientId, required int roleId ,required String lang}) async{

      try{
        LoginResponse login =
        await IdempiereClient().login("/auth/tokens", username, password);

        //using the first client id in loginresponse (just for example purposes)
        int clientId = login.clients.first.id!;
        List<Role> roles = await IdempiereClient().getRoles(clientId);

        //using the first role id in roles (just for example purposes)
        int roleId = roles.first.id!;
        List<Organization> orgs =
        await IdempiereClient().getOrganizations(clientId, roleId);

        //using the first org id in orgs (just for example purporses)
        int orgId = orgs.first.id!;
        List<Warehouse> warehouses =
        await IdempiereClient().getWarehouses(clientId, roleId, orgId);

        //using the first warehouseId in warehouses (just for example purposes)
        // int whId = warehouses.first.id!;

        //init session
        await IdempiereClient().initSession(
            "/auth/tokens", login.token, login.clients.first.id!, roleId,
            organizationId: orgId, language: "en_GB");
        // await IdempiereClient().oneStepLogin("/auth/tokens", username, password, clientId, roleId , language: lang);
        return true;

      }on SocketException {
        throw NoInternetException('No Internet Connection');
      } on TimeoutException {
        throw FetchDataException('Network Request time out');
      } on APIException catch (e) {
        exceptionHandler(e.message, e.statusCode);
      } on Exception catch(e){
        exceptionHandler(e.toString() , 0);
      }
      return false;
  }

  @override
  Future<ProcessSummary?> runProcess({required String slugName, Map<String, dynamic>? body}) async {
    try{
      if(body != null){
        ProcessSummary ps = await IdempiereClient().runProcess(
            "/processes/$slugName",
            params: body).timeout(const Duration(seconds: 60));
        return ps;
      }else{
        ProcessSummary ps = await IdempiereClient().runProcess(
            "/processes/$slugName"
        ).timeout(const Duration(seconds: 60));
        return ps;
      }
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    } on APIException catch (e) {
      exceptionHandler(e.message, e.statusCode);
    } on Exception catch(e){
      exceptionHandler(e.toString() , 0);
    }

  }


  void exceptionHandler(String msg, int? code) {
    switch (code) {
      case 400:
        throw BadRequestException(msg);
      case 500:
      case 404:
      case 401:
        throw UnauthorisedException(msg);
      default:
        throw FetchDataException(
            '${code == 0 ? "" : code} : $msg');
    }
  }




}
