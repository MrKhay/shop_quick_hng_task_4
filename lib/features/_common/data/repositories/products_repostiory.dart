import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../features.dart';

///
class ProdcutsRepostiory {
  /// Handles C.R.U.D operations on products
  const ProdcutsRepostiory();

  /// Returns list of [Product]
  Future<CustomResponse<List<Product>>> getProducts(Session session) async {
    final Uri url = Uri.parse(
        '$kTimuApiBaseUrl/products?organization_id=$kTimuOrganisationID&size=20');

    try {
      final http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Token ${session.accessToken}'
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body) as dynamic;
        final List<dynamic> items = data['items'] as List<dynamic>;

        final List<Product> products = List<dynamic>.from(items)
            .map((e) => Product.fromMap(e as Map<String, dynamic>))
            .toList();

        return CustomResponse<List<Product>>(value: products);
      } else {
        debugPrint('Failed to fetch data. Status code: ${response.statusCode}');
        return CustomResponse<List<Product>>(error: kSomethingWentWrong);
      }
    } on HttpException catch (e) {
      debugPrint('Error: $e');
      return CustomResponse<List<Product>>(error: kSomethingWentWrong);
    } catch (e) {
      debugPrint('Error: $e');
      return CustomResponse<List<Product>>(error: kSomethingWentWrong);
    }
  }
}
