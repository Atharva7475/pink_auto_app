# Pink Auto

Pink Auto is a ride-hailing application designed specifically for auto-rickshaw services. It provides a streamlined platform for both customers requesting rides and drivers managing their trips.

## Features

- **User Roles:** Distinct interfaces and functionality for Customers and Drivers.
- **Authentication:** Secure OTP-based login system.
- **Driver Onboarding:** Comprehensive driver registration flow, including document uploads (Driving License, RC, Aadhaar).
- **State Management:** Efficient state handling using Riverpod.

## Tech Stack

- **Framework:** Flutter (Dart)
- **Routing:** GoRouter
- **State Management:** Riverpod, Shared Preferences

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)

### Installation

1. Clone the repository.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

## Project Structure

- `lib/features/`: Contains feature-specific modules (auth, customer, driver).
- `lib/core/`: Contains core application setup like routing.