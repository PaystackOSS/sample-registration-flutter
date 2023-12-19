import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class DropdownField extends StatefulWidget {
  final void Function(Map<String, dynamic>) onTicketSelected;
  const DropdownField({
    super.key,
    required this.onTicketSelected,
  });

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  List<dynamic> tickets = [];

  Future getTickets() async {
    final supabase = Supabase.instance.client;
    final res = await supabase.functions.invoke('fetch-tickets');
    final response = res.data;

    if (response.containsKey('status')) {
      setState(() {
        tickets = response['data'] as List<dynamic>;
      });
    } else {
      print('Unable to fetch tickets');
    }
  }

  void getAmount(String ticketId) {
    for (var i = 0; i < tickets.length; i++) {
      var ticket = tickets[i];
      if (ticketId == ticket['id']) {
        widget.onTicketSelected({'id': ticket['id'], 'price': ticket['price']});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getTickets();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: "Basic",
      onSelected: (String? value) {
        getAmount(value!);
      },
      dropdownMenuEntries: tickets.map((ticket) {
        return DropdownMenuEntry<String>(
            value: ticket["id"].toString(), label: ticket["name"].toString());
      }).toList(),
    );
  }
}
