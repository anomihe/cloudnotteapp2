import 'package:cloudnottapp2/src/screens/accounting/fee_payment_screen.dart';

class FeeModel {
  final String title;
  final String session;
  final String term;
  final double totalAmount;
  final double outstandingAmount;
  final double discountAmount;
  final double amountPaid;
  final PaymentStatus status;

  FeeModel({
    required this.title,
    required this.session,
    required this.term,
    required this.totalAmount,
    required this.outstandingAmount,
    required this.discountAmount,
    required this.amountPaid,
    required this.status,
  });
}
