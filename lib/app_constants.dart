abstract class FFAppConstants {
  /// Base URL for all API endpoints
  static const String baseUrl = 'https://api.knex-app.xyz/api';

  /// Ticket Management Endpoints
  static const String ticketListURL = '$baseUrl/getTicketList';
  static const String createticketURL = '$baseUrl/createTicketForAttendant';
  static const String createcasualTicket = '$baseUrl/createProvisionalTicket';
  static const String settickettoprocessing = '$baseUrl/setTicketToProcessing';
  static const String setTicketToParked = '$baseUrl/ticketToParked';
  static const String setTicketToCancel = '$baseUrl/setTicketToCancel';
  static const String setTicketStatus = '$baseUrl/setTicketStatus';

  /// Search Endpoint
  static const String searchURL = '$baseUrl/search';

  /// User Management Endpoints
  static const String getUserURL = '$baseUrl/getUser';

  /// Tip/Payment Endpoints
  static const String setTipURL = '$baseUrl/setTicketTip';

  /// Messaging Endpoints (Note: These may need to use /search endpoint based on OpenAPI spec)
  static const String getMessagesURL =
      '$baseUrl/search'; // Updated: no dedicated getMessages endpoint in spec
  static const String postMessage =
      '$baseUrl/search'; // Updated: no generateMessageData endpoint in spec

  /// Location Endpoints
  static const String createLocation = '$baseUrl/createLocation';
  static const String updateLocation = '$baseUrl/updateLocation';
  static const String getLocationsForCompany =
      '$baseUrl/getLocationsForCompany';

  /// Departure Endpoints
  static const String setToDeparture = '$baseUrl/setToDeparture';
  static const String setToDepartureCasual = '$baseUrl/setToDepartureCasual';

  /// Legacy/External URLs
  static const String registerphonstaticurl =
      'https://lobby.knex-app.xyz/register-phone';

  /// Deprecated endpoints (kept for backward compatibility, but not in OpenAPI spec)
  @Deprecated('This endpoint does not exist in the OpenAPI specification')
  static const String setPINtoticket = '$baseUrl/setPINtoticket';

  @Deprecated('This endpoint does not exist in the OpenAPI specification')
  static const String setPINtoCompleted = '$baseUrl/setPINtoCompleted';
}
