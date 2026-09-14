# 🌾 Mausam Saathi — Weather & Crop Advisory App

Multilingual farmer-focused app: real-time weather + seasonal crop advisory in English, Hindi & Marathi.

---

## 📁 Project Structure

```
mausam_saathi_project/
├── backend/          ← Django REST API
└── flutter_app/      ← Flutter Android App
```

---

## ⚡ QUICK SETUP (Do this in order)

---

## STEP 1 — Setup Django Backend

### Open Terminal 1 in VS Code → go to backend folder

```bash
cd mausam_saathi_project/backend
```

### Create virtual environment

```bash
python -m venv venv
```

### Activate virtual environment

**Windows:**
```bash
venv\Scripts\activate
```

**Mac/Linux:**
```bash
source venv/bin/activate
```

### Install dependencies

```bash
pip install -r requirements.txt
```

### Run database migrations

```bash
python manage.py makemigrations
python manage.py migrate
```

### Seed crop data (IMPORTANT — run this once)

```bash
python manage.py seed_crops
```

### Create admin user (optional)

```bash
python manage.py createsuperuser
```

### Start Django server

```bash
python manage.py runserver
```

✅ Django running at: **http://127.0.0.1:8000**

### Test APIs in browser:
- http://127.0.0.1:8000/api/weather/location/search/?q=Jalgaon
- http://127.0.0.1:8000/api/weather/?lat=21.0077&lon=75.5626
- http://127.0.0.1:8000/api/crops/?district=Jalgaon&season=kharif&lang=en
- http://127.0.0.1:8000/api/advisory/?crop=Cotton&rain=80&humidity=85&wind=10&temp=33&lang=en

---

## STEP 2 — Setup Flutter App

### Open Terminal 2 in VS Code → go to flutter_app folder

```bash
cd mausam_saathi_project/flutter_app
```

### Get Flutter packages

```bash
flutter pub get
```

### Generate localization files

```bash
flutter gen-l10n
```

### ⚠️ IMPORTANT: Set Backend URL

Open: `lib/core/constants/app_constants.dart`

**If using Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:8000';
```

**If using Physical Device (same WiFi as PC):**
```dart
// Replace with your PC's actual IP address
static const String baseUrl = 'http://192.168.1.XXX:8000';
```
> Find your PC IP: run `ipconfig` (Windows) or `ifconfig` (Mac/Linux)

### Run the app

```bash
flutter run
```

---

## ✅ Everything is working when:

1. Django terminal shows: `Starting development server at http://127.0.0.1:8000/`
2. Flutter app opens on emulator/device
3. App shows language selection screen (English / हिन्दी / मराठी)
4. You select a language → Home screen opens
5. Search "Jalgaon" → location results appear
6. Select location → weather loads
7. Go to Crops tab → crops appear (Cotton, Soybean, etc.)
8. Tap Cotton → Advisory screen with weather-based advice

---

## 🗄️ Database

By default: **SQLite** (db.sqlite3 file — no setup needed)

To switch to PostgreSQL, edit `backend/.env`:
```
DB_ENGINE=postgresql
DB_NAME=mausam_saathi
DB_USER=postgres
DB_PASSWORD=yourpassword
DB_HOST=localhost
DB_PORT=5432
```

---

## 🌐 API Endpoints

| Endpoint | Description |
|----------|-------------|
| `GET /api/weather/location/search/?q=jalgaon` | Search locations |
| `GET /api/weather/?lat=21.00&lon=75.56` | Get weather data |
| `GET /api/crops/?district=Jalgaon&season=kharif&lang=en` | Get crops |
| `GET /api/crops/season/` | Get current season |
| `GET /api/advisory/?crop=Cotton&rain=80&humidity=85&wind=10&temp=33&lang=en` | Get advisory |
| `GET/POST /api/users/preference/?device_id=xxx` | User preferences |

---

## 🌍 Languages

| Code | Language |
|------|----------|
| `en` | English |
| `hi` | हिन्दी (Hindi) |
| `mr` | मराठी (Marathi) |

Pass `?lang=en` or `?lang=hi` or `?lang=mr` in API calls.

---

## 🌾 Crops in Database

| Crop | Season | Districts |
|------|--------|-----------|
| Cotton (कापूस) | Kharif | Jalgaon, Amravati, Buldhana, Yavatmal... |
| Soybean (सोयाबीन) | Kharif | Jalgaon, Aurangabad, Latur... |
| Maize (मका) | Kharif + Rabi | Jalgaon, Nashik, Pune... |
| Tur (तूर) | Kharif | Jalgaon, Latur, Nanded... |
| Wheat (गहू) | Rabi | Nashik, Pune, Jalgaon... |
| Sugarcane (ऊस) | Annual | Pune, Kolhapur, Satara... |
| Onion (कांदा) | Rabi | Nashik, Pune... |
| Gram (हरभरा) | Rabi | Aurangabad, Latur... |
| Jowar (ज्वारी) | Kharif + Rabi | Aurangabad, Solapur... |
| Bajra (बाजरी) | Kharif | Nashik, Pune... |

---

## 📱 App Screens

1. **Language Selection** — EN / हिन्दी / मराठी
2. **Home** — Search + Weather Summary + Season + Crops
3. **Weather** — Full weather details with stats grid
4. **Crops** — Season-wise crops for the region
5. **Advisory** — Crop-specific weather-based advisory
6. **Forecast** — 7-day + Hourly tabs

---

## 🚀 Free Hosting (After Development)

| Component | Platform |
|-----------|----------|
| Flutter APK | GitHub Releases |
| Django Backend | Render (free tier) |
| PostgreSQL | Neon (free tier) |
| Weather API | Open-Meteo (free) |
| Source Code | GitHub |

---

## ⚠️ Common Issues

**"Connection refused" in Flutter:**
- Make sure Django server is running
- Check baseUrl in app_constants.dart
- Emulator: use `10.0.2.2:8000` not `localhost:8000`
- Physical device: use PC's IP address

**"No crops found":**
- Make sure you ran `python manage.py seed_crops`

**Flutter gen-l10n error:**
- Run `flutter pub get` first, then `flutter gen-l10n`

**Migrations error:**
- Run `python manage.py makemigrations crops advisory users weather`
- Then `python manage.py migrate`
