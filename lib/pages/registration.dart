import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sample_registration/components/email_field.dart';
import 'package:sample_registration/components/dropdown_field.dart';
import 'package:sample_registration/components/quantity_field.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  RegistrationFormState createState() {
    return RegistrationFormState();
  }
}

class RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _quantityController = TextEditingController();
  Map<String, dynamic> _ticket = HashMap();

  static const _methodChannel =
      MethodChannel('com.example.sample_registration/payment');

  @override
  void dispose() {
    _emailController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _onTicketSelected(Map<String, dynamic> ticketObj) {
    setState(() {
      _ticket = ticketObj;
    });
  }

  Future<void> makePayment() async {
    int totalPrice =
        int.parse(_ticket['price']) * int.parse(_quantityController.text);

    try {
      var options = {
        'amount': totalPrice,
        'supplementaryData': {
          'developerSuppliedText': null,
          'developerSuppliedImageUrlPath':
              "https://assets.paystack.com/assets/img/press/Terminal-x-Bature-x-World-Cup-Receipt.jpg",
          'barcodeOrQrcodeImageText': null,
          'textImageType': null
        }
      };

      var response = await _methodChannel.invokeMethod('makePayment', options);
      if (response['status'] != null) {
        completeRegistration();
        print("Response if: $response");
        // handle other post successful payment activities
      } else {
        // handle unsuccessful payment
        print("Response else: $response");
      }
    } on PlatformException catch (e) {
      print("Error: $e");
    }
  }

  Future completeRegistration() async {
    final supabase = Supabase.instance.client;
    final res = await supabase.functions.invoke('create-registration', body: {
      "email": _emailController.text,
      "quantity": _quantityController.text,
      "ticket_id": _ticket['id']
    });

    final response = res.data;
    // handle post registration
    print("Registration: $response");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 70),
          Text(
            'Event Registration Form',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                EmailField(
                  controller: _emailController,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownField(onTicketSelected: _onTicketSelected),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: QuantityField(controller: _quantityController),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      minimumSize: Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                  onPressed: () {
                    makePayment();
                    // completeRegistration();
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Registration extends StatelessWidget {
  const Registration({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: RegistrationForm(),
    );
  }
}
