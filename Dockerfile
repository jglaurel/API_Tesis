# Imagen base con Python
FROM python:3.12-slim

# Evitar buffering de stdout/stderr
ENV PYTHONUNBUFFERED=1

# Forzar uso de CPU (como haces en main2.py)
ENV CUDA_VISIBLE_DEVICES=-1

# Crear directorio de trabajo
WORKDIR /app

# Instalar dependencias del sistema para opencv, etc.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

# Copiar requirements e instalarlos
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el código de la API y el modelo
COPY main.py resnet50_v21.h5 /app/

# Exponer el puerto de FastAPI
EXPOSE 8000

# Comando para arrancar la API
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
