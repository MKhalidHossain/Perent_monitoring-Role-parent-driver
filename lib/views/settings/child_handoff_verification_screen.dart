import 'package:bbpool/controllers/settings_controller.dart';
import 'package:bbpool/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChildHandoffVerificationScreen extends StatefulWidget {
  const ChildHandoffVerificationScreen({super.key});

  @override
  State<ChildHandoffVerificationScreen> createState() =>
      _ChildHandoffVerificationScreenState();
}

class _ChildHandoffVerificationScreenState
    extends State<ChildHandoffVerificationScreen> {
  late TextEditingController _nameController;
  late TextEditingController _pinController;

  late String _initialName;
  late String _initialPin;

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsController>(context, listen: false)
        .settings;

    _initialName = settings.handoffVerificationName;
    _initialPin = settings.handoffVerificationPin;

    _nameController = TextEditingController(text: _initialName);
    _pinController = TextEditingController(text: _initialPin);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pinController.dispose();
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
          'Child Handoff Verification',
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
            const Text(
              'Verification Pin',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            _buildVerificationCard(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationCard() {
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
            'Verification Name',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _nameController,
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
            'Pin',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _pinController,
            keyboardType: TextInputType.number,
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
      _pinController.text = _initialPin;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes discarded')),
    );
  }

  void _saveChanges() {
    Provider.of<SettingsController>(context, listen: false)
        .updateChildHandoffVerification(
      name: _nameController.text.trim(),
      pin: _pinController.text.trim(),
    );

    setState(() {
      _initialName = _nameController.text.trim();
      _initialPin = _pinController.text.trim();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification updated')),
    );
  }
}
