import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

import '../../../../data/models/enter_score_widget_model.dart';

class PdfGenerator {
  final ResultData? myData;
  final Student studentResultModel;

  PdfGenerator(this.myData, this.studentResultModel);

  Future<void> generatedANdDownloadPdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          header: (pw.Context context) => pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Text(
                  'Student Results - ${myData?.student?.firstName ?? ''} ${myData?.student?.lastName ?? ''}',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
              ),
          build: (pw.Context context) => [
                pw.Column(
                  children: [
                    _buildRows(
                      titleLeft: 'Academic session',
                      subtLeft: myData?.session?.session ?? '',
                      titleRight: 'Academic term',
                      subtRight: '${myData?.term?.name}',
                    ),
                    pw.Divider(height: 5),
                    _buildRows(
                      titleLeft: 'Total score',
                      subtLeft: '${myData?.totalScore}',
                      titleRight: 'Average score',
                      subtRight: '${myData?.averageScore}',
                    ),
                    pw.Divider(height: 5),
                    _buildRows(
                      titleLeft: 'Best subject',
                      subtLeft: '${myData?.bestSubject?.name}',
                      titleRight: 'Least Subject',
                      subtRight: '${myData?.leastSubject?.name}',
                    ),
                    pw.Divider(height: 5),
                    _buildRows(
                      titleLeft: 'Grade',
                      subtLeft: '${myData?.overallGrading?.grade}',
                      titleRight: 'Position',
                      subtRight:
                          '${myData?.position} of ${myData?.positionOutOf}',
                      isContainer: true,
                    ),
                    pw.Divider(height: 5),
                    _buildRows(
                      titleLeft: 'Academic session',
                      subtLeft: myData?.session?.session ?? '',
                      titleRight: 'Academic term',
                      subtRight: '${myData?.term?.name}',
                    ),
                    pw.SizedBox(height: 20),
                    _headerCont(
                      leadingTxt: 'Subjects',
                      trailingTxt: 'Score',
                    ),
                    pw.Column(
                      children: List.generate(
                        myData?.subjects?.length ?? 0,
                        (index) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 10),
                            child: _buildTile(myData),
                          );
                        },
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    _headerCont(
                      leadingTxt: 'Psychomotor domain',
                    ),
                    if (myData?.cognitiveKeyRatings != null)
                      ...List.generate(myData!.cognitiveKeyRatings?.length ?? 0,
                          (v) {
                        final value = myData?.cognitiveKeyRatings?[v];
                        return _assessmentCont(
                          assessment: value?.cognitiveKey?.domain ?? '',
                          assessmentScore: value?.rating ?? 0,
                        );
                      }),
                    pw.SizedBox(height: 20),
                    pw.Column(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.blue,
                            borderRadius: const pw.BorderRadius.only(
                              topLeft: pw.Radius.circular(10),
                              topRight: pw.Radius.circular(10),
                            ),
                          ),
                          child: pw.Row(
                            children: [
                              pw.SizedBox(width: 5),
                              pw.Text(
                                "CLASS/FORM TEACHER'S COMMENT",
                                style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.grey,
                            borderRadius: const pw.BorderRadius.only(
                              bottomLeft: pw.Radius.circular(10),
                              bottomRight: pw.Radius.circular(10),
                            ),
                          ),
                          child: pw.Text('${myData?.formTeacherComment}'),
                        )
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Column(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.blue,
                            borderRadius: const pw.BorderRadius.only(
                              topLeft: pw.Radius.circular(10),
                              topRight: pw.Radius.circular(10),
                            ),
                          ),
                          child: pw.Row(
                            children: [
                              pw.SizedBox(width: 5),
                              pw.Text(
                                "PRINCIPAL'S COMMENT",
                                style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.grey,
                            borderRadius: const pw.BorderRadius.only(
                              bottomLeft: pw.Radius.circular(10),
                              bottomRight: pw.Radius.circular(10),
                            ),
                          ),
                          child: pw.Text("${myData?.principalComment}"),
                        )
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Column(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.blue,
                            borderRadius: const pw.BorderRadius.only(
                              topLeft: pw.Radius.circular(10),
                              topRight: pw.Radius.circular(10),
                            ),
                          ),
                          child: pw.Row(
                            children: [
                              pw.SizedBox(width: 5),
                              pw.Text(
                                "KEYS TO RATING",
                                style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 18,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        pw.Container(
                          decoration: pw.BoxDecoration(
                            color: PdfColors.grey,
                            borderRadius: const pw.BorderRadius.only(
                              bottomLeft: pw.Radius.circular(10),
                              bottomRight: pw.Radius.circular(10),
                            ),
                          ),
                          child: pw.Table(
                            border: pw.TableBorder.all(
                              color: PdfColors.black,
                              width: 0.5,
                            ),
                            columnWidths: const {
                              0: pw.FlexColumnWidth(1.5), // score
                              1: pw.FlexColumnWidth(1.0), // grade
                              2: pw.FlexColumnWidth(2.0), // remark
                            },
                            children: [
                              pw.TableRow(
                                children: [
                                  _buildTableCell('SCORES', isHeader: true),
                                  _buildTableCell('GRADE', isHeader: true),
                                  _buildTableCell('REMARK', isHeader: true),
                                ],
                              ),
                              pw.TableRow(
                                children: [
                                  _buildTableCell('70 - 100'),
                                  _buildTableCell('A'),
                                  _buildTableCell('Excellent'),
                                ],
                              ),
                              pw.TableRow(
                                children: [
                                  _buildTableCell('60 - 69'),
                                  _buildTableCell('B'),
                                  _buildTableCell('Very Good'),
                                ],
                              ),
                              pw.TableRow(
                                children: [
                                  _buildTableCell('50 - 59'),
                                  _buildTableCell('C'),
                                  _buildTableCell('Good'),
                                ],
                              ),
                              pw.TableRow(
                                children: [
                                  _buildTableCell('40 - 49'),
                                  _buildTableCell('D'),
                                  _buildTableCell('Fair'),
                                ],
                              ),
                              pw.TableRow(
                                children: [
                                  _buildTableCell('30 - 39'),
                                  _buildTableCell('E'),
                                  _buildTableCell('Poor'),
                                ],
                              ),
                              pw.TableRow(
                                children: [
                                  _buildTableCell('0 - 29'),
                                  _buildTableCell('F'),
                                  _buildTableCell('Very Poor'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
    );
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/student_result.pdf");
    await file.writeAsBytes(await pdf.save());
    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'student_result.pdf');
  }

  pw.Widget _buildRows({
    required String titleLeft,
    required String subtLeft,
    required String titleRight,
    required String subtRight,
    bool isContainer = false,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(titleLeft,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(subtLeft),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(titleRight,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(subtRight),
          ],
        ),
      ],
    );
  }

  pw.Widget _headerCont({required String leadingTxt, String? trailingTxt}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            leadingTxt,
            style: pw.TextStyle(
                color: PdfColors.white, fontWeight: pw.FontWeight.bold),
          ),
          if (trailingTxt != null)
            pw.Text(
              trailingTxt,
              style: pw.TextStyle(
                  color: PdfColors.white, fontWeight: pw.FontWeight.bold),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildTile(ResultData? data) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(data?.subjects?[0].name ?? ''),
          pw.Text('${data?.subjects?[0].name}'),
        ],
      ),
    );
  }

  pw.Widget _assessmentCont(
      {required String assessment, required int assessmentScore}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(assessment),
          pw.Text('$assessmentScore'),
        ],
      ),
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
