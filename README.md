# LuxeVault - High-Performance Finance Tracker

LuxeVault is a high-performance, modern finance tracker engineered for speed, clarity, and reliability, featuring real-time data synchronization, secure biometric authentication, and a premium analytics-driven user experience.

## Screenshots

![Dashboard](path/to/dashboard_image)
![Add Transaction](path/to/add_transaction_image)

## PRD / Architecture Diagram

```mermaid
graph TD
	 A[User] --> B[Auth Layer<br/>Firebase Auth + Biometric]
	 B --> C[Dashboard<br/>Riverpod Providers]
	 C --> D[Transaction Repository<br/>Firestore / Mock Source]
	 D --> E[UI Updates<br/>Reactive Widgets]

	 C --> F[fl_chart<br/>Real-time Analytics]
	 E --> G[Glassmorphism UI<br/>Cyberpunk/Dark Components]

	 D --> H[Cloud Sync<br/>Firebase Firestore]
	 H --> C
```

## Tech Stack

- Flutter
- Dart
- Riverpod
- Firebase
- Fl_chart
- Glassmorphism UI

## Features

- Real-time Analytics
- Cyberpunk/Dark UI
- Secure Auth
- Cloud Sync

## Getting Started

1. Install dependencies:

	```bash
	flutter pub get
	```

2. Configure Firebase for your local environment:

	```bash
	flutterfire configure
	```

3. Run the app:

	```bash
	flutter run
	```
