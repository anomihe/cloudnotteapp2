import 'dart:developer';
import 'package:cloudnottapp2/src/data/models/class_group.dart';
import 'package:cloudnottapp2/src/data/models/response_model.dart';
import 'package:cloudnottapp2/src/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:intl/intl.dart';

import '../../config/config.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository userRepository;
  UserProvider({required this.userRepository});
  ResponseSuccess? successResponse;
  ResponseError? errorResponse;
  User? _user;
  User? _searchedUser;
  bool _isLoading = false;
  bool _isLoadingStateTwo = false;
  bool _isTimeTableLoading = false;
  bool _isError = false;
  List<UserSpace> _space = [];
  SpaceUser? _singleSpace;
  SpaceModel? _model;
  UserSpace? _data;
  List<ClassTimeTable> _timeTable = [];
  List<ClassTimeTable> _filteredTimeTable = [];
  List<ClassTimeTable> get timeTable => _timeTable;
  List<ClassTimeTable> get filteredTimeTable => _filteredTimeTable;
  List<ClassInfo> _classes = [];
  List<UserSpaceInvitation> _invitations = [];
  List<UserSpaceInvitation> get invitations => _invitations;
  List<PendingSpaceLinkRequest> _linkRequests = [];
  List<PendingSpaceLinkRequest> get linkRequests => _linkRequests;
  List<ClassInfo> get classes => _classes;
  List<ClassGroup> _classGroups = [];
  List<ClassGroup> get classGroups => _classGroups;
  List<UserSpace> get space => _space;
  SpaceUser? get singleSpace => _singleSpace;
  SpaceModel? get model => _model;
  bool get isLoading => _isLoading;
  bool get isLoadingStateTwo => _isLoadingStateTwo;
  bool get isTimeTableLoading => _isTimeTableLoading;
  bool get isError => _isError;
  User? get user => _user;
  bool _isDefaultSet = false;
  String? _extraId;
  String _currentSpace = '';
  String _classSessionId = '';
  String _termId = '';
  String _alias = '';
  String _spaceId = '';
  String _memberId = '';
  User? get searchedUser => _searchedUser;
  String get currentSpace => _currentSpace;
  String get classSessionId => _classSessionId;
  String get termId => _termId;
  String get memberId => _memberId;
  String get alias => _alias;
  String get spaceId => _spaceId;
  bool get isDefaultSet => _isDefaultSet;
  String? get extraId => _extraId;
  UserSpace? get data => _data;
  String _role = '';
  String get role => _role;
  int _subjectCount = 0;
  int get subjectCount => _subjectCount;
  int _activityCount = 0;
  int get activityCount => _activityCount;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setData(UserSpace? da) {
    _data = da;
    notifyListeners();
  }

  void setAlias(String space) {
    _alias = space;
    notifyListeners();
  }

  void setJustSpace(SpaceModel model) {
    _model = model;
    notifyListeners();
  }

  void setGroup({required String sessionId, required String termId}) {
    _classSessionId = sessionId;
    _termId = termId;
    notifyListeners();
  }

  void setSpaceId(String spaceId) {
    _spaceId = spaceId;
    notifyListeners();
  }

  void setCurrentSpace(String space) {
    _currentSpace = space;
    notifyListeners();
  }

  void setLoadingTwo(bool value) {
    _isLoadingStateTwo = value;
    notifyListeners();
  }

  void setTimeTableLoading(bool value) {
    _isTimeTableLoading = value;
    notifyListeners();
  }

  void setError(bool value) {
    _isError = value;
    notifyListeners();
  }

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  setRole(String role) {
    role = role;
    notifyListeners();
  }

  void setListSpaces(List<UserSpace> space) {
    _space = space;
    log('Spaces: ${space}');
    notifyListeners();
  }

  void setSingleSpace(SpaceUser single) {
    _singleSpace = single;
    log('Single Space: ${single.role} ${single.classInfo?.classGroup?.id} $role');
    // role = single.role;
    notifyListeners();
  }

  void setLinkRequests(List<PendingSpaceLinkRequest> linkRequests) {
    _linkRequests = linkRequests;
    notifyListeners();
  }

  void setMemberId(String id) {
    _memberId = id;
    notifyListeners();
  }

  void setTimeTable(List<ClassTimeTable>? timeTable) {
    // _timeTable = timeTable;
    if (timeTable == null) {
      _timeTable = [];
      notifyListeners();
    } else {
      log("Before update: $_timeTable");
      _timeTable = [...timeTable];
      log("After update: $_timeTable");
      notifyListeners();
    }
  }

  void setClasses(List<ClassInfo> classes) {
    log("Before update: $classes");
    _classes = [...classes];
    log("After update: $classes");
    notifyListeners();
  }

  void setClassGroups(List<ClassGroup> classGroups) {
    log("Before update: $classGroups");
    _classGroups = [...classGroups];
    log("After update: $classGroups");
    notifyListeners();
  }
void filterClassTimeTable(DateTime? selectedDay) {
  final selectedDayName =
      DateFormat.EEEE().format(selectedDay ?? DateTime.now());

  _filteredTimeTable = timeTable
      .where((e) =>
          e.dayOfWeek?.name == selectedDayName &&
          (e.subject != null || (e.activity?.trim().isNotEmpty ?? false)))
      .toList();

  notifyListeners();

  final subjectItems = [];
  final activityItems = [];

  for (var e in _filteredTimeTable) {
    final data = e.subject ?? e.activity ?? '';
    log("DATA: ${data.toString()}");

    if (e.subject != null) {
      subjectItems.add(e.subject);
    } else if (e.activity?.trim().isNotEmpty ?? false) {
      activityItems.add(e.activity);
    }
  }

  _subjectCount = subjectItems.length;
  _activityCount = activityItems.length;
}

  // void filterClassTimeTable(DateTime? selectedDay) {
  //   final selectedDayName =
  //       DateFormat.EEEE().format(selectedDay ?? DateTime.now());
  //   _filteredTimeTable =
  //       timeTable.where((e) => e.dayOfWeek?.name == selectedDayName).toList();
  //   notifyListeners();

  //   final subjectItems = [];
  //   final activityItems = [];
  //   for (var e in filteredTimeTable) {
  //     final data = e.subject ?? e.activity ?? '';
  //     log("DATA: ${data.toString()}");
  //     if (e.subject != null) {
  //       subjectItems.add(e.subject);
  //       continue;
  //     }
  //     if (e.activity != null) {
  //       activityItems.add(e.activity);
  //       continue;
  //     }
  //   }
  //   _subjectCount = subjectItems.length;
  //   _activityCount = activityItems.length;
  // }

  void setInvitations(List<UserSpaceInvitation> invitations) {
    log("Before update: $invitations");
    _invitations = [...invitations];
    log("After update: $invitations");
    notifyListeners();
  }

  Future<void> getSignedUser(context) async {
    log('you are called');
    try {
      setLoading(true);
      Result<dynamic> result = await userRepository.getUser(context: context);
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERROR user: ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as User;
      setUser(data);
      print('my data called $data ${data.id} ');
      //setSuccess(true);
      setLoading(false);
      notifyListeners();
      return;
    } catch (e) {
      print('check my error $e');
      errorResponse = ResponseError(message: e.toString());
      setError(true);
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> getUserByUsername(String username) async {
    try {
      setLoading(true);
      Result<dynamic> result =
          await userRepository.getUserByUsername(username: username);
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERROR user: ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as User;
      _searchedUser = data;
      setLoading(false);
      notifyListeners();
      return;
    } catch (e) {
      print('check my error $e');
      errorResponse = ResponseError(message: e.toString());
      setError(true);
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> getUserSpaces(BuildContext context) async {
    try {
      setLoadingTwo(true);
      Result<dynamic> result =
          await userRepository.userSpaces(context: context);
      //og("space result ${result.response}");
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERROR space: ${errorResponse?.errors.toString()}");
        setError(true);
        setLoadingTwo(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<UserSpace>;
      setListSpaces(data);

      //setSuccess(true);
      setLoadingTwo(false);
      notifyListeners();
      return;
    } catch (e) {
      log('mr error $e');
      errorResponse = ResponseError(message: e.toString());
      setError(true);
      setLoadingTwo(false);
      notifyListeners();
    }
  }

  Future<void> getUserOneSpace(
    BuildContext context,
    String alias,
    String spaceId, {
    String? classId,
    bool loadingState = true,
  }) async {
    log('my deeerede ${_alias} $spaceId ${ user?.id}');
    try {
      setLoading(loadingState);
      // notifyListeners();
      Result<dynamic> result = await userRepository.userPersonnelSpace(
        alias: _alias,
        userId: user?.id ?? "",
      );
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        log("ERROR: single space ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as SpaceUser;
      log('User Role: ${data.role} ${successResponse!.data}  ${data.classInfo?.classGroup?.id} info ${data.classInfo?.classGroup?.id}');
       getSpace(context, alias, spaceId);
      //role = data.role;
      localStore.put('role', data.role);
      setSingleSpace(data);
      setMemberId(data.memberId!);
      setSpaceId(spaceId);

      // if (data.role?.toLowerCase() != "teacher") {
      //   log('Processing student data - Class ID: ${data.classInfo?.id}');
      //   if (data.classInfo?.id != null) {
      //     await getUserTime(
      //       context: context,
      //       spaceId: spaceId,
      //       classId: singleSpace?.classInfo?.id ?? '',
      //     );
      //   }
      // } else {
      //   log('Processing teachers data');
      //   await getTeacherTimetable(
      //     context: context,
      //     spaceId: spaceId,
      //   );
      // }
      final String role = data.role?.toLowerCase() ?? '';
      switch (role) {
        case 'teacher':
          log('Processing teacher timetable');
          await getTeacherTimetable(
            context: context,
            spaceId: spaceId,
          );
          break;

        case 'student':
          log('Processing student timetable');
          if (data.classInfo?.id != null) {
            await getUserTime(
              context: context,
              spaceId: spaceId,
              classId: data.classInfo?.id ?? '',
            );
          }
          break;

        case 'admin':
          log('Processing admin timetable');

          await getUserTime(
            context: context,
            spaceId: spaceId,
            classId: classId ?? '',
          );
         
          break;

        default:
          log('Unknown role: $role');
          // Handle unknown role or throw error
          throw Exception('Unknown user role: $role');
      }
     
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error ${errorResponse} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> getSpace(
      BuildContext context, String alias, String spaceId) async {
    log('myyy ${_alias} $spaceId');
    try {
      var ro = localStore.get('role', defaultValue: role);
      bool isAdmin = ro == 'admin' ? true : false;
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await userRepository.userJustSpace(
        alias: _alias,
        isAdmin: isAdmin,
      );
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERROR:space ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as SpaceModel;

      //role = data.role;

      setJustSpace(data);

      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error ${errorResponse} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> getUserTime({
    required BuildContext context,
    required String spaceId,
    required String classId,
  }) async {
    try {
      setTimeTableLoading(true);
      notifyListeners();
      Result<dynamic> result = await userRepository.userClassTimeTable(
          context: context, spaceId: spaceId, classId: classId);
      if (result.response is ResponseError) {
        log("ERROR in time: ${errorResponse?.errors.toString()}");
        setTimeTableLoading(false);
        setError(true);
        errorResponse = result.response as ResponseError;
        notifyListeners();
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<ClassTimeTable>?;
      setTimeTable(data);
      setTimeTableLoading(false);
      notifyListeners();
      return;
    } catch (e) {
      log("my erriror $e");
      errorResponse = ResponseError(message: e.toString());
      setError(true);
      setTimeTableLoading(false);
      notifyListeners();
    }finally {
      setTimeTableLoading(false);
      log('Finally: Loading set to false');
      notifyListeners();
    }
  }

  getTeacherTimetable(
      {required BuildContext context, required String spaceId}) async {
    log('my datasssss ${singleSpace?.classInfo?.id} ${spaceId}');
    try {
      setLoadingTwo(true);
      notifyListeners();
      Result<dynamic> result = await userRepository.teacherTimeTable(
        context: context,
        spaceId: spaceId,
      );
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        log("ERROR in time teacher: ${errorResponse?.errors.toString()}");
        setError(true);
        setLoadingTwo(false);
        notifyListeners();
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<ClassTimeTable>;
      if (data.isEmpty) {
        log("Warning: API returned an empty list, skipping update!");
        return;
      }
      log('Fetched time table: ${data.length} items');
      setTimeTable(data);
      //setSuccess(true);
      log('teacherimetabe ${data}');
      setLoadingTwo(false);
      notifyListeners();
      return;
    } catch (e) {
      log("my erriror $e");
      errorResponse = ResponseError(message: e.toString());
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
      log('Finally: Loading set to false');
      notifyListeners();
    }
  }

  Future<void> getClasses(
      {required BuildContext context,
      required String spaceId,
      required String classGroupId}) async {
    try {
      setLoadingTwo(true);
      notifyListeners();
      Result<dynamic> result = await userRepository.getUserClasses(
          context: context, spaceId: spaceId, classGroupId: classGroupId);
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        log("ERROR : ${errorResponse?.errors.toString()}");
        setError(true);
        setLoadingTwo(false);
        notifyListeners();
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<ClassInfo>;
      if (data.isEmpty) {
        log("Warning: API returned an empty list, skipping update!");
        return;
      }
      log('Fetched time table: ${data.length} items');
      setClasses(data);
      //setSuccess(true);
      log('DATA: ${data.toString()}');
      setLoadingTwo(false);
      notifyListeners();
      return;
    } catch (e) {
      log("my erriror $e");
      errorResponse = ResponseError(message: e.toString());
      setError(true);
      setLoadingTwo(false);
      notifyListeners();
    } finally {
      setLoadingTwo(false);
      log('Finally: Loading set to false');
      notifyListeners();
    }
  }

  Future<void> teachersTimetable({
    required BuildContext context,
    required String spaceId,
  }) async {
    log('my datasssss ${singleSpace?.classInfo?.id} $spaceId');
    try {
      setLoadingTwo(true);
      Result<dynamic> result = await userRepository.teacherTimeTable(
        context: context,
        spaceId: spaceId,
        // classId: singleSpace?.classInfo?.id ?? '',
      );
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERROR in time: ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<ClassTimeTable>;
      setTimeTable(data);
      //setSuccess(true);
      log('teachers timetable ${data}');
      setLoadingTwo(false);
      notifyListeners();
      return;
    } catch (e) {
      log("my erriror $e");
      errorResponse = ResponseError(message: e.toString());
      setError(true);
      setLoading(false);
      notifyListeners();
    }
  }

  void checkDefaultSpace() {
    _isDefaultSet = localStore.get('default_space_set', defaultValue: false);
    _extraId = localStore.get('extraId', defaultValue: '');
    log("my set value ${_isDefaultSet}${_extraId}");
    notifyListeners();
  }

  Future<void> getInvite({required BuildContext context}) async {
    try {
      setLoading(true);
      // setError(false);
      Result<dynamic> result = await userRepository.getSpaceInvite(
        context: context,
        spaceId: spaceId,
      );
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERROR: ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<UserSpaceInvitation>;
      setInvitations(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      setError(true);
      setLoading(false);
      notifyListeners();
    }finally{
       setError(true);
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> rejectInvite({
    required BuildContext context,
    required String spaceId,
    required String inviteId,
  }) async {
    try {
      reset();
      setLoadingTwo(true);
      notifyListeners();
      Result<dynamic> result = await userRepository.getSpaceInviteReject(
          context: context, spaceId: spaceId, invitationId: inviteId);
      log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("resumeed:  ${errorResponse?.errors.toString()}");
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "${errorResponse?.message}",
          ),
        );
        setError(true);
        setLoadingTwo(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as bool;
      log('assess $data');
      if (data == true) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: "Invitation Rejected",
          ),
        );
      }
      setLoadingTwo(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error ${errorResponse} ${e.toString()} ');
      setError(true);
      setLoadingTwo(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> acceptInvite({
    required BuildContext context,
    required String spaceId,
    required String inviteId,
  }) async {
    try {
      reset();
      setLoadingTwo(true);
      notifyListeners();
      Result<dynamic> result = await userRepository.getSpaceInviteAccept(
        context: context,
        spaceId: spaceId,
        invitationId: inviteId,
      );
      log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("resumeed:  ${errorResponse?.errors.toString()}");
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "${errorResponse?.message}",
          ),
        );
        setError(true);
        setLoadingTwo(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as bool;
      log('assess $data');
      if (data == true) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: "Saved Successfully",
          ),
        );
      }
      setLoadingTwo(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error ${errorResponse} ${e.toString()} ');
      setError(true);
      setLoadingTwo(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getSpaceLinkRequests({
    required BuildContext context,
  }) async {
     final stopwatch = Stopwatch()..start();
   try {
  setLoading(true);
  // setError(false);
   notifyListeners();
  Result<dynamic> result = await userRepository.getSpaceInviteLink(context: context);

  if (result.response is ResponseError) {
    errorResponse = result.response as ResponseError;
    print("ERROR linking: ${errorResponse?.errors.toString()}");
    setError(true);
    setLoading(false);
  } else {
    successResponse = result.response as ResponseSuccess;
    var data = successResponse!.data as List<PendingSpaceLinkRequest>;
    setLinkRequests(data);
    setLoading(false);
    notifyListeners();
  }
} catch (e) {
  errorResponse = ResponseError(message: e.toString());
  setError(true);
  print("ERROR linking: $e");
} finally {
    stopwatch.stop();
  setLoading(false);
  log('duration ${stopwatch.elapsed}');
  notifyListeners();
}

  }

  Future<void> linkResponse({
    required BuildContext context,
    required String spaceId,
    required String requesterId,
    required String status,
  }) async {
    try {
      reset();
      setLoadingTwo(true);
      notifyListeners();
      Result<dynamic> result = await userRepository.responseSpaceLinkRequest(
        context: context,
        spaceId: spaceId,
        requesterId: requesterId,
        status: status,
      );
      log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("resumeed:  ${errorResponse?.errors.toString()}");
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "${errorResponse?.message}",
          ),
        );
        setError(true);
        setLoadingTwo(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as bool;
      log('assess $data');
      if (data == true) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: "Saved Successfully",
          ),
        );
      }
      setLoadingTwo(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error ${errorResponse} ${e.toString()} ');
      setError(true);
      setLoadingTwo(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> sendSpaceLinkInvite({
    required BuildContext context,
    required String requestedUserUsernames,
    required String contactPerson,
    required String spaceId,
  }) async {
    try {
      reset();
      setLoadingTwo(true);
      notifyListeners();
      Result<dynamic> result = await userRepository.sendSpaceLinkRequest(
        context: context,
        spaceId: spaceId,
        requestedUserUsernames: requestedUserUsernames,
        contactPerson: contactPerson,
      );

      log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("linkederror:  ${errorResponse?.errors.toString()}");
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "${errorResponse?.message}",
          ),
        );
        setError(true);
        setLoadingTwo(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as bool;
      log('assess $data');
      if (data == true) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: "Invitation Sent Successfully",
          ),
        );
      }
      setLoadingTwo(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error ${errorResponse} ${e.toString()} ');
      setError(true);
      setLoadingTwo(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  void setDefaultSpace(
      {required String id, required String sessionId, required String termId}) {
    localStore.put('default_space_set', true);
    localStore.put('extraId', id);
    // localStore.put('classGroupId', classGroupId);
    localStore.put('sessionId', sessionId);
    localStore.put('termId', termId);
  }

  // void setDefaultSpace(String id, String alias) {
  //   localStore.put('default_space_set', true);
  //   localStore.put('extraId', id);
  //   localStore.put('alias', alias);

  //   _isDefaultSet = true;
  //   _extraId = id;
  //   _alias = alias;
  //   notifyListeners();
  // }

  void reset() {
    errorResponse = null;
    successResponse = null;
    setError(false);
    setLoading(false);
    // setLoadingStateTwo(false);
    // setSuccess(false);
    notifyListeners();
  }

  // Future<void> fetchUserSpaceAndTime(
  //     BuildContext context, String spaceId) async {
  //   log('Fetching user space and timetable simultaneously...');
  //   try {
  //     reset();
  //     setLoading(true);

  //     // Run both functions in parallel
  //     final results = await Future.wait([
  //       userRepository.userPersonnelSpace(spaceId: spaceId, userId: user!.id),
  //       userRepository.userClassTimeTable(
  //         context: context,
  //         spaceId: spaceId,
  //         classId: singleSpace?.classInfo.id ?? '',
  //       ),
  //     ]);

  //     // Process user space result
  //     if (results[0] is ResponseError) {
  //       errorResponse = results[0] as ResponseError;
  //       log("ERROR in space: ${errorResponse?.message}");
  //       setError(true);
  //     } else {
  //       successResponse = results[0] as ResponseSuccess;
  //       setSingleSpace(successResponse!.data as SpaceUser);
  //       log('Space fetched successfully');
  //     }

  //     // Process user timetable result
  //     if (results[1] is ResponseError) {
  //       errorResponse = results[1] as ResponseError;
  //       log("ERROR in time: ${errorResponse?.message}");
  //       setError(true);
  //     } else {
  //       successResponse = results[1] as ResponseSuccess;
  //       setTimeTable(successResponse!.data as List<ClassTimeTable>);
  //       log('Timetable fetched successfully');
  //     }

  //     setLoading(false);
  //     notifyListeners();
  //   } catch (e) {
  //     log("❌ Exception caught: $e");
  //     errorResponse = ResponseError(message: e.toString());
  //     setError(true);
  //     setLoading(false);
  //     notifyListeners();
  //   }
  // }
  // }

  void clearData() {
    _user = null;
    _searchedUser = null;
    _isLoading = false;
    _isLoadingStateTwo = false;
    _isError = false;
    _space = [];
    _singleSpace = null;
    _data = null;
    _timeTable = [];
    _isDefaultSet = false;
    _extraId = null;
    _currentSpace = '';
    _classSessionId = '';
    _termId = '';
    _alias = '';
    _spaceId = '';
    _memberId = '';
    _role = '';
    notifyListeners();
  }
}
