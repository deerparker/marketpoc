## Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK

### Configuration
The app uses environment variables to configure its behavior, specifically for toggling between "Offline/Stub" mode and "Connected/Real" mode.

#### Environment Files
- **`.env`**: The active configuration file used by the app. **Do not commit this file.**
- **`.env.example`**: A template file containing all available configuration keys. Use this to create your own `.env`.
- **`.env.test`**: Configuration used specifically for running tests.

#### Running Modes

**1. Offline Demo Mode (Default)**
Run the app entirely without a backend. All data is stubbed locally.

**Setup:**
Create a `.env` file with:
```env
USE_MOCK_BACKEND=true
# API_BASE_URL is ignored in this mode
```

**2. Connected Mode**
Run the app connected to the real backend services (`mercur-store`, etc.).

**Setup:**
Create a `.env` file with:
```env
USE_MOCK_BACKEND=false
API_BASE_URL=http://localhost:9000  # Update with your backend URL
PUBLISHABLE_API_KEY=super_secure_key
```

### Running the App
```bash
flutter run
```

### Running Tests
```bash
flutter test
```
