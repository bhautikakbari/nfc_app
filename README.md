<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NFC Scanner App</title>
    <style>
        :root {
            --primary-color: #6200EE;
            --primary-dark: #3700B3;
            --secondary-color: #03DAC6;
            --text-color: #333333;
            --light-bg: #f8f9fa;
            --card-bg: #ffffff;
            --border-radius: 8px;
            --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: var(--text-color);
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
            background-color: var(--light-bg);
        }

        header {
            text-align: center;
            margin-bottom: 40px;
        }

        h1 {
            color: var(--primary-color);
            font-size: 2.5rem;
            margin-bottom: 10px;
        }

        .status-badge {
            display: inline-block;
            background-color: var(--primary-color);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .app-image {
            width: 100%;
            max-width: 800px;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            margin: 20px 0;
        }

        section {
            background-color: var(--card-bg);
            border-radius: var(--border-radius);
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: var(--box-shadow);
        }

        h2 {
            color: var(--primary-dark);
            border-bottom: 2px solid var(--secondary-color);
            padding-bottom: 10px;
            margin-top: 0;
        }

        h3 {
            color: var(--primary-color);
            margin-top: 25px;
            margin-bottom: 15px;
        }

        ul {
            padding-left: 20px;
        }

        li {
            margin-bottom: 8px;
        }

        .feature-list li::before {
            content: "✓";
            color: var(--secondary-color);
            font-weight: bold;
            display: inline-block;
            width: 1em;
            margin-left: -1em;
        }

        .tech-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .tech-item {
            background-color: rgba(98, 0, 238, 0.1);
            padding: 15px;
            border-radius: var(--border-radius);
            text-align: center;
            font-weight: 500;
        }

        .tech-item strong {
            display: block;
            color: var(--primary-color);
            margin-bottom: 5px;
        }

        code {
            background-color: #f5f5f5;
            padding: 2px 5px;
            border-radius: 3px;
            font-family: 'Courier New', Courier, monospace;
            font-size: 0.9em;
        }

        pre {
            background-color: #f5f5f5;
            padding: 15px;
            border-radius: var(--border-radius);
            overflow-x: auto;
            font-family: 'Courier New', Courier, monospace;
            font-size: 0.9em;
        }

        @media (max-width: 600px) {
            body {
                padding: 15px;
            }
            
            h1 {
                font-size: 2rem;
            }
            
            section {
                padding: 15px;
            }
            
            .tech-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <header>
        <h1>NFC Scanner App</h1>
        <div class="status-badge">Work in Progress</div>
        <p>A modern Flutter application for scanning, reading, and writing NFC tags with a clean, intuitive interface.</p>
        <img src="https://via.placeholder.com/800x400?text=NFC+Scanner+App" alt="App Screenshot" class="app-image">
    </header>

    <section>
        <h2>Features</h2>
        <ul class="feature-list">
            <li>Scan NFC tags and view their content</li>
            <li>Write different types of data to NFC tags (Text, URL, Contact)</li>
            <li>Save scan history and mark favorites</li>
            <li>Dark and light theme support</li>
            <li>Debug tools for testing without physical NFC tags</li>
        </ul>
    </section>

    <section>
        <h2>Architecture & Technical Details</h2>
        <p>This project follows the <strong>MVVM (Model-View-ViewModel)</strong> architecture pattern:</p>
        
        <ul>
            <li><strong>Models:</strong> Data structures representing NFC tags and records</li>
            <li><strong>Views:</strong> UI components that display data to the user</li>
            <li><strong>ViewModels:</strong> Business logic that connects models and views</li>
            <li><strong>Repositories:</strong> Data access layer that abstracts data sources</li>
            <li><strong>Services:</strong> Core functionality like NFC operations</li>
        </ul>

        <h3>State Management</h3>
        <ul>
            <li>Uses <strong>Provider</strong> for dependency injection and state management</li>
            <li>Implements reactive UI updates based on NFC operations</li>
            <li>Separates business logic from UI components</li>
        </ul>

        <h3>Key Technologies</h3>
        <div class="tech-grid">
            <div class="tech-item">
                <strong>Flutter</strong>
                UI framework
            </div>
            <div class="tech-item">
                <strong>Provider</strong>
                State management
            </div>
            <div class="tech-item">
                <strong>Google Fonts</strong>
                Typography
            </div>
            <div class="tech-item">
                <strong>NFC Manager</strong>
                NFC tag reading/writing
            </div>
            <div class="tech-item">
                <strong>Shared Preferences</strong>
                Local storage
            </div>
            <div class="tech-item">
                <strong>Custom Widgets</strong>
                Reusable UI components
            </div>
        </div>
    </section>

    <section>
        <h2>Project Structure</h2>
        <pre>
lib/
├── constants/       # App-wide constants (colors, strings, theme)
├── controllers/     # App controllers (theme, etc.)
├── models/          # Data models
├── repositories/    # Data access layer
├── services/        # Core services (NFC, mock services)
├── utils/           # Utility functions
├── view_models/     # Business logic
├── views/           # UI screens
├── widgets/         # Reusable UI components
└── main.dart        # App entry point</pre>
    </section>

    <section>
        <h2>Getting Started</h2>
        
        <h3>Prerequisites</h3>
        <ul>
            <li>Flutter SDK (latest stable version)</li>
            <li>Android device with NFC capability for testing</li>
            <li>iOS device with NFC capability for testing (iPhone 7 or newer)</li>
        </ul>

        <h3>Installation</h3>
        <ol>
            <li>
                Clone the repository
                <pre>git clone https://github.com/yourusername/nfc_app.git</pre>
            </li>
            <li>
                Install dependencies
                <pre>flutter pub get</pre>
            </li>
            <li>
                Run the app
                <pre>flutter run</pre>
            </li>
        </ol>
    </section>

    <section>
        <h2>Testing Without NFC Hardware</h2>
        <p>The app includes a mock NFC service for testing without physical NFC tags:</p>
        <ol>
            <li>Enable debug mode in the settings</li>
            <li>Use the debug tools to simulate different tag types</li>
            <li>Test writing and reading functionality</li>
        </ol>
    </section>

    <section>
        <h2>Future Plans</h2>
        <ul>
            <li>Add support for more NFC tag types</li>
            <li>Implement tag encryption</li>
            <li>Add cloud backup for tag history</li>
            <li>Improve UI animations</li>
            <li>Add tag templates for quick writing</li>
        </ul>
    </section>

    <footer style="text-align: center; margin-top: 40px; color: #666;">
        <p>This project is licensed under the MIT License - see the LICENSE file for details.</p>
    </footer>
</body>
</html>
