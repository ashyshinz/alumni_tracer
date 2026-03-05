import 'package:flutter/material.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  // 1. DYNAMIC DATA LIST
  final List<Map<String, dynamic>> _uploadedDocuments = [
    {
      "id": 1,
      "fileName": "Diploma_2020.pdf",
      "info": "Diploma • 2.4 MB • 10/15/2024",
      "status": "Approved",
      "statusColor": Colors.green,
    },
    {
      "id": 2,
      "fileName": "Employment_Letter.pdf",
      "info": "Employment Proof • 1.2 MB • 11/18/2024",
      "status": "Pending",
      "statusColor": Colors.orange,
    },
    {
      "id": 3,
      "fileName": "Valid_ID.jpg",
      "info": "Valid ID • 856 KB • 11/10/2024",
      "status": "Approved",
      "statusColor": Colors.green,
      "feedback": "Admin Feedback: The ID image is too blurry. Please upload a clearer image.",
      "showResubmit": true,
    },
  ];

  // 2. DELETE FUNCTION WITH CONFIRMATION
  void _deleteDocument(int id, String fileName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Document"),
        content: Text("Are you sure you want to delete '$fileName'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _uploadedDocuments.removeWhere((doc) => doc['id'] == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$fileName deleted successfully")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // 3. DOWNLOAD SIMULATION
  void _downloadDocument(String fileName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Downloading $fileName..."),
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF3F3F3),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Document Upload Center",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
            ),
            const Text(
              "Upload and manage your verification documents",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // UPLOAD NEW DOCUMENT (GRID)
            _buildSectionContainer(
              title: "Upload New Document",
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2.8,
                children: [
                  _buildUploadDropZone("Diploma", "Official diploma or transcript"),
                  _buildUploadDropZone("Employment Proof", "Certificate of employment or payslip"),
                  _buildUploadDropZone("Valid ID", "Government-issued ID"),
                  _buildUploadDropZone("Other Documents", "Additional supporting documents"),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // UPLOADED DOCUMENTS LIST
            _buildSectionContainer(
              title: "Uploaded Documents",
              child: _uploadedDocuments.isEmpty
                  ? const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No documents uploaded yet.", style: TextStyle(color: Colors.grey))))
                  : Column(
                      children: _uploadedDocuments.map((doc) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: _buildDocumentItem(
                            doc['id'],
                            doc['fileName'],
                            doc['info'],
                            doc['status'],
                            doc['statusColor'],
                            feedback: doc['feedback'],
                            showResubmit: doc['showResubmit'] ?? false,
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionContainer({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildUploadDropZone(String title, String subtitle) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("File picker opened...")));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF673AB7), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.file_upload_outlined, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis),
                  const Text("Max 10MB", style: TextStyle(fontSize: 9, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(int id, String fileName, String info, String status, Color statusColor, {String? feedback, bool showResubmit = false}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.description_outlined, color: Colors.grey, size: 30),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fileName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(info, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              _buildStatusBadge(status, statusColor),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => _deleteDocument(id, fileName),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: "Delete File",
              ),
            ],
          ),
          if (feedback != null) ...[
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
              child: Text(feedback, style: TextStyle(color: Colors.red.shade900, fontSize: 13)),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              _buildActionButton(Icons.download_outlined, "Download", Colors.black87, () => _downloadDocument(fileName)),
              if (showResubmit) ...[
                const SizedBox(width: 10),
                _buildActionButton(Icons.replay_outlined, "Resubmit", Colors.blue, () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Resubmitting $fileName...")));
                }, isFilled: true),
              ],
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.5))),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 14, color: color),
          const SizedBox(width: 5),
          Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onPressed, {bool isFilled = false}) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        foregroundColor: isFilled ? Colors.white : color,
        backgroundColor: isFilled ? color : Colors.transparent,
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}