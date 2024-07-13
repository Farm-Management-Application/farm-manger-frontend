# Farm Management Frontend Application

## Overview

This Flutter-based application is designed to manage livestock, including chickens, fish, and pigs. The app includes features for creating, editing, and viewing livestock groups, as well as estimating production for these groups. 

## Features

- **Home Screen**: Displays a list of livestock and general statistics.
- **Detail Screen**: Shows statistics and general data for a specific type of livestock, listing groups.
- **Group Detail**: Provides detailed statistics and production estimates for a specific livestock group.
- **Create Group**: Allows users to create new livestock groups.
- **Edit Group**: Enables users to edit existing livestock groups.
- **Production Estimation**: Estimates egg production, fish price, and pig price for selected periods.

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Farm-Management-Application/farm-manger-frontend.git
   cd farm-manger-frontend
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## Directory Structure

```
lib
├── models
│   ├── chicken.dart
│   ├── fish.dart
│   ├── pig.dart
│   └── food_consumption.dart
├── screens
│   ├── home_screen.dart
│   ├── detail_screen.dart
│   ├── group_detail_screen.dart
│   ├── create_group_screen.dart
│   ├── edit_group_screen.dart
│   └── estimation_result_screen.dart
├── services
│   ├── chicken_service.dart
│   ├── fish_service.dart
│   ├── pig_service.dart
│   └── api_service.dart
├── utils
    └── utilFunction.dart
```

## Dependencies

- **Flutter**: Framework for building the app.
- **Provider**: State management.
- **Http**: For making HTTP requests.
- **Printing**: For generating PDF reports (ensure to resolve any Gradle or dependency issues).

## Usage

1. **Creating a Group**: Navigate to the "Create Group" screen from the home screen to add new livestock groups.
2. **Editing a Group**: Use the "Edit Group" button on the group detail page to modify group details.
3. **Estimating Production**: On the detail screen, click the "Estimate Production" button to view production estimates.

## Issues and Troubleshooting

- **Gradle Issues**: Ensure you're using the correct versions of Gradle and Kotlin plugins.
- **Printing Dependency**: Ensure the `printing` package is correctly set up for generating PDF reports.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.
