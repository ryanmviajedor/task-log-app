# 🐝 HiveFlow

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
- **Light/Dark Theme**: Complete theme system with toggle button

### 🌙 Theme System
- **Light Mode**: Clean, bright interface with vibrant gradients
- **Dark Mode**: Elegant dark interface with optimized contrast
- **System Mode**: Automatically follows device theme settings
- **Theme Toggle**: Easy switching via app bar button
- **Persistent Storage**: Theme preference saved between sessions

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
   git clone https://github.com/ryanmviajedor/task-log-app.git
   cd task-log-app
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

### 🎯 Quick Start Guide

1. **Create Your First Task**: Tap the floating action button (+) to add a new task
2. **Set Priorities**: Choose from Low, Normal, or High priority levels
3. **Track Time**: Tasks automatically start timing when moved to "In Progress"
4. **Switch Themes**: Use the theme toggle button in the app bar (☀️/🌙/🔄)
5. **View Analytics**: Check the dashboard for comprehensive task statistics

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
- **State Management**: Provider pattern for reactive UI updates
- **Local Storage**: Hive database for fast, local data persistence
- **Notifications**: flutter_local_notifications for smart reminders
- **Calendar**: table_calendar for interactive date selection
- **Theme Management**: Custom ThemeProvider with persistent storage
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

### Light Theme
- **Background**: Light gradients with soft transitions
- **Cards**: White backgrounds with subtle shadows
- **Text**: Dark text for optimal readability
- **Accents**: Vibrant gradient highlights

### Dark Theme
- **Background**: Deep dark gradients (#1A1A1A → #0F0F0F)
- **Cards**: Dark surfaces (#1E1E1E) with enhanced contrast
- **Text**: Light text optimized for dark backgrounds
- **Accents**: Maintained gradient vibrancy with adjusted opacity

### Gradients
- **Primary Gradient**: Deep Purple → Blue
- **Secondary Gradient**: Blue → Cyan
- **Accent Gradient**: Cyan → Mint
- **Full Gradient**: All colors combined
- **Dark Gradients**: Specialized gradients for dark mode

## 📱 Features Overview

### 🎯 Core Features
- ✅ **Task Creation & Management**: Full CRUD operations with intuitive UI
- ✅ **Automatic Timer Tracking**: Seamless time tracking with status changes
- ✅ **Smart Notifications**: Contextual reminders and completion alerts
- ✅ **Priority Management**: Visual priority indicators with gradient styling
- ✅ **Date Management**: Flexible start and end date scheduling
- ✅ **Analytics Dashboard**: Comprehensive statistics and insights

### 🎨 UI/UX Features
- ✅ **Light/Dark Theme Toggle**: Seamless theme switching with persistence
- ✅ **Responsive Design**: Optimized for all mobile screen sizes
- ✅ **Gradient Design System**: Beautiful, consistent visual language
- ✅ **Material Design 3**: Modern design principles and components
- ✅ **Smooth Animations**: Polished transitions and interactions
- ✅ **Production Ready**: No debug banners, proper error handling

### 🔧 Technical Features
- ✅ **Clean Architecture**: Separation of concerns with SOLID principles
- ✅ **Local Data Persistence**: Fast Hive database integration
- ✅ **State Management**: Reactive Provider pattern implementation
- ✅ **Error Handling**: Comprehensive error management and user feedback
- ✅ **Permission Management**: Proper Android notification permissions
- ✅ **Multi-Platform Support**: Android, iOS, Web, Windows, macOS, Linux

## 🎮 How to Use

### Theme Toggle
1. **Locate the theme button** in the top-right corner of the app bar
2. **Tap the icon** to cycle through theme modes:
   - ☀️ **Light Mode**: Bright, clean interface
   - 🌙 **Dark Mode**: Dark, elegant interface
   - 🔄 **System Mode**: Follows device theme automatically
3. **Your preference is saved** and restored when you reopen the app

### Task Management
1. **Create Tasks**: Tap the (+) floating action button
2. **Set Details**: Add title, description, dates, and priority
3. **Track Progress**: Move tasks through Todo → In Progress → Completed
4. **Monitor Time**: Automatic timer tracking for in-progress tasks
5. **View Analytics**: Check dashboard for comprehensive insights

## 🆕 Recent Updates

### v2.1.0 - HiveFlow Rebrand
- 🐝 **New Brand Identity**: Renamed to HiveFlow with updated app identity
- 📱 **Updated App Names**: Consistent branding across all platforms
- 🎨 **Enhanced Theme Colors**: Updated theme colors to match HiveFlow branding
- 📚 **Documentation Updates**: Updated README and descriptions

### v2.0.0 - Production Ready with Theme System
- 🌙 **Complete Light/Dark Theme System**: Toggle between light, dark, and system themes
- 🚀 **Production Ready**: Removed debug banners, improved error handling
- 🎨 **Enhanced Dark Mode**: Beautiful dark gradients and optimized contrast
- 🔧 **Bug Fixes**: Resolved task creation issues with same start/end dates
- 📱 **Improved Notifications**: Better permission handling and error management
- ✨ **UI Polish**: Responsive design improvements and smooth animations

### v1.0.0 - Initial Release
- 📋 **Core Task Management**: Full CRUD operations with timer functionality
- 📊 **Analytics Dashboard**: Comprehensive statistics and insights
- 🔔 **Smart Notifications**: Task reminders and completion alerts
- 📅 **Calendar Integration**: Interactive calendar with task scheduling
- 🎨 **Gradient Design**: Beautiful UI with custom gradient system
- 🏗️ **Clean Architecture**: Scalable codebase with SOLID principles

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

## 📞 Support & Feedback

### 🐛 Found a Bug?
- Open an issue on [GitHub Issues](https://github.com/ryanmviajedor/task-log-app/issues)
- Include steps to reproduce, expected behavior, and screenshots if applicable

### 💡 Feature Requests
- Submit feature requests via [GitHub Issues](https://github.com/ryanmviajedor/task-log-app/issues)
- Use the "enhancement" label for new feature suggestions

### 📧 Contact
- **GitHub**: [@ryanmviajedor](https://github.com/ryanmviajedor)
- **Repository**: [task-log-app](https://github.com/ryanmviajedor/task-log-app)

### 🌟 Show Your Support
If you find this project helpful, please consider:
- ⭐ **Starring the repository** on GitHub
- 🍴 **Forking and contributing** to the project
- 📢 **Sharing** with others who might find it useful

---

**Made with ❤️ using Flutter** | **HiveFlow - Production-Ready Task Management** | **Open Source**
