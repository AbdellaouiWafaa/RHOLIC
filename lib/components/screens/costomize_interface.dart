import 'package:flutter/material.dart';


class CustomizeInterfaceScreen extends StatelessWidget {
  const CustomizeInterfaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E3F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reading Settings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          CustomSection(
            title: 'Text Size',
            options: ['Small', 'Medium', 'Large'],
            subtitle: 'Select the size of the text',
          ),
          CustomSection(
            title: 'Text Color',
            options: ['Black', 'White', 'Red', 'Purple'],
            subtitle: 'Select your preferred text color',
          ),
          CustomSection(
            title: 'Text Style',
            options: ['Normal', 'Italic', 'Bold'],
            subtitle: 'Choose the style of the text',
          ),
          CustomSection(
            title: 'Interface Color',
            options: ['Blue', 'Green', 'Pink', 'Orange'],
            subtitle: 'Choose your interface color',
          ),
          CustomSection(
            title: 'Theme Mode',
            options: ['Light', 'Dark'],
            subtitle: 'Select your preferred theme mode',
          ),
        ],
      ),
    );
  }
}

class CustomSection extends StatefulWidget {
  final String title;
  final List<String> options;
  final String subtitle;

  const CustomSection({
    required this.title,
    required this.options,
    required this.subtitle,
    super.key,
  });

  @override
  State<CustomSection> createState() => _CustomSectionState();
}

class _CustomSectionState extends State<CustomSection> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: widget.options.map((option) {
              return ChoiceChip(
                label: Text(option),
                selected: selectedOption == option,
                onSelected: (bool selected) {
                  setState(() {
                    selectedOption = selected ? option : null;
                  });
                },
                selectedColor: const Color(0xFF1E2C6C),
                labelStyle: TextStyle(
                  color: selectedOption == option ? Colors.white : Colors.white,
                ),
                backgroundColor: const Color(0xFF0A0E3F),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            widget.subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 58, 58, 58),
            ),
          ),
        ],
      ),
    );
  }
}
