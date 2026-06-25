import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost/lost_found_api";

  // ─── AUTH ────────────────────────────────────────────────

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register.php"),
      body: {"name": name, "email": email, "password": password},
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login.php"),
      body: {"email": email, "password": password},
    );
    return jsonDecode(response.body);
  }

  // ─── REPORTS ─────────────────────────────────────────────

  static Future<List<dynamic>> getReports() async {
    final response = await http.get(Uri.parse("$baseUrl/get_reports.php"));
    final data = jsonDecode(response.body);
    return data['data'] ?? [];
  }

  static Future<Map<String, dynamic>> addReport({
    required String userId,
    required String itemName,
    required String category,
    required String description,
    required String location,
    required String reportType,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/add_report.php"),
      body: {
        "user_id": userId,
        "item_name": itemName,
        "category": category,
        "description": description,
        "location": location,
        "report_type": reportType,
        "status": "Unclaimed",
      },
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateReport({
    required String reportId,
    required String itemName,
    required String category,
    required String description,
    required String location,
    required String reportType,
    required String status,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/update_report.php"),
      body: {
        "report_id": reportId,
        "item_name": itemName,
        "category": category,
        "description": description,
        "location": location,
        "report_type": reportType,
        "status": status,
      },
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteReport(String reportId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/delete_report.php"),
      body: {"report_id": reportId},
    );
    return jsonDecode(response.body);
  }
}