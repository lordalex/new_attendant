// Automatic FlutterFlow imports
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchEnrichedEntity(
  String openapiJsonUrl,
  String url,
  String modelName,
  String property,
  String value,
  String idToken,
) async {
  // Add your function code here!
  try {
    // 1. Fetch OpenAPI JSON
    final openapiJsonResponse = await http.get(Uri.parse(openapiJsonUrl));
    if (openapiJsonResponse.statusCode != 200) {
      print('Failed to fetch OpenAPI JSON: ${openapiJsonResponse.statusCode}');
      return "{}";
    }
    final openapiJson =
        jsonDecode(openapiJsonResponse.body) as Map<String, dynamic>;

    // 2. Construct Search Request Body for initial search
    final searchRequestBody = {
      "idToken": idToken, // Include idToken in the request body
      "data": {
        "modelName": modelName,
        "searchCriteria": {property: value},
      },
    };

    // 3. Make Initial Search Request
    final searchResponse = await http.post(
      Uri.parse('$url/search'), // Assuming /search is the endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(searchRequestBody),
    );

    if (searchResponse.statusCode != 200) {
      print(
        'Initial search failed: ${searchResponse.statusCode}, body: ${searchResponse.body}',
      );
      return "{}"; // Or handle error based on response body
    }

    final searchResult =
        jsonDecode(searchResponse.body) as Map<String, dynamic>;
    if (searchResult['results'] == null ||
        (searchResult['results'] as List).isEmpty) {
      print('No results found for initial search.');
      return "{}";
    }

    Map<String, dynamic> entity =
        (searchResult['results'] as List).first as Map<String, dynamic>;

    // 4. Resolve Schema Relationships (nested function)
    Future<Map<String, dynamic>> resolveRelationships(
      Map<String, dynamic> entity,
      Map<String, dynamic> openapiJson,
      String baseUrl,
      String idToken, // Pass idToken to nested function
    ) async {
      String? getModelNameFromRef(String ref) {
        final parts = ref.split('/');
        if (parts.length == 4 &&
            parts[1] == 'components' &&
            parts[2] == 'schemas') {
          return parts[3];
        }
        return null; // Return null when model name cannot be extracted
      }

      String? getEntitySchemaNameFromRef(String? ref) {
        if (ref == null) return null;
        return getModelNameFromRef(ref);
      }

      Future<Map<String, dynamic>?> fetchRelatedEntity(
        String baseUrl,
        String relatedModelName,
        String relatedId,
        String idToken, // Pass idToken to nested function
      ) async {
        final relatedSearchRequestBody = {
          "idToken":
              idToken, // Include idToken in the request body for related entity search
          "data": {
            "modelName": relatedModelName,
            "searchCriteria": {
              "id": relatedId,
            }, // Assuming related entities are searched by 'id'
          },
        };

        final relatedSearchResponse = await http.post(
          Uri.parse('$baseUrl/search'), // Use the same /search endpoint
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(relatedSearchRequestBody),
        );

        if (relatedSearchResponse.statusCode != 200) {
          print(
            'Failed to fetch related entity ($relatedModelName with id: $relatedId): ${relatedSearchResponse.statusCode}, body: ${relatedSearchResponse.body}',
          );
          return null;
        }

        final relatedSearchResult =
            jsonDecode(relatedSearchResponse.body) as Map<String, dynamic>;
        if (relatedSearchResult['results'] == null ||
            (relatedSearchResult['results'] as List).isEmpty) {
          print(
            'No results found for related entity ($relatedModelName with id: $relatedId).',
          );
          return null;
        }
        return (relatedSearchResult['results'] as List).first
            as Map<String, dynamic>;
      }

      final componentsSchemas =
          openapiJson['components']['schemas'] as Map<String, dynamic>;
      final entitySchemaName = getEntitySchemaNameFromRef(
        entity['\$ref']?.toString(),
      ); // If entity itself is a ref
      Map<String, dynamic>? schema = entitySchemaName != null
          ? componentsSchemas[entitySchemaName] as Map<String, dynamic>?
          : null;

      if (schema == null) {
        //Try to find the schema based on the type of entity we are processing, assuming entity is Ticket in the first call
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
              (entity['status'] == 'active' ||
                  entity['status'] == 'inactive')) {
            currentSchemaName = 'UserAttendant';
          }
        } else if (entity.containsKey('vehicle_make') &&
            entity.containsKey('vehicle_model') &&
            entity.containsKey('license_plate')) {
          currentSchemaName = 'VehicleData';
        }

        if (currentSchemaName.isNotEmpty) {
          schema =
              componentsSchemas[currentSchemaName] as Map<String, dynamic>?;
        }
        if (schema == null) {
          return entity; // If schema not found, return entity as is
        }
      }

      for (final propertyName in entity.keys) {
        if (entity[propertyName] is String &&
            (entity[propertyName] as String).isNotEmpty) {
          final propertySchema = schema['properties'][propertyName];
          if (propertySchema != null && propertySchema['\$ref'] != null) {
            final ref = propertySchema['\$ref'].toString();
            final relatedModelName = getModelNameFromRef(ref);
            if (relatedModelName != null) {
              final relatedId =
                  entity[propertyName]; // Assuming ID is directly the value

              if (relatedId != null && relatedId.toString().isNotEmpty) {
                final relatedEntity = await fetchRelatedEntity(
                  baseUrl,
                  relatedModelName,
                  relatedId.toString(),
                  idToken, // Pass idToken to fetchRelatedEntity
                );
                if (relatedEntity != null) {
                  entity[propertyName] = relatedEntity;
                  await resolveRelationships(
                    // Recursively resolve relationships for the related entity
                    entity[propertyName] as Map<String, dynamic>,
                    openapiJson,
                    baseUrl,
                    idToken, // Pass idToken for recursive calls
                  );
                }
              }
            }
          }
        } else if (entity[propertyName] is Map<String, dynamic>) {
          // Handle nested objects, although in this schema, direct refs are strings
          // If you have nested object refs in your real schema, you might need to recursively call resolveRelationships here as well.
        } else if (entity[propertyName] is List) {
          // Handle lists if needed, for example if parkingSpace or lockerSpace were lists of refs
          // In this schema, parkingSpace and lockerSpace are complex objects already.
        }
      }
      return entity;
    }

    final enrichedEntity = await resolveRelationships(
      entity,
      openapiJson,
      url,
      idToken, // Pass idToken to resolveRelationships
    );

    return jsonEncode(enrichedEntity); // Return JSON string
  } catch (e) {
    print('Error in fetchEnrichedEntity: $e');
    return "{}";
  }
}
