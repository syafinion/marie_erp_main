# Marie ERP System

A Flutter-based Enterprise Resource Planning (ERP) system for restaurant inventory management.

## Project Demo Video
[![Marie ERP Demo]](https://www.youtube.com/watch?v=OCg42viAJXE)

Click the image above to watch the demonstration video of the Marie ERP System.

## Project Overview

**Developed by:** Group 17  
**Created:** 2024  
**Platform:** Flutter/Dart  

## System Requirements

- Windows 10 or later
- Flutter SDK 3.0.0 or later
- Dart SDK 2.17.0 or later
- Visual Studio Code with Flutter extension
- Android Studio (for Android emulator)
- XAMPP (for MySQL database)
- Git

## Setup Instructions

1. **Install Required Software**
   ```bash
   # Install Flutter SDK
   - Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
   - Extract to C:\src\flutter
   - Add Flutter to PATH: C:\src\flutter\bin
   
   # Install Android Studio
   - Download from https://developer.android.com/studio
   - Install with Android SDK
   - Install Flutter and Dart plugins in Android Studio
   
   # Install XAMPP
   - Download from https://www.apachefriends.org/download.html
   - Install with Apache and MySQL options checked
   ```

2. **Configure Android Emulator**
   ```bash
   # In Android Studio:
   1. Go to Tools > Device Manager
   2. Click "Create Device"
   3. Select "Pixel 2" (or any other device)
   4. Download and select system image (API 30 recommended)
   5. Name your AVD and click Finish
   
   # Verify emulator setup:
   flutter emulators
   
   # Note the emulator ID for later use
   ```

3. **Database Setup**
   ```bash
   1. Start XAMPP Control Panel
   2. Start Apache and MySQL services
   3. Open browser and go to: http://localhost/phpmyadmin
   4. Create new database:
      - Click "New"
      - Database name: marie-erp
      - Character set: utf8mb4_general_ci
      - Click "Create"
   5. Import database:
      - Select marie-erp database
      - Click "Import" tab
      - Choose File: select marie-erp.sql from project files
      - Click "Go" at bottom
   ```

4. **Clone the Repository**
   ```bash
   git clone https://github.com/[your-repo]/marie_erp-main.git
   cd marie_erp-main
   ```

5. **Install Dependencies**
   ```bash
   flutter pub get
   ```

6. **Configure Environment**
   - Create `.env` file in project root
   - Add required API endpoints and credentials:
   ```env
   API_BASE_URL=http://localhost/marie-erp/api
   DB_HOST=localhost
   DB_NAME=marie-erp
   DB_USER=root
   DB_PASS=
   ```

7. **Run the Application**
   ```bash
   # Start Android emulator (replace <emulator_id> with your actual emulator ID)
   flutter emulators --launch <emulator_id>
   
   # Run the app
   flutter run
   ```

## Common Issues

1. **API Connection Error**
   - Check internet connection
   - Verify API endpoints in constants/url.dart
   - Ensure correct credentials in .env
   - Verify XAMPP services are running
   - Check if database is properly imported

2. **Emulator Issues**
   - Run `flutter doctor` to verify setup
   - Check Android Studio installation
   - Verify AVD configuration
   - Ensure enough RAM is available (4GB minimum recommended)
   - Try recreating the AVD if it's corrupted

3. **Database Issues**
   - Verify XAMPP services are running (Apache and MySQL)
   - Check if marie-erp database exists
   - Ensure proper database permissions
   - Try restarting XAMPP services

## License

Copyright (c) 2024 Group 17. All rights reserved.

## Contact

For technical issues or questions, contact Group 17 members.