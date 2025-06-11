import 'dart:developer';

import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/enter_score_widget_model.dart';
import 'package:cloudnottapp2/src/data/models/student_result_model.dart';
import 'package:cloudnottapp2/src/data/providers/result_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'widgets/result_download.dart';

class ResultViewScreen extends StatefulWidget {
  static const routeName = '/result_view_screen';
  final Student studentResultModel;
  final String termId;
  final String sessionId;
  final String assessmentId;
  final String userId;
  final String spaceId;
  final String classId;
  const ResultViewScreen(
      {super.key,
      required this.studentResultModel,
      required this.userId,
      required this.termId,
      required this.sessionId,
      required this.assessmentId,
      required this.spaceId,
      required this.classId});

  @override
  State<ResultViewScreen> createState() => _ResultViewScreenState();
}

class _ResultViewScreenState extends State<ResultViewScreen> {
  TextEditingController formTeacherCont = TextEditingController();
  TextEditingController principalCont = TextEditingController();
  String? role;
  bool isEditing = false;
  bool isPrincipalEditting = false;
  @override
  void initState() {
    super.initState();
  
    final futures = [
      Provider.of<ResultProvider>(context, listen: false).getFinalResult(
        context: context,
        spaceId: widget.spaceId,
        sessionId: widget.sessionId,
        termId: widget.termId,
        userId: widget.userId,
        assessmentId: widget.assessmentId,
        classId: widget.classId,
      ),
      Provider.of<ResultProvider>(context, listen: false).getBasicGrading(
        context: context,
        spaceId: widget.spaceId,
        assessmentId: widget.assessmentId,
      ),
      // Note: You have this call duplicated in your original code
      Provider.of<ResultProvider>(context, listen: false).getGradingSystems(
        context: context,
        spaceId: widget.spaceId,
        assessmentId: widget.assessmentId,
      ),
      Provider.of<ResultProvider>(context, listen: false).getTermDate(
        context: context,
        spaceId: widget.spaceId,
        sessionId: widget.sessionId,
        termId: widget.termId,
      ),
    ];

    // Wait for all futures to complete
    Future.wait(futures).then((_) {}).catchError((error) {
      // Handle errors here
      print('Error loading data: $error');
    });
    role = localStore.get('role', defaultValue: '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final resultProvider =
          Provider.of<ResultProvider>(context, listen: false);
      formTeacherCont.text =
          resultProvider.resultData?.formTeacherComment ?? '';
      principalCont.text = resultProvider.resultData?.principalComment ?? '';
    });
  }

  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void togglePrincipalEdit() {
    setState(() {
      isPrincipalEditting = !isPrincipalEditting;
    });
  }
 bool _isDialogShowing = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: customAppBarLeadingIcon(context),
        title: Text(
          "${widget.studentResultModel.user?.lastName} ${widget.studentResultModel.user?.firstName} result",
          style: setTextTheme(fontSize: 24.sp),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              PdfGenerator(context.read<ResultProvider>().resultData,
                      widget.studentResultModel)
                  .generatedANdDownloadPdf(context);
            },
            child: Icon(
              Icons.file_download_outlined,
              size: 24.r,
              color: blueShades[0],
            ),
          ),
          SizedBox(width: 10.w)
        ],
      ),
      body: Consumer<ResultProvider>(builder: (context, snapshot, _) {
        if (snapshot.isLoading) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
            child: SkeletonItem(
              child: Column(
                children: [
                  // Skeleton for the Container Box
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ThemeProvider().isDarkMode
                          ? Colors.transparent
                          : blueShades[17],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: List.generate(
                          5,
                          (index) => Column(
                                children: [
                                  _skeletonRow(),
                                  if (index < 4) Divider(height: 5),
                                ],
                              )),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  _skeletonHeader(),

                  Column(
                    children: List.generate(
                        5,
                        (index) => Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: _skeletonSubjectTile(),
                            )),
                  ),
                ],
              ),
            ),
          );
        }
if (snapshot.isError) {
  Future.microtask(() {
    // Check if dialog is already showing
    if (!_isDialogShowing) {
      _isDialogShowing = true;
      
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Dismiss',
        barrierColor: Colors.black.withOpacity(0.3),
        pageBuilder: (context, animation1, animation2) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 16),
                  const Text(
                    'No result found',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Reset the flag when dialog is dismissed
                      _isDialogShowing = false;
                      // customAppBarLeadingIcon(context);
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        },
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
            scale: CurvedAnimation(parent: a1, curve: Curves.easeOutBack),
            child: widget,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ).then((_) {
        // Also reset the flag when dialog is dismissed by tapping outside
        _isDialogShowing = false;
      });
      
      snapshot.setError(false);
    } else {
      // Dialog is already showing, just reset the error state
      snapshot.setError(false);
    }
  });
}

// if (snapshot.isError) {
//    Future.microtask(() {
//   showGeneralDialog(
//     context: context,
//     barrierDismissible: true,
//     barrierLabel: 'Dismiss',
//     barrierColor: Colors.black.withOpacity(0.3), // 👈 Transparent background
//     pageBuilder: (context, animation1, animation2) {
//       return Center(
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.8,
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.error_outline, color: Colors.red, size: 50),
//               const SizedBox(height: 16),
//               const Text(
//                 'No result found',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 24),
//               TextButton(
//                 onPressed: () {
//                    Navigator.of(context).pop();
//                   // customAppBarLeadingIcon(context);
//                 },
//                 child: const Text('Go Back'),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//     transitionBuilder: (context, a1, a2, widget) {
//       return ScaleTransition(
//         scale: CurvedAnimation(parent: a1, curve: Curves.easeOutBack),
//         child: widget,
//       );
//     },
//     transitionDuration: const Duration(milliseconds: 300),
//   );

//   snapshot.setError(false);
// });
// }
        final data = snapshot.resultData;
        final Map<int, List<Subject>> mySub = groupBy<Subject, int>(
          data?.subjects ?? [],
          (subject) => int.tryParse(subject.id.toString()) ?? 0,
        );
        String color = context.read<UserProvider>().model?.colour ?? '#000000';

        int? colorValue;
        try {
          colorValue = int.tryParse(color.replaceAll('#', '0xff'));
        } catch (e) {
          colorValue = 0xFF000000;
        }
        // final rawCognitiveKeys =
        //     context.read<ResultProvider>().cognitiveKeyRating ?? [];
        // final allClassCognitiveKeys =
        //     context.read<ResultProvider>().cognitiveKeyRating ?? [];
        final allClassCognitiveKeys = snapshot.cognitiveKeyRating ?? [];
        final studentRatings = data?.cognitiveKeyRatings ?? [];
        print('allClassCognitiveKeys: ${allClassCognitiveKeys.map((e) => {
              'cognitiveKeyId': e.cognitiveKey?.cognitiveKeyId,
              'domain': e.cognitiveKey?.domain,
              'name': e.cognitiveKey?.name,
              'rating': e.rating
            }).toList()}');
        print('studentRatings: ${studentRatings.map((e) => {
              'cognitiveKeyId': e.cognitiveKey?.cognitiveKeyId,
              'rating': e.rating
            }).toList()}');
        final Map<String, CognitiveKeyRating> ratingMap = {
          for (var r in studentRatings) r.cognitiveKey?.cognitiveKeyId ?? '': r,
        };

        final groupedByDomain = groupBy<CognitiveKeyRating, String>(
          allClassCognitiveKeys.where((rating) =>
              rating.cognitiveKey != null &&
              rating.cognitiveKey!.domain != null),
          (rating) => rating.cognitiveKey!.domain!,
        );
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15.r),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: ThemeProvider().isDarkMode
                            ? Colors.transparent
                            : blueShades[17],
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(
                          15.r,
                        )),
                    child: Column(
                      children: [
                        _buildRows(
                          context,
                          titleLeft: 'Academic session',
                          subtLeft: data?.session?.session ?? '',
                          titleRight: 'Academic term',
                          subtRight: '${data?.term?.name ?? ''}',
                        ),
                        Divider(height: 5),
                        _buildRows(
                          context,
                          titleLeft: 'Total score',
                          subtLeft: '${data?.totalScore}',
                          titleRight: 'Average score',
                          subtRight: '${data?.averageScore}',
                        ),
                        Divider(height: 5),
                        _buildRows(
                          context,
                          titleLeft: 'Best subject',
                          subtLeft: '${data?.bestSubject?.name}',
                          titleRight: 'Least Subject',
                          subtRight: '${data?.leastSubject?.name}',
                        ),
                        Divider(height: 5),
                        _buildRows(
                          context,
                          titleLeft: 'Grade',
                          subtLeft: '${data?.overallGrading?.grade}',
                          titleRight: 'Position',
                          subtRight:
                              '${data?.position} of ${data?.positionOutOf}',
                          isContainer: true,
                        ),
                        // Divider(height: 5),
                        // _buildRows(
                        //   context,
                        //   titleLeft: 'Academic session',
                        //   subtLeft: data?.session?.session ?? '',
                        //   titleRight: 'Academic term',
                        //   subtRight: '${data?.term?.name ?? "N/A"}',
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _headerCont(
                    context,
                    leadingTxt: 'Subjects',
                    trailingTxt: 'Score',
                  ),
                  Column(
                    children: mySub.entries.map((entry) {
                      final int studentId = entry.key;
                      final List<Subject> studentSubjects = entry.value;

                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: _buildTile(context, data),
                      );
                    }).toList(),
                  ),

                  // Column(
                  //   children: List.generate(
                  //     data?.subjects?.length ?? 0,
                  //     (index) {
                  //       return Padding(
                  //         padding: EdgeInsets.only(bottom: 10.h),
                  //         child: _buildTile(context, data),
                  //       );
                  //     },
                  //   ),
                  // ),
                  SizedBox(height: 20.h),
                  ...groupedByDomain.entries.map((entry) {
                    final domain = entry.key;
                    final keys = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _headerCont(context,
                            leadingTxt: '${domain.toUpperCase()} DOMAIN'),
                        ...keys.map((key) {
                          // Get the cognitive key ID first
                          final cognitiveKeyId =
                              key.cognitiveKey?.cognitiveKeyId ?? '';

                          // Look up the student's rating for this key
                          final matchedRating =
                              ratingMap[key.cognitiveKey?.cognitiveKeyId] ??
                                  CognitiveKeyRating(
                                    cognitiveKey: key
                                        .cognitiveKey, // This should include the domain
                                    rating: 0,
                                  );

                          return _assessmentCont(
                            data: data,
                            assessment:
                                domain, // Use the domain from the groupBy operation
                            assessmentScore: matchedRating.rating ?? 0,
                            assessmentName: key.cognitiveKey?.name ?? '',
                            spaceId: widget.spaceId,
                            cognitiveKeyId: cognitiveKeyId,
                            context: context,
                            termId: widget.termId,
                            sessionId: widget.sessionId,
                            userId: widget.userId,
                            assessmentId: widget.assessmentId,
                            classId: widget.classId,
                          );
                        }).toList(),
                        SizedBox(height: 20.h),
                      ],
                    );
                  }).toList(),

                  // if (data?.cognitiveKeyRatings != null)
                  //   ...List.generate(data!.cognitiveKeyRatings?.length ?? 0,
                  //       (v) {
                  //     final value = data.cognitiveKeyRatings?[v];
                  //     return Column(
                  //       children: [
                  //         _headerCont(
                  //           context,
                  //           leadingTxt:
                  //               '${value?.cognitiveKey?.domain?.toUpperCase()} domain'
                  //                   .toUpperCase(),
                  //         ),
                  //         _assessmentCont(
                  //           data: data,
                  //           assessment: value?.cognitiveKey?.domain ?? '',
                  //           assessmentScore: value?.rating ?? 0,
                  //           assessmentName: value?.cognitiveKey?.name ?? '',
                  //           spaceId: widget.spaceId,
                  //           cognitiveKeyId:
                  //               value?.cognitiveKey?.cognitiveKeyId ?? '',
                  //           context: context,
                  //           termId: widget.termId,
                  //           sessionId: widget.sessionId,
                  //           userId: widget.userId,
                  //           assessmentId: widget.assessmentId,
                  //           classId: widget.classId,
                  //         ),
                  //         SizedBox(
                  //           height: 20.h,
                  //         )
                  //       ],
                  //     );
                  //   }),
                  // _assessmentCont(
                  //     assessment: 'Attendance', assessmentScore: '5'),
                  // _assessmentCont(assessment: 'Neatness', assessmentScore: '3'),
                  // SizedBox(height: 20.h),
                  // _headerCont(
                  //   context,
                  //   leadingTxt: 'Affective domain',
                  // ),
                  // _assessmentCont(
                  //     assessment: 'Attendance', assessmentScore: '4'),
                  // _assessmentCont(assessment: 'Neatness', assessmentScore: '1'),
                  SizedBox(height: 20.h),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.r, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Color(colorValue!),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 5.w),
                            Text(
                              "CLASS/FORM TEACHER'S COMMENT",
                              style: setTextTheme(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (role == 'admin' ||
                                context.read<UserProvider>().user?.id ==
                                    context
                                        .read<ResultProvider>()
                                        .classModel
                                        ?.formTeacher
                                        ?.id) ...[
                              Container(
                                height: 40.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: whiteShades[0]),
                                child: IconButton(
                                  onPressed: toggleEdit,
                                  icon: Icon(Icons.edit),
                                ),
                              )
                            ]
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.r, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: ThemeProvider().isDarkMode
                              ? blueShades[15]
                              : blueShades[17],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.r),
                            bottomRight: Radius.circular(10.r),
                          ),
                        ),
                        child: isEditing
                            ? Column(
                                children: [
                                  TextField(
                                    controller: formTeacherCont,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter comment...",
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Provider.of<ResultProvider>(context,
                                                listen: false)
                                            .teacherComent(
                                                context: context,
                                                spaceId: widget.spaceId,
                                                resultId: data?.resultId ??
                                                    '', // Now uses the passed data parameter
                                                comment: formTeacherCont.text)
                                            .then((_) {
                                          Provider.of<ResultProvider>(context,
                                                  listen: false)
                                              .getFinalResult(
                                            context: context,
                                            spaceId: widget.spaceId,
                                            sessionId: widget.sessionId,
                                            termId: widget.termId,
                                            // userId: widget.studentResultModel.user?.id ?? '',
                                            userId: widget.userId,
                                            assessmentId: widget.assessmentId,
                                            classId: widget.classId,
                                          );
                                        });
                                        toggleEdit();
                                      },
                                      child: Text("Save"),
                                    ),
                                  )
                                ],
                              )
                            : Text('${data?.formTeacherComment ?? ''}'),
                        // child: Text('${data?.formTeacherComment}'),
                      )
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.r, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Color(colorValue),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 5.w),
                            Text(
                              "PRINCIPAL'S COMMENT",
                              style: setTextTheme(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Spacer(),
                            if (role == 'admin')
                              Container(
                                height: 40.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: whiteShades[0]),
                                child: IconButton(
                                    onPressed: togglePrincipalEdit,
                                    icon: Icon(Icons.edit)),
                              )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.r, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: ThemeProvider().isDarkMode
                              ? blueShades[15]
                              : blueShades[17],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.r),
                            bottomRight: Radius.circular(10.r),
                          ),
                        ),
                        child: isPrincipalEditting
                            ? Column(
                                children: [
                                  TextField(
                                    controller: principalCont,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter comment...",
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Provider.of<ResultProvider>(context,
                                                listen: false)
                                            .principalComment(
                                                context: context,
                                                spaceId: widget.spaceId,
                                                resultId: data?.resultId ?? '',
                                                comment: principalCont.text)
                                            .then((_) {
                                          Provider.of<ResultProvider>(context,
                                                  listen: false)
                                              .getFinalResult(
                                            context: context,
                                            spaceId: widget.spaceId,
                                            sessionId: widget.sessionId,
                                            termId: widget.termId,
                                            userId: widget.userId,
                                            assessmentId: widget.assessmentId,
                                            classId: widget.classId,
                                          );
                                        });
                                        togglePrincipalEdit();
                                      },
                                      child: Text("Save"),
                                    ),
                                  )
                                ],
                              )
                            : Text("${data?.principalComment ?? ''}"),
                      )
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Column(
                    children: [
                      _headerCenterCont(context,
                          leadingTxt: "Personal Information"),
                      _personalInfoCard(context, data),
                    ],
                  ),

                  SizedBox(height: 20.h),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.r, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Color(colorValue),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 5.w),
                            Text(
                              "KEYS TO RATING",
                              style: setTextTheme(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer<ResultProvider>(builder: (context, value, _) {
                        return Container(
                          decoration: BoxDecoration(
                            color: ThemeProvider().isDarkMode
                                ? blueShades[15]
                                : blueShades[17],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.r),
                              bottomRight: Radius.circular(10.r),
                            ),
                          ),
                          child: Table(
                            border: TableBorder.all(
                              color: ThemeProvider().isDarkMode
                                  ? whiteShades[3]
                                  : blueShades[3],
                              width: 0.5,
                            ),
                            columnWidths: const {
                              0: FlexColumnWidth(1.5), // score
                              1: FlexColumnWidth(1.0), // grade
                              2: FlexColumnWidth(2.0), // remark
                            },
                            children: [
                              TableRow(
                                children: [
                                  _buildTableCell('SCORES', isHeader: true),
                                  _buildTableCell('GRADE', isHeader: true),
                                  _buildTableCell('REMARK', isHeader: true),
                                ],
                              ),
                              ...List.generate(value.gradeSystem.length, (e) {
                                final data = value.gradeSystem[e];
                                String color = data.color ?? "#000000";

                                int? colorValue;
                                try {
                                  colorValue = int.tryParse(
                                      color.replaceAll('#', '0xff'));
                                } catch (e) {
                                  colorValue = 0xFF000000;
                                }
                                return TableRow(children: [
                                  _buildTableCell(
                                    '${data.from} - ${data.to}',
                                  ),
                                  _buildTableCell(data.grade ?? '',
                                      color: Color(colorValue!)),
                                  _buildTableCell(data.remark ?? ''),
                                ]);
                              })
                              // TableRow(
                              //   children: [
                              //     _buildTableCell('70 - 100'),
                              //     _buildTableCell('A'),
                              //     _buildTableCell('Excellent'),
                              //   ],
                              // ),
                              // TableRow(
                              //   children: [
                              //     _buildTableCell('60 - 69'),
                              //     _buildTableCell('B'),
                              //     _buildTableCell('Very Good'),
                              //   ],
                              // ),
                              // TableRow(
                              //   children: [
                              //     _buildTableCell('50 - 59'),
                              //     _buildTableCell('C'),
                              //     _buildTableCell('Good'),
                              //   ],
                              // ),
                              // TableRow(
                              //   children: [
                              //     _buildTableCell('40 - 49'),
                              //     _buildTableCell('D'),
                              //     _buildTableCell('Fair'),
                              //   ],
                              // ),
                              // TableRow(
                              //   children: [
                              //     _buildTableCell('30 - 39'),
                              //     _buildTableCell('E'),
                              //     _buildTableCell('Poor'),
                              //   ],
                              // ),
                              // TableRow(
                              //   children: [
                              //     _buildTableCell('0 - 29'),
                              //     _buildTableCell('F'),
                              //     _buildTableCell('Very Poor'),
                              //   ],
                              // ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// Skeleton for a row (simulates _buildRows)
Widget _skeletonRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SkeletonLine(
        style: SkeletonLineStyle(
          height: 14.sp,
          width: 120.w,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      SkeletonLine(
        style: SkeletonLineStyle(
          height: 14.sp,
          width: 100.w,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ],
  );
}

// Skeleton for the header (simulates _headerCont)
Widget _skeletonHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SkeletonLine(
        style: SkeletonLineStyle(
          height: 16.sp,
          width: 150.w,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      SkeletonLine(
        style: SkeletonLineStyle(
          height: 16.sp,
          width: 80.w,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ],
  );
}

// Skeleton for a subject score row (simulates _buildTile)
Widget _skeletonSubjectTile() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: ThemeProvider().isDarkMode ? Colors.transparent : blueShades[17],
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 14.sp,
            width: 180.w,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 14.sp,
            width: 50.w,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    ),
  );
}

_buildRows(
  BuildContext context, {
  required String titleLeft,
  required String titleRight,
  required String subtLeft,
  required String subtRight,
  bool? isContainer,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleLeft,
            style: setTextTheme(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          isContainer == true
              ? Container(
                  width: 16.r,
                  height: 16.r,
                  decoration: BoxDecoration(
                    color: greenShades[0],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      subtLeft,
                      textAlign: TextAlign.center,
                      style: setTextTheme(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              : Text(
                  subtLeft,
                  style: setTextTheme(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
        ],
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleRight,
              style: setTextTheme(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              subtRight,
              style: setTextTheme(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      )
    ],
  );
}

_buildTile(
  BuildContext context,
  ResultData? myData,
) {
  final myAssess = context.read<ResultProvider>().basicAssessmentSecond;
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(
        10.r,
      ),
      color: ThemeProvider().isDarkMode ? blueShades[15] : blueShades[17],
    ),
    child: Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Container(
                color: Colors.white,
                // thickness: 0.5,
                height: 20.h,
              ),
          itemCount: myData?.scores?.length ?? 0,
          itemBuilder: (context, snapshot) {
            final data = myData?.scores?[snapshot];
            final sub = myData?.subjectGrades?[snapshot];
            final total = data?.subjectScores?.fold(0.0, (p, n) {
              return p + (n.score ?? 0.0);
            });
            final subjectGrade = myData?.subjectGrades?.firstWhere(
              (sg) => sg.subject?.id == data?.subject?.id,
              orElse: () => SubjectGrade(),
            );
            final color = subjectGrade?.grade?.color?.replaceAll('#', '0xff');
            final myPosition = myData?.subjectsPosition
                ?.firstWhere((e) => e.subject?.id == subjectGrade?.subject?.id);
            int calculateTotalAssessment() {
              final myAssess =
                  context.read<ResultProvider>().basicAssessmentSecond;
              int totalPercentage = 0;

              if (myAssess?.components != null) {
                for (var component in myAssess!.components!) {
                  totalPercentage += component.percentage ?? 0;
                }
              }

              print(
                  "Total Assessment Percentage: $totalPercentage"); // Debugging
              return totalPercentage;
            }

            final totalSub = calculateTotalAssessment();

            log('jjjj $data');
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  ExpansionTile(
                    childrenPadding:
                        EdgeInsets.only(left: 15.r, right: 15.r, bottom: 20.r),
                    initiallyExpanded: true,
                    title: Row(
                      children: [
                        Container(
                          width: 25.r,
                          height: 25.r,
                          decoration: BoxDecoration(
                            color: Color(int.parse(color ?? '0xff')),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Center(
                            child: Text(
                              '${subjectGrade?.grade?.grade}',
                              style: setTextTheme(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.r),
                        SizedBox(
                          width: 110.w,
                          child: Text(
                            '${data?.subject?.name}',
                            style: setTextTheme(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          '$total/$totalSub',
                          style: setTextTheme(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      // Dynamically generated subjectScores
                      ...List.generate(
                        data?.subjectScores?.length ?? 0,
                        (index) {
                          final subScore = data?.subjectScores?[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _tileRows(
                                context,
                                title: subScore?.subAssessment?.name ?? 'N/A',
                                value: '${subScore?.score ?? '0'}',
                              ),
                              SizedBox(height: 5.h),
                            ],
                          );
                        },
                      ).toList(),

                      _tileRows(context,
                          title: 'Total Score', value: total.toString()),
                      _tileRows(context,
                          title: 'Subject Position',
                          value: myPosition?.position.toString() ?? 'N/A'),
                      _tileRows(context,
                          title: 'Grade',
                          value: subjectGrade?.grade?.grade ?? 'N/A'),
                      _tileRows(context,
                          title: 'Remark',
                          value: subjectGrade?.grade?.remark ?? 'N/A'),

                      // _tileRows(context,
                      //     title: 'Average Score', value: '16'),
                      // _tileRows(context,
                      //     title: 'Class highest score',
                      //     value: '90'),
                      // _tileRows(context,
                      //     title: 'Class lowest score',
                      //     value: '47'),
                      SizedBox(height: 10.h),

                      // Teacher's comment section
                      Row(
                        children: [
                          SizedBox(width: 40.r),
                          Text(
                            "Teacher's comment:",
                            style: setTextTheme(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 40.r),
                          Flexible(
                            child: Text(
                              subjectGrade?.grade?.formTeacherComment ??
                                  'No comment',
                              style: setTextTheme(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.r),
                        ],
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 15.h,
                  // )
                ],
              ),
            );
          }),
    ),
  );
}

_tileRows(BuildContext context,
    {required String title, required String value}) {
  return Column(
    children: [
      Divider(
        height: 1,
        thickness: 0.5,
        color: ThemeProvider().isDarkMode ? blueShades[3] : whiteShades[3],
      ),
      Row(
        children: [
          SizedBox(width: 40.r),
          Text(
            title,
            style: setTextTheme(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3.9,
            child: Text(
              value,
              style: setTextTheme(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

_headerCont(BuildContext context,
    {required String leadingTxt, String? trailingTxt, double? fontSize}) {
  String color = context.read<UserProvider>().model?.colour ?? '#000000';

  int? colorValue;
  try {
    colorValue = int.tryParse(color.replaceAll('#', '0xff'));
  } catch (e) {
    colorValue = 0xFF000000;
  }
  return Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 3.h),
        decoration: BoxDecoration(
          color: Color(colorValue ?? 0xFF000000),
          // color: blueShades[0],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r),
            topRight: Radius.circular(10.r),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 5.w),
            Text(
              leadingTxt,
              style: setTextTheme(
                color: Colors.white,
                fontSize: fontSize ?? 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (trailingTxt != null) Spacer(),
            if (trailingTxt != null)
              SizedBox(
                width: MediaQuery.of(context).size.width / 3.7,
                child: Text(
                  trailingTxt,
                  style: setTextTheme(
                    color: Colors.white,
                    fontSize: fontSize ?? 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
          ],
        ),
      ),
      SizedBox(height: 5),
    ],
  );
}

Color _getAssessmentColor(String score) {
  final intScore = int.tryParse(score) ?? 0;
  switch (intScore) {
    case 1:
      return redShades[1]; // Deep red
    case 2:
      return redShades[0]; // Light red
    case 3:
      return goldenShades[0]; // Yellow/Golden
    case 4:
      return greenShades[0].withOpacity(0.8); // Light green
    case 5:
      return greenShades[0]; // Deep green
    default:
      return Colors.grey; // Invalid score
  }
}

// _assessmentCont({required String assessment, required int assessmentScore}) {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 15.r),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(
//         10.r,
//       ),
//       color: ThemeProvider().isDarkMode ? blueShades[15] : blueShades[17],
//     ),
//     child: Row(
//       children: [
//         Text(
//           assessment,
//           style: setTextTheme(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         Spacer(),
//         Container(
//           //assessment count container
//           width: 25.r,
//           height: 25.r,
//           decoration: BoxDecoration(
//             color: _getAssessmentColor(assessmentScore.toString()),
//             borderRadius: BorderRadius.circular(5.r),
//           ),
//           child: Center(
//             child: Text(
//               assessmentScore.toString(),
//               style: setTextTheme(
//                 fontSize: 12.sp,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
_assessmentCont({
  required BuildContext context,
  required String assessment,
  required int assessmentScore,
  required String assessmentName,
  required String spaceId,
  required String cognitiveKeyId,
  required String sessionId,
  required String termId,
  required String userId,
  required String assessmentId,
  required String classId,
  required ResultData? data, // Added data as a required parameter
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 15.r),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.r),
      color: ThemeProvider().isDarkMode ? blueShades[15] : blueShades[17],
    ),
    child: Row(
      children: [
        Text(
          assessmentName,
          style: setTextTheme(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        Spacer(),
        Container(
          width: 40.r,
          height: 30.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: _getAssessmentColor(assessmentScore.toString()),
          ),
          child: Center(
            child: DropdownButton<int>(
              // value: assessmentScore,
              value: (assessmentScore >= 1 && assessmentScore <= 5)
                  ? assessmentScore
                  : null,
              onChanged: (newValue) {
                if (newValue != null) {
                  Provider.of<ResultProvider>(context, listen: false)
                      .addCognitive(
                    context: context,
                    spaceId: spaceId,
                    cognitiveKeyId: cognitiveKeyId,
                    name: assessmentName,
                    resultId: data?.resultId ?? '',
                    rating: newValue ,
                  )
                      .then((_) {
                    Provider.of<ResultProvider>(context, listen: false)
                        .getFinalResult(
                      context: context,
                      spaceId: spaceId,
                      sessionId: sessionId,
                      termId: termId,
                      // userId: widget.studentResultModel.user?.id ?? '',
                      userId: userId,
                      assessmentId: assessmentId,
                      classId: classId,
                    );
                  });
                }
              },
              items: List.generate(
                5,
                (index) => DropdownMenuItem(
                  value: (index + 1),
                  child: Text(
                    (index + 1).toString(),
                    style: setTextTheme(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              dropdownColor: blueShades[15],
              underline: SizedBox(),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildTableCell(String text, {Color? color, bool isHeader = false}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: setTextTheme(
        fontSize: 12.sp,
        color: color,
        fontWeight: isHeader ? FontWeight.w700 : FontWeight.w400,
      ),
    ),
  );
}

Widget _headerCenterCont(BuildContext context, {required String leadingTxt}) {
  String color = context.read<UserProvider>().model?.colour ??
      '#5B4536'; // Brown color from screenshot

  int? colorValue;
  try {
    colorValue = int.tryParse(color.replaceAll('#', '0xff'));
  } catch (e) {
    colorValue = 0xFF5B4536; // Default brown shade
  }

  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 8.h),
    decoration: BoxDecoration(
      color: Color(colorValue!),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5.r),
        topRight: Radius.circular(5.r),
      ),
    ),
    child: Center(
      child: Text(
        leadingTxt.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

Widget _personalInfoCard(BuildContext context, ResultData? data) {
  final myData = context.read<ResultProvider>().termData;
  final attend = data?.metadata?['attendance']?.toString() ?? '0';
  final total = (myData?.daysOpen ?? 0) - (int.tryParse(attend) ?? 0);
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(5.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow("Days School Opened:", "${myData?.daysOpen ?? 'N/A'}"),
        _infoRow("Days Absent:", "$total"),
        _infoRow("Days Present:", attend ?? 'N/A', isBold: true),
        _infoRow(
            "This Term Closes:",
            _formatDate(
                myData?.currentTermClosesOn?.toIso8601String() ?? 'N/A')),
        _infoRow("Next Term Resumes:",
            _formatDate(myData?.nextTermBeginsOn?.toIso8601String() ?? "N/A")),
      ],
    ),
  );
}

String _formatDate(String dateString) {
  try {
    DateTime date = DateTime.parse(dateString);
    return DateFormat("dd MMMM yyyy").format(date).toUpperCase();
  } catch (e) {
    return dateString; // Fallback if parsing fails
  }
}

Widget _infoRow(String label, String value, {bool isBold = false}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 3.h),
    child: RichText(
      text: TextSpan(
        text: "$label ",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
  );
}
