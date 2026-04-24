import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/financial_event.dart';
import '../providers/financial_events_provider.dart';

class EventSetupScreen extends ConsumerStatefulWidget {
  final FinancialEvent template;

  const EventSetupScreen({super.key, required this.template});

  @override
  ConsumerState<EventSetupScreen> createState() => _EventSetupScreenState();
}

class _EventSetupScreenState extends ConsumerState<EventSetupScreen> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _locationController = TextEditingController();

  // Common financial controllers
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _depositController = TextEditingController();

  // Scenario-specific metadata
  final Map<String, dynamic> _metadata = {};

  // Text controllers for metadata fields
  final Map<String, TextEditingController> _metadataControllers = {};

  @override
  void initState() {
    super.initState();
    // Initialize controllers for this event type
    _initializeControllersForType(widget.template.type);
  }

  void _initializeControllersForType(FinancialEventType type) {
    final fields = _getTextFieldsForType(type);
    for (final field in fields) {
      _metadataControllers[field] = TextEditingController();
    }
  }

  List<String> _getTextFieldsForType(FinancialEventType type) {
    switch (type) {
      case FinancialEventType.buyingHouse:
        return ['propertyType', 'bedrooms'];
      case FinancialEventType.buyingCar:
        return ['vehicleType'];
      case FinancialEventType.havingBaby:
        return ['hospitalName'];
      case FinancialEventType.gettingMarried:
        return ['venueName', 'guestCount'];
      case FinancialEventType.divorce:
        return [];
      case FinancialEventType.bereavement:
        return ['relationship'];
      case FinancialEventType.anniversary:
        return ['anniversaryYears'];
      case FinancialEventType.birthday:
        return ['personName', 'personAge'];
      case FinancialEventType.christmas:
        return ['recipientCount'];
      case FinancialEventType.retirement:
        return ['targetRetirementAge', 'currentPensionValue'];
      case FinancialEventType.startingBusiness:
        return ['businessType', 'startupCapital'];
      case FinancialEventType.university:
        return ['institutionName', 'courseName', 'tuitionFees'];
      case FinancialEventType.startingSchool:
        return ['childName', 'schoolName'];
      case FinancialEventType.newJob:
        return ['companyName', 'newSalary'];
      case FinancialEventType.gettingFit:
        return ['fitnessGoal', 'targetWeight'];
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _budgetController.dispose();
    _depositController.dispose();
    for (final controller in _metadataControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _collectMetadata() {
    // Collect text field values into metadata
    _metadataControllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        // Try to parse as number if it looks like one
        final numValue = double.tryParse(controller.text);
        final intValue = int.tryParse(controller.text);
        if (intValue != null && !controller.text.contains('.')) {
          _metadata[key] = intValue;
        } else if (numValue != null) {
          _metadata[key] = numValue;
        } else {
          _metadata[key] = controller.text;
        }
      }
    });
  }

  void _saveEvent() {
    final budget = double.tryParse(_budgetController.text);
    final deposit = double.tryParse(_depositController.text);

    _collectMetadata();

    final newEvent = widget.template.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: _selectedDate,
      location: _locationController.text,
      budget: budget,
      depositAmount: deposit,
      metadata: _metadata,
    );

    ref.read(financialEventsProvider.notifier).addEvent(newEvent);
    context.go('/banking');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setup ${widget.template.title}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Event Details'),
            const SizedBox(height: 16),
            _buildDatePicker(),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Location',
              controller: _locationController,
              hint: 'e.g. London, UK',
              icon: Icons.location_on,
            ),
            const SizedBox(height: 24),

            // Scenario-specific fields
            ..._buildScenarioFields(),

            const SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getDateLabel(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
            );
            if (picked != null) {
              setState(() => _selectedDate = picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
                const Icon(Icons.calendar_today, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getDateLabel() {
    switch (widget.template.type) {
      case FinancialEventType.havingBaby:
        return 'Due Date';
      case FinancialEventType.gettingMarried:
        return 'Wedding Date';
      case FinancialEventType.retirement:
        return 'Target Retirement Date';
      case FinancialEventType.newJob:
        return 'Start Date';
      case FinancialEventType.birthday:
      case FinancialEventType.anniversary:
      case FinancialEventType.christmas:
        return 'Event Date';
      default:
        return 'Target Date';
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    IconData? icon,
    TextInputType? keyboardType,
    String? prefix,
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            suffixText: suffix,
            prefixIcon: icon != null ? Icon(icon, size: 20) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggle({
    required String label,
    required String metadataKey,
    bool defaultValue = false,
  }) {
    return SwitchListTile(
      title: Text(label),
      value: _metadata[metadataKey] as bool? ?? defaultValue,
      onChanged: (value) {
        setState(() => _metadata[metadataKey] = value);
      },
      contentPadding: EdgeInsets.zero,
    );
  }

  List<Widget> _buildScenarioFields() {
    final type = widget.template.type;
    final widgets = <Widget>[];

    switch (type) {
      case FinancialEventType.buyingHouse:
        widgets.addAll([
          _buildSectionHeader('Property Details'),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Property Type',
            controller: _metadataControllers['propertyType']!,
            hint: 'e.g. Detached, Semi-detached, Flat',
            icon: Icons.home,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Number of Bedrooms',
            controller: _metadataControllers['bedrooms']!,
            hint: 'e.g. 3',
            keyboardType: TextInputType.number,
            icon: Icons.bed,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Target Budget',
            controller: _budgetController,
            hint: 'e.g. 350000',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.attach_money,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Deposit Amount',
            controller: _depositController,
            hint: 'e.g. 35000',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.savings,
          ),
        ]);
        break;

      case FinancialEventType.buyingCar:
        widgets.addAll([
          _buildSectionHeader('Vehicle Details'),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Vehicle Type',
            controller: _metadataControllers['vehicleType']!,
            hint: 'e.g. SUV, Hatchback, Electric',
            icon: Icons.directions_car,
          ),
          const SizedBox(height: 16),
          _buildToggle(label: 'Buying New', metadataKey: 'isNewVehicle'),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Target Budget',
            controller: _budgetController,
            hint: 'e.g. 25000',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.attach_money,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Deposit Amount',
            controller: _depositController,
            hint: 'e.g. 5000',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.savings,
          ),
        ]);
        break;

      case FinancialEventType.havingBaby:
        widgets.addAll([
          _buildSectionHeader('Baby Planning'),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Hospital / Birthing Centre',
            controller: _metadataControllers['hospitalName']!,
            hint: 'e.g. St Mary\'s Hospital',
            icon: Icons.local_hospital,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Budget for Baby Items',
            controller: _budgetController,
            hint: 'e.g. 5000',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.attach_money,
          ),
        ]);
        break;

      case FinancialEventType.gettingMarried:
        widgets.addAll([
          _buildSectionHeader('Wedding Details'),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Venue',
            controller: _metadataControllers['venueName']!,
            hint: 'e.g. The Grand Hotel',
            icon: Icons.location_city,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Guest Count',
            controller: _metadataControllers['guestCount']!,
            hint: 'e.g. 100',
            keyboardType: TextInputType.number,
            icon: Icons.people,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Wedding Budget',
            controller: _budgetController,
            hint: 'e.g. 20000',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.attach_money,
          ),
        ]);
        break;

      case FinancialEventType.divorce:
        widgets.addAll([
          _buildSectionHeader('Divorce Planning'),
          const SizedBox(height: 16),
          _buildToggle(label: 'Children Involved', metadataKey: 'hasChildren'),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Legal Budget',
            controller: _budgetController,
            hint: 'e.g. 5000',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.gavel,
          ),
        ]);
        break;

      case FinancialEventType.bereavement:
        widgets.addAll([
          _buildSectionHeader('Support Planning'),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Relationship',
            controller: _metadataControllers['relationship']!,
            hint: 'e.g. Parent, Spouse, Friend',
            icon: Icons.favorite,
          ),
        ]);
        break;

      case FinancialEventType.anniversary:
        widgets.addAll([
          _buildSectionHeader('Anniversary Details'),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Years Together',
            controller: _metadataControllers['anniversaryYears']!,
            hint: 'e.g. 10',
            keyboardType: TextInputType.number,
            icon: Icons.celebration,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Celebration Budget',
            controller: _budgetController,
            hint: 'e.g. 500',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.attach_money,
          ),
        ]);
        break;

      case FinancialEventType.birthday:
        widgets.addAll([
          _buildSectionHeader('Birthday Details'),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Person\'s Name',
            controller: _metadataControllers['personName']!,
            hint: 'e.g. John',
            icon: Icons.person,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Age',
            controller: _metadataControllers['personAge']!,
            hint: 'e.g. 30',
            keyboardType: TextInputType.number,
            icon: Icons.cake,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Gift / Party Budget',
            controller: _budgetController,
            hint: 'e.g. 200',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.attach_money,
          ),
        ]);
        break;

      case FinancialEventType.christmas:
        widgets.addAll([
          _buildSectionHeader('Christmas Planning'),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Number of Gift Recipients',
            controller: _metadataControllers['recipientCount']!,
            hint: 'e.g. 15',
            keyboardType: TextInputType.number,
            icon: Icons.card_giftcard,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Total Gift Budget',
            controller: _budgetController,
            hint: 'e.g. 500',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.attach_money,
          ),
        ]);
        break;

      case FinancialEventType.retirement:
        widgets.addAll([
          _buildSectionHeader('Retirement Planning'),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Target Retirement Age',
            controller: _metadataControllers['targetRetirementAge']!,
            hint: 'e.g. 65',
            keyboardType: TextInputType.number,
            icon: Icons.beach_access,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Current Pension Value',
            controller: _metadataControllers['currentPensionValue']!,
            hint: 'e.g. 150000',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.savings,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Target Retirement Fund',
            controller: _budgetController,
            hint: 'e.g. 500000',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.account_balance,
          ),
        ]);
        break;

      case FinancialEventType.startingBusiness:
        widgets.addAll([
          _buildSectionHeader('Business Details'),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Business Type',
            controller: _metadataControllers['businessType']!,
            hint: 'e.g. E-commerce, Consulting, Cafe',
            icon: Icons.business,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Startup Capital Needed',
            controller: _metadataControllers['startupCapital']!,
            hint: 'e.g. 50000',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.attach_money,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Amount Saved',
            controller: _depositController,
            hint: 'e.g. 10000',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.savings,
          ),
        ]);
        break;

      case FinancialEventType.university:
        widgets.addAll([
          _buildSectionHeader('University Details'),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Institution',
            controller: _metadataControllers['institutionName']!,
            hint: 'e.g. University of Manchester',
            icon: Icons.school,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Course',
            controller: _metadataControllers['courseName']!,
            hint: 'e.g. Computer Science',
            icon: Icons.book,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Annual Tuition Fees',
            controller: _metadataControllers['tuitionFees']!,
            hint: 'e.g. 9250',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.attach_money,
          ),
        ]);
        break;

      case FinancialEventType.startingSchool:
        widgets.addAll([
          _buildSectionHeader('School Details'),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Child\'s Name',
            controller: _metadataControllers['childName']!,
            hint: 'e.g. Emma',
            icon: Icons.child_care,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'School Name',
            controller: _metadataControllers['schoolName']!,
            hint: 'e.g. St Mary\'s Primary',
            icon: Icons.school,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Uniform & Supplies Budget',
            controller: _budgetController,
            hint: 'e.g. 300',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.attach_money,
          ),
        ]);
        break;

      case FinancialEventType.newJob:
        widgets.addAll([
          _buildSectionHeader('New Job Details'),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Company Name',
            controller: _metadataControllers['companyName']!,
            hint: 'e.g. Acme Corporation',
            icon: Icons.business,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'New Salary',
            controller: _metadataControllers['newSalary']!,
            hint: 'e.g. 45000',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.attach_money,
          ),
        ]);
        break;

      case FinancialEventType.gettingFit:
        widgets.addAll([
          _buildSectionHeader('Fitness Goals'),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Fitness Goal',
            controller: _metadataControllers['fitnessGoal']!,
            hint: 'e.g. Run marathon, Lose weight, Build muscle',
            icon: Icons.fitness_center,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Target Weight (kg)',
            controller: _metadataControllers['targetWeight']!,
            hint: 'e.g. 75',
            suffix: 'kg',
            keyboardType: TextInputType.number,
            icon: Icons.monitor_weight,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Gym / Equipment Budget',
            controller: _budgetController,
            hint: 'e.g. 500',
            prefix: '£ ',
            keyboardType: TextInputType.number,
            icon: Icons.attach_money,
          ),
        ]);
        break;
    }

    return widgets;
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveEvent,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Create Event', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
