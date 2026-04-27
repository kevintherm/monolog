<p align="center">
    <img src="assets/logo.png" width="250" />
</p>


# MonoLog

MonoLog is an opinionated minimalist daily consistency tracker app. It's designed for a high-contrast, distraction-free way to log purely physical progress.

## Features

- Daily Log: Track your sleep duration, mood, meals, and workouts in a single streamlined view.
- Meal Tracking: Log calories, protein, and take photos of your meals. Leverage AI to fill the estimated calories and protein based on the image. (soon)
- Workout Tracking: Log your exercise, sets and reps.

## Tech Stack

- Framework: Flutter
- Backend: Veloquent

## Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Android Studio / VS Code
- An active Veloquent backend instance

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/monolog.git
   cd monolog
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure the backend:
   Edit lib/config.dart to point to your Veloquent API URL.

4. Generate App Icons:
   ```bash
   dart run flutter_launcher_icons
   ```

5. Run the app:
   ```bash
   flutter run
   ```
