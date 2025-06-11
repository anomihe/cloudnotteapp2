// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis/calendar/v3.dart' as calendar;
// import 'package:googleapis_auth/googleapis_auth.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

// class GoogleCalendarManager {
//   // Scopes for Calendar access - read/write access
//   static const _scopes = [calendar.CalendarApi.calendarScope];
  
//   // Google Sign-In instance
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: _scopes,
//   );

//   // Calendar API client
//   calendar.CalendarApi? _calendarApi;

//   // Method to authenticate and initialize the Calendar API
//   Future<bool> authenticateWithGoogle() async {
//     try {
//       // Try to sign in silently first
//       GoogleSignInAccount? account = await _googleSignIn.signInSilently();
      
//       // If that fails, try explicit sign-in
//       account ??= await _googleSignIn.signIn();
//       if (account == null) {
//         // User canceled the sign-in flow
//         return false;
//       }

//       // Get authentication credentials
//       final GoogleSignInAuthentication googleAuth = await account.authentication;
//       final AccessCredentials credentials = AccessCredentials(
//         AccessToken(
//           'Bearer',
//           googleAuth.accessToken!,
//           DateTime.now().toUtc().add(const Duration(hours: 1)),
//         ),
//         googleAuth.idToken,
//         _scopes,
//       );

//       // Create authenticated HTTP client
//       final AuthClient httpClient = authenticatedClient(
//         http.Client(),
//         credentials,
//       );

//       // Initialize Calendar API client
//       _calendarApi = calendar.CalendarApi(httpClient);
//       return true;
//     } catch (e) {
//       print('Error authenticating with Google: $e');
//       return false;
//     }
//   }

//   // Method to create a new calendar event
//   Future<String?> addEvent({
//     required String title,
//     required String description,
//     required DateTime startTime,
//     required DateTime endTime,
//     String calendarId = 'primary',
//   }) async {
//     if (_calendarApi == null) {
//       bool authenticated = await authenticateWithGoogle();
//       if (!authenticated) return null;
//     }

//     try {
//       // Create event
//       final event = calendar.Event()
//         ..summary = title
//         ..description = description
//         ..start = calendar.EventDateTime()
//           ..dateTime = startTime
//           ..timeZone = startTime.timeZoneName
//         ..end = calendar.EventDateTime()
//           ..dateTime = endTime
//           ..timeZone = endTime.timeZoneName;

//       // Insert event to calendar
//       final result = await _calendarApi!.events.insert(event, calendarId);
//       return result.id;
//     } catch (e) {
//       print('Error adding event to calendar: $e');
//       return null;
//     }
//   }

//   // Method to list calendar events within a time range
//   Future<List<calendar.Event>> getEvents({
//     required DateTime startTime,
//     required DateTime endTime,
//     String calendarId = 'primary',
//   }) async {
//     if (_calendarApi == null) {
//       bool authenticated = await authenticateWithGoogle();
//       if (!authenticated) return [];
//     }

//     try {
//       // Format DateTime for API request
//       final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
//       final timeMino = formatter.format(startTime.toUtc());
//       final timeMaxt = formatter.format(endTime.toUtc());
//       final timeMin = DateTime.parse(timeMino); 
//       final timeMax = DateTime.parse(timeMaxt);

//       // Request events within time range
//       final events = await _calendarApi!.events.list(
//         calendarId,
//         timeMin: timeMin,
//         timeMax: timeMax,
//         singleEvents: true,
//         orderBy: 'startTime',
//       );

//       return events.items ?? [];
//     } catch (e) {
//       print('Error fetching events: $e');
//       return [];
//     }
//   }

//   // Method to update an existing event
//   Future<bool> updateEvent({
//     required String eventId,
//     required String title,
//     required String description,
//     required DateTime startTime,
//     required DateTime endTime,
//     String calendarId = 'primary',
//   }) async {
//     if (_calendarApi == null) {
//       bool authenticated = await authenticateWithGoogle();
//       if (!authenticated) return false;
//     }

//     try {
//       // Get the existing event
//       final existingEvent = await _calendarApi!.events.get(calendarId, eventId);
      
//       // Update event details
//       existingEvent
//         ..summary = title
//         ..description = description
//         ..start = calendar.EventDateTime()
//           ..dateTime = startTime
//           ..timeZone = startTime.timeZoneName
//         ..end = calendar.EventDateTime()
//           ..dateTime = endTime
//           ..timeZone = endTime.timeZoneName;

//       // Update the event in calendar
//       await _calendarApi!.events.update(existingEvent, calendarId, eventId);
//       return true;
//     } catch (e) {
//       print('Error updating event: $e');
//       return false;
//     }
//   }

//   // Method to delete an event
//   Future<bool> deleteEvent({
//     required String eventId,
//     String calendarId = 'primary',
//   }) async {
//     if (_calendarApi == null) {
//       bool authenticated = await authenticateWithGoogle();
//       if (!authenticated) return false;
//     }

//     try {
//       await _calendarApi!.events.delete(calendarId, eventId);
//       return true;
//     } catch (e) {
//       print('Error deleting event: $e');
//       return false;
//     }
//   }

//   // Method to sign out
//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//     _calendarApi = null;
//   }
// }