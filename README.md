# 📱 Task Log App

A beautiful and feature-rich Flutter task management application with timer functionality, local notifications, and comprehensive analytics dashboard.

## ✨ Features

### 🎯 Core Functionality
- **Task Management**: Create, edit, delete, and organize tasks
- **Status Tracking**: Todo, In Progress, and Completed states
- **Priority Levels**: Low, Normal, and High priority tasks
- **Date Management**: Set start and end dates for tasks

### ⏱️ Timer System
- **Automatic Timer**: Starts when task moves to "In Progress"
- **Duration Tracking**: Tracks total time spent on each task
- **Session Management**: Handles multiple work sessions
- **Live Updates**: Real-time timer display with formatted duration

### 📱 Local Notifications
- **Smart Reminders**: Notifications for tasks due today
- **Completion Alerts**: Instant notifications when tasks are completed
- **Daily Reminders**: Scheduled daily task check reminders
- **Permission Handling**: Proper Android notification permissions

### 📊 Analytics Dashboard
- **Tasks Today**: Number of tasks due today
- **Ongoing Tasks**: Currently in-progress tasks with running timers
- **Total Tasks**: Complete task count
- **Tasks Due**: Tasks needing completion before end date
- **Completed Tasks**: Successfully finished tasks

### 🎨 Beautiful Design
- **Gradient UI**: Custom gradient color scheme (#4300FF, #0065F8, #00CAFF, #00FFDE)
- **Material Design 3**: Modern Flutter design principles
- **Responsive Layout**: Adapts to different screen sizes
- **Smooth Animations**: Elegant transitions and interactions

### 📅 Multiple Views
- **Dashboard**: Statistics and quick actions
- **Calendar View**: Interactive calendar with task scheduling
- **Task List**: Comprehensive list with filtering options

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/task_log_app.git
   cd task_log_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (if needed)**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Architecture

### Clean Architecture Pattern
```
lib/
├── core/                   # Core functionality
│   ├── services/          # Services (notifications, etc.)
│   └── theme/             # App theming and colors
├── data/                  # Data layer
│   ├── datasources/       # Local data sources
│   ├── models/            # Data models
│   └── repositories/      # Repository implementations
├── domain/                # Business logic layer
│   ├── entities/          # Business entities
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business use cases
└── presentation/          # UI layer
    ├── providers/         # State management
    ├── screens/           # App screens
    └── widgets/           # Reusable widgets
```

### Key Technologies
- **State Management**: Provider pattern
- **Local Storage**: Hive database
- **Notifications**: flutter_local_notifications
- **Calendar**: table_calendar
- **Architecture**: Clean Architecture with SOLID principles

## 📦 Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `provider`: State management
- `hive`: Local database
- `hive_flutter`: Flutter integration for Hive

### Feature Dependencies
- `flutter_local_notifications`: Local notifications
- `permission_handler`: Permission management
- `timezone`: Timezone handling
- `table_calendar`: Calendar widget
- `intl`: Internationalization
- `uuid`: Unique ID generation

### Development Dependencies
- `build_runner`: Code generation
- `hive_generator`: Hive model generation

## 🎨 Design System

### Color Palette
- **Primary**: #4300FF (Deep Purple)
- **Secondary**: #0065F8 (Blue)
- **Accent**: #00CAFF (Cyan)
- **Highlight**: #00FFDE (Mint)

### Gradients
- **Primary Gradient**: Deep Purple → Blue
- **Secondary Gradient**: Blue → Cyan
- **Accent Gradient**: Cyan → Mint
- **Full Gradient**: All colors combined

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for design inspiration
- Open source community for the excellent packages

---

Made with ❤️ using Flutter
