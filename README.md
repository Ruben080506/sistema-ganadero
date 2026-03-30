<div align="center">

# 🐄 Sistema de Gestión Ganadera Inteligente

### Monitoreo integral de fincas ganaderas con tecnología cloud y escaneo QR

[![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-009688?style=flat-square&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![Flutter](https://img.shields.io/badge/Flutter-Stable-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-47A248?style=flat-square&logo=mongodb&logoColor=white)](https://www.mongodb.com/atlas)
[![Python](https://img.shields.io/badge/Python-3.11-3776AB?style=flat-square&logo=python&logoColor=white)](https://python.org)
[![Render](https://img.shields.io/badge/Hosted_on-Render-46E3B7?style=flat-square&logo=render&logoColor=white)](https://render.com)

</div>

---

## 📋 Tabla de Contenidos

- [Descripción General](#-descripción-general)
- [Funcionalidades](#-funcionalidades-principales)
- [Arquitectura del Sistema](#-arquitectura-del-sistema)
- [Tecnologías](#%EF%B8%8F-tecnologías)
- [Pre-requisitos](#-pre-requisitos)
- [Instalación](#-instalación-y-configuración)
- [Uso](#-uso-y-flujo-de-trabajo)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Variables de Entorno](#-variables-de-entorno)
- [API Reference](#-api-reference)
- [Autores](#%EF%B8%8F-autores)


---

## 📖 Descripción General

**Sistema de Gestión Ganadera Inteligente** es una solución full-stack diseñada para modernizar la administración de fincas ganaderas. Combina una **aplicación móvil Flutter** con un **backend Python de alto rendimiento**, permitiendo a los ganaderos gestionar su hato de forma eficiente, precisa y en tiempo real desde cualquier lugar.

> 💡 **¿Por qué este sistema?** El manejo manual de registros ganaderos es propenso a errores y pérdidas de información. Este sistema digitaliza y centraliza toda la información, desde el peso hasta el historial médico de cada animal, con una simple lectura de código QR.

### ¿Qué resuelve?

| Problema Tradicional | Solución del Sistema |
|---|---|
| Registros en papel fáciles de perder | Base de datos cloud sincronizada en tiempo real |
| Difícil identificación de animales | Escaneo QR instantáneo desde la app |
| Historial médico desorganizado | Fichas digitales por animal con historial completo |
| Sin acceso remoto a la información | API REST accesible desde cualquier dispositivo |



## ✨ Funcionalidades Principales

- [x] **Gestión de animales** — Registro con ID único (ej: `VACA098`), raza, edad y propietario
- [x] **Escaneo QR** — Identificación inmediata del animal via cámara del celular
- [x] **Control de peso** — Historial de pesajes con análisis de curva de crecimiento
- [x] **Historial médico** — Registro de vacunas, tratamientos y revisiones veterinarias
- [x] **Sincronización cloud** — Datos actualizados en tiempo real en MongoDB Atlas
- [x] **API REST documentada** — Endpoints Swagger para integración con otros sistemas
- [ ] **Reportes en PDF** — Generación de informes por animal o lote *(próximamente)*
- [ ] **Notificaciones push** — Alertas de vacunas y controles pendientes *(próximamente)*
- [ ] **Módulo de reproducción** — Seguimiento de ciclos y gestaciones *(próximamente)*

---

## 🏗️ Arquitectura del Sistema

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENTE (Android)                        │
│  ┌─────────────────────────────────────────────────────┐   │
│  │          Aplicación Flutter (Dart)                  │   │
│  │  ┌──────────┐  ┌────────────┐  ┌─────────────────┐ │   │
│  │  │  UI/UX   │  │  Estado    │  │  Escáner QR     │ │   │
│  │  │  Widgets │  │ (Provider) │  │  (Cámara)       │ │   │
│  │  └──────────┘  └────────────┘  └─────────────────┘ │   │
│  │              Paquete HTTP                          │   │
│  └────────────────────┬───────────────────────────────┘   │
└───────────────────────│────────────────────────────────────┘
                        │ HTTPS / REST
┌───────────────────────▼────────────────────────────────────┐
│                 BACKEND (Render Cloud)                     │
│  ┌─────────────────────────────────────────────────────┐  │
│  │    Python 3.11 + FastAPI (Uvicorn/Gunicorn)         │  │
│  │  ┌──────────┐  ┌────────────┐  ┌─────────────────┐ │  │
│  │  │ Rutas    │  │  Modelos   │  │ Lógica de       │ │  │
│  │  │ (REST)   │  │ Pydantic   │  │ negocio y       │ │  │
│  │  │          │  │            │  │ validación      │ │  │
│  │  └──────────┘  └────────────┘  └─────────────────┘ │  │
│  └────────────────────┬───────────────────────────────┘  │
└───────────────────────│───────────────────────────────────┘
                        │ Driver de MongoDB
┌───────────────────────▼────────────────────────────────────┐
│              BASE DE DATOS (MongoDB Atlas)                │
│      Colecciones: animales | registros | vacunas          │
└────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Tecnologías

### Frontend — Móvil

| Tecnología | Versión | Propósito |
|---|---|---|
| [Flutter](https://flutter.dev) | Stable | Framework UI multiplataforma |
| [Dart](https://dart.dev) | 3.x | Lenguaje de programación |
| [http](https://pub.dev/packages/http) | latest | Comunicación con la API REST |
| [mobile_scanner](https://pub.dev/packages/mobile_scanner) | latest | Escaneo de códigos QR |
| [Provider](https://pub.dev/packages/provider) | latest | Gestión del estado |

### Backend — Servidor

| Tecnología | Versión | Propósito |
|---|---|---|
| [Python](https://python.org) | 3.11 | Lenguaje base del servidor |
| [FastAPI](https://fastapi.tiangolo.com) | 0.100+ | Framework REST asíncrono |
| [Motor / PyMongo](https://motor.readthedocs.io) | latest | Driver para MongoDB |
| [Pydantic](https://docs.pydantic.dev) | v2 | Validación de datos y esquemas |
| [Uvicorn](https://www.uvicorn.org) | latest | Servidor ASGI de producción |
| [Gunicorn](https://gunicorn.org) | latest | Process manager en producción |

### Infraestructura

| Servicio | Propósito |
|---|---|
| [MongoDB Atlas](https://www.mongodb.com/atlas) | Base de datos NoSQL en la nube |
| [Render](https://render.com) | Hosting del backend API |

---

## 📋 Pre-requisitos

Asegúrate de tener instalado lo siguiente antes de comenzar:

```bash
# Verificar versiones
flutter --version    # Flutter SDK (canal stable)
python --version     # Python 3.10 o superior
dart --version       # Dart SDK (incluido con Flutter)
```

**Herramientas necesarias:**

- ✅ [Flutter SDK](https://docs.flutter.dev/get-started/install) (canal stable)
- ✅ [Python 3.10+](https://www.python.org/downloads/)
- ✅ [Android Studio](https://developer.android.com/studio) o [VS Code](https://code.visualstudio.com/) con extensiones de Dart y Python
- ✅ [Git](https://git-scm.com/)
- ✅ Conexión a internet (para MongoDB Atlas y Render)

---

## 🔧 Instalación y Configuración

### 1. Clonar el Repositorio

```bash
git clone https://github.com/tu-usuario/sistema-ganadero.git
cd sistema-ganadero
```

### 2. Configurar el Backend

```bash
# Entrar al directorio del backend
cd backend_python

# Crear y activar entorno virtual
python -m venv venv

# En Linux/macOS:
source venv/bin/activate

# En Windows:
venv\Scripts\activate

# Instalar dependencias
pip install -r requirements.txt

# Copiar variables de entorno
cp .env.example .env
# → Edita el archivo .env con tus credenciales de MongoDB Atlas

# Iniciar el servidor en modo desarrollo
uvicorn app.main:app --reload --port 8000
```

> ✅ El servidor estará disponible en `http://localhost:8000`
> ✅ La documentación Swagger en `http://localhost:8000/docs`

### 3. Configurar el Frontend (App Flutter)

```bash
# Volver a la raíz y entrar al proyecto Flutter
cd ../flutter_app

# Instalar dependencias de Flutter
flutter pub get
```

**Configurar la URL del API:**

Abre el archivo `lib/services/api_services.dart` y ajusta la variable `baseUrl`:

```dart
// Para desarrollo local:
final String baseUrl = "http://10.0.2.2:8000"; // Emulador Android
// final String baseUrl = "http://192.168.x.x:8000"; // Dispositivo físico

// Para producción (Render):
// final String baseUrl = "https://sistema-ganadero-1.onrender.com";
```

**Ejecutar la aplicación:**

```bash
# Listar dispositivos disponibles
flutter devices

# Ejecutar en el dispositivo/emulador
flutter run

# Compilar APK de release
flutter build apk --release
```

---

## 📖 Uso y Flujo de Trabajo

```
┌─────────────┐     ┌─────────────────┐     ┌─────────────────────┐
│  1. Registro │────▶│  2. Código QR   │────▶│  3. Gestión Médica  │
│             │     │                 │     │                     │
│ El admin    │     │ Se imprime el QR│     │ Vacunas, revisiones │
│ crea la     │     │ y se coloca en  │     │ directamente en el  │
│ ficha del   │     │ el animal       │     │ corral desde la app │
│ animal      │     │ (collar/tag)    │     │                     │
└─────────────┘     └─────────────────┘     └─────────┬───────────┘
                                                       │
                    ┌──────────────────────────────────▼───┐
                    │         4. Actualización de Peso      │
                    │                                       │
                    │  Se ingresa el peso → sincroniza con  │
                    │  la nube → análisis de crecimiento    │
                    └───────────────────────────────────────┘
```

**Flujo detallado:**

1. **Registro:** El administrador crea una ficha digital para cada animal (ID: `VACA098`, `TORO012`, etc.) con datos como raza, fecha de nacimiento y peso inicial.

2. **Identificación QR:** Se genera y asocia un código QR único al animal. Al escanearlo desde la app, se carga inmediatamente toda su información.

3. **Gestión Médica:** Desde el corral, el veterinario o ganadero registra vacunas aplicadas y revisiones periódicas directamente en el teléfono.

4. **Control de Peso:** Se ingresa el peso actual del animal y el sistema lo almacena con fecha y hora, generando automáticamente una curva de crecimiento.

---

## 📁 Estructura del Proyecto

```
sistema-ganadero/
├── 📁 backend_python/
│   ├── 📁 app/
│   │   ├── 📄 main.py              # Punto de entrada FastAPI
│   │   ├── 📁 routes/              # Endpoints REST
│   │   │   ├── 📄 animals.py
│   │   │   ├── 📄 medical.py
│   │   │   └── 📄 weights.py
│   │   ├── 📁 models/              # Esquemas Pydantic
│   │   ├── 📁 database/            # Conexión MongoDB
│   │   └── 📁 services/            # Lógica de negocio
│   ├── 📄 requirements.txt
│   ├── 📄 .env.example
│   └── 📄 Procfile                 # Config para Render
│
├── 📁 flutter_app/
│   ├── 📁 lib/
│   │   ├── 📄 main.dart            # Punto de entrada Flutter
│   │   ├── 📁 screens/             # Pantallas de la app
│   │   ├── 📁 services/            # Comunicación API
│   │   │   └── 📄 api_services.dart
│   │   ├── 📁 models/              # Modelos de datos Dart
│   │   ├── 📁 widgets/             # Componentes reutilizables
│   │   └── 📁 providers/           # Gestión del estado
│   ├── 📄 pubspec.yaml
│   └── 📄 android/
│
└── 📄 README.md
```

---

## 🔐 Variables de Entorno

Crea un archivo `.env` en `backend_python/` basándote en `.env.example`:

```env
# Base de Datos
MONGODB_URL=mongodb+srv://usuario:password@cluster.mongodb.net/
DATABASE_NAME=sistema_ganadero
```

---

## 📡 API Reference

La documentación completa e interactiva está disponible en:

**🔗 [https://sistema-ganadero.onrender.com/docs](https://sistema-ganadero.onrender.com/docs)**

**Endpoints principales:**

| Método | Endpoint | Descripción |
|---|---|---|
| `GET` | `/animals` | Listar todos los animales |
| `POST` | `/animals` | Registrar nuevo animal |
| `GET` | `/animals/{id}` | Obtener ficha por ID |
| `PUT` | `/animals/{id}` | Actualizar datos del animal |
| `POST` | `/animals/{id}/weight` | Registrar nuevo peso |
| `GET` | `/animals/{id}/weights` | Historial de pesos |
| `POST` | `/animals/{id}/medical` | Registrar evento médico |
| `GET` | `/animals/{id}/medical` | Historial médico |

## ✒️ Autores

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/LeandroBatioja">
        <b>Leandro Batioja</b>
      </a>
      <br />
      <sub>Backend · Cloud Infrastructure</sub>
    </td>
    <td align="center">
      <a href="https://github.com/Ruben080506">
        <b>Rubén Bone</b>
      </a>
      <br />
      <sub></sub>
    </td>
    <td align="center">
      <a href="">
        <b>Josué Tofiño</b>
      </a>
      <br />
      <sub></sub>
    </td>
  </tr>
</table>

---
