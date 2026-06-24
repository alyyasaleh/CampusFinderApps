import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use localhost for Chrome/Windows
  static const String baseUrl = "http://localhost/lost_found_api";

  // ─── AUTH ───────────────────────────────────────────────

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register.php"),
      body: {
        "name": name,
        "email": email,
        "password": password,
      },
    );

    print("REGISTER RESPONSE: ${response.body}");
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login.php"),
      body: {
        "email": email,
        "password": password,
      },
    );

    print("LOGIN RESPONSE: ${response.body}");
    return jsonDecode(response.body);
  }

  // ─── REPORTS ────────────────────────────────────────────

  static Future<List<dynamic>> getReports() async {
    // Your PHP file name is get_report.php, not get_reports.php
    final response = await http.get(
      Uri.parse("$baseUrl/get_report.php"),
    );

    print("GET REPORTS RESPONSE: ${response.body}");

    final data = jsonDecode(response.body);
    return data['data'] ?? [];
  }

  static Future<Map<String, dynamic>> addReport({
    required int userId,
    required String title,
    required String description,
    required String category,
    required String type,
    required String location,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_report.php"),
      body: {
        "user_id": userId.toString(),
        "item_name": title,
        "description": description,
        "category": category,
        "report_type": type,
        "location": location,
        "status": "Unclaimed",
      },
    );

    print("ADD REPORT RESPONSE: ${response.body}");
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
      body: {
        "report_id": id.toString(),
        "item_name": title,
        "description": description,
        "category": category,
        "report_type": type,
        "location": location,
        "status": status,
      },
    );

    print("UPDATE REPORT RESPONSE: ${response.body}");
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteReport(int id) async {
    final response = await http.post(
      Uri.parse("$baseUrl/delete_report.php"),
      body: {
        "report_id": id.toString(),
      },
    );

    print("DELETE REPORT RESPONSE: ${response.body}");
    return jsonDecode(response.body);
  }
}