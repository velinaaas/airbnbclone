import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'perjalanan.dart';

class BookingPage extends StatefulWidget {
  final int propertyId;

  const BookingPage({Key? key, required this.propertyId}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTimeRange? selectedDateRange;
  int adults = 1;
  int children = 0;
  int infants = 0;

  void _pickDateRange() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:const Color(0xFFFF5A5F),
            colorScheme: const ColorScheme.light(primary: Color(0xFFFF5A5F)),
          ),
          child: child!,
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedDateRange = result;
      });
    }
  }

  void _increment(String type) {
    setState(() {
      if (type == 'adult') adults++;
      if (type == 'child') children++;
      if (type == 'infant') infants++;
    });
  }

  void _decrement(String type) {
    setState(() {
      if (type == 'adult' && adults > 1) adults--;
      if (type == 'child' && children > 0) children--;
      if (type == 'infant' && infants > 0) infants--;
    });
  }

  Future<void> _submitBooking() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Token tidak ditemukan. Silakan login ulang.")),
      );
      return;
    }

    final url = Uri.parse("https://apiairbnb-production.up.railway.app/api/bookings/book");
    final body = {
      "property_id": widget.propertyId,
      "check_in": selectedDateRange!.start.toIso8601String().substring(0, 10),
      "check_out": selectedDateRange!.end.toIso8601String().substring(0, 10),
      "guests": (adults + children + infants)
    };


    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      final booking = json["booking"];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Berhasil Dipesan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Booking ID: ${booking['id_booking']}"),
              Text("Status: ${booking['status']}"),
              Text("Tanggal: ${booking['start_date'].substring(0, 10)} - ${booking['end_date'].substring(0, 10)}"),
              Text("Total: Rp ${booking['total_price']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerjalananPage(),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      final err = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal booking: ${err['message']}")),
      );
    }
  }

  Widget _guestCounter(String title, int count, VoidCallback onAdd, VoidCallback onRemove) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$count', style: const TextStyle(fontSize: 16)),
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    String dateText = 'Pilih tanggal booking';
    if (selectedDateRange != null) {
      dateText =
          '${dateFormat.format(selectedDateRange!.start)} - ${dateFormat.format(selectedDateRange!.end)}';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Villa'),
        backgroundColor:const Color(0xFFFF5A5F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Silahkan pilih tanggal untuk booking:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDateRange,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 241, 227, 233),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFF5A5F)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateText,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today, color: const Color(0xFFFF5A5F)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Jumlah Tamu:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _guestCounter(
              'Dewasa',
              adults,
              () => _increment('adult'),
              () => _decrement('adult'),
            ),
            _guestCounter(
              'Anak-anak',
              children,
              () => _increment('child'),
              () => _decrement('child'),
            ),
            _guestCounter(
              'Bayi',
              infants,
              () => _increment('infant'),
              () => _decrement('infant'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: selectedDateRange == null ? null : _submitBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor:const Color(0xFFFF5A5F),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Booking Sekarang',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
