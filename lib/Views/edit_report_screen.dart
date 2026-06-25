import 'package:flutter/material.dart';
import '../Service/api_config.dart';

class EditReportScreen extends StatefulWidget {
  final Map<String, dynamic> report;

  const EditReportScreen({super.key, required this.report});

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _itemNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;

  late String _selectedCategory;
  late String _selectedType;
  late String _selectedStatus;
  bool _isLoading = false;

  final List<String> _categories = [
    'Personal Item',
    'Books',
    'Electronics',
    'Others',
  ];
  final List<String> _types = ['Lost', 'Found'];
  final List<String> _statuses = ['Unclaimed', 'Claimed'];

  @override
  void initState() {
    super.initState();
    _itemNameController =
        TextEditingController(text: widget.report['item_name']);
    _descriptionController =
        TextEditingController(text: widget.report['description']);
    _locationController =
        TextEditingController(text: widget.report['location']);
    _selectedCategory = widget.report['category'] ?? 'Personal Item';
    _selectedType = widget.report['report_type'] ?? 'Lost';
    _selectedStatus = widget.report['status'] ?? 'Unclaimed';
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final result = await ApiConfig.updateReport(
        reportId: widget.report['report_id'].toString(),
        itemName: _itemNameController.text.trim(),
        category: _selectedCategory,
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        reportType: _selectedType,
        status: _selectedStatus,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Return updated report back to detail screen
        Navigator.pop(context, {
          ...widget.report,
          'item_name': _itemNameController.text.trim(),
          'category': _selectedCategory,
          'description': _descriptionController.text.trim(),
          'location': _locationController.text.trim(),
          'report_type': _selectedType,
          'status': _selectedStatus,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Update failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text('Edit Report',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Report type toggle ───────────────────────
              const Text('Report Type',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E3A5F),
                      fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: _types.map((type) {
                  final isSelected = _selectedType == type;
                  final color = type == 'Lost'
                      ? const Color(0xFFD32F2F)
                      : const Color(0xFF2E7D32);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = type),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? color : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: isSelected ? color : Colors.grey[300]!),
                        ),
                        child: Text(
                          type,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // ── Item name ────────────────────────────────
              TextFormField(
                controller: _itemNameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter item name' : null,
              ),
              const SizedBox(height: 16),

              // ── Category dropdown ────────────────────────
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 16),

              // ── Location ─────────────────────────────────
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter location' : null,
              ),
              const SizedBox(height: 16),

              // ── Description ──────────────────────────────
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description_outlined),
                  alignLabelWithHint: true,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 16),

              // ── Status dropdown ──────────────────────────
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  prefixIcon: Icon(Icons.info_outline),
                ),
                items: _statuses
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedStatus = v!),
              ),
              const SizedBox(height: 28),

              // ── Submit button ────────────────────────────
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text('Save Changes',
                        style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}