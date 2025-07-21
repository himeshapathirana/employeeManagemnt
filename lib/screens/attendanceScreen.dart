// lib/screens/attendance_screen.dart
import 'package:eadta/models/attendancemodel.dart';
import 'package:eadta/services/localStorageServices.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<LocalStorageService>(context);
    final today = DateUtils.dateOnly(DateTime.now());
    final todayRecord = storage.attendanceRecords.firstWhere(
      (r) => DateUtils.isSameDay(r.date, today),
      orElse: () => AttendanceRecord(date: today),
    );

    return Container(
      color: const Color(0xFFF8F9FA),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(storage),
            const SizedBox(height: 20),
            _buildActionButtons(context, storage, todayRecord),
            const SizedBox(height: 24),
            _buildSectionTitle("Today's Record"),
            const SizedBox(height: 12),
            _buildRecordCard(todayRecord),
            const SizedBox(height: 24),
            _buildSectionTitle("History"),
            const SizedBox(height: 12),
            _buildHistoryList(storage, today),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(LocalStorageService storage) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome back!",
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF7F8C8D),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            storage.employeeName ?? 'Employee',
            style: const TextStyle(
              fontSize: 24,
              color: Color(0xFF2C3E50),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF7F8C8D),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2C3E50),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    LocalStorageService storage,
    AttendanceRecord todayRecord,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            label: "Check In",
            icon: Icons.login,
            color: const Color(0xFF27AE60),
            isEnabled: todayRecord.checkIn == null,
            onPressed: todayRecord.checkIn != null
                ? null
                : () => storage.checkIn(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            label: "Check Out",
            icon: Icons.logout,
            color: const Color(0xFFE74C3C),
            isEnabled:
                todayRecord.checkOut == null && todayRecord.checkIn != null,
            onPressed:
                todayRecord.checkOut != null || todayRecord.checkIn == null
                ? null
                : () => storage.checkOut(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isEnabled,
    required VoidCallback? onPressed,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: isEnabled ? color : const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isEnabled ? Colors.white : const Color(0xFF7F8C8D),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isEnabled ? Colors.white : const Color(0xFF7F8C8D),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordCard(AttendanceRecord record) {
    final dateFormat = DateFormat('MM/dd/yyyy');
    final dayFormat = DateFormat('EEEE');
    final timeFormat = DateFormat('HH:mm');

    String statusText;
    Color statusColor;

    switch (record.status) {
      case AttendanceStatus.Present:
        statusText = "Present";
        statusColor = const Color(0xFF27AE60);
        break;
      case AttendanceStatus.Incomplete:
        statusText = "Incomplete";
        statusColor = const Color(0xFFF39C12);
        break;
      case AttendanceStatus.Absent:
        statusText = "Absent";
        statusColor = const Color(0xFF95A5A6);
        break;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormat.format(record.date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  dayFormat.format(record.date),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F8C8D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: const Color(0xFFE9ECEF)),
            const SizedBox(height: 16),
            _buildInfoRow(
              "Check-In:",
              record.checkIn != null
                  ? timeFormat.format(record.checkIn!)
                  : "--:--",
              Icons.login,
            ),
            _buildInfoRow(
              "Check-Out:",
              record.checkOut != null
                  ? timeFormat.format(record.checkOut!)
                  : "--:--",
              Icons.logout,
            ),
            _buildInfoRow("Time Spent:", record.timeSpent, Icons.schedule),
            _buildInfoRow(
              "Status:",
              statusText,
              Icons.info_outline,
              valueColor: statusColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF7F8C8D)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF2C3E50),
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? const Color(0xFF2C3E50),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(LocalStorageService storage, DateTime today) {
    final history = storage.attendanceRecords
        .where((r) => !DateUtils.isSameDay(r.date, today))
        .toList();

    if (history.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.history,
                size: 32,
                color: Color(0xFF7F8C8D),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "No history available",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Your attendance history will appear here",
              style: TextStyle(fontSize: 14, color: Color(0xFF7F8C8D)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: history.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildRecordCard(history[index]);
      },
    );
  }
}
