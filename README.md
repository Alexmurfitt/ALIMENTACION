# 🍏 NutriApp

**NutriApp** es un sistema de seguimiento de alimentos que te permite registrar alimentos con sus macronutrientes y micronutrientes, y calcular su aporte nutricional según la cantidad consumida.

> Hecho en **Python + Flask + MySQL**

---

## ✅ Funcionalidades

- Registro de alimentos (con macros y micros)
- Cálculo automático por gramos introducidos
- Visualización de resumen nutricional en interfaz web

---

## 🗂️ Estructura del proyecto

```bash
ALIMENTACION/
├── data/               # Documentos de apoyo (Excel, textos)
│   └── DIETA COMPLETA.xlsx
│
├── nutriapp/           # Código principal de la app Flask
│   ├── app.py
│   ├── config.py
│   ├── __init__.py
│   └── templates/
│       ├── alimento_form.html
│       ├── index.html
│       └── resumen.html
│
├── scripts/            # SQL y scripts de utilidad
│   ├── ALIMENTACION.sql
│   ├── ASIG_ALIM.py
│   ├── ASIG_ALIM_CANT.py
│   └── CONSULTAS_ALIMENTACION.sql
│
├── README.md
└── __pycache__/

▶️ Ejemplo de uso del script en terminal

Nombre del alimento: Avena
Proteínas: 11
Carbohidratos: 66
Grasas: 7
¿Incluir micronutrientes? s
Nombre del micronutriente: hierro
Valor: 4.2
Nombre del micronutriente: calcio
Valor: 52
Nombre del micronutriente: fin
✅ Alimento añadido.

🚀 Cómo ejecutar el proyecto (modo local)

   1.Clona el repositorio:
git clone git@github.com:Alexmurfitt/ALIMENTACION.git
cd ALIMENTACION

   2 Crea y activa un entorno virtual:

python3.13 -m venv venv
source venv/bin/activate

    Instala dependencias:

pip install flask mysql-connector-python

    Crea la base de datos desde:

scripts/ALIMENTACION.sql
Lanza la app:

cd nutriapp
python app.py

Abre tu navegador y entra en:

http://127.0.0.1:5000

✍️ Autor
Alexander Murfitt Santana

🔗 GitHub
📜 Licencia

Este proyecto está bajo la licencia MIT.
¡Siéntete libre de usarlo, mejorarlo y compartirlo!
