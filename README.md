# Tarket Contracts – Flutter Mobile App + Fake API

Este repositorio contiene el código fuente principal de la aplicación móvil **Tarket Contracts**, orientada a profesionales que buscan crear contratos digitales con desarrolladores. También incluye una API falsa (`fake-api/`) utilizada para pruebas locales sin necesidad de conexión a un backend real.

---

##  Estructura del Repositorio base

```
├── lib/      
│   ├── Contracts/
│   ├── Profile/
│   ├── IAM/
│   └── shared/
├── assets/   
├── fake-api/ 
│   ├── package.json
│   ├── package-lock.json
│   └── server.js
├── analysis\_options.yaml  
├── pubspec.yaml    
└── README.md  
````

---

## ✅ Pre-requisitos

- Flutter (v3.0+ recomendado)
- Node.js (v18+ recomendado) para la API falsa
- Herramienta SDK: NDK Version		27.0.12077973 instalada

---

## 🚀 Instalación Rápida

### 1. Clona el repositorio

```bash
git clone https://github.com/tu_usuario/tarket-contracts.git
cd tarket-contracts
````

### 2. Inicializa el proyecto Flutter

```bash
flutter pub get
flutter create .
```

Esto generará las carpetas faltantes como `android/`, `ios/`, `web/`, etc.

> Asegúrate de no sobrescribir `lib/`, `assets/` ni `pubspec.yaml` si `flutter create .` lo solicita.

---

### 3. Levanta la fake API (Node.js)

```bash
cd fake-api
npm install
node server.js
```

Esto inicia un servidor en `http://localhost:3000/` con rutas simuladas para pruebas.

---

### 3. Levantar emulador Android API 35+ de preferencia

### 4. Iniciar la aplicación
```bash
flutter run
```

## ⚠️ Notas Importantes

* La carpeta `node_modules/` **no está incluida** en el repositorio por buenas prácticas. Se genera automáticamente con `npm install`.
* No se incluyen las carpetas generadas por Flutter como `android/`, `ios/`, `.dart_tool/`, etc., para mantener el repositorio limpio y enfocado en el dominio.
* Al ejecutar `flutter create .` se generará automáticamente la estructura mínima necesaria para correr el proyecto localmente en cualquier entorno.

---