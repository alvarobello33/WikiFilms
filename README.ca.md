# 🎬 WikiFilms

**WikiFilms** és una aplicació mòbil per a iOS desenvolupada en **Swift amb Xcode** que permet consultar pel·lícules, veure’n els detalls i afegir-les a una *watchlist* personal.  
Integra serveis externs com **The Movie Database (TMDB)** i **Firebase**, combinats amb funcionalitats del dispositiu com l’autenticació biomètrica per accedir al compte d’usuari sense necessitat d’iniciar sessió manualment.

---

## 📱 Funcionalitats principals

- Pantalla inicial amb pel·lícules populars i millor valorades.
- Cerca dinàmica de pel·lícules per títol.
- Vista de detall amb pòster, sinopsi i valoració.
- Sistema de watchlist personal.
- Registre i inici de sessió amb Firebase.
- Autenticació biomètrica (Face ID / Touch ID).
- Perfil d’usuari amb edició de nom.
- Suport multillenguatge (castellà i anglès).
- Disseny adaptat per a iPhone i iPad.

---

## 🧭 Navegació de l’app

L’aplicació utilitza un **TabBar** amb quatre seccions:

1. **Home** – Pel·lícules populars i millor valorades  
2. **Search** – Cerca per text  
3. **Watchlist** – Llista personal (Firestore)  
4. **Profile** – Dades d’usuari i tancament de sessió  

---

## ⚙ Configuracións necessària

- Configurar el paràmetre CHANGE_FOR_YOUR_API_KEY a WikiFilms/nil.bagaria_alvaro.bello/nil.bagaria_alvaro.bello/WikiFilms/GoogleService-Info.plist amb una nova API KEY de Firebase.
- Configurar el paràmetre CHANGE_FOR_YOUR_TMDB_TOKEN a WikiFilms/nil.bagaria_alvaro.bello/nil.bagaria_alvaro.bello/WikiFilms/TMDB/TMDBRouter.swift amb un nou TOKEN de TMDB (The Movie Database).

---

## 🛠️ Tecnologies i SDKs

| Tecnologia | Ús |
|------------|----|
| **Xcode** | Entorn de desenvolupament |
| **Firebase Authentication** | Registre i inici de sessió |
| **Firestore** | Emmagatzematge de dades d’usuari i watchlist |
| **Alamofire** | Peticions HTTP a l’API |
| **SDWebImage** | Descàrrega i memòria cau d’imatges |
| **LocalAuthentication** | Face ID / Touch ID |

---

## 🌐 API utilitzada

**The Movie Database (TMDB) API**  
Proporciona informació actualitzada sobre pel·lícules: títol, sinopsi, valoració, dates d’estrena i imatges promocionals.

---

## 🔐 Autenticació

- Registre i inici de sessió amb correu electrònic i contrasenya.
- Autenticació biomètrica només si ja existeix una sessió.
- Gestió segura amb Firebase Authentication.
- Dades addicionals (nom d’usuari i watchlist) emmagatzemades a Firestore.

---

## 🎨 Disseny

- Prototip inicial dissenyat amb **Figma**.

Figma:  
https://www.figma.com/design/3wGtDe9z4RlYiNZxtpOF4t/Projectes-Mobils

---

## 👨‍💻 Autors

- Alvaro Bello Garrido  
- Nil Bagaria Nofre  

La Salle – Universitat Ramon Llull  
Grau en Enginyeria Informàtica  
Assignatura Programació de Dispositius Mòbils  
Curs 2025–2026
