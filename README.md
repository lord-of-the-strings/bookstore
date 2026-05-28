# The Book Nook

A virtual bookstore built with Flutter + Spring Boot.

## Setup

### Backend
1. Install PostgreSQL and create a database called `bookstore_db`
2. Copy `.env.example` to `.env` and fill in your values
3. Place your Firebase service account JSON at `backend/config/firebase-service-account.json`
4. Run backend/run.sh:
   ```bash
   cd backend
   ./run.sh
   ```

### Frontend
1. Place your `google-services.json` at `frontend/android/app/google-services.json`
2. Run:
```bash
cd frontend
flutter pub get
flutter run --dart-define=BASE_URL=http://your-ip:8080/api
```

## Environment Variables
See `.env.example` for all required variables.
