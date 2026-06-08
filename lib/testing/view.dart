import 'package:flutter/material.dart';
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';
import 'package:kkiapay_flutter_sdk/utils/config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KKiaPay Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const PaymentHomePage(),
    );
  }
}

class PaymentHomePage extends StatefulWidget {
  const PaymentHomePage({super.key});

  @override
  State<PaymentHomePage> createState() => _PaymentHomePageState();
}

class _PaymentHomePageState extends State<PaymentHomePage> {
  bool _isPaying = false;

  void _startPayment() {
    setState(() => _isPaying = true);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KKiaPay(
          amount: 5000, // in XOF (CFA)
          apikey: "197c8b4084cd11f0a0845d14785d8374", // your public key
          sandbox: true, // test mode
          phone: "97000000",
          name: "John Doe",
          email: "john.doe@gmail.com",
          reason: "Hotel Booking Payment",
          theme: "#222F5A",
          callback: (response, context) {
            setState(() => _isPaying = false);
            print("KKiaPay Response: $response");

            if (response['status'] == "SUCCESS") {
              _showResultDialog(context, "Payment Successful ✅");
            } else {
              _showResultDialog(context, "Payment Failed ❌");
            }
          },
        ),
      ),
    );
  }

  void _showResultDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Payment Result"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KKiaPay Payment Demo')),
      body: Center(
        child: _isPaying
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
          onPressed: _startPayment,
          icon: const Icon(Icons.payment),
          label: const Text(
            "Pay Now",
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            padding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
        ),
      ),
    );
  }
}
