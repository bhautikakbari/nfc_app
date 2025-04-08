NFC Scanner App
A modern Flutter application for scanning, reading, and writing NFC tags with a clean, intuitive interface.

Status: Work in Progress - This project is actively being developed.

Features
- Scan NFC tags and view their content
- Write different types of data to NFC tags (Text, URL, Contact)
- Save scan history and mark favorites
- Dark and light theme support
- Debug tools for testing without physical NFC tags

Architecture & Technical Details
This project follows the MVVM (Model-View-ViewModel) architecture pattern:

- Models: Data structures representing NFC tags and records
- Views: UI components that display data to the user
- ViewModels: Business logic that connects models and views
- Repositories: Data access layer that abstracts data sources
- Services: Core functionality like NFC operations

State Management
- Uses Provider for dependency injection and state management
- Implements reactive UI updates based on NFC operations
- Separates business logic from UI components

Key Technologies
- Flutter: UI framework
- Provider: State management
- Google Fonts: Typography
- NFC Manager: NFC tag reading/writing
- Shared Preferences: Local storage
- Custom Widgets: Reusable UI components for consistent design
