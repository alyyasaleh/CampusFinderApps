import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use 10.0.2.2 for Android emulator, localhost for Chrome/Windows
  static const String baseUrl = "http://10.0.2.2/lost_found_api";

  // ─── AUTH ───────────────────────────────────────────────

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return jsonDecode(response.body);
  }

  // ─── REPORTS ────────────────────────────────────────────

  static Future<List<dynamic>> getReports() async {
    final response = await http.get(Uri.parse("$baseUrl/get_reports.php"));
    final data = jsonDecode(response.body);
    return data['data'] ?? [];
  }

  static Future<Map<String, dynamic>> addReport({
    required int userId,
    required String title,
    required String description,
    required String category,
    required String type, // 'lost' or 'found'
    required String location,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_report.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "title": title,
        "description": description,
        "category": category,
        "type": type,
        "location": location,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateReport({
    required int id,
    required String title,
    required String description,
    required String category,
    required String type,
    required String location,
    required String status,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/update_report.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "title": title,
        "description": description,
        "category": category,
        "type": type,
        "location": location,
        "status": status,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteReport(int id) async {
    final response = await http.post(
      Uri.parse("$baseUrl/delete_report.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id}),
    );
    return jsonDecode(response.body);
  }
}
