# 🎬 WikiFilms

**WikiFilms** es una aplicación móvil para iOS desarrollada en **Swift con XCode**, que permite consultar películas, viendo sus detalles y añadiéndolas una *watchlist* personal.  
Integra servicios externos como **The Movie Database (TMDB)** y **Firebase**, combinados con funcionalidades propias del dispositivo como la autenticación biométrica para acceder a la cuenta de usuario sin necesidad de iniciar sesión.

---

## 📱 Características principales

- Visualización de pantalla inicial con películas populares y mejor valoradas.
- Búsqueda dinámica de películas por título.
- Vista de detalle de la película con póster, sinopsis y valoración.
- Sistema de watchlist personal.
- Registro e inicio de sesión con Firebase.
- Autenticación biométrica (Face ID / Touch ID).
- Perfil de usuario con edición de nombre.
- Soporte multilenguaje (español e inglés).
- Diseño adaptado para iPhone y iPad.

---

## 🧭 Navegación de la app

La aplicación utiliza un **TabBar** con cuatro secciones:

1. **Home** – Películas populares y top rated  
2. **Search** – Búsqueda por texto 
3. **Watchlist** – Lista personal (Firestore)  
4. **Profile** – Datos de usuario y logout  

---

## 🛠️ Tecnologías y SDKs

| Tecnología | Uso |
|------------|-----|
| **XCode** | Framework de desarrollo utilizado |
| **Firebase Authentication** | Registro y login de usuarios |
| **Firestore** | Almacenamiento de datos de usuario y watchlist |
| **Alamofire** | Peticiones HTTP a la API |
| **SDWebImage** | Descarga y caché de imágenes |
| **LocalAuthentication** | Face ID / Touch ID |

---

## 🌐 API utilizada

**The Movie Database (TMDB) API**  
Proporciona información actualizada sobre películas: título, sinopsis, valoración, fechas de estreno e imágenes promocionales.

---

## 🔐 Autenticación

- Registro y login con email y contraseña.
- Autenticación biométrica solo si ya existe sesión.
- Gestión segura con Firebase Authentication.
- Datos adicionales (username y watchlist) almacenados en Firestore.

---

## 🎨 Diseño

- Prototipo inicial diseñado en **Figma**.

Figma:
https://www.figma.com/design/3wGtDe9z4RlYiNZxtpOF4t/Projectes-Mobils

---

## 👨‍💻 Autores

- Alvaro Bello Garrido  
- Nil Bagaria Nofre  

La Salle – Universitat Ramon Llull  
Grado en Ingeniería Informática  
Asignatura Programación de Dispositivos Móbiles
Curso 2025–2026
