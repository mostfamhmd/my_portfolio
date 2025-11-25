# 🎨 Flutter Portfolio App with Admin Dashboard

A stunning, modern portfolio application built with Flutter, featuring a beautiful portfolio view and a comprehensive admin dashboard for easy content management.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)

## ✨ Features

- 🎨 **Modern UI** with Material 3 design, gradients, and glassmorphism effects
- 📱 **Cross-Platform** - Works on Web, Android, iOS, and Desktop
- 💾 **Local Storage** - Data persists using Hive database
- 🎭 **Smooth Animations** - Beautiful entry animations and transitions
- 🌙 **Dark Mode** - Automatic theme switching
- 📊 **Admin Dashboard** - Complete CRUD operations for all content
- 🚀 **Easy Deployment** - Ready for Firebase Hosting or Vercel
- ♿ **Responsive** - Adapts to all screen sizes

## 🚀 Live Demo

- **Portfolio**: [your-portfolio-url.web.app](https://your-portfolio-url.web.app)
- **Dashboard**: [your-portfolio-url.web.app/dashboard](https://your-portfolio-url.web.app/dashboard)

## 📸 Screenshots

### Portfolio View
![Hero Section](screenshots/hero_section.png)
*Landing page with animated hero section*

### Admin Dashboard
![Dashboard](screenshots/dashboard.png)
*Comprehensive admin dashboard*

### Skills Management
![Skills](screenshots/skills_management.png)
*Easy skills management with proficiency levels*

### Projects Showcase
![Projects](screenshots/projects.png)
*Beautiful project cards with tech stack*

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform UI framework |
| **Dart** | Programming language |
| **Provider** | State management |
| **Hive** | Local NoSQL database |
| **GoRouter** | Navigation and routing |
| **Google Fonts** | Custom typography (Inter, Outfit) |
| **flutter_animate** | Smooth animations |
| **url_launcher** | Open external links |

## 📋 Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Chrome (for web development)
- Android Studio / Xcode (for mobile development)

## 🏃 Getting Started

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/my_portfolio.git
   cd my_portfolio
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For web
   flutter run -d chrome
   
   # For Android
   flutter run -d android
   
   # For iOS
   flutter run -d ios
   ```

### First Run

On the first run, the app will seed default data. Navigate to the dashboard (`/dashboard`) to customize your portfolio:

1. Click the floating **Dashboard** button on the portfolio page
2. Update your **Personal Information**
3. Add your **Skills** with proficiency levels
4. Showcase your **Projects** with images and links
5. Add your **Experience** (work and education)
6. Connect your **Social Media** profiles
7. Return to the portfolio to see your changes!

## 📱 Build for Production

### Web

```bash
flutter build web --release
```

The build output will be in `build/web/`

### Android

```bash
flutter build apk --release
```

APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`

### iOS

```bash
flutter build ios --release
```

## 🌐 Deployment

### Firebase Hosting

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

3. Initialize Firebase:
   ```bash
   firebase init hosting
   ```
   - Select `build/web` as public directory
   - Configure as single-page app: **Yes**
   - Overwrite index.html: **No**

4. Build and deploy:
   ```bash
   flutter build web --release
   firebase deploy --only hosting
   ```

### Vercel

1. Push your code to GitHub
2. Import repository on [Vercel](https://vercel.com)
3. Configure build settings:
   - **Build Command**: `flutter build web --release`
   - **Output Directory**: `build/web`
4. Deploy!

## 📂 Project Structure

```
lib/
├── main.dart                     # App entry point
├── models/                       # Data models
│   ├── personal_info.dart
│   ├── skill.dart
│   ├── project.dart
│   ├── experience.dart
│   └── social_link.dart
├── services/
│   └── storage_service.dart      # Hive database service
├── providers/
│   └── portfolio_provider.dart   # State management
├── routes/
│   └── app_router.dart           # Navigation configuration
├── theme/
│   ├── app_theme.dart            # Material 3 themes
│   └── app_colors.dart           # Color palette
├── widgets/                      # Reusable components
├── screens/
│   ├── portfolio/                # Portfolio view screens  
│   └── dashboard/                # Admin dashboard screens
```

## 🎨 Customization

### Colors

Edit `lib/theme/app_colors.dart` to change the color scheme:

```dart
static const LinearGradient primaryGradient = LinearGradient(
  colors: [Color(0xFF667eea), Color(0xFF764ba2)], // Your colors
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
```

### Typography

Modify `lib/theme/app_theme.dart` to use different Google Fonts:

```dart
textTheme: GoogleFonts.robotoTextTheme(), // Change font here
```

### Default Data

Customize default portfolio data in `lib/services/storage_service.dart`:

```dart
Future<void> _seedDefaultData() async {
  // Modify default values here
}
```

## 🎯 Dashboard Features

### Personal Information
- Name and professional title
- Bio and contact details
- Profile photo URL

### Skills Management
- Add/edit/delete skills
- Set proficiency levels (0-100%)
- Organize by category

### Projects Showcase
- Title, description, and images
- Technology stack tags
- Live demo and GitHub links
- Featured project toggle

### Experience Timeline
- Work and education entries
- Date ranges with "Present" option
- Company/organization details

### Social Links
- Connect all social platforms
- Platform auto-detection
- URL validation

##🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev) - Google's UI toolkit
- [Material Design 3](https://m3.material.io) - Design system
- [Google Fonts](https://fonts.google.com) - Typography
- [Hive](https://docs.hivedb.dev) - Lightweight database

## 📧 Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter) - your.email@example.com

Project Link: [https://github.com/yourusername/my_portfolio](https://github.com/yourusername/my_portfolio)

---

⭐ If you found this project helpful, please give it a star!

Made with ❤️ using Flutter
