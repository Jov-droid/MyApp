## ✅ MyApp – Todo List Flutter Application

MyApp is a Flutter-based Todo List application that allows users to log in, create, view, edit, delete, and categorize tasks.
The app supports light/dark mode, task filtering, search, and a clean Material UI for productivity-focused task management.

## 📱 App Overview

This application helps users organize daily activities by managing todos with:

- Title and description
- Category (Urgent, Personal, School, etc.)
- Completion status
- Search and filter functionality

The app includes a login screen, ensuring that task management is tied to authenticated users.

## ✨ Features
1. 🔐 Authentication:
- Login screen with email and password
- User-based access to the todo list

2. 📝 Todo Management:
- Add new todos using a bottom sheet
- Edit existing todos
- Delete todos
- Mark todos as completed

3. 🗂 Categorization & Filtering:
- Categorize tasks (Urgent, Personal, School)
- Filter todos by category
- Search todos by title

4. 🌗 UI & Experience:
- Light and Dark mode toggle
- Floating Action Button (FAB) for adding tasks
- Clean and responsive UI using Flutter Material components

5. 🧩 Reusable Widgets
The app is built using custom reusable widgets to keep the UI clean, modular, and maintainable:
- Todo Item Widget:
   Displays task title, description, category badge, and action icons

- Search Bar Widget:
   Enables searching todos by title

- Filter Dropdown Widget:
   Allows filtering todos by category

- Custom Input Fields:
   Reused across login and add/edit todo screens

- Action Buttons:
   Edit and delete icons reused across todo items

These widgets improve code reusability, readability, and UI consistency across the app.  
  
## Screenshots
### 1. White theme
![WhatsApp Image 2025-09-18 at 22 18 37](https://github.com/user-attachments/assets/05bec800-8bcc-4a1d-a572-942400f0a357)
![WhatsApp Image 2025-09-18 at 22 21 21](https://github.com/user-attachments/assets/7a9c959b-4387-4060-94cd-1eafe72945ee)
![WhatsApp Image 2025-09-18 at 22 23 50](https://github.com/user-attachments/assets/d328cde3-f2e7-4a50-bd00-0f08d6f758d3)
### 2. Dark theme
![WhatsApp Image 2025-09-18 at 22 24 23](https://github.com/user-attachments/assets/ec37d05b-5f7c-428d-b545-8cf3996b34c4)
![WhatsApp Image 2025-09-18 at 22 25 24](https://github.com/user-attachments/assets/466cb4c9-2084-41b3-b86c-123eddb763d2)
![WhatsApp Image 2025-09-18 at 22 26 18](https://github.com/user-attachments/assets/68923ece-cd28-4448-8980-11c9144cb458)

# 🛠 Tech Stack
```text
| Layer            | Technology                               |
| ---------------- | ---------------------------------------- |
| Framework        | Flutter                                  |
| Language         | Dart                                     |
| UI               | Material Design                          |
| State Management | setState / Provider (if added)           |
| Storage          | Local (can be extended to Hive/Firebase) |
| Authentication   | Local / Extendable                       |
```
# 📁 Project Structure
```text
MyApp/
├── android/                        # Android native build/config files
├── ios/                            # iOS native build/config files
├── web/                            # Flutter web configuration (if used)
├── lib/                            # Dart source code
│   ├── main.dart                   # App entry point
│   ├── constants/                  # App constants (colors, strings, enums)
│   │   └── app_constants.dart
│   ├── models/                     # Data models
│   │   └── todo_model.dart         # Defines the Todo data structure
│   ├── screens/                    # All UI screens in the app
│   │   ├── login_screen.dart       # User login UI
│   │   ├── todo_list_screen.dart   # Displays list of todos
│   │   └── add_todo_screen.dart    # Screen/modal to add or edit todo
│   ├── widgets/                    # Reusable UI components
│   │   ├── todo_item_widget.dart   # Individual todo list item
│   │   ├── search_todo_widget.dart # Search bar UI widget
│   │   ├── filter_dropdown.dart    # Filter dropdown component
│   │   └── custom_inputs.dart      # Inputs used across screens
│   ├── services/                   # App services
│   │   └── storage_service.dart    # Handles storing/loading todos
│   ├── theme/                      # App theme data
│   │   └── app_theme.dart          # Light/Dark theme definitions
│   └── utils/                      # Utility functions/helpers
│       └── helpers.dart
├── assets/                         # Static assets
│   ├── images/                     # App images used in UI
│   └── icons/                      # Icons used in UI
├── test/                           # Unit / widget tests
│   └── widget_test.dart
├── .gitignore
├── pubspec.yaml                    # Dependencies and assets configuration
└── README.md                       # Project documentation
```
# 🧠 App Workflow

1. User launches the app
2. Login screen is displayed
3. On successful login:
   User is redirected to Todo List screen
4. User can:
   - Add a todo
   - Edit or delete a todo
   - Filter/search todos
5. UI updates dynamically

# ▶️ Run the Project
```bash
git clone https://github.com/Jov-droid/MyApp.git
cd MyApp
flutter pub get
flutter run
```

   


