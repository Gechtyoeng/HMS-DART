# HMS (Hospital Management System)

A simple **CLI-based Hospital Management System** built using **Dart**, following a clean architecture structure with **Domain Layer**, **Service Layer**, and **UI Layer**. The system allows registration of patients, bed/room allocation, searching patients, checking out, and saving/loading data.

---

## ✅ Features

* Register new patients
* Search patient by contact
* Assign rooms and beds to patients
* Change patient room
* Checkout patients
* View available & occupied rooms
* Save & load data from JSON
* Clear separation of **Domain**, **Service**, **UI**, and **Data** layers

---

## 🧱 Project Architecture

```
lib/
 ├── domain/
 │    ├── patient.dart
 │    ├── room.dart
 │    ├── bed_assignment.dart
 │    └── hms.dart
 │
 ├── services/
 │    └── hms_service.dart
 │
 ├── data/
 │    ├── bed_assignment_repository.dart
 │    ├── hms_repository.dart
 │    ├── patient_repository.dart
 │    ├── room_repository.dart
 │    ├── roomList.json{}
 │    ├── patientList.json{}
 │    └── assignment.json{}
 │
 └── ui/
      └── room_allocation_ui.dart
```

## ▶️ How to Run the Program

Run the CLI program using:

```
dart run bin/main.dart
```

---

## ✅ Running Tests

```
dart test
```

Test cases cover:

* Patient registration
* Input validation
* Duplicate contacts
* Searching patients
* Bed assignment logic

---
