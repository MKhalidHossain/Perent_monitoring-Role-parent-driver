import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bbpool/config/app_colors.dart';
import 'package:bbpool/models/child_info_model.dart';
import 'package:bbpool/services/child_info_service.dart';
import 'package:bbpool/services/token_manager.dart';
import 'package:image_picker/image_picker.dart';

class ParentProfileSetupView extends StatefulWidget {
  const ParentProfileSetupView({super.key});

  @override
  State<ParentProfileSetupView> createState() => _ParentProfileSetupViewState();
}

class _ParentProfileSetupViewState extends State<ParentProfileSetupView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController(text: 'Alex');
  final _lastNameController = TextEditingController(text: 'Smith');
  final _dateOfBirthController = TextEditingController();
  final _phoneController = TextEditingController(text: '+1 123 1234 1234');
  final _streetAddressController = TextEditingController(text: '27 Baker Street');
  final _areaController = TextEditingController(text: 'Kensington');
  final _postcodeController = TextEditingController(text: 'NW1 6XE');
  
  bool _agreeToTerms = true;
  bool _isLoading = false;
  bool _isLoadingChildren = true;
  List<ChildInfoModel> _children = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadChildrenFromStorage(); // Load from storage first for faster display
    _loadChildren(); // Then refresh from API
  }

  // Load children from SharedPreferences (cached data)
  Future<void> _loadChildrenFromStorage() async {
    try {
      final childInfoList = await TokenManager.getChildInfo();
      if (childInfoList != null && childInfoList.isNotEmpty) {
        setState(() {
          _children = childInfoList
              .map((item) => ChildInfoModel.fromJson(item))
              .toList();
        });
        print('✅ Loaded ${_children.length} children from SharedPreferences');
      }
    } catch (e) {
      print('❌ Error loading children from storage: $e');
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _phoneController.dispose();
    _streetAddressController.dispose();
    _areaController.dispose();
    _postcodeController.dispose();
    super.dispose();
  }

  Future<void> _loadChildren() async {
    if (!mounted) return;
    
    setState(() {
      _isLoadingChildren = true;
    });

    print('🔄 Loading children from API...');
    final response = await ChildInfoService.getChildInfo();
    
    if (!mounted) return;
    
    if (response.success && response.data != null) {
      print('✅ Successfully loaded ${response.data!.length} children');
      
      // Save child info to SharedPreferences
      try {
        final childInfoList = response.data!
            .map((child) => child.toJson())
            .toList();
        await TokenManager.saveChildInfo(childInfoList);
        print('✅ Child info saved to SharedPreferences');
      } catch (e) {
        print('❌ Error saving child info to storage: $e');
      }
      
      setState(() {
        _children = response.data!;
        _isLoadingChildren = false;
      });
      
      if (response.data!.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No children found. Add your first child below.'),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } else {
      print('❌ Failed to load children: ${response.message}');
      setState(() {
        _isLoadingChildren = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Set-up your Profile!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section
              _buildUserProfileSection(),
              const SizedBox(height: 24),
              
              // Child Profile Section
              _buildChildProfileSection(),
              const SizedBox(height: 24),
              
              // Terms and Conditions
              _buildTermsAndConditions(),
              const SizedBox(height: 32),
              
              // Continue Button
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: _firstNameController,
            label: 'First Name on ID',
            isRequired: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _lastNameController,
            label: 'Last Name on ID',
            isRequired: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _dateOfBirthController,
            label: 'DD/MM/YYYY',
            suffixIcon: Icons.calendar_today,
            onTap: () => _selectDate(),
            readOnly: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _phoneController,
            label: 'Phone Number',
            keyboardType: TextInputType.phone,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _streetAddressController,
            label: 'Street Address',
            isRequired: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _areaController,
                  label: 'Area',
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _postcodeController,
                  label: 'Postcode',
                  isRequired: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Child Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoadingChildren)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_children.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'No children added yet',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ..._children.map((child) => _buildChildItem(child)),
          const SizedBox(height: 16),
          _buildAddChildButton(),
        ],
      ),
    );
  }

  Widget _buildChildItem(ChildInfoModel child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            backgroundImage: child.avatar?.url != null && child.avatar!.url!.isNotEmpty
                ? NetworkImage(child.avatar!.url!)
                : null,
            child: child.avatar?.url == null || child.avatar!.url!.isEmpty
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (child.schoolName.isNotEmpty)
                  Text(
                    child.schoolName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
            onPressed: () => _editChild(child),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: () => _deleteChild(child),
          ),
        ],
      ),
    );
  }

  Widget _buildAddChildButton() {
    return InkWell(
      onTap: _addChild,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              'Add Child Profile',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (value) {
            setState(() {
              _agreeToTerms = value ?? false;
            });
          },
          activeColor: Colors.purple,
        ),
        Expanded(
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              children: [
                TextSpan(text: 'By clicking here I agree to BPool '),
                TextSpan(
                  text: 'Terms and Conditions',
                  style: TextStyle(
                    color: Colors.purple,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: AppColors.gradientButton,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: _agreeToTerms ? _handleContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isRequired = false,
    TextInputType? keyboardType,
    IconData? suffixIcon,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: Colors.grey)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.purple),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: isRequired
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            }
          : null,
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _addChild() {
    final nameController = TextEditingController();
    final schoolNameController = TextEditingController();
    final emergencyContactNameController = TextEditingController();
    final emergencyContactNumberController = TextEditingController();
    final relationshipController = TextEditingController();
    final dateOfBirthController = TextEditingController();
    String? selectedAvatarPath;
    DateTime? selectedDateOfBirth;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Child Profile'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar picker
                    GestureDetector(
                      onTap: () async {
                        final XFile? image = await _imagePicker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 85, // Compress image
                        );
                        if (image != null) {
                          // Validate file extension
                          final extension = image.path.split('.').last.toLowerCase();
                          if (extension != 'jpg' && 
                              extension != 'jpeg' && 
                              extension != 'png') {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Only images (jpeg, jpg, png) are allowed'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            return;
                          }
                          
                          setDialogState(() {
                            selectedAvatarPath = image.path;
                          });
                        }
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: selectedAvatarPath != null
                            ? ClipOval(
                                child: Image.file(
                                  File(selectedAvatarPath!),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.add_photo_alternate, size: 40),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: schoolNameController,
                      decoration: const InputDecoration(
                        labelText: 'School Name *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emergencyContactNameController,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Contact Name *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emergencyContactNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Contact Number *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: relationshipController,
                      decoration: const InputDecoration(
                        labelText: 'Relationship *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedDateOfBirth = picked;
                            dateOfBirthController.text =
                                '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dateOfBirthController,
                          decoration: const InputDecoration(
                            labelText: 'Date of Birth',
                            suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (nameController.text.isEmpty ||
                              schoolNameController.text.isEmpty ||
                              emergencyContactNameController.text.isEmpty ||
                              emergencyContactNumberController.text.isEmpty ||
                              relationshipController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all required fields'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          setDialogState(() {
                            _isLoading = true;
                          });

                          final response = await ChildInfoService.addChildInfo(
                            fullName: nameController.text,
                            schoolName: schoolNameController.text,
                            emergencyContactName:
                                emergencyContactNameController.text,
                            emergencyContactNumber:
                                emergencyContactNumberController.text,
                            relationship: relationshipController.text,
                            dateOfBirth: selectedDateOfBirth,
                            avatarPath: selectedAvatarPath,
                          );

                          setDialogState(() {
                            _isLoading = false;
                          });

                          if (response.success) {
                            Navigator.pop(context);
                            _loadChildren(); // Reload children list
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Child added successfully'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } else {
                            if (mounted) {
                              // Show detailed error message
                              String errorMessage = response.message;
                              if (errorMessage.contains('Only images')) {
                                errorMessage = 'Please select a valid image file (JPEG, JPG, or PNG)';
                              }
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          }
                        },
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editChild(ChildInfoModel child) {
    final nameController = TextEditingController(text: child.fullName);
    final schoolNameController = TextEditingController(text: child.schoolName);
    final emergencyContactNameController = TextEditingController(
      text: child.emergencyContactName,
    );
    final emergencyContactNumberController = TextEditingController(
      text: child.emergencyContactNumber.isNotEmpty
          ? child.emergencyContactNumber.first
          : '',
    );
    final relationshipController = TextEditingController(text: child.relationship);
    final dateOfBirthController = TextEditingController(
      text: child.dateOfBirth != null
          ? '${child.dateOfBirth!.day.toString().padLeft(2, '0')}/${child.dateOfBirth!.month.toString().padLeft(2, '0')}/${child.dateOfBirth!.year}'
          : '',
    );
    String? selectedAvatarPath;
    DateTime? selectedDateOfBirth = child.dateOfBirth;
    String? currentAvatarUrl = child.avatar?.url;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Child Profile'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar picker
                    GestureDetector(
                      onTap: () async {
                        final XFile? image = await _imagePicker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 85, // Compress image
                        );
                        if (image != null) {
                          // Validate file extension
                          final extension = image.path.split('.').last.toLowerCase();
                          if (extension != 'jpg' &&
                              extension != 'jpeg' &&
                              extension != 'png') {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Only images (jpeg, jpg, png) are allowed'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            return;
                          }

                          setDialogState(() {
                            selectedAvatarPath = image.path;
                            currentAvatarUrl = null; // Clear network image when new one selected
                          });
                        }
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: selectedAvatarPath != null
                            ? ClipOval(
                                child: Image.file(
                                  File(selectedAvatarPath!),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : currentAvatarUrl != null &&
                                    currentAvatarUrl!.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      currentAvatarUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.person,
                                          size: 40,
                                        );
                                      },
                                    ),
                                  )
                                : const Icon(Icons.add_photo_alternate, size: 40),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: schoolNameController,
                      decoration: const InputDecoration(
                        labelText: 'School Name *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emergencyContactNameController,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Contact Name *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emergencyContactNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Contact Number *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: relationshipController,
                      decoration: const InputDecoration(
                        labelText: 'Relationship *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDateOfBirth ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedDateOfBirth = picked;
                            dateOfBirthController.text =
                                '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dateOfBirthController,
                          decoration: const InputDecoration(
                            labelText: 'Date of Birth',
                            suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (nameController.text.isEmpty ||
                              schoolNameController.text.isEmpty ||
                              emergencyContactNameController.text.isEmpty ||
                              emergencyContactNumberController.text.isEmpty ||
                              relationshipController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all required fields'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          setDialogState(() {
                            _isLoading = true;
                          });

                          print('🔄 Updating child: ${child.fullName} (ID: ${child.id})');
                          final response = await ChildInfoService.updateChildInfo(
                            childId: child.id,
                            fullName: nameController.text,
                            schoolName: schoolNameController.text,
                            emergencyContactName:
                                emergencyContactNameController.text,
                            emergencyContactNumber:
                                emergencyContactNumberController.text,
                            relationship: relationshipController.text,
                            dateOfBirth: selectedDateOfBirth,
                            avatarPath: selectedAvatarPath,
                          );

                          setDialogState(() {
                            _isLoading = false;
                          });

                          if (response.success && response.data != null) {
                            Navigator.pop(context);
                            
                            // Update child in local list
                            final index = _children.indexWhere((c) => c.id == child.id);
                            if (index != -1) {
                              setState(() {
                                _children[index] = response.data!;
                              });
                            }
                            
                            // Update SharedPreferences
                            try {
                              final childInfoList = _children
                                  .map((c) => c.toJson())
                                  .toList();
                              await TokenManager.saveChildInfo(childInfoList);
                              print('✅ Updated child info in SharedPreferences');
                            } catch (e) {
                              print('❌ Error updating child info in storage: $e');
                            }
                            
                            // Reload from API to ensure sync
                            _loadChildren();
                            
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Child profile updated successfully'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } else {
                            if (mounted) {
                              // Show detailed error message
                              String errorMessage = response.message;
                              if (errorMessage.contains('Only images')) {
                                errorMessage =
                                    'Please select a valid image file (JPEG, JPG, or PNG)';
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          }
                        },
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteChild(ChildInfoModel child) {
    showDialog(
      context: context,
      builder: (context) {
        bool isDeleting = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Delete Child Profile'),
              content: Text('Are you sure you want to delete ${child.fullName}? This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: isDeleting
                      ? null
                      : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isDeleting
                      ? null
                      : () async {
                          setDialogState(() {
                            isDeleting = true;
                          });

                          print('🗑️ Deleting child: ${child.fullName} (ID: ${child.id})');
                          final response = await ChildInfoService.deleteChildInfo(
                            childId: child.id,
                          );

                          setDialogState(() {
                            isDeleting = false;
                          });

                          if (!mounted) return;

                          if (response.success) {
                            Navigator.pop(context);
                            
                            // Remove child from local list
                            setState(() {
                              _children.removeWhere((c) => c.id == child.id);
                            });
                            
                            // Update SharedPreferences
                            try {
                              final childInfoList = _children
                                  .map((c) => c.toJson())
                                  .toList();
                              await TokenManager.saveChildInfo(childInfoList);
                              print('✅ Updated child info in SharedPreferences');
                            } catch (e) {
                              print('❌ Error updating child info in storage: $e');
                            }
                            
                            // Reload from API to ensure sync
                            _loadChildren();
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Child profile deleted successfully'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(response.message),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: isDeleting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      // Handle form submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile setup completed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to next screen or handle success
    }
  }
}

