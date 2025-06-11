import 'dart:io';
import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/components/shared_widget/copyable_text_widget.dart';
import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/accounting/transaction_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class TransactionDetailsScreen extends StatefulWidget {
  static const routeName = '/transaction-details';
  final TransactionModel transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  final screenshotController = ScreenshotController();
  bool isSharing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaction Details',
          style: setTextTheme(fontSize: 24.sp),
        ),
        leading: customAppBarLeadingIcon(context),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    _buildStatusCard(),
                    SizedBox(height: 20.h),
                    _buildDetailsCard(),
                    if (widget.transaction.status == TransactionStatus.failed &&
                        widget.transaction.failureReason != null) ...[
                      SizedBox(height: 20.h),
                      _buildFailureCard(),
                    ],
                  ],
                ),
              ),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: Buttons(
                    onTap: () {
                      isSharing ? null : _shareAsImage();
                    },
                    text: 'Share as Image',
                    height: 35.h,
                    isLoading: false,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Buttons(
                    onTap: () {
                      isSharing ? null : _shareAsPDF();
                    },
                    text: 'Share as PDF',
                    boxColor: redShades[2],
                    height: 35.h,
                    isLoading: false,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final isSuccessful =
        widget.transaction.status == TransactionStatus.successful;

    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: isSuccessful
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              'N ${NumberFormat("#,##0.00").format(widget.transaction.amount)}',
              style: setTextTheme(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: isSuccessful ? Colors.green : Colors.red,
              ),
            ),
            Text(
              widget.transaction.status.name.toUpperCase(),
              style: setTextTheme(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isSuccessful ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 5.h),
            CopyableText(
              label: 'Trx ID',
              value: widget.transaction.id,
              // spaced: true,
              shouldCopy: true,
              spaceWidth: 50.w,
              feedbackPosition: CopyFeedbackPosition.above,
              labelTextStyle: setTextTheme(
                fontSize: 14.sp,
                color: whiteShades[3],
              ),
              valueTextStyle: setTextTheme(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildDetailRow('Student Name', widget.transaction.studentName),
            _buildDetailRow('Class', widget.transaction.studentClass),
            _buildDetailRow(
              'Date & Time',
              DateFormat('dd MMM, yyyy - HH:mm')
                  .format(widget.transaction.date),
            ),
            _buildDetailRow(
                'Payment Method', widget.transaction.paymentTypeName),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: ThemeProvider().isDarkMode ? blueShades[15] : blueShades[17],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.transaction.fees != null &&
              widget.transaction.fees!.isNotEmpty) ...[
            Text(
              'Fees Paid',
              style: setTextTheme(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.h),
            ...widget.transaction.fees!.map((fee) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fee.title,
                              style: setTextTheme(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${fee.session} - ${fee.term}',
                              style: setTextTheme(
                                fontSize: 10.sp,
                                color: whiteShades[3],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'N ${NumberFormat("#,##0.00").format(fee.amount)}',
                        style: setTextTheme(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (fee != widget.transaction.fees!.last) _buildDivider(),
                ],
              );
            }),
            _buildDivider(),
          ] else ...[
            _buildDetailRow('Transaction Title', widget.transaction.feeTitle),
            _buildDivider(),
          ],
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discount Applied',
                style: setTextTheme(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '- N ${NumberFormat("#,##0.00").format(widget.transaction.discountAmount)}',
                style: setTextTheme(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          _buildDivider(),
          _buildDetailRow(
            'Total Amount',
            'N ${NumberFormat("#,##0.00").format(widget.transaction.amount)}',
          ),
        ],
      ),
    );
  }

  Widget _buildFailureCard() {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 24.sp,
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Failure Reason',
                  style: setTextTheme(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
                Text(
                  widget.transaction.failureReason!,
                  style: setTextTheme(
                    fontSize: 14.sp,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareAsImage() async {
    try {
      setState(() => isSharing = true);

      final image = await screenshotController.capture(
        delay: const Duration(milliseconds: 100),
        pixelRatio: 3.0,
      );

      if (image == null) {
        throw Exception('Failed to capture screenshot');
      }

      final tempDir = await getTemporaryDirectory();
      final file = File(
          '${tempDir.path}/receipt_${widget.transaction.id}_${DateTime.now().millisecondsSinceEpoch}.png');

      await file.writeAsBytes(image);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Transaction Receipt - ${widget.transaction.id}',
      );
    } catch (e) {
      debugPrint('Error sharing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share image: $e')),
      );
    } finally {
      setState(() => isSharing = false);
    }
  }

  Future<void> _shareAsPDF() async {
    try {
      setState(() => isSharing = true);

      final image = await screenshotController.capture(
        delay: const Duration(milliseconds: 100),
        pixelRatio: 3.0,
      );

      if (image == null) {
        throw Exception('Failed to capture screenshot');
      }

      final pdf = pw.Document();
      final imageProvider = pw.MemoryImage(image);

      pdf.addPage(
        pw.Page(
          margin: const pw.EdgeInsets.all(15),
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(imageProvider),
            );
          },
        ),
      );

      final tempDir = await getTemporaryDirectory();
      final file = File(
          '${tempDir.path}/receipt_${widget.transaction.id}_${DateTime.now().millisecondsSinceEpoch}.pdf');

      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Transaction Receipt - ${widget.transaction.id}',
      );
    } catch (e) {
      debugPrint('Error sharing PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share PDF: $e')),
      );
    } finally {
      setState(() => isSharing = false);
    }
  }
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: setTextTheme(
            fontSize: 14.sp,
            color: whiteShades[3],
          ),
        ),
        Text(
          value,
          style: setTextTheme(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildDivider() {
  return Divider(
    color: whiteShades[3].withValues(alpha: 0.1),
    height: 1,
  );
}
