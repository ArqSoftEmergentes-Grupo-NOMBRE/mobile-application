import 'dart:convert';
import '../../shared/services/http_client.dart';
import '../models/contract.dart';
import '../models/deliverable.dart';
import '../models/create_contract_args.dart';


abstract class IContractService {
  Future<List<Contract>> fetchAll();
  Future<Contract> fetchById(String id);
  Future<Contract> create(Contract contract);
  Future<bool> signContract(String id);
  Future<void> createContract(CreateContractArgs args);

}

class ContractService implements IContractService {
  static const _basePath = '/api/contracts';

  @override
  Future<List<Contract>> fetchAll() async {
    final res = await HttpClient.get(_basePath);
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list
          .map((e) => Contract.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Error fetching contracts: ${res.body}');
  }

  @override
  Future<Contract> fetchById(String id) async {
    final res = await HttpClient.get('$_basePath/$id');
    if (res.statusCode == 200) {
      return Contract.fromJson(jsonDecode(res.body));
    }
    throw Exception('Error fetching contract: ${res.body}');
  }

  @override
  Future<Contract> create(Contract contract) async {
    final res = await HttpClient.post(_basePath, contract.toJson());
    if (res.statusCode == 200 || res.statusCode == 201) {
      return Contract.fromJson(jsonDecode(res.body));
    }
    throw Exception('Error creating contract: ${res.body}');
  }

  @override
  Future<bool> signContract(String id) async {
    final res = await HttpClient.post('$_basePath/$id/sign', {});
    if (res.statusCode == 200) return true;
    throw Exception('Error signing contract: ${res.body}');
  }

  @override
  Future<void> createContract(CreateContractArgs args) async {
    final res = await HttpClient.post(_basePath, args.toJson());
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Error al crear contrato: ${res.body}');
    }
  }

  @override
  Future<void> finalizeContract(String id) async {
    final res = await HttpClient.post('$_basePath/$id/finalize', {});
    if (res.statusCode != 200) {
      throw Exception('Error finalizando contrato: ${res.body}');
    }
  }

}
