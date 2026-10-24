<p align="center">
  <img src="docs/hero.png" alt="To Do: main screen" width="320">
</p>

<h1 align="center">To Do</h1>

<p align="center">
  A simple SwiftUI to-do app that syncs with a REST API built with FastAPI.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-26.6+-000000?logo=apple&logoColor=white" alt="iOS">
  <img src="https://img.shields.io/badge/Swift-5.0-F05138?logo=swift&logoColor=white" alt="Swift">
  <img src="https://img.shields.io/badge/UI-SwiftUI-0D96F6" alt="SwiftUI">
  <img src="https://img.shields.io/badge/Backend-FastAPI-009688?logo=fastapi&logoColor=white" alt="FastAPI">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License">
</p>

---

## Table of Contents

- [About](#about)
- [Features](#features)
- [Screenshots](#screenshots)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Requirements](#requirements)
- [Running the Server](#running-the-server)
- [Running the iOS App](#running-the-ios-app)
- [API Reference](#api-reference)
- [Authentication](#authentication)
- [Project Structure](#project-structure)
- [Known Limitations](#known-limitations)
- [Roadmap](#roadmap)
- [Author](#author)
- [License](#license)

---

## About

**To Do** is a native iOS app for managing personal tasks. Users register, sign in, and keep a list of dated tasks. They can create, edit, complete, and delete tasks.

The project has two parts:

| Component | Repository | Stack |
|-----------|------------|-------|
| Client (iOS) | [todo-ios-app-swiftui](https://github.com/Empty-Developer/todo-ios-app-swiftui) | Swift, SwiftUI, async/await, Observation |
| Server (API) | [backend-fastapi-todo](https://github.com/Empty-Developer/backend-fastapi-todo) | Python, FastAPI, SQLAlchemy, PostgreSQL, JWT |

See the [server README](https://github.com/Empty-Developer/backend-fastapi-todo#readme) for full backend documentation.

---

## Features

- Registration and sign-in with email and password
- JWT authentication; the token is stored, so the session is restored on app launch
- View the current user's task list
- Create a task with a title and a date
- Edit a task's title and date
- Mark tasks as completed directly from the list
- Delete tasks
- Each user sees only their own tasks

---

## Screenshots

| Sign In | Task List | Add Task | Edit Task |
|:-------:|:---------:|:--------:|:---------:|
| ![Sign In](docs/auth.png) | ![List](docs/list.png) | ![Add](docs/add.png) | ![Edit](docs/edit.png) |

---

## Tech Stack

**iOS client**
- Swift 5 and SwiftUI
- `@Observable` and `@MainActor` for the ViewModel layer
- `async/await` and `URLSession` for networking
- `Codable` for JSON decoding
- JWT storage via `TokenStorage`
- iPhone and iPad support (`TARGETED_DEVICE_FAMILY = 1,2`)

**Server**
- Python 3.14, FastAPI, Uvicorn
- SQLAlchemy 2.0 with the psycopg 3 driver, PostgreSQL
- Pydantic 2 for validation
- bcrypt for password hashing
- JWT (python-jose) with the OAuth2 Password flow
- pytest and HTTPX for tests
- uv as the package manager

---

## Architecture

The client follows an **MVVM** pattern. Views render the state of a ViewModel, and ViewModels call services (`AuthService`, `ItemService`) that talk to the API.

---

## Requirements

**Server**
- Python 3.14 (set in `.python-version`)
- PostgreSQL
- [uv](https://docs.astral.sh/uv/) or `pip`

**Client**
- macOS with Xcode that supports the iOS 26.6 SDK
- iOS Simulator or a physical device

---

## Running the Server

The full guide is in the [server README](https://github.com/Empty-Developer/backend-fastapi-todo#readme). In short:

```bash
# 1. Clone the repository
git clone https://github.com/Empty-Developer/backend-fastapi-todo.git
cd backend-fastapi-todo

# 2. Install dependencies (uv)
uv sync
# or: python -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
```

Create a `.env` file in the project root. Example:

```env
DB_USER=postgres
PASSWORD=your_db_password
HOST=localhost
PORT=5432
DBNAME=todo_db

SECRET_KEY=replace_with_a_long_random_string
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

Generate a `SECRET_KEY` with `openssl rand -hex 32`.

```bash
# 3. Create the database
createdb todo_db

# 4. Start the server (run from the app/ folder, since imports are relative to it)
cd app
uvicorn main:app --reload
```

The server runs at `http://127.0.0.1:8000`. Interactive docs:

- Swagger UI: http://127.0.0.1:8000/docs
- ReDoc: http://127.0.0.1:8000/redoc

Tables are created automatically on startup.

### Tests

```bash
# from the server repository root
pytest
```

---

## Running the iOS App

1. Clone the repository:

   ```bash
   git clone https://github.com/Empty-Developer/todo-ios-app-swiftui.git
   ```

2. Open `To Do/To Do.xcodeproj` in Xcode.
3. Make sure the server is running at `http://127.0.0.1:8000`.
4. Pick a simulator and press **Run** (⌘R).

### Running on a Physical Device

The server address is currently set in `Service/AuthService.swift` and `Service/ItemService.swift`:

```swift
private let baseUrl = URL(string: "http://127.0.0.1:8000")!
```

On a real device, `127.0.0.1` points to the device itself. Replace it with your computer's local network IP, for example `http://192.168.1.10:8000`, and start the server with `--host 0.0.0.0`:

```bash
uvicorn main:app --reload --host 0.0.0.0
```

Because the app uses plain HTTP, you may also need an App Transport Security exception (`NSAppTransportSecurity`) in `Info.plist`.

---

## API Reference

Base URL: `http://127.0.0.1:8000`. All task endpoints require the header `Authorization: Bearer <token>`.

| Method | Path | Description | Auth | Response |
|--------|------|-------------|:----:|----------|
| POST | `/users` | Register a user | No | 201 with user data |
| GET | `/users/{id}` | Get a user by ID | No | 200 |
| POST | `/login` | Sign in (form data: `username`, `password`) | No | 200 with `access_token` |
| GET | `/items` | List the current user's tasks | Yes | 200 |
| GET | `/items/{id}` | Get a task by ID | Yes | 200 / 404 |
| POST | `/items` | Create a task (`title`, `date`) | Yes | 201 |
| PUT | `/items/{id}` | Replace a task's title and date | Yes | 200 |
| PATCH | `/items/{id}` | Update completion status (`is_check`) | Yes | 200 |
| DELETE | `/items/{id}` | Delete a task | Yes | 204 |

**Example: create a task**

```http
POST /items
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
Content-Type: application/json

{
  "title": "Buy milk",
  "date": "2026-10-25"
}
```

---

## Authentication

1. A user registers via `POST /users`. The password must be 8 to 72 characters.
2. To sign in, the client sends `POST /login` as `application/x-www-form-urlencoded`.
3. The server verifies the password with bcrypt and returns a JWT containing `user_id`.
4. The client stores the token and sends it in the `Authorization: Bearer ...` header for every task request.
5. On launch, the app checks the token's expiration (`exp`) and restores the session or asks the user to sign in again.

---

## Known Limitations

- The server address is hardcoded in the client services and is not configurable from the app.
- There are no refresh tokens. After the token expires, the user has to sign in again.
- The app works only with a local server. No production deployment is configured.
- The `/login` endpoint returns errors with `return HTTPException(...)` instead of `raise`, so wrong credentials currently produce a 200 response with an error body. This is planned to be fixed.

---

## Roadmap

- [ ] Move the server address into build configuration
- [ ] Refresh tokens
- [ ] Offline mode with local caching
- [ ] Reminders via `UNUserNotificationCenter`
- [ ] Search and filtering by date
- [ ] Unit tests for the client
- [ ] Docker Compose for the server and PostgreSQL

---

## Author

**Empty-Developer**: [github.com/Empty-Developer](https://github.com/Empty-Developer)

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.