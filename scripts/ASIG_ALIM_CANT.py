# nutricion_mysql.py

import mysql.connector

# 📌 CONFIGURA TUS DATOS DE CONEXIÓN
config = {
    "host": "localhost",
    "user": "tu_usuario_mysql",
    "password": "tu_contraseña",
    "database": "nutricion"
}

def conectar():
    return mysql.connector.connect(**config)

def insertar_alimento(nombre, prote, carbs, grasas, kcal):
    conn = conectar()
    cursor = conn.cursor()
    sql = """
        INSERT INTO alimentos (nombre, proteinas, carbohidratos, grasas, kcal)
        VALUES (%s, %s, %s, %s, %s)
    """
    cursor.execute(sql, (nombre, prote, carbs, grasas, kcal))
    conn.commit()
    alimento_id = cursor.lastrowid
    cursor.close()
    conn.close()
    return alimento_id

def insertar_micronutriente(alimento_id, nombre, cantidad_mg):
    conn = conectar()
    cursor = conn.cursor()
    sql = """
        INSERT INTO micronutrientes (alimento_id, nombre, cantidad_mg)
        VALUES (%s, %s, %s)
    """
    cursor.execute(sql, (alimento_id, nombre, cantidad_mg))
    conn.commit()
    cursor.close()
    conn.close()

def calcular_valores(nombre_alimento, gramos):
    conn = conectar()
    cursor = conn.cursor(dictionary=True)

    # Buscar alimento
    cursor.execute("SELECT * FROM alimentos WHERE nombre = %s", (nombre_alimento,))
    alimento = cursor.fetchone()

    if not alimento:
        print("❌ Alimento no encontrado.")
        return

    factor = gramos / 100

    print(f"\n🍽️ Cálculo nutricional para {gramos}g de {nombre_alimento}:\n")
    print(f"  🥩 Proteínas:     {alimento['proteinas'] * factor:.2f} g")
    print(f"  🍞 Carbohidratos: {alimento['carbohidratos'] * factor:.2f} g")
    print(f"  🥑 Grasas:        {alimento['grasas'] * factor:.2f} g")
    print(f"  🔥 Calorías:      {alimento['kcal'] * factor:.2f} kcal")

    # Micronutrientes
    cursor.execute("SELECT nombre, cantidad_mg FROM micronutrientes WHERE alimento_id = %s", (alimento['id'],))
    micros = cursor.fetchall()

    if micros:
        print("\n🌿 Micronutrientes:")
        for m in micros:
            print(f"  {m['nombre']}: {m['cantidad_mg'] * factor:.2f} mg")

    cursor.close()
    conn.close()

def menu():
    while True:
        print("\n📋 MENÚ")
        print("[1] Añadir alimento")
        print("[2] Calcular macros/micros por cantidad")
        print("[3] Salir")
        opcion = input("Opción: ")

        if opcion == "1":
            nombre = input("Nombre del alimento: ")
            prote = float(input("Proteínas por 100g: "))
            carbs = float(input("Carbohidratos por 100g: "))
            grasas = float(input("Grasas por 100g: "))
            kcal = (prote * 4) + (carbs * 4) + (grasas * 9)
            alimento_id = insertar_alimento(nombre, prote, carbs, grasas, kcal)
            print(f"✅ Alimento '{nombre}' guardado con ID {alimento_id}.")

            agregar_micros = input("¿Agregar micronutrientes? (s/n): ").lower()
            while agregar_micros == "s":
                micro = input("  Nombre del micronutriente: ")
                valor = float(input(f"  Cantidad por 100g (mg): "))
                insertar_micronutriente(alimento_id, micro, valor)
                agregar_micros = input("¿Agregar otro? (s/n): ").lower()

        elif opcion == "2":
            nombre = input("Nombre del alimento: ")
            gramos = float(input("Cantidad consumida (g): "))
            calcular_valores(nombre, gramos)

        elif opcion == "3":
            print("¡Hasta pronto!")
            break
        else:
            print("❌ Opción no válida.")

if __name__ == "__main__":
    menu()
