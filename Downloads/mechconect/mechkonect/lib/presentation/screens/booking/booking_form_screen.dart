import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../providers/booking_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/mechanic_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../data/models/booking_model.dart';

class BookingFormScreen extends StatefulWidget {
  final String mechanicId;

  const BookingFormScreen({
    super.key,
    required this.mechanicId,
  });

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleModelController = TextEditingController();
  final _instructionsController = TextEditingController();
  ServiceType _selectedServiceType = ServiceType.minor;
  DateTime? _scheduledTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MechanicProvider>(context, listen: false)
          .loadMechanic(widget.mechanicId);
    });
  }

  @override
  void dispose() {
    _vehicleModelController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final mechanicProvider = Provider.of<MechanicProvider>(context, listen: false);

    // Get mechanic details if available
    final mechanic = mechanicProvider.selectedMechanic;

    final bookingData = {
      'user_id': authProvider.user?.id ?? '',
      'mechanic_id': widget.mechanicId,
      'mechanic_name': mechanic?.name,
      'mechanic_phone': mechanic?.phone,
      'service_type': _selectedServiceType.name,
      'vehicle_model': _vehicleModelController.text.trim(),
      'special_instructions': _instructionsController.text.trim(),
      'scheduled_time': _scheduledTime?.toIso8601String(),
      'user_latitude': locationProvider.currentPosition?.latitude,
      'user_longitude': locationProvider.currentPosition?.longitude,
      'user_address': locationProvider.currentAddress,
    };

    try {
      final booking = await bookingProvider.createBooking(bookingData);
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking created successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        // Navigate to booking history after a brief delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.go('/booking-history');
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(bookingProvider.error ?? 'Failed to create booking: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final mechanicProvider = Provider.of<MechanicProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Book Mechanic')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingXL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Service Type', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppDimensions.spacingMD),
              ...ServiceType.values.map((type) {
                return RadioListTile<ServiceType>(
                  title: Text(type.name.toUpperCase()),
                  value: type,
                  groupValue: _selectedServiceType,
                  onChanged: (value) {
                    setState(() {
                      _selectedServiceType = value!;
                    });
                  },
                );
              }),
              const SizedBox(height: AppDimensions.spacingLG),
              CustomTextField(
                label: 'Vehicle Model',
                hint: 'e.g., Toyota Corolla 2020',
                controller: _vehicleModelController,
                validator: Validators.vehicleModel,
              ),
              const SizedBox(height: AppDimensions.spacingLG),
              CustomTextField(
                label: 'Special Instructions',
                hint: 'Any additional details...',
                controller: _instructionsController,
                maxLines: 4,
              ),
              const SizedBox(height: AppDimensions.spacingLG),
              CustomTextField(
                label: 'Scheduled Time (Optional)',
                hint: _scheduledTime == null
                    ? 'Select time'
                    : _scheduledTime.toString(),
                readOnly: true,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null) {
                    setState(() {
                      _scheduledTime = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: AppDimensions.spacingXXL),
              CustomButton(
                text: 'Confirm Booking',
                onPressed: bookingProvider.isLoading ? null : _handleSubmit,
                isLoading: bookingProvider.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

