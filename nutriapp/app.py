# app.py
from flask import Flask, render_template, request, redirect
import mysql.connector
from config import DB_CONFIG
from datetime import date

app = Flask(__name__)

def conectar():
    return mysql.connector.connect(**DB_CONFIG)

@app.route('/')
def index():
    return render_template("index.html")

@app.route('/alimentos', methods=["GET", "POST"])
def alimentos():
    if request.method == "POST":
        nombre = request.form["nombre"]
        prote = float(request.form["proteinas"])
        carbs = float(request.form["carbohidratos"])
        grasas = float(request.form["grasas"])
        kcal = prote * 4 + carbs * 4 + grasas * 9

        conn = conectar()
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO alimentos (nombre, proteinas, carbohidratos, grasas, kcal)
            VALUES (%s, %s, %s, %s, %s)
        """, (nombre, prote, carbs, grasas, kcal))
        conn.commit()
        cur.close()
        conn.close()
        return redirect("/")

    return render_template("alimento_form.html")

@app.route('/resumen/<int:alimento_id>/<int:cantidad>')
def resumen(alimento_id, cantidad):
    conn = conectar()
    cur = conn.cursor(dictionary=True)

    cur.execute("SELECT * FROM alimentos WHERE id = %s", (alimento_id,))
    a = cur.fetchone()

    factor = cantidad / 100
    resultado = {
        "nombre": a["nombre"],
        "proteinas": a["proteinas"] * factor,
        "carbohidratos": a["carbohidratos"] * factor,
        "grasas": a["grasas"] * factor,
        "kcal": a["kcal"] * factor,
        "cantidad": cantidad
    }

    cur.execute("SELECT nombre, cantidad_mg FROM micronutrientes WHERE alimento_id = %s", (alimento_id,))
    resultado["micros"] = [
        {"nombre": m["nombre"], "valor": m["cantidad_mg"] * factor}
        for m in cur.fetchall()
    ]

    cur.close()
    conn.close()

    return render_template("resumen.html", datos=resultado)

if __name__ == "__main__":
    app.run(debug=True)
