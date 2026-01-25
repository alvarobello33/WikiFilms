# 🎬 WikiFilms

**WikiFilms** is an iOS mobile application developed in **Swift with Xcode** that allows users to browse movies, view their details, and add them to a personal *watchlist*.  
It integrates external services such as **The Movie Database (TMDB)** and **Firebase**, combined with device features like biometric authentication to access the user account without needing to log in manually.

---

## 📱 Main Features

- Home screen displaying popular and top rated movies.
- Dynamic movie search by title.
- Movie detail view with poster, synopsis, and rating.
- Personal watchlist system.
- User registration and login with Firebase.
- Biometric authentication (Face ID / Touch ID).
- User profile with name editing.
- Multilanguage support (Spanish and English).
- Responsive design for iPhone and iPad.

---

## 🧭 App Navigation

The application uses a **TabBar** with four sections:

1. **Home** – Popular and top rated movies  
2. **Search** – Text-based search  
3. **Watchlist** – Personal list (Firestore)  
4. **Profile** – User data and logout  

---

## 🛠️ Technologies and SDKs

| Technology | Purpose |
|------------|---------|
| **Xcode** | Development environment |
| **Firebase Authentication** | User registration and login |
| **Firestore** | User and watchlist data storage |
| **Alamofire** | HTTP requests to the API |
| **SDWebImage** | Image downloading and caching |
| **LocalAuthentication** | Face ID / Touch ID |

---

## 🌐 API Used

**The Movie Database (TMDB) API**  
Provides up-to-date information about movies: title, synopsis, rating, release dates, and promotional images.

---

## 🔐 Authentication

- Email and password registration and login.
- Biometric authentication only if a session already exists.
- Secure management with Firebase Authentication.
- Additional data (username and watchlist) stored in Firestore.

---

## 🎨 Design

- Initial prototype designed in **Figma**.

Figma:  
https://www.figma.com/design/3wGtDe9z4RlYiNZxtpOF4t/Projectes-Mobils

---

## 👨‍💻 Authors

- Alvaro Bello Garrido  
- Nil Bagaria Nofre  

La Salle – Universitat Ramon Llull  
Bachelor’s Degree in Computer Engineering  
Mobile Devices Programming  
Course 2025–2026
