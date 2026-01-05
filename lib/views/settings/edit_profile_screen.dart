import 'dart:io';

import 'package:bbpool/config/app_colors.dart';
import 'package:bbpool/config/icon_path.dart';
import 'package:bbpool/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _dobController;
  late TextEditingController _phoneController;

  late String _initialFirstName;
  late String _initialLastName;
  late String _initialDateOfBirth;
  late String _initialPhoneNumber;
  late String _initialProfileImage;

  String? _profileImagePath;
  bool _acceptedTerms = true;

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsController>(context, listen: false)
        .settings;
    final nameParts = _splitName(settings.name);

    _initialFirstName = nameParts[0];
    _initialLastName = nameParts[1];
    _initialDateOfBirth =
        settings.dateOfBirth.isEmpty ? '01/01/2003' : settings.dateOfBirth;
    _initialPhoneNumber =
        settings.phoneNumber.isEmpty ? '+1 123 1234 1234' : settings.phoneNumber;
    _initialProfileImage = settings.profileImage;

    _profileImagePath = _initialProfileImage;
    _firstNameController = TextEditingController(text: _initialFirstName);
    _lastNameController = TextEditingController(text: _initialLastName);
    _dobController = TextEditingController(text: _initialDateOfBirth);
    _phoneController = TextEditingController(text: _initialPhoneNumber);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 24),
            _buildNameCard(),
            const SizedBox(height: 16),
            _buildSingleFieldCard(
              label: 'Date of Birth',
              controller: _dobController,
              readOnly: true,
              onTap: _pickDate,
              trailing: _buildTrailingIcon(
                icon: Icons.calendar_month_outlined,
                onTap: _pickDate,
              ),
            ),
            const SizedBox(height: 16),
            _buildSingleFieldCard(
              label: 'Phone Number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTermsRow(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  List<String> _splitName(String fullName) {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) {
      return ['', ''];
    }
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return [parts[0], ''];
    }
    return [parts.first, parts.sublist(1).join(' ')];
  }

  ImageProvider _resolveProfileImage(String imagePath) {
    if (imagePath.isEmpty) {
      return const AssetImage(IconPath.profileIcon);
    }
    final uri = Uri.tryParse(imagePath);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return NetworkImage(imagePath);
    }
    return FileImage(File(imagePath));
  }

  Future<void> _pickProfileImage() async {
    final XFile? selected =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (selected == null || !mounted) {
      return;
    }
    setState(() {
      _profileImagePath = selected.path;
    });
  }

  Future<void> _pickDate() async {
    final current = _tryParseDate(_dobController.text) ?? DateTime(2003, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF9DB2FF),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _dobController.text = _formatDate(picked);
    });
  }

  DateTime? _tryParseDate(String value) {
    final parts = value.split('/');
    if (parts.length != 3) {
      return null;
    }
    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (month == null || day == null || year == null) {
      return null;
    }
    return DateTime(year, month, day);
  }

  String _formatDate(DateTime date) {
    return '${_twoDigits(date.month)}/${_twoDigits(date.day)}/${date.year}';
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  Widget _buildProfileSection() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: _resolveProfileImage(_profileImagePath ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickProfileImage,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCCCF8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.file_upload_outlined,
                    color: Colors.black87,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Change Profile Picture',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildNameCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'First Name on ID',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Divider(height: 24, color: Colors.grey[300]),
          Text(
            'Last Name on ID',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleFieldCard({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    TextInputType? keyboardType,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: controller,
                    readOnly: readOnly,
                    keyboardType: keyboardType,
                    onTap: readOnly ? onTap : null,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingIcon({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildTermsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptedTerms,
          onChanged: (value) {
            setState(() => _acceptedTerms = value ?? false);
          },
          activeColor: const Color(0xFF9DB2FF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
                children: [
                  const TextSpan(text: 'By clicking here I agree to BPool '),
                  TextSpan(
                    text: 'Terms and Conditions',
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _discardChanges,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.gradientButtonEnd),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text(
              'Discard Changes',
              style: TextStyle(
                color: AppColors.gradientButtonEnd,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              gradient: AppColors.gradientButton,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _saveProfile,
                borderRadius: BorderRadius.circular(28),
                child: const Center(
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _discardChanges() {
    setState(() {
      _firstNameController.text = _initialFirstName;
      _lastNameController.text = _initialLastName;
      _dobController.text = _initialDateOfBirth;
      _phoneController.text = _initialPhoneNumber;
      _profileImagePath = _initialProfileImage;
      _acceptedTerms = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes discarded')),
    );
  }

  void _saveProfile() {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms to continue')),
      );
      return;
    }

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final fullName =
        lastName.isEmpty ? firstName : '$firstName $lastName'.trim();

    Provider.of<SettingsController>(context, listen: false).updateProfile(
      name: fullName,
      profileImage: _profileImagePath,
      phoneNumber: _phoneController.text.trim(),
      dateOfBirth: _dobController.text.trim(),
    );

    setState(() {
      _initialFirstName = _firstNameController.text.trim();
      _initialLastName = _lastNameController.text.trim();
      _initialDateOfBirth = _dobController.text.trim();
      _initialPhoneNumber = _phoneController.text.trim();
      _initialProfileImage = _profileImagePath ?? '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }
}
