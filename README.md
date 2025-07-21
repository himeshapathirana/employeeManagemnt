# Employee Attendance & Daily Tasks App

**Developer**: Himesha Pathirana  


## Overview

This Flutter app helps employees manage their Attendance and Daily Tasks with persistent local storage.  
It supports both **Web** and Android (APK) platforms.

---

## Features

### 1. Attendance Management
- **Persistent User Login**: Enter your name once and it persists across sessions using `shared_preferences`.
- **Check-In / Check-Out**: Log timestamps in local device time.
- **Today's Record**:
  -  Date (MM/DD/YYYY)
  -  Day Name (e.g., Monday)
  -  Check-In / Check-Out Time
  -  Time Spent (HH:mm)
  -  Attendance Status:
    - **Present**: Both Check-In & Check-Out recorded
    - **Incomplete**: Only Check-In or Check-Out
    - **Absent**: No record for the day
-  History stores each user’s daily records.
-  **Edge Case**: Incomplete previous day records persist in history.

### 2. Daily Task Management
- Task List (stored **per user name**):
  - Task Name
  - Due Date (with DatePicker)
  - Priority: Low / Medium / High
  - Status: Not Started / In Progress / Done
-  Add new tasks
-  Update task statuses
-  All data is retained across restarts and hot reloads

### 3. Error Simulation (Debug)
- Long-press on the App Title to show the hidden **"Simulate Error"** button
- Triggers artificial exceptions to verify error-handling
- UI shows:
  -  Loading Indicator during data operations
  -  Clear error messages (e.g., “Failed to save, please try again”)

### 4. User Interface
- Two-tab navigation:
  - **Attendance**
  - **Tasks**
- Built using standard Flutter widgets only:
  - `Scaffold`, `AppBar`, `ListView`, `ElevatedButton`, `TextField`, `DatePicker`, `DropdownButton`, `Radio`, etc.
- An **About Page** shows developer name and app build date

---

## Data Persistence Strategy

- **shared_preferences** is used for all data storage:
  - Attendance records and task lists are stored and retrieved as JSON strings.
  - Data is stored **per user name**, so each employee gets isolated records.

---

##  Tools & Packages Used

| Package                 | Purpose                                                              |
|--------------------------|----------------------------------------------------------------------|
| `shared_preferences`     | Local data storage for attendance and tasks per user                |
| `intl`                   | Formatting dates and times (e.g., MM/DD/YYYY, weekday names)        |
| `provider`               | State management for user info, attendance, and task updates        |
| `uuid`                   | Generating unique IDs for tasks                                     |
| `cupertino_icons`        | iOS-style icons for a polished UI                                   |
| `flutter_launcher_icons` | Customizing app icon (uses `assets/logo.jpg` as app launcher icon)  |
| `flutter_test`           | Used for writing unit and widget tests                              |
| `flutter_lints`          | Enforces recommended Flutter/Dart coding practices                  |
| **Flutter SDK**          | UI development and cross-platform app building (Web + Android)      |


---

##  Assumptions

- Name entered at launch uniquely identifies a user.
- Only one user logs in per device/session at a time.
- No cloud sync all data is device-local and username-scoped.
- Error simulation is for debug/testing only.

---

