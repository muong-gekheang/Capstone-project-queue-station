import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';

const Color appBlue = Color(0xFF154394);
const Color appOrange = Color(0xFFF05A28);

class ContactFormResult {
  final List<SocialAccount> socialAccounts;
  const ContactFormResult({required this.socialAccounts});
}

Widget buildDialogHeader(String title, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: appOrange,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(
                color: appBlue,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.close, color: appOrange, size: 20),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Container(height: 3, width: double.infinity, color: appBlue),
      const SizedBox(height: 16),
    ],
  );
}

// --- Contact Details Dialog ---
class ContactDetailsDialog extends StatelessWidget {
  final List<SocialAccount> socialAccounts;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isOwner;
  final bool isCurrentStore;

  const ContactDetailsDialog({
    super.key,
    required this.socialAccounts,
    required this.onEdit,
    required this.onDelete,
    required this.isOwner,
    required this.isCurrentStore,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: appBlue, width: 2.5),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDialogHeader('Contact', context),
              if (socialAccounts.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'No contact details yet.',
                    style: TextStyle(color: appBlue, fontSize: 15),
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double halfWidth = (constraints.maxWidth - 16) / 2;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 24,
                      children: socialAccounts.map((account) {
                        return SizedBox(
                          width: halfWidth,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                backgroundColor: appBlue,
                                radius: 18,
                                child: Icon(
                                  Icons.link,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      account.platform,
                                      style: const TextStyle(
                                        color: appOrange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      account.username,
                                      style: const TextStyle(
                                        color: appBlue,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              const SizedBox(height: 24),
              if (isOwner && isCurrentStore)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appBlue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Edit/Add Contact Dialog ---
class SocialFieldControllers {
  final TextEditingController platformController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
}

class AddContactDialog extends StatefulWidget {
  final List<SocialAccount> initialAccounts;
  const AddContactDialog({super.key, this.initialAccounts = const []});

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final List<SocialFieldControllers> _socialFields = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialAccounts.isNotEmpty) {
      for (final account in widget.initialAccounts) {
        final field = SocialFieldControllers();
        field.platformController.text = account.platform;
        field.usernameController.text = account.username;
        _socialFields.add(field);
      }
    } else {
      _addNewSocialField();
    }
  }

  void _addNewSocialField() =>
      setState(() => _socialFields.add(SocialFieldControllers()));

  void _removeSocialField(int index) {
    setState(() {
      _socialFields[index].platformController.dispose();
      _socialFields[index].usernameController.dispose();
      _socialFields.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (final field in _socialFields) {
      field.platformController.dispose();
      field.usernameController.dispose();
    }
    super.dispose();
  }

  void _saveContact() {
    final List<SocialAccount> validAccounts = [];
    for (final field in _socialFields) {
      if (field.platformController.text.isNotEmpty &&
          field.usernameController.text.isNotEmpty) {
        validAccounts.add(
          SocialAccount(
            platform: field.platformController.text,
            username: field.usernameController.text,
          ),
        );
      }
    }
    Navigator.pop(context, ContactFormResult(socialAccounts: validAccounts));
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.initialAccounts.isNotEmpty;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: appBlue, width: 2.5),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDialogHeader(
                isEditing ? 'Edit Contacts' : 'Add Contacts',
                context,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _socialFields.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: appBlue.withOpacity(0.03),
                      border: Border.all(color: appBlue.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Account ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: appOrange,
                              ),
                            ),
                            if (_socialFields.length > 1)
                              GestureDetector(
                                onTap: () => _removeSocialField(index),
                                child: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                        TextField(
                          controller: _socialFields[index].platformController,
                          decoration: const InputDecoration(
                            labelText: 'Platform (e.g. Telegram)',
                          ),
                        ),
                        TextField(
                          controller: _socialFields[index].usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Number / Username',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Center(
                child: TextButton.icon(
                  onPressed: _addNewSocialField,
                  icon: const Icon(Icons.add_circle, color: appOrange),
                  label: const Text(
                    'Add Another Social',
                    style: TextStyle(
                      color: appOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _saveContact,
                  child: Text(
                    isEditing ? 'UPDATE' : 'SAVE',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
