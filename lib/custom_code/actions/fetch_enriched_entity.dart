// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import '../../services/http_request_manager.dart';

Future<String> fetchEnrichedEntity(
  String openapiJsonUrl,
  String url,
  String modelName,
  String property,
  String value,
  String idToken,
) async {
  _log('Starting for $modelName.$property=$value');
  
  try {
    // 1. Fetch OpenAPI JSON
    final openapiJsonResponse = await HttpRequestManager().get(
      uri: Uri.parse(openapiJsonUrl),
      priority: RequestPriority.background,
      description: 'fetchOpenAPI',
    );
    
    if (openapiJsonResponse.statusCode != 200) {
      _log('Failed to fetch OpenAPI JSON: ${openapiJsonResponse.statusCode}');
      return "{}";
    }
    
    final openapiJson = jsonDecode(openapiJsonResponse.body) as Map<String, dynamic>;

    // 2. Construct Search Request Body for initial search
    final searchRequestBody = {
      "idToken": idToken,
      "data": {
        "modelName": modelName,
        "searchCriteria": {property: value},
      },
    };

    // 3. Make Initial Search Request
    final searchResponse = await HttpRequestManager().post(
      uri: Uri.parse('$url/search'),
      headers: {'Content-Type': 'application/json'},
      body: searchRequestBody,
      priority: RequestPriority.normal,
      description: 'searchEntity: $modelName',
    );

    if (searchResponse.statusCode != 200) {
      _log('Initial search failed: ${searchResponse.statusCode}');
      return "{}";
    }

    final searchResult = jsonDecode(searchResponse.body) as Map<String, dynamic>;
    if (searchResult['results'] == null || (searchResult['results'] as List).isEmpty) {
      _log('No results found for initial search');
      return "{}";
    }

    Map<String, dynamic> entity = (searchResult['results'] as List).first as Map<String, dynamic>;

    // 4. Resolve Schema Relationships (nested function)
    Future<Map<String, dynamic>> resolveRelationships(
      Map<String, dynamic> entity,
      Map<String, dynamic> openapiJson,
      String baseUrl,
      String idToken,
    ) async {
      String? getModelNameFromRef(String ref) {
        final parts = ref.split('/');
        if (parts.length == 4 && parts[1] == 'components' && parts[2] == 'schemas') {
          return parts[3];
        }
        return null;
      }

      String? getEntitySchemaNameFromRef(String? ref) {
        if (ref == null) return null;
        return getModelNameFromRef(ref);
      }

      Future<Map<String, dynamic>?> fetchRelatedEntity(
        String baseUrl,
        String relatedModelName,
        String relatedId,
        String idToken,
      ) async {
        final relatedSearchRequestBody = {
          "idToken": idToken,
          "data": {
            "modelName": relatedModelName,
            "searchCriteria": {"id": relatedId},
          },
        };

        final relatedSearchResponse = await HttpRequestManager().post(
          uri: Uri.parse('$baseUrl/search'),
          headers: {'Content-Type': 'application/json'},
          body: relatedSearchRequestBody,
          priority: RequestPriority.background, // Related entity fetches are background
          description: 'fetchRelated: $relatedModelName',
        );

        if (relatedSearchResponse.statusCode != 200) {
          _log('Failed to fetch related entity ($relatedModelName): ${relatedSearchResponse.statusCode}');
          return null;
        }

        final relatedSearchResult = jsonDecode(relatedSearchResponse.body) as Map<String, dynamic>;
        if (relatedSearchResult['results'] == null || (relatedSearchResult['results'] as List).isEmpty) {
          _log('No results for related entity ($relatedModelName)');
          return null;
        }
        return (relatedSearchResult['results'] as List).first as Map<String, dynamic>;
      }

      final componentsSchemas = openapiJson['components']['schemas'] as Map<String, dynamic>;
      final entitySchemaName = getEntitySchemaNameFromRef(entity['\$ref']?.toString());
      Map<String, dynamic>? schema = entitySchemaName != null
          ? componentsSchemas[entitySchemaName] as Map<String, dynamic>?
          : null;

      if (schema == null) {
        // Try to find the schema based on the type of entity
        String currentSchemaName = '';
        if (entity.containsKey('ticket_number')) {
          currentSchemaName = 'Ticket';
        } else if (entity.containsKey('firstname') &&
            entity.containsKey('lastname') &&
            entity.containsKey('email') &&
            entity.containsKey('phone')) {
          if (entity.containsKey('photoURL')) {
            currentSchemaName = 'UserClient';
          } else if (entity.containsKey('status') &&
              (entity['status'] == 'active' || entity['status'] == 'inactive')) {
            currentSchemaName = 'UserAttendant';
          }
        } else if (entity.containsKey('vehicle_make') &&
            entity.containsKey('vehicle_model') &&
            entity.containsKey('license_plate')) {
          currentSchemaName = 'VehicleData';
        }

        if (currentSchemaName.isNotEmpty) {
          schema = componentsSchemas[currentSchemaName] as Map<String, dynamic>?;
        }
        if (schema == null) {
          return entity;
        }
      }

      for (final propertyName in entity.keys) {
        if (entity[propertyName] is String && (entity[propertyName] as String).isNotEmpty) {
          final propertySchema = schema['properties'][propertyName];
          if (propertySchema != null && propertySchema['\$ref'] != null) {
            final ref = propertySchema['\$ref'].toString();
            final relatedModelName = getModelNameFromRef(ref);
            if (relatedModelName != null) {
              final relatedId = entity[propertyName];

              if (relatedId != null && relatedId.toString().isNotEmpty) {
                final relatedEntity = await fetchRelatedEntity(
                  baseUrl,
                  relatedModelName,
                  relatedId.toString(),
                  idToken,
                );
                if (relatedEntity != null) {
                  entity[propertyName] = relatedEntity;
                  await resolveRelationships(
                    entity[propertyName] as Map<String, dynamic>,
                    openapiJson,
                    baseUrl,
                    idToken,
                  );
                }
              }
            }
          }
        }
      }
      return entity;
    }

    final enrichedEntity = await resolveRelationships(entity, openapiJson, url, idToken);
    
    _log('Completed');
    return jsonEncode(enrichedEntity);
  } catch (e) {
    _log('Error: $e');
    return "{}";
  }
}

// Simplified logging
void _log(String message) {
  print('[fetchEnrichedEntity] $message');
}
