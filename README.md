# NFC Scanner App

A modern Flutter application for scanning, reading, and writing NFC tags with a clean, intuitive interface.

## ✨ Features

<ul style="list-style-type: none;">
  <li>✅ Scan NFC tags and view their content</li>
  <li>✅ Write different types of data to NFC tags (Text, URL, Contact)</li>
  <li>✅ Save scan history and mark favorites</li>
  <li>✅ Dark and light theme support</li>
  <li>✅ Debug tools for testing without physical NFC tags</li>
</ul>

## 🏗️ Architecture & Technical Details

This project follows the **MVVM (Model-View-ViewModel)** architecture pattern:

- **Models:** Data structures representing NFC tags and records
- **Views:** UI components that display data to the user
- **ViewModels:** Business logic that connects models and views
- **Repositories:** Data access layer that abstracts data sources
- **Services:** Core functionality like NFC operations

### State Management

- Uses **Provider** for dependency injection and state management
- Implements reactive UI updates based on NFC operations
- Separates business logic from UI components

### Key Technologies

<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-top: 20px;">
  <div style="background-color: rgba(98, 0, 238, 0.1); padding: 15px; border-radius: 8px; text-align: center;">
    <strong style="color: #6200EE; display: block;">Flutter</strong>
    UI framework
  </div>
  <div style="background-color: rgba(98, 0, 238, 0.1); padding: 15px; border-radius: 8px; text-align: center;">
    <strong style="color: #6200EE; display: block;">Provider</strong>
    State management
  </div>
  <div style="background-color: rgba(98, 0, 238, 0.1); padding: 15px; border-radius: 8px; text-align: center;">
    <strong style="color: #6200EE; display: block;">Google Fonts</strong>
    Typography
  </div>
  <div style="background-color: rgba(98, 0, 238, 0.1); padding: 15px; border-radius: 8px; text-align: center;">
    <strong style="color: #6200EE; display: block;">NFC Manager</strong>
    NFC tag reading/writing
  </div>
  <div style="background-color: rgba(98, 0, 238, 0.1); padding: 15px; border-radius: 8px; text-align: center;">
    <strong style="color: #6200EE; display: block;">Shared Preferences</strong>
    Local storage
  </div>
  <div style="background-color: rgba(98, 0, 238, 0.1); padding: 15px; border-radius: 8px; text-align: center;">
    <strong style="color: #6200EE; display: block;">Custom Widgets</strong>
    Reusable UI components
  </div>
</div>
