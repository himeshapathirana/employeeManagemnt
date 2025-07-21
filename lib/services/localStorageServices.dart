import 'package:eadta/models/attendancemodel.dart';
import 'package:eadta/models/taskmodel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class LocalStorageService with ChangeNotifier {
  late SharedPreferences _prefs;
  bool _simulateError = false;

  // Data
  String? _employeeName;
  bool? _isLoggedIn;
  List<AttendanceRecord> _attendanceRecords = [];
  List<Task> _tasks = [];

  // State
  bool _isLoading = true;
  String? _errorMessage;

  //user specific
  String get _attendanceKey => 'attendanceRecords_$_employeeName';
  String get _tasksKey => 'tasks_$_employeeName';

  // Getters
  String? get employeeName => _employeeName;
  bool? get isLoggedIn => _isLoggedIn;
  List<AttendanceRecord> get attendanceRecords => _attendanceRecords;
  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  LocalStorageService() {
    _init();
  }
  @override
  void notifyListeners() {
    debugPrint('Notifying listeners (isLoggedIn: $_isLoggedIn)');
    super.notifyListeners();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    try {
      _prefs = await SharedPreferences.getInstance();

      _isLoggedIn = _prefs.getBool('loggedIn') ?? false;
      if (_isLoggedIn == true) {
        _employeeName = _prefs.getString('employeeName');

        await _loadUserData();
      }
    } catch (e) {
      _errorMessage = "Failed to initialize storage. Please restart the app.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadUserData() async {
    if (_employeeName == null) return;

    if (_simulateError) throw Exception("Simulated load error");

    final recordsData = _prefs.getString(_attendanceKey);
    _attendanceRecords = recordsData != null
        ? AttendanceRecord.decode(recordsData)
        : [];

    final tasksData = _prefs.getString(_tasksKey);
    _tasks = tasksData != null ? Task.decode(tasksData) : [];
  }

  Future<void> _saveData() async {
    if (_employeeName == null) return;

    if (_simulateError) throw Exception("Simulated save error");

    await _prefs.setString(
      _attendanceKey,
      AttendanceRecord.encode(_attendanceRecords),
    );
    await _prefs.setString(_tasksKey, Task.encode(_tasks));
  }

  Future<void> _performAction(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      await _saveData();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    } finally {
      _isLoading = false;
      _simulateError = false;
      notifyListeners();
    }
  }

  Future<void> login(String username, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 100));

      _employeeName = username;
      _isLoggedIn = true;

      await _prefs.setBool('loggedIn', true);
      await _prefs.setString('employeeName', username);
      await _loadUserData();

      debugPrint('LOGIN STATE COMPLETE');
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _prefs.remove('loggedIn');
    await _prefs.remove('employeeName');

    // Clear the memory
    _employeeName = null;
    _isLoggedIn = false;
    _attendanceRecords = [];
    _tasks = [];

    _isLoading = false;
    notifyListeners();
  }

  void toggleErrorSimulation() {
    _simulateError = true;
  }

  Future<void> setEmployeeName(String name) async {
    await _performAction(() async {
      _employeeName = name;
    });
  }

  Future<void> checkIn() async {
    await _performAction(() async {
      final today = DateUtils.dateOnly(DateTime.now());
      final recordIndex = _attendanceRecords.indexWhere(
        (r) => DateUtils.isSameDay(r.date, today),
      );

      if (recordIndex != -1) {
        _attendanceRecords[recordIndex].checkIn = DateTime.now();
      } else {
        _attendanceRecords.add(
          AttendanceRecord(date: today, checkIn: DateTime.now()),
        );
      }
      _attendanceRecords.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  Future<void> checkOut() async {
    await _performAction(() async {
      final today = DateUtils.dateOnly(DateTime.now());
      final recordIndex = _attendanceRecords.indexWhere(
        (r) => DateUtils.isSameDay(r.date, today),
      );

      if (recordIndex != -1) {
        _attendanceRecords[recordIndex].checkOut = DateTime.now();
      } else {
        _attendanceRecords.add(
          AttendanceRecord(date: today, checkOut: DateTime.now()),
        );
        _attendanceRecords.sort((a, b) => b.date.compareTo(a.date));
      }
    });
  }

  Future<void> addTask(
    String name,
    DateTime dueDate,
    TaskPriority priority,
  ) async {
    await _performAction(() async {
      _tasks.add(
        Task(
          id: const Uuid().v4(),
          name: name,
          dueDate: dueDate,
          priority: priority,
        ),
      );
    });
  }

  Future<void> updateTaskStatus(String taskId, TaskStatus newStatus) async {
    await _performAction(() async {
      final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex].status = newStatus;
      }
    });
  }
}
