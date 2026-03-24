from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.routes.ganado import router as ganado_router
from app.database import test_connection


# =========================
# Crear app
# =========================

app = FastAPI(
    title="AgroScan API",
    description="Backend para el control de trazabilidad ganadera (Offline-First)",
    version="1.0.0"
)


# =========================
# CORS (IMPORTANTE para celular)
# =========================

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # permitir celular, PC, emulador
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# =========================
# Evento startup
# =========================

@app.on_event("startup")
async def startup_db_client():

    if await test_connection():

        print(">>> API conectada exitosamente a MongoDB Atlas <<<")

    else:

        print("XXX Error crítico: No se pudo conectar a la base de datos XXX")


# =========================
# Rutas
# =========================

app.include_router(
    ganado_router,
    prefix="/ganado",
    tags=["Ganado"]
)


# =========================
# Root
# =========================

@app.get("/", tags=["General"])
async def root():
    return {
        "mensaje": "Bienvenido a la API de AgroScan - Sistema de Control Ganadero"
    }