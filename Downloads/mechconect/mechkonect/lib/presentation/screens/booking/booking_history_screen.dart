import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/error_widget.dart' as error_widget;
import '../../providers/booking_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../data/models/booking_model.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/currency_formatter.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      Provider.of<BookingProvider>(context, listen: false)
          .loadBookings(userId: authProvider.user?.id);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: bookingProvider.isLoading
          ? const LoadingIndicator()
          : TabBarView(
              controller: _tabController,
              children: [
                _BookingsList(bookings: bookingProvider.activeBookings),
                _BookingsList(bookings: bookingProvider.completedBookings),
                _BookingsList(bookings: bookingProvider.cancelledBookings),
              ],
            ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  final List<BookingModel> bookings;

  const _BookingsList({required this.bookings});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return error_widget.EmptyStateWidget(
        message: 'No bookings found',
        subtitle: 'Your bookings will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.spacingMD),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppDimensions.spacingMD),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: booking.mechanicPhotoUrl != null
                  ? NetworkImage(booking.mechanicPhotoUrl!)
                  : null,
              child: booking.mechanicPhotoUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(booking.mechanicName ?? 'Unknown Mechanic'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Service: ${booking.serviceType.name}'),
                Text('Date: ${DateFormatter.formatBookingDate(booking.createdAt)}'),
                if (booking.cost != null)
                  Text('Cost: ${CurrencyFormatter.formatCurrency(booking.cost!)}'),
              ],
            ),
            trailing: _StatusChip(status: booking.status),
            onTap: () {
              // Navigate to payment if booking needs payment
              if (booking.cost != null && 
                  booking.cost! > 0 && 
                  (booking.status == BookingStatus.pending || 
                   booking.status == BookingStatus.confirmed)) {
                context.push('/payment/${booking.id}');
              }
            },
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  final BookingStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case BookingStatus.pending:
        color = Colors.orange;
        break;
      case BookingStatus.confirmed:
        color = Colors.blue;
        break;
      case BookingStatus.inProgress:
        color = Colors.purple;
        break;
      case BookingStatus.completed:
        color = Colors.green;
        break;
      case BookingStatus.cancelled:
        color = Colors.red;
        break;
    }

    return Chip(
      label: Text(status.name.toUpperCase()),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
    );
  }
}

