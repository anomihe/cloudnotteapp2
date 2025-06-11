import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:collection/collection.dart';
import 'package:cloudnottapp2/src/data/models/accounting_mode_second.dart'
    show StudentFeeSecond;
import 'package:cloudnottapp2/src/data/providers/accounting_providers.dart'
    show AccountingProvider;
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/accounting/admin_fee_payment_screen.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:cloudnottapp2/src/screens/accounting/transaction_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'fee_payment_screen.dart';

class MakePaymentScreen extends StatefulWidget {
  static const routeName = '/make_payment_screen';
  const MakePaymentScreen({super.key});

  @override
  State<MakePaymentScreen> createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
  
  bool isIndividualFee = false;
  Map<String, int> selectedFeeAmounts = {};

  Map<String, TextEditingController> controllers = {};
  Map<String, FocusNode> focusNodes = {};
  String? selectedFeeTitle;
  NumberFormat numberFormat = NumberFormat('#,##0', 'en_US');
  double getTotalSelectedAmount() {
    return selectedFeeAmounts.values.fold(0, (sum, amount) => sum + amount);
  }

  double getTotalOutstandingAmount(List<StudentFeeSecond> fees) {
    return fees.where((fee) {
      final status = statusFromString(fee.status ?? '');
      return status == PaymentStatus.unpaid || status == PaymentStatus.owning;
    }).fold(0, (sum, fee) {
      final amountPaid = int.parse(fee.amountPaid ?? '0');
      final discountAmount = int.parse(fee.discountAmount ?? '0');
      final totalAmount = int.parse(fee.amount ?? '0');
      final outstanding = totalAmount - amountPaid - discountAmount;
      return sum + outstanding;
    });
  }

  @override
  void initState() {
    super.initState();

    // You may want to delay this init if fees are loaded async
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feeProvider =
          Provider.of<AccountingProvider>(context, listen: false);
      final unpaidFees = feeProvider.studentPay.where((fee) {
        final status = statusFromString(fee.status ?? '');
        return status == PaymentStatus.unpaid || status == PaymentStatus.owning;
      });

      if (!isIndividualFee) {
        for (var fee in unpaidFees) {
          if (fee.paymentItem.feeName != null) {
            final amountPaid = int.parse(fee.amountPaid ?? '0');
            final discountAmount = int.parse(fee.discountAmount ?? '0');
            final totalAmount = int.parse(fee.amount ?? '0');
            final outstanding = totalAmount - amountPaid - discountAmount;
            selectedFeeAmounts[fee.paymentItem.feeName!] = outstanding.toInt();
          }
        }
      }
    });
  }

  PaymentStatus? getPaymentStatus(String? status) {
    try {
      return PaymentStatus.values.firstWhere(
        (e) => e.name == status,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    for (var node in focusNodes.values) {
      node.dispose();
    }
    // controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountingProvider>(
      builder: (context, feeProvider, _) {
        final fees = feeProvider.studentPay;
        // print('>>> fees count: ${feeProvider.studentPay.length}');
        // final unpaidFees = fees
        //     .where((fee) =>
        //         fee.status == PaymentStatus.unpaid.name ||
        //         fee.status == PaymentStatus.owning.name)
        //     .toList();
        final unpaidFees = fees.where((fee) {
          final status = statusFromString(fee.status ?? '');
          return status == PaymentStatus.unpaid ||
              status == PaymentStatus.owning;
        }).toList();
        // print('>>> unpaid fees count: ${unpaidFees.length}');

        final totalSelectedAmount = getTotalSelectedAmount();
        final totalOutstandingAmount = getTotalOutstandingAmount(fees);

        return Scaffold(
          appBar: AppBar(
            leading: customAppBarLeadingIcon(context),
            leadingWidth: 20,
            title: Text(
              'Make Payment',
              style: setTextTheme(fontSize: 24.sp),
            ),
            actions: [
              // TextButton(
              //   onPressed: () {
              //     context.push(TransactionHistoryScreen.routeName);
              //   },
              //   child: Text(
              //     'History',
              //     style: setTextTheme(
              //       fontSize: 14.sp,
              //       fontWeight: FontWeight.w700,
              //     ),
              //   ),
              // ),
              SizedBox(width: 10.w),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(15.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Select individual fee',
                          style: setTextTheme(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(width: 10.w),
                        Switch(
                          value: isIndividualFee,
                          inactiveThumbColor: Colors.grey[600],
                          trackOutlineColor:
                              WidgetStateProperty.all(Colors.transparent),
                          onChanged: (value) {
                            setState(() {
                              isIndividualFee = value;
                              selectedFeeAmounts.clear();
                              controllers.clear();
                              if (!value) {
                                for (var fee in unpaidFees) {
                                  final amountPaid =
                                      int.parse(fee.amountPaid ?? '0');
                                  final discountAmount =
                                      int.parse(fee.discountAmount ?? '0');
                                  final totalAmount =
                                      int.parse(fee.amount ?? '0');
                                  selectedFeeAmounts[fee.paymentItem.feeName!] =
                                      totalAmount - amountPaid - discountAmount;
                                }
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    /// INDIVIDUAL FEE SELECTION
                    if (isIndividualFee) ...[
                      CustomDropdownFormField(
                        title: 'Outstanding Fees',
                        hintText: 'Select fee to pay',
                        value: selectedFeeTitle != null &&
                                unpaidFees.any((f) => f.id == selectedFeeTitle)
                            ? selectedFeeTitle
                            : null,
                        onChanged: (value) {
                          if (value != null) {
                            final fee =
                                unpaidFees.firstWhere((f) => f.id == value);
                            setState(() {
                              if (!selectedFeeAmounts.containsKey(value)) {
                                final amountPaid =
                                    int.parse(fee.amountPaid ?? '0');
                                final discountAmount =
                                    int.parse(fee.discountAmount ?? '0');
                                final totalAmount =
                                    int.parse(fee.amount ?? '0');
                                selectedFeeAmounts[value] =
                                    totalAmount - amountPaid - discountAmount;
                                selectedFeeTitle =
                                    value; // Now storing the fee ID
                              }
                            });
                          }
                        },
                        items: unpaidFees
                            .map((fee) => DropdownMenuItem(
                                  value: fee.id, // Use unique fee ID as value
                                  child: Text(
                                    '${fee.paymentItem.feeName} (N${(int.parse(fee.amount ?? '0') - int.parse(fee.amountPaid ?? '0') - int.parse(fee.discountAmount ?? '0')).toStringAsFixed(2)})',
                                    style: setTextTheme(),
                                  ),
                                ))
                            .toList(),
                      ),
                      ...selectedFeeAmounts.entries.map(
                        (entry) {
                          // final fee = fees.firstWhere(
                          //     (f) => f.paymentItem.feeName == entry.key);
                          final fee =
                              fees.firstWhereOrNull((f) => f.id == entry.key);
                          if (fee == null) return const SizedBox.shrink();
                          final controller = controllers[entry.key] ??=
                              TextEditingController(
                                  text: entry.value.toStringAsFixed(2));
                          if (!focusNodes.containsKey(entry.key)) {
                            focusNodes[entry.key] = FocusNode();
                          }
                          if (controller.text !=
                              entry.value.toStringAsFixed(2)) {
                            controller.text = entry.value.toStringAsFixed(2);
                          }
                          final focusNode = focusNodes[entry.key]!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${fee.paymentItem.feeName} (${fee.spaceSession.session} - ${fee.spaceTerm.name})',
                                    style: setTextTheme(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      lineHeight: 0.1,
                                    ),
                                  ),
                                  IconButton(
                                    icon:
                                        Icon(Icons.close, color: redShades[0]),
                                    onPressed: () {
                                      setState(() {
                                        selectedFeeAmounts.remove(entry.key);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              CustomTextFormField(
                                text:
                                    'Outstanding: N ${(int.parse(fee.amount ?? '0') - int.parse(fee.amountPaid ?? '0') - int.parse(fee.discountAmount ?? '0')).toStringAsFixed(2)}',
                                titleFontSize: 12.sp,
                                titleFontWeight: FontWeight.w400,
                                // initialValue: entry.value.toStringAsFixed(2),
                                controller: controller,
                                focusNode: focusNode,
                                keyboardType: TextInputType.number,
                                prefixIcon: Container(
                                  margin: EdgeInsets.all(8.r),
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: blueShades[2],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.r),
                                      bottomLeft: Radius.circular(5.r),
                                    ),
                                  ),
                                  child: Text(
                                    'NGN',
                                    style: setTextTheme(
                                      fontSize: 12.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                onEditingComplete: () {
                                  final value = controller.text;
                                  final amount = int.tryParse(value) ?? 0;
                                  final amountPaid =
                                      int.parse(fee.amountPaid ?? '0');
                                  final discountAmount =
                                      int.parse(fee.discountAmount ?? '0');
                                  final totalAmount =
                                      int.parse(fee.amount ?? '0');
                                  final outstanding =
                                      totalAmount - amountPaid - discountAmount;
                                  // if (amount <= outstanding) {
                                  //   setState(() {
                                  //     selectedFeeAmounts[entry.key] = amount;
                                  //   });
                                  // }
                                  if (amount <= outstanding) {
                                    setState(() {
                                      selectedFeeAmounts[entry.key] = amount;
                                    });
                                  } else {
                                    // controller.text =
                                    //     outstanding.toStringAsFixed(2);
                                    setState(() {
                                      selectedFeeAmounts[entry.key] =
                                          outstanding;
                                    });
                                  }
                                  // focusNode.unfocus();
                                },
                                onSubmitted: (value) {
                                  final amount = int.tryParse(value) ?? 0;
                                  final amountPaid =
                                      int.parse(fee.amountPaid ?? '0');
                                  final discountAmount =
                                      int.parse(fee.discountAmount ?? '0');
                                  final totalAmount =
                                      int.parse(fee.amount ?? '0');
                                  final outstanding =
                                      totalAmount - amountPaid - discountAmount;
                                  // if (amount <= outstanding) {
                                  //   setState(() {
                                  //     selectedFeeAmounts[entry.key] = amount;
                                  //   });
                                  // }
                                  if (amount <= outstanding) {
                                    setState(() {
                                      selectedFeeAmounts[entry.key] = amount;
                                    });
                                  } else {
                                    // controller.text =
                                    //     outstanding.toStringAsFixed(2);
                                    setState(() {
                                      selectedFeeAmounts[entry.key] =
                                          outstanding;
                                    });
                                  }
                                  focusNode.unfocus();
                                },
                                // onChanged: (value) {
                                //   final amount = int.tryParse(value) ?? 0;
                                //   final amountPaid =
                                //       int.parse(fee.amountPaid ?? '0');
                                //   final discountAmount =
                                //       int.parse(fee.discountAmount ?? '0');
                                //   final totalAmount =
                                //       int.parse(fee.amount ?? '0');
                                //   final outstanding =
                                //       totalAmount - amountPaid - discountAmount;
                                //   // if (amount <= outstanding) {
                                //   //   setState(() {
                                //   //     selectedFeeAmounts[entry.key] = amount;
                                //   //   });
                                //   // }
                                //   if (amount <= outstanding) {
                                //     setState(() {
                                //       selectedFeeAmounts[entry.key] = amount;
                                //     });
                                //   } else {
                                //     // controller.text =
                                //     //     outstanding.toStringAsFixed(2);
                                //     setState(() {
                                //       selectedFeeAmounts[entry.key] =
                                //           outstanding;
                                //     });
                                //   }
                                // },
                                hintText: '',
                              ),
                              SizedBox(height: 10.h),
                            ],
                          );
                        },
                      ),
                    ] else ...[
                      /// ALL FEES TOGETHER
                      CustomTextFormField(
                        text: 'How much are you paying?',
                        initialValue: '${context.watch<UserProvider>().model?.currency} ${numberFormat.format(totalOutstandingAmount.toInt())}',
                        // initialValue:
                        //     'N ${totalOutstandingAmount.toStringAsFixed(2)}',
                        keyboardType: TextInputType.number,
                        prefixIcon: Container(
                          margin: EdgeInsets.all(8.r),
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: blueShades[2],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.r),
                              bottomLeft: Radius.circular(5.r),
                            ),
                          ),
                          child: Text(
                            '${context.watch<UserProvider>().model?.currency}',
                            style: setTextTheme(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        hintText: '',
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        'This amount will pay for the fee items below...',
                        style: setTextTheme(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      ...unpaidFees.map(
                        (fee) => Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 3.r,
                                      height: 3.r,
                                      margin: EdgeInsets.only(right: 8.w),
                                      decoration: BoxDecoration(
                                        color: ThemeProvider().isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        '${fee.paymentItem.feeName} (${fee.spaceSession.session} - ${fee.spaceTerm.name}):',
                                        style: setTextTheme(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 4,
                                child: Text(
                                  '${context.watch<UserProvider>().model?.currency} ${numberFormat.format(int.parse(fee.amount ?? '0') - int.parse(fee.amountPaid ?? '0') - int.parse(fee.discountAmount ?? '0'))}',
                                  style: setTextTheme(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    /// Totals & Actions
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount:',
                          style: setTextTheme(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          isIndividualFee
                              ? '${context.watch<UserProvider>().model?.currency} ${numberFormat.format(totalSelectedAmount)}'
                              : '${context.watch<UserProvider>().model?.currency} ${numberFormat.format(totalOutstandingAmount)}',
                          style: setTextTheme(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Outstanding Amount:',
                          style: setTextTheme(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${context.watch<UserProvider>().model?.currency} ${numberFormat.format(totalOutstandingAmount)}',
                          style: setTextTheme(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      'Select Payment method',
                      style: setTextTheme(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Wallet balance: ${context.watch<UserProvider>().model?.currency} ${numberFormat.format(int.parse(context.read<UserProvider>().singleSpace?.spaceWallet?.balance?.toString() ?? '0'))}',
                      style: setTextTheme(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Buttons(
                      width: double.infinity,
                      text: 'Pay with wallet',
                      textColor: Colors.white,
                      fontSize: 14.sp,
                      isLoading: false,
                      onTap: () {
                        final walletBalance = int.tryParse(
        context.read<UserProvider>().singleSpace?.spaceWallet?.balance ?? '0',
      ) ?? 0;

  final amountToPay = isIndividualFee
      ? totalSelectedAmount
      : totalOutstandingAmount.toInt();

  if (amountToPay == 0) {
       showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: 'Please select an amount to pay.',
            backgroundColor: redShades[9],
          ));
    return;
  }

  if (walletBalance < amountToPay) {
     showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: 'Insufficient wallet balance to make this payment.',
            backgroundColor: redShades[9],
          ));
    return;
  }

                      },
                    ),
                    SizedBox(height: 10.h),
                    Buttons(
                      width: double.infinity,
                      text: 'Pay with card/bank transfer',
                      textColor: Colors.white,
                      fontSize: 14.sp,
                      boxColor: redShades[0],
                      isLoading: false,
                      onTap: () {
                        if (selectedFeeAmounts.isNotEmpty) {
                          double rawAmount = isIndividualFee
                              ? totalSelectedAmount
                              : totalOutstandingAmount;

                          if (rawAmount <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Amount must be greater than 0 to proceed with payment."),
                              ),
                            );
                            return;
                          }

                          double finalAmount =
                              (rawAmount ).toInt().toDouble();

                          // print(
                          //     "Paying NGN ${rawAmount.toString()} as $finalAmount kobo");
                          makePayment(
                            context,
                            // amount: (totalSelectedAmount * 100).roundToDouble(),
                            amount: finalAmount,
                            email:
                                fees.first.student?.user?.email?.isNotEmpty ==
                                        true
                                    ? fees.first.student!.user!.email!
                                    : 'talk2ugomatt@gmail.com',
                          );
                          // handle card/bank payment
                          //   PaystackFlutter().pay(
                          //     context: context,
                          //     secretKey:
                          //         'sk_test_9cd45dbcf0b9413ee0c0a65a9250d640e081cadf', // Your Paystack secret key gotten from your Paystack dashboard.
                          //     amount:
                          //         60000, // The amount to be charged in the smallest currency unit. If amount is 600, multiply by 100(600*100)
                          //     email:
                          //         'theelitedevelopers1@gmail.com', // The customer's email address.
                          //     callbackUrl:
                          //         'https://callback.com', // The URL to which Paystack will redirect the user after the transaction.
                          //     showProgressBar:
                          //         true, // If true, it shows progress bar to inform user an action is in progress when getting checkout link from Paystack.
                          //     paymentOptions: [
                          //       PaymentOption.card,
                          //       PaymentOption.bankTransfer,
                          //       PaymentOption.mobileMoney
                          //     ],
                          //     currency: Currency.NGN,
                          //     metaData: {
                          //       "product_name": "Nike Sneakers",
                          //       "product_quantity": 3,
                          //       "product_price": 24000
                          //     }, // Additional metadata to be associated with the transaction
                          //     onSuccess: (paystackCallback) {
                          //       ScaffoldMessenger.of(context)
                          //           .showSnackBar(SnackBar(
                          //         content: Text(
                          //             'Transaction Successful::::${paystackCallback.reference}'),
                          //         backgroundColor: Colors.blue,
                          //       ));
                          //     }, // A callback function to be called when the payment is successful.
                          //     onCancelled: (paystackCallback) {
                          //       ScaffoldMessenger.of(context)
                          //           .showSnackBar(SnackBar(
                          //         content: Text(
                          //             'Transaction Failed/Not successful::::${paystackCallback.reference}'),
                          //         backgroundColor: Colors.red,
                          //       ));
                          //     }, // A callback function to be called when the payment is canceled.
                          //   );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void makePayment(
    BuildContext context, {
    required double amount,
    required String email,
  }) async {
    // final uniqueTransRef = PayWithPayStack().generateUuidV4();
    final uniqueTransRef = 'TX-${DateTime.now().millisecondsSinceEpoch}';
    PayWithPayStack().now(
        context: context,
        secretKey: "pk_live_0600e4073b73f1d7c008e55974e5b588a5ddc0ee",
        // secretKey: "sk_test_9cd45dbcf0b9413ee0c0a65a9250d640e081cadf",
        customerEmail: email,
        reference: uniqueTransRef,
        currency: "NGN",
        amount: amount,
        callbackUrl: "https://google.com",
        transactionCompleted: (paymentData) {
          debugPrint(paymentData.toString());
        },
        transactionNotCompleted: (reason) {
          debugPrint("==> Transaction failed reason $reason");
        });
    //   final feeProvider = Provider.of<AccountingProvider>(context, listen: false);
    //   final totalAmount = isIndividualFee
    //       ? getTotalSelectedAmount().toInt()
    //       : getTotalOutstandingAmount(feeProvider.studentPay).toInt();

    //   if (totalAmount <= 0) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Please select an amount to pay.'),
    //         backgroundColor: Colors.red,
    //       ),
    //     );
    //     return;
    //   }

    //   // Prepare metadata as custom fields
    //   Map<String, String> customFields = {};
    //   // if (isIndividualFee) {
    //   //   customFields['selected_fees'] = jsonEncode(
    //   //     selectedFeeAmounts.map((key, value) => MapEntry(key, value.toString())),
    //   //   );
    //   // } else {
    //   //   customFields['selected_fees'] = jsonEncode(
    //   //     feeProvider.studentPay
    //   //         .where((fee) {
    //   //           final status = statusFromString(fee.status ?? '');
    //   //           return status == PaymentStatus.unpaid || status == PaymentStatus.owning;
    //   //         })
    //   //         .fold<Map<String, String>>({}, (map, fee) {
    //   //           final outstanding = int.parse(fee.amount ?? '0') -
    //   //               int.parse(fee.amountPaid ?? '0') -
    //   //               int.parse(fee.discountAmount ?? '0');
    //   //           map[fee.paymentItem.feeName!] = outstanding.toString();
    //   //           return map;
    //   //         }),
    //   //   );
    //   // }

    //   Charge charge = Charge()
    //     ..amount = totalAmount * 100 // Convert to kobo
    //     ..email = 'theelitedevelopers1@gmail.com' // Replace with dynamic email
    //     ..currency = 'NGN'
    //     ..reference = 'ref_${DateTime.now().millisecondsSinceEpoch}';

    //   // Add custom fields for metadata
    //   customFields.forEach((key, value) {
    //     charge.putCustomField(key, value);
    //   });

    //   try {
    //     CheckoutResponse response = await PaystackPlugin().checkout(
    //       context,
    //       method: CheckoutMethod.selectable, // Card, bank transfer, etc.
    //       charge: charge,
    //       fullscreen: false,
    //     );

    //     if (response.status) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text('Transaction Successful: ${response.reference}'),
    //           backgroundColor: Colors.blue,
    //         ),
    //       );
    //       setState(() {
    //         if (isIndividualFee) {
    //           selectedFeeAmounts.clear();
    //         } else {
    //           selectedFeeAmounts.clear();
    //         }
    //       });
    //     } else {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content:
    //               Text('Transaction Failed: ${response.message ?? "Cancelled"}'),
    //           backgroundColor: Colors.red,
    //         ),
    //       );
    //     }
    //   } catch (e) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Payment Error: $e'),
    //         backgroundColor: Colors.red,
    //       ),
    //     );
    //   }
  }
}

// class _MakePaymentScreenState extends State<MakePaymentScreen> {
//   bool isIndividualFee = false;
//   Map<String, double> selectedFeeAmounts = {};
//   String? selectedFeeTitle;

//   @override
//   void initState() {
//     super.initState();
//     if (!isIndividualFee) {
//       // Initialize with all unpaid/uncleared fees
//       for (var fee in fees.where((fee) =>
//           fee.status == PaymentStatus.unpaid ||
//           fee.status == PaymentStatus.owning)) {
//         selectedFeeAmounts[fee.title] = fee.outstandingAmount;
//       }
//     }
//   }

//   double get totalSelectedAmount =>
//       selectedFeeAmounts.values.fold(0, (sum, amount) => sum + amount);

//   double get totalOutstandingAmount => fees
//       .where((fee) =>
//           fee.status == PaymentStatus.unpaid ||
//           fee.status == PaymentStatus.owning)
//       .fold(0, (sum, fee) => sum + fee.outstandingAmount);

//   @override
//   Widget build(BuildContext context) {
//     final unpaidFees = fees
//         .where((fee) =>
//             fee.status == PaymentStatus.unpaid ||
//             fee.status == PaymentStatus.owning)
//         .toList();

//     return Scaffold(
//       appBar: AppBar(
//         leading: customAppBarLeadingIcon(context),
//         leadingWidth: 20,
//         title: Text(
//           'Make Payment',
//           style: setTextTheme(fontSize: 24.sp),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               context.push(TransactionHistoryScreen.routeName);
//             },
//             child: Text(
//               'History',
//               style: setTextTheme(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//           SizedBox(width: 10.w),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(15.r),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       'Select individual fee',
//                       style: setTextTheme(
//                         // fontSize: 12.sp,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     SizedBox(width: 10.w),
//                     Switch(
//                       value: isIndividualFee,
//                       inactiveThumbColor: Colors.grey[600],
//                       trackOutlineColor:
//                           WidgetStateProperty.all(Colors.transparent),
//                       onChanged: (value) {
//                         setState(() {
//                           isIndividualFee = value;
//                           selectedFeeAmounts.clear();
//                           if (!value) {
//                             // Reset to all fees if switching back
//                             for (var fee in unpaidFees) {
//                               selectedFeeAmounts[fee.title] =
//                                   fee.outstandingAmount;
//                             }
//                           }
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10.h),
//                 if (isIndividualFee) ...[
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 10.h),
//                       CustomDropdownFormField(
//                         title: 'Outstanding Fees',
//                         hintText: 'Select fee to pay',
//                         value: selectedFeeTitle,
//                         onChanged: (value) {
//                           if (value != null) {
//                             final fee =
//                                 unpaidFees.firstWhere((f) => f.title == value);
//                             setState(() {
//                               if (!selectedFeeAmounts.containsKey(value)) {
//                                 selectedFeeAmounts[value] =
//                                     fee.outstandingAmount;
//                               }
//                             });
//                           }
//                         },
//                         items: unpaidFees
//                             .map((fee) => DropdownMenuItem(
//                                   value: fee.title,
//                                   child: Text(
//                                     '${fee.title} (N${fee.outstandingAmount.toStringAsFixed(2)})',
//                                     style: setTextTheme(),
//                                   ),
//                                 ))
//                             .toList(),
//                       ),
//                       ...selectedFeeAmounts.entries.map(
//                         (entry) {
//                           final fee =
//                               fees.firstWhere((f) => f.title == entry.key);
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     '${fee.title} (${fee.session} - ${fee.term})',
//                                     style: setTextTheme(
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.w700,
//                                       lineHeight: 0.1,
//                                     ),
//                                   ),
//                                   IconButton(
//                                     icon:
//                                         Icon(Icons.close, color: redShades[0]),
//                                     onPressed: () {
//                                       setState(() {
//                                         selectedFeeAmounts.remove(entry.key);
//                                       });
//                                     },
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 child: CustomTextFormField(
//                                   text:
//                                       'Outstanding: N ${fee.outstandingAmount.toStringAsFixed(2)}',
//                                   titleFontSize: 12.sp,
//                                   titleFontWeight: FontWeight.w400,
//                                   initialValue: entry.value.toStringAsFixed(2),
//                                   keyboardType: TextInputType.number,
//                                   prefixIcon: Container(
//                                     margin: EdgeInsets.all(8.r),
//                                     padding: EdgeInsets.all(8.r),
//                                     decoration: BoxDecoration(
//                                       color: blueShades[2],
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(5.r),
//                                         bottomLeft: Radius.circular(5.r),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       'NGN',
//                                       style: setTextTheme(
//                                         fontSize: 12.sp,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                   ),
//                                   onChanged: (value) {
//                                     final amount = double.tryParse(value) ?? 0;
//                                     if (amount <= fee.outstandingAmount) {
//                                       setState(() {
//                                         selectedFeeAmounts[entry.key] = amount;
//                                       });
//                                     }
//                                   },
//                                   hintText: '',
//                                 ),
//                               ),
//                               SizedBox(height: 10.h),
//                             ],
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ] else ...[
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomTextFormField(
//                         text: 'How much are you paying?',
//                         initialValue:
//                             'N ${totalOutstandingAmount.toStringAsFixed(2)}',
//                         keyboardType: TextInputType.number,
//                         prefixIcon: Container(
//                           margin: EdgeInsets.all(8.r),
//                           padding: EdgeInsets.all(8.r),
//                           decoration: BoxDecoration(
//                             color: blueShades[2],
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(5.r),
//                               bottomLeft: Radius.circular(5.r),
//                             ),
//                           ),
//                           child: Text(
//                             'NGN',
//                             style: setTextTheme(
//                               fontSize: 12.sp,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                         hintText: '',
//                       ),
//                       SizedBox(height: 15.h),
//                       Text(
//                         'This amount will pay for the fee items below; You can either continue or select fees individually by toggling the button above',
//                         style: setTextTheme(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                       SizedBox(height: 15.h),
//                       ...unpaidFees.map(
//                         (fee) => Padding(
//                           padding: EdgeInsets.only(top: 10.h),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: 3.r,
//                                       height: 3.r,
//                                       margin: EdgeInsets.only(right: 8.w),
//                                       decoration: BoxDecoration(
//                                         color: ThemeProvider().isDarkMode
//                                             ? Colors.white
//                                             : Colors.black,
//                                         shape: BoxShape.circle,
//                                       ),
//                                     ),
//                                     Flexible(
//                                       child: Text(
//                                         '${fee.title} (${fee.session} - ${fee.term}):',
//                                         style: setTextTheme(
//                                           fontSize: 11.sp,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width / 4,
//                                 child: Text(
//                                   'NGN ${fee.outstandingAmount.toStringAsFixed(2)}',
//                                   style: setTextTheme(
//                                     fontSize: 11.sp,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//                 SizedBox(height: 20.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Total Amount:',
//                       style: setTextTheme(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width / 4,
//                       child: Text(
//                         'N ${totalSelectedAmount.toStringAsFixed(2)}',
//                         style: setTextTheme(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Divider(height: 5.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Outstanding Amount:',
//                       style: setTextTheme(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width / 4,
//                       child: Text(
//                         'N ${totalOutstandingAmount.toStringAsFixed(2)}',
//                         style: setTextTheme(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 30.h),
//                 Text(
//                   'Select Payment method',
//                   style: setTextTheme(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 Text(
//                   'Wallet balance: N23,000',
//                   style: setTextTheme(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 Buttons(
//                   width: double.infinity,
//                   text: 'Pay with wallet',
//                   textColor: Colors.white,
//                   fontSize: 14.sp,
//                   boxColor: blueShades[0],
//                   isLoading: false,
//                   onTap: () {
//                     if (selectedFeeAmounts.isNotEmpty) {
//                       // Handle payment
//                     }
//                   },
//                 ),
//                 SizedBox(height: 10.h),
//                 Buttons(
//                   width: double.infinity,
//                   text: 'Pay with card/bank transfer',
//                   textColor: Colors.white,
//                   fontSize: 14.sp,
//                   boxColor: redShades[0],
//                   isLoading: false,
//                   onTap: () {
//                     if (selectedFeeAmounts.isNotEmpty) {
//                       // Handle payment
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
