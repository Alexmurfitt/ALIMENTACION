# nutricion.py

def calcular_calorias(proteinas, carbohidratos, grasas):
    return (proteinas * 4) + (carbohidratos * 4) + (grasas * 9)

def mostrar_resumen(alimentos):
    print("\n📊 RESUMEN NUTRICIONAL\n")
    total_prote = total_carbs = total_grasas = total_kcal = 0
    micronutrientes_totales = {}

    for alimento in alimentos:
        p = alimento["proteinas"]
        c = alimento["carbohidratos"]
        g = alimento["grasas"]
        kcal = calcular_calorias(p, c, g)

        total_prote += p
        total_carbs += c
        total_grasas += g
        total_kcal += kcal

        print(f"🍏 {alimento['nombre']}")
        print(f"   Proteínas:     {p} g")
        print(f"   Carbohidratos: {c} g")
        print(f"   Grasas:        {g} g")
        print(f"   Calorías:      {kcal} kcal")

        if alimento["micros"]:
            for clave, valor in alimento["micros"].items():
                micronutrientes_totales[clave] = micronutrientes_totales.get(clave, 0) + valor

    print("\n✅ Totales diarios:")
    print(f"   🥩 Proteínas:     {total_prote} g")
    print(f"   🍞 Carbohidratos: {total_carbs} g")
    print(f"   🥑 Grasas:        {total_grasas} g")
    print(f"   🔥 Calorías:      {total_kcal} kcal")

    if micronutrientes_totales:
        print("\n🌱 Micronutrientes (estimados):")
        for micro, valor in micronutrientes_totales.items():
            print(f"   {micro}: {valor} mg")

def main():
    alimentos = []

    print("🍽️  ANALIZADOR DE ALIMENTOS\n")
    while True:
        nombre = input("Nombre del alimento (o 'fin' para terminar): ").strip()
        if nombre.lower() == 'fin':
            break

        try:
            p = float(input("  Proteínas (g): "))
            c = float(input("  Carbohidratos (g): "))
            g = float(input("  Grasas (g): "))

            incluir_micros = input("  ¿Incluir micronutrientes? (s/n): ").strip().lower()
            micros = {}

            if incluir_micros == 's':
                while True:
                    micro = input("    Nombre del micronutriente (o 'fin'): ").strip()
                    if micro == 'fin':
                        break
                    valor = float(input(f"    Valor de {micro} (mg): "))
                    micros[micro] = valor

            alimentos.append({
                "nombre": nombre,
                "proteinas": p,
                "carbohidratos": c,
                "grasas": g,
                "micros": micros
            })
            print("✅ Alimento añadido.\n")

        except ValueError:
            print("⚠️  Entrada inválida. Inténtalo de nuevo.\n")

    if alimentos:
        mostrar_resumen(alimentos)
    else:
        print("No se ingresaron alimentos.")

if __name__ == "__main__":
    main()
