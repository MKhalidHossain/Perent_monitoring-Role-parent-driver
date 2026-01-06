import 'package:bbpool/controllers/settings_controller.dart';
import 'package:bbpool/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmergencyContactScreen extends StatefulWidget {
  const EmergencyContactScreen({super.key});

  @override
  State<EmergencyContactScreen> createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {
  static const List<String> _relationshipOptions = [
    'Guardian',
    'Parent',
    'Sibling',
    'Relative',
    'Other',
  ];

  late TextEditingController _nameController;
  late TextEditingController _numberController;
  late TextEditingController _name2Controller;
  late TextEditingController _number2Controller;

  late String _relationship;
  late String _relationship2;
  late bool _showSecondContact;

  late String _initialName;
  late String _initialNumber;
  late String _initialRelationship;
  late String _initialName2;
  late String _initialNumber2;
  late String _initialRelationship2;

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsController>(context, listen: false)
        .settings;

    _initialName = settings.emergencyContactName;
    _initialNumber = settings.emergencyContactNumber;
    _initialRelationship =
        _normalizeRelationship(settings.emergencyContactRelationship);

    _initialName2 = settings.emergencyContactName2;
    _initialNumber2 = settings.emergencyContactNumber2;
    _initialRelationship2 =
        _normalizeRelationship(settings.emergencyContactRelationship2);

    _showSecondContact = _initialName2.isNotEmpty ||
        _initialNumber2.isNotEmpty ||
        settings.emergencyContactRelationship2.isNotEmpty;

    _nameController = TextEditingController(text: _initialName);
    _numberController = TextEditingController(text: _initialNumber);
    _name2Controller = TextEditingController(text: _initialName2);
    _number2Controller = TextEditingController(text: _initialNumber2);
    _relationship = _initialRelationship;
    _relationship2 = _initialRelationship2;
  }

  String _normalizeRelationship(String value) {
    if (_relationshipOptions.contains(value)) {
      return value;
    }
    return _relationshipOptions.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _name2Controller.dispose();
    _number2Controller.dispose();
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
          'Emergency Contact',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactCard(
              nameLabel: 'Emergency Contact Name',
              nameController: _nameController,
              relationshipValue: _relationship,
              onRelationshipChanged: (value) {
                setState(() => _relationship = value);
              },
              numberLabel: 'Emergency Contact Number',
              numberController: _numberController,
            ),
            const SizedBox(height: 16),
            if (!_showSecondContact)
              TextButton.icon(
                onPressed: () {
                  setState(() => _showSecondContact = true);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: AppColors.gradientButtonEnd,
                ),
                icon: const Icon(Icons.add),
                label: const Text(
                  'Add Second Emergency Contact',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            if (_showSecondContact) ...[
              _buildContactCard(
                nameLabel: 'Second Emergency Contact Name',
                nameController: _name2Controller,
                relationshipValue: _relationship2,
                onRelationshipChanged: (value) {
                  setState(() => _relationship2 = value);
                },
                numberLabel: 'Second Emergency Contact Number',
                numberController: _number2Controller,
              ),
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required String nameLabel,
    required TextEditingController nameController,
    required String relationshipValue,
    required ValueChanged<String> onRelationshipChanged,
    required String numberLabel,
    required TextEditingController numberController,
  }) {
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
            nameLabel,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: nameController,
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
            'Relationship',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: relationshipValue,
            items: _relationshipOptions
                .map(
                  (option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ),
                )
                .toList(),
            onChanged: (value) {
              onRelationshipChanged(value ?? _relationshipOptions.first);
            },
            icon: const Icon(Icons.keyboard_arrow_down),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            dropdownColor: Colors.white,
          ),
          Divider(height: 24, color: Colors.grey[300]),
          Text(
            numberLabel,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: numberController,
            keyboardType: TextInputType.phone,
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
                onTap: _saveChanges,
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
      _nameController.text = _initialName;
      _numberController.text = _initialNumber;
      _relationship = _initialRelationship;
      _name2Controller.text = _initialName2;
      _number2Controller.text = _initialNumber2;
      _relationship2 = _initialRelationship2;
      _showSecondContact = _initialName2.isNotEmpty ||
          _initialNumber2.isNotEmpty ||
          _initialRelationship2.isNotEmpty;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes discarded')),
    );
  }

  void _saveChanges() {
    Provider.of<SettingsController>(context, listen: false).updateEmergencyContacts(
      name: _nameController.text.trim(),
      relationship: _relationship,
      number: _numberController.text.trim(),
      name2: _showSecondContact ? _name2Controller.text.trim() : '',
      relationship2: _showSecondContact ? _relationship2 : '',
      number2: _showSecondContact ? _number2Controller.text.trim() : '',
    );

    setState(() {
      _initialName = _nameController.text.trim();
      _initialNumber = _numberController.text.trim();
      _initialRelationship = _relationship;
      _initialName2 = _showSecondContact ? _name2Controller.text.trim() : '';
      _initialNumber2 = _showSecondContact ? _number2Controller.text.trim() : '';
      _initialRelationship2 = _showSecondContact ? _relationship2 : '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Emergency contact updated')),
    );
  }
}
