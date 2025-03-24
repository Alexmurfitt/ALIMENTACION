## CONSULTAS AVANZADAS PARA OPTIMIZAR BASE DE DATOS NUTRICIONAL:

### 1\. Consultar composición detallada de una comida específica:
SELECT 
    m.name AS 'Nombre de la Comida',
    f.name AS 'Alimento',
    mi.amount_g AS 'Cantidad (g)',
    mi.total_kcal AS 'Kcal Totales',
    mi.total_protein AS 'Proteína Total',
    mi.total_carbs AS 'Carbohidratos Totales',
    mi.total_fat AS 'Grasas Totales'
FROM meal_items mi
INNER JOIN foods f ON mi.food_id = f.id
INNER JOIN meals m ON mi.meal_id = m.id
WHERE m.name = 'Comida 1';

### 2\. Resumen nutricional total de cada comida:
SELECT
    m.name AS 'Nombre de la Comida',
    m.time AS 'Hora',
    SUM(mi.total_kcal) AS 'Total Kcal',
    SUM(mi.total_protein) AS 'Total Proteínas',
    SUM(mi.total_carbs) AS 'Total Carbohidratos',
    SUM(mi.total_fat) AS 'Total Grasas'
FROM meal_items mi
INNER JOIN meals m ON mi.meal_id = m.id
GROUP BY m.name, m.time;

## 3\. Buscar alimentos altos en proteínas de origen vegetal o animal para ajustar comidas:

SELECT 
    name AS 'Alimento',
    protein_per_100g AS 'Proteína por 100g',
    protein_source AS 'Fuente de proteína'
FROM foods
WHERE protein_per_100g > 10
ORDER BY protein_per_100g DESC;

-- (Cambia el número `10` para ajustar tu búsqueda según tus necesidades.)*

### 4\. Crear comidas ajustadas exactamente a objetivos nutricionales específicos  
-- (Supón un objetivo diario de una comida: 600 kcal, mínimo 40g proteína, máximo 20g grasas)

SELECT 
    name AS 'Alimento',
    kcal_per_100g,
    protein_per_100g,
    carbs_per_100g,
    fat_per_100g,
    ROUND((600 / kcal_per_100g) * 100, 2) AS 'Cantidad (g) para 600kcal',
    ROUND((protein_per_100g * (600 / kcal_per_100g)),2) AS 'Proteína total (g)',
    ROUND((fat_per_100g * (600 / kcal_per_100g)),2) AS 'Grasas totales (g)',
    ROUND((carbs_per_100g * (600 / kcal_per_100g)),2) AS 'Carbos totales (g)'
FROM foods
WHERE (protein_per_100g * (600 / kcal_per_100g)) >= 40
AND (fat_per_100g * (600 / kcal_per_100g)) <= 20;
-- Esta consulta te indica claramente cuánto alimento usar exactamente para alcanzar objetivos nutricionales muy específicos._

### 5\. Identificar rápidamente alimentos según fuente proteica:
SELECT
    protein_source AS 'Fuente Proteica',
    COUNT(*) AS 'Cantidad Alimentos'
FROM foods
GROUP BY protein_source;

### 6\. Búsqueda avanzada de comidas por rango nutricional:  
-- (Ejemplo: comidas que tengan entre 500 y 800 kcal, mínimo 25g proteína y máximo 30g grasas)
SELECT
    m.name AS 'Comida',
    SUM(mi.total_kcal) AS 'Total Kcal',
    SUM(mi.total_protein) AS 'Proteína Total',
    SUM(mi.total_carbs) AS 'Carbohidratos Totales',
    SUM(mi.total_fat) AS 'Grasas Totales'
FROM meals m
INNER JOIN meal_items mi ON mi.meal_id = m.id
GROUP BY m.name
HAVING SUM(mi.total_kcal) BETWEEN 500 AND 800
AND SUM(mi.total_protein) >= 25
AND SUM(mi.total_fat) <= 30;

-- 7\. Modificar dinámicamente cantidades de un alimento dentro de una comida para ajustar nutrientes:
-- Supón que quieres ajustar el yogur natural en la comida 1 a 200g:
UPDATE meal_items
SET 
    amount_g = 200,
    total_kcal = (SELECT kcal_per_100g FROM foods WHERE id = food_id) * 2,
    total_protein = (SELECT protein_per_100g FROM foods WHERE id = food_id) * 2,
    total_carbs = (SELECT carbs_per_100g FROM foods WHERE id = food_id) * 2,
    total_fat = (SELECT fat_per_100g FROM foods WHERE id = food_id) * 2
WHERE meal_id = 1 AND food_id = (SELECT id FROM foods WHERE name = 'Yogur natural');

-- (Multiplicas por 2 porque 200g es el doble de 100g. Para otras cantidades usa la proporción correcta.)*

## 🚀 **Sugerencias para una base de datos nutricional de vanguardia:**

-- Incorpora en el futuro columnas detalladas para micronutrientes.
-- Añade un sistema de etiquetas (`tags`) como "desayuno", "pre-entreno", "post-entreno", etc.
-- Incorpora funciones personalizadas o procedimientos almacenados para automatizar cálculos nutricionales avanzados.
-- Usa vistas (`views`) para simplificar consultas comunes.

## 🔍 Próximas mejoras avanzadas que te recomiendo incorporar:

-- **Micronutrientes**: Vitaminas, minerales y fibra por alimento.
-- **Histórico**: Registro histórico de modificaciones en comidas.
-- **Dietas**: Creación automática de dietas según perfiles de atletas (objetivos, fases, etc.).
-- **Sugerencias Automáticas**: Procedimientos que sugieran automáticamente combinaciones óptimas según objetivos.

-- Usando estas consultas como punto de partida, tendrás la capacidad de manipular tu base de datos nutricional con total precisión y eficiencia, adaptándola a cualquier objetivo o necesidad futura que surja.
-- ¡Estoy aquí para apoyarte en el siguiente paso!
