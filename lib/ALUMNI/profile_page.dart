import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final String? initialName;
  final String? initialEmail;

  const ProfilePage({
    super.key, 
    this.initialName, 
    this.initialEmail,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // --- State Variables ---
  bool _isEditing = false;
  bool _isLoading = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Dynamic Skills List
  final List<String> _skills = ["JavaScript", "React", "Node.js"];

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final TextEditingController _phoneController = TextEditingController(text: "+63 912 345 6789");
  final TextEditingController _addressController = TextEditingController(text: "Butuan City, Philippines");

  @override
  void initState() {
    super.initState();
    // Initialize with data from Shell/Login
    _nameController = TextEditingController(text: widget.initialName ?? "Alumni User");
    _emailController = TextEditingController(text: widget.initialEmail ?? "alumni@jmc.edu.ph");
    
    // Updates the bold header name in real-time
    _nameController.addListener(() {
      setState(() {}); 
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // --- Actions ---

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name cannot be empty"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate Network Latency
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _isEditing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showAddSkillDialog() {
    final TextEditingController skillController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Skill"),
        content: TextField(
          controller: skillController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "e.g. Flutter, Python, SQL",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF420031), foregroundColor: Colors.white),
            onPressed: () {
              if (skillController.text.isNotEmpty) {
                setState(() {
                  _skills.add(skillController.text.trim());
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FA),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),

            // PROFILE SUMMARY CARD
            _buildSectionCard(
              child: Row(
                children: [
                  _buildProfileAvatar(),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nameController.text, 
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D3436))
                        ),
                        Text(
                          _emailController.text, 
                          style: const TextStyle(color: Color(0xFF0984E3), fontSize: 15)
                        ),
                        const SizedBox(height: 4),
                        const Text("Batch 2024 • BS Information Technology", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // PERSONAL INFORMATION SECTION
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Personal Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      _buildEditButton(),
                    ],
                  ),
                  const Divider(height: 30),
                  Row(
                    children: [
                      Expanded(child: _buildField("Full Name", _nameController, Icons.person_outline)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildField("Email Address", _emailController, Icons.email_outlined)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildField("Phone Number", _phoneController, Icons.phone_outlined)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildField("Account Status", TextEditingController(text: "Verified Alumni"), Icons.verified_user, canEdit: false)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildField("Residential Address", _addressController, Icons.location_on_outlined),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // SKILLS SECTION
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Professional Skills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ..._skills.map((skill) => _buildSkillChip(skill)),
                      if (_isEditing) 
                        ActionChip(
                          avatar: const Icon(Icons.add, size: 16, color: Color(0xFF420031)),
                          label: const Text("Add Skill"),
                          onPressed: _showAddSkillDialog,
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFC5CAE9)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Profile Management",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF420031)),
        ),
        Text(
          "Update your personal and professional profile for the tracer study",
          style: TextStyle(fontSize: 15, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
          ),
          child: CircleAvatar(
            radius: 55,
            backgroundColor: Colors.grey[200],
            backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
            child: _imageFile == null 
                ? const Icon(Icons.person, size: 55, color: Colors.grey) 
                : null,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 4,
          child: InkWell(
            onTap: _pickImage,
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFF420031), 
              child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    if (_isLoading) return const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2));

    return ElevatedButton.icon(
      onPressed: () {
        if (_isEditing) {
          _saveProfile();
        } else {
          setState(() => _isEditing = true);
        }
      },
      icon: Icon(_isEditing ? Icons.check_circle_outline : Icons.edit_note_rounded, size: 20),
      label: Text(_isEditing ? "Save Profile" : "Edit Profile"),
      style: ElevatedButton.styleFrom(
        backgroundColor: _isEditing ? const Color(0xFF2ECC71) : const Color(0xFF420031),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: child,
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData? icon, {bool canEdit = true}) {
    bool activeEdit = _isEditing && canEdit;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: !activeEdit,
          style: TextStyle(color: activeEdit ? Colors.black : Colors.black54),
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, size: 18, color: activeEdit ? const Color(0xFF420031) : Colors.grey) : null,
            filled: true,
            fillColor: activeEdit ? Colors.white : const Color(0xFFF8F9FA),
            hintText: "Enter $label",
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: activeEdit ? const Color(0xFF420031).withOpacity(0.3) : Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF420031), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: const Color(0xFFF3E5F5), 
      labelStyle: const TextStyle(color: Color(0xFF420031), fontWeight: FontWeight.w600, fontSize: 13),
      onDeleted: _isEditing ? () {
        setState(() {
          _skills.remove(label);
        });
      } : null,
      deleteIconColor: const Color(0xFF420031),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}