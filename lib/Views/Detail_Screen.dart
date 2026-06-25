import 'package:flutter/material.dart';
import '../Service/api_config.dart';
import 'edit_report_screen.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> report;

  const DetailScreen({super.key, required this.report});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Map<String, dynamic> _report;
  bool _isUpdating = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _report = Map<String, dynamic>.from(widget.report);
  }

  Color _typeColor(String type) {
    return type.toLowerCase() == 'lost'
        ? const Color(0xFFD32F2F)
        : const Color(0xFF2E7D32);
  }

  Future<void> _toggleStatus() async {
    final newStatus = _report['status'] == 'Claimed' ? 'Unclaimed' : 'Claimed';
    setState(() => _isUpdating = true);
    try {
      final result = await ApiConfig.updateReport(
        reportId: _report['report_id'].toString(),
        itemName: _report['item_name'],
        category: _report['category'],
        description: _report['description'],
        location: _report['location'],
        reportType: _report['report_type'],
        status: newStatus,
      );
      if (result['success'] == true) {
        setState(() => _report['status'] = newStatus);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Status updated to $newStatus'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Future<void> _deleteReport() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Report'),
        content: const Text('Are you sure you want to delete this report?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isDeleting = true);
    try {
      final result =
          await ApiConfig.deleteReport(_report['report_id'].toString());
      if (result['success'] == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report deleted'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1E3A5F)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = _report['report_type']?.toString() ?? 'Lost';
    final status = _report['status']?.toString() ?? 'Unclaimed';
    final isClaimed = status == 'Claimed';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Report Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            tooltip: 'Edit',
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditReportScreen(report: _report),
                ),
              );
              if (updated != null) {
                setState(() => _report = Map<String, dynamic>.from(updated));
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header card ─────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: _typeColor(type),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      type.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _report['item_name']?.toString() ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A5F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Reported by ${_report['user_name']?.toString() ?? 'Unknown'}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Details card ─────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _infoRow(Icons.category_outlined, 'Category',
                      _report['category']?.toString() ?? ''),
                  _infoRow(Icons.location_on_outlined, 'Location',
                      _report['location']?.toString() ?? ''),
                  _infoRow(Icons.description_outlined, 'Description',
                      _report['description']?.toString() ?? ''),
                  _infoRow(Icons.calendar_today_outlined, 'Date Reported',
                      _report['date_reported']?.toString() ?? ''),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),

      // ── Bottom buttons ──────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        color: Colors.white,
        child: Row(
          children: [
            // Delete button — bottom right
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isDeleting ? null : _deleteReport,
                icon: _isDeleting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.delete_outline),
                label: const Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const Spacer(),

            // Status toggle — bottom center
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isUpdating ? null : _toggleStatus,
                icon: _isUpdating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Icon(isClaimed
                        ? Icons.unpublished_outlined
                        : Icons.check_circle_outline),
                label: Text(isClaimed ? 'Set Unclaimed' : 'Set Claimed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isClaimed
                      ? const Color(0xFFE65100)
                      : const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const Spacer(),
            const SizedBox(width: 80),
          ],
        ),
      ),
    );
  }
}