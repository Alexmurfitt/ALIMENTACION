DROP DATABASE IF EXISTS ALIMENTACION;
CREATE DATABASE ALIMENTACION;
USE ALIMENTACION;

-- TABLA DE ÍTEMS DE COMIDAS
-- ========================

-- 1. TABLA DE ALIMENTOS
CREATE TABLE foods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    kcal_per_100g FLOAT NOT NULL,
    protein_per_100g FLOAT DEFAULT 0,
    carbs_per_100g FLOAT DEFAULT 0,
    fat_per_100g FLOAT DEFAULT 0,
    protein_source ENUM('animal', 'vegetal', 'mixto', 'sin_proteina') DEFAULT 'sin_proteina'
);
-- 2. TABLA DE COMIDAS
CREATE TABLE meals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    time TIME
);

-- 3. TABLA DE ÍTEMS DE COMIDAS
CREATE TABLE meal_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    meal_id INT NOT NULL,
    food_id INT NOT NULL,
    amount_g FLOAT NOT NULL,
    total_kcal FLOAT,
    total_protein FLOAT,
    total_carbs FLOAT,
    total_fat FLOAT,
    FOREIGN KEY (meal_id) REFERENCES meals(id),
    FOREIGN KEY (food_id) REFERENCES foods(id)
);
-- 2. Trigger para calcular automáticamente los totales
DELIMITER //

CREATE TRIGGER calc_meal_item_totals
BEFORE INSERT ON meal_items
FOR EACH ROW
BEGIN
    DECLARE kcal FLOAT;
    DECLARE protein FLOAT;
    DECLARE carbs FLOAT;
    DECLARE fat FLOAT;

    SELECT kcal_per_100g, protein_per_100g, carbs_per_100g, fat_per_100g
    INTO kcal, protein, carbs, fat
    FROM foods
    WHERE id = NEW.food_id;

    SET NEW.total_kcal = kcal * NEW.amount_g / 100;
    SET NEW.total_protein = protein * NEW.amount_g / 100;
    SET NEW.total_carbs = carbs * NEW.amount_g / 100;
    SET NEW.total_fat = fat * NEW.amount_g / 100;
END;
//
DELIMITER ;

-- ========================
-- DATOS DE ALIMENTOS
-- ========================
-- Insertar alimentos
INSERT INTO foods (name, kcal_per_100g, protein_per_100g, carbs_per_100g, fat_per_100g) VALUES
('Arándanos congelados', 52, 0.7, 11, 0),
('Zumo de naranja', 45, 0.9, 10, 0.2),
('Chocolate negro', 616, 12, 35, 56),
('Alga espirulina', 355, 56.02, 1.03, 4.3),
('Maca', 289, 14, 64, 2),
('Açaí', 533, 8.6, 8.8, 44.5),
('Manzana Golden', 52, 0.3, 14, 0.2),
('Platano de Canarias', 89, 1.1, 22.8, 0.3),
('Yogur natural', 40, 4.5, 5.3, 0.1);

-- Insertar comida
INSERT INTO meals (name, time) VALUES ('Comida 1', '07:30:00');

-- Insertar ítems de la comida (asumiendo meal_id = 1 y foods id del 1 al 9)
INSERT INTO meal_items (meal_id, food_id, amount_g, total_kcal, total_protein, total_carbs, total_fat) VALUES
(1, 1, 300, 156, 2.1, 33, 0),
(1, 2, 330, 148.5, 2.97, 33, 0.66),
(1, 3, 18, 110.88, 2.16, 6.3, 10.08),
(1, 4, 5, 17.75, 2.801, 0.0515, 0.215),
(1, 5, 5, 14.45, 0.7, 3.2, 0.1),
(1, 6, 5, 26.65, 0.43, 0.44, 2.225),
(1, 7, 160, 83.2, 0.48, 22.4, 0.32),
(1, 8, 160, 142.4, 1.76, 36.48, 0.48),
(1, 9, 125, 50, 5.625, 6.625, 0.125);

-- ========================
-- Archivo: comidas_2.sql
-- ========================
INSERT INTO foods (name, kcal_per_100g, protein_per_100g, carbs_per_100g, fat_per_100g) VALUES
('Avena', 375, 14, 59, 7),
('Almendras', 586, 24, 8.1, 48),
('Queso Fresco Batido', 46, 8, 3.5, 0.5),
('Atún (lata)', 150, 23, 0.4, 10),
('Huevo entero (1 huevo)', 143, 12, 0.5, 10),
('Claras de huevo (2 claras)', 52, 11, 0.4, 0.2);



-- Insertar comidas
INSERT INTO meals (name, time) VALUES 
('Comida 2-A', '11:00:00'),
('Comida 2-B', '11:00:00');

-- Insertar ítems de comida 2-A (meal_id = 2)
INSERT INTO meal_items (meal_id, food_id, amount_g, total_kcal, total_protein, total_carbs, total_fat) VALUES
(2, 10, 80, 300, 11.2, 47.84, 5.6),
(2, 11, 80, 468.8, 19.2, 6.48, 38.4),
(2, 3, 125, 50, 5.625, 6.625, 0.125),
(2, 12, 250, 115, 20, 8.75, 1.25);

-- Insertar ítems de comida 2-B (meal_id = 3)
INSERT INTO meal_items (meal_id, food_id, amount_g, total_kcal, total_protein, total_carbs, total_fat) VALUES
(3, 13, 80, 120, 18.4, 0.4, 8),
(3, 14, 50, 71.5, 6.5, 0.2, 5),
(3, 15, 66, 34.32, 7.26, 0.264, 0.132);

-- ========================
-- Archivo: comidas_3.sql
-- ========================

-- Insertar nuevos alimentos (evitando duplicados, esto es solo ejemplo)
INSERT INTO foods (name, kcal_per_100g, protein_per_100g, carbs_per_100g, fat_per_100g) VALUES
('Arroz rojo', 329, 7.4, 69, 2.9),
('Arroz blanco', 343, 7.2, 74, 2.5),
('Quinoa real', 361, 12.3, 56.2, 6.2),
('Trío de quinoa', 360, 13, 57, 6),
('Lenteja pardina', 329, 24.5, 48, 1.6),
('Batata', 86, 1.6, 20.1, 0.1),
('Queso Burgos desnat.', 68, 12.3, 4.4, 0.2),
('Cebolla', 40, 1, 9.3, 0.1),
('Ajo', 149, 6.4, 27.5, 0.2),
('Aceite de oliva', 900, 0, 0, 100),
('Tomate cherry', 18, 0.9, 3.9, 0.1),
('Huevo entero', 150, 12.5, 0.5, 11.1),
('Menestra de verduras', 43, 2.6, 5.9, 0),
('Garbanzos', 348, 21.3, 47.5, 5),
('Judia Mungo', 314, 23.9, 44.2, 1.2),
('Judia Verde', 210, 2.4, 3.2, 0.1),
('Alubia roja', 292, 21.4, 40, 0.8),
('Frijoles negros', 315, 21.6, 23, 0.9);

-- Insertar comidas
INSERT INTO meals (name, time) VALUES 
('Comida 3-A', '16:30:00'),
('Comida 3-B', '16:30:00'),
('Comida 3-C', '16:30:00');

-- Comida 3-A (meal_id = 4)
INSERT INTO meal_items (meal_id, food_id, amount_g, total_kcal, total_protein, total_carbs, total_fat) VALUES
(4, 16, 17.51, 57.6079, 1.29574, 12.0819, 0.24514),
(4, 17, 17.51, 60.0593, 1.36578, 12.9571, 0.43775),
(4, 18, 17.51, 63.2111, 2.15373, 9.84062, 1.085162),
(4, 19, 17.51, 63.216, 2.2763, 9.9807, 1.0506),
(4, 5, 17.51, 57.6324, 2.45184, 8.42331, 0.28016),
(4, 6, 125, 215, 1.6, 26.25, 0.125),
(4, 7, 125, 85, 15.375, 5.5, 0.25),
(4, 8, 53, 21.2, 0.583, 4.929, 0.106),
(4, 9, 7, 10.43, 0.448, 1.925, 0.014),
(4, 10, 3, 27, 0, 0, 3),
(4, 11, 10, 1.8, 0.09, 0.39, 0.01),
(4, 12, 58, 87, 7.25, 0.29, 6.46);

-- Comida 3-B (meal_id = 5)
INSERT INTO meal_items (meal_id, food_id, amount_g, total_kcal, total_protein, total_carbs, total_fat) VALUES
(5, 13, 300, 129, 7.8, 17.7, 0),
(5, 6, 140, 120.4, 2.24, 28.14, 0.14),
(5, 7, 125, 85, 15.375, 5.5, 0.25),
(5, 8, 53, 21.2, 0.583, 4.929, 0.106),
(5, 9, 7, 10.43, 0.448, 1.925, 0.014),
(5, 10, 3, 27, 0, 0, 3),
(5, 11, 10, 1.8, 0.09, 0.39, 0.01),
(5, 12, 58, 87, 7.25, 0.29, 6.46);

-- Comida 3-C (meal_id = 6)
INSERT INTO meal_items (meal_id, food_id, amount_g, total_kcal, total_protein, total_carbs, total_fat) VALUES
(6, 5, 14.5985, 46.7152, 3.5766325, 5.95835, 0.175182),
(6, 14, 14.5985, 50.80278, 3.124079, 6.9184225, 0.729925),
(6, 15, 14.5985, 45.83929, 3.493123, 6.452537, 0.175182),
(6, 16, 14.5985, 42.62762, 2.6424285, 3.208038, 0.014599),
(6, 17, 14.5985, 42.71517, 3.124079, 5.8354, 0.116788),
(6, 18, 14.5985, 46.49355, 3.136746, 3.356655, 0.131386),
(6, 6, 125, 215, 1.6, 26.25, 0.125),
(6, 7, 125, 85, 15.375, 5.5, 0.25),
(6, 8, 53, 21.2, 0.583, 4.929, 0.106),
(6, 9, 7, 10.43, 0.448, 1.925, 0.014),
(6, 10, 3, 27, 0, 0, 3),
(6, 11, 10, 1.8, 0.09, 0.39, 0.01),
(6, 12, 58, 87, 7.25, 0.29, 6.46);

-- ========================
-- Archivo: comidas_4.sql
-- ========================

-- Insertar nuevos alimentos (evitando duplicados)
INSERT INTO foods (name, kcal_per_100g, protein_per_100g, carbs_per_100g, fat_per_100g) VALUES
('Espinaca congelada', 27, 2.9, 1.6, 0.4),
('Brócoli congelado', 29, 3.9, 1.4, 0.4),
('Zanahoria fresca', 41, 1, 9.6, 0.2),
('Semillas de cáñamo', 580, 31, 13, 48),
('Remolacha fresca', 43, 1.6, 9.6, 0.1),
('Cúrcuma fresca', 354, 7.8, 64.9, 10),
('Jengibre fresco', 80, 1.8, 17.8, 0.8),
('Chucrut', 22, 1.4, 1.7, 0.2),
('Espárragos', 23, 2.1, 2.4, 0.6),
('Salmon ahumado', 184, 19, 0.5, 8.5),
('Vinagre balsámico', 88, 0, 17, 0);

-- Insertar comidas
INSERT INTO meals (name, time) VALUES 
('Comida 4-A', '20:15:00'),
('Comida 4-B', '20:15:00');

-- Comida 4-A (meal_id = 7)
INSERT INTO meal_items (meal_id, food_id, amount_g, total_kcal, total_protein, total_carbs, total_fat) VALUES
(7, 19, 175, 47.25, 5.075, 2.8, 0.7),
(7, 20, 175, 50.75, 6.825, 2.45, 0.7),
(7, 21, 175, 71.75, 1.75, 16.8, 0.35),
(7, 22, 50, 290, 15.5, 6.5, 24),
(7, 8, 120, 106.8, 1.32, 27.36, 0.36),
(7, 23, 45, 19.35, 0.72, 4.32, 0.045),
(7, 24, 10, 35.4, 0.78, 6.49, 1),
(7, 25, 10, 8, 0.18, 1.78, 0.08);

-- Comida 4-B (meal_id = 8)
INSERT INTO meal_items (meal_id, food_id, amount_g, total_kcal, total_protein, total_carbs, total_fat) VALUES
(8, 26, 100, 22, 1.4, 1.7, 0.2),
(8, 27, 215, 49.45, 4.515, 5.16, 1.29),
(8, 28, 85, 156.4, 19.55, 0.425, 8.5),
(8, 29, 7, 6.16, 0, 1.19, 0);

-- ========================
-- Archivo: cenas_semana.sql
-- ========================
-- Insertar alimentos base (asumiendo valores por 100g)
INSERT INTO foods (name, kcal_per_100g, protein_per_100g, carbs_per_100g, fat_per_100g) VALUES
('Dorada', 96, 20, 0, 1.8),
('Salmon', 206, 22, 0, 13.1),
('Huevos', 150, 12.5, 0.6, 11.1),
('Pechuga de Pavo', 135, 29, 0, 1.2),
('Pechuga de Pollo', 165, 31, 0, 3.6),
('Solomillo de Ternera', 180, 27, 0, 8),
('Pimiento rojo', 31, 0.9, 6.3, 0.3),
('Zumo de limón', 22, 0.4, 0.1, 0.1),
('Pepino', 13, 0.5, 1.2, 0.1),
('Berberechos', 74, 17.64, 4.158, 1.25),
('Tomate', 18, 0.9, 3.9, 0.2);

-- Insertar cenas
INSERT INTO meals (name, time) VALUES
('Cena Lunes - Salmon', '21:00:00'),
('Cena Martes - Dorada', '21:00:00'),
('Cena Miércoles - Pavo', '21:00:00'),
('Cena Jueves - Pollo', '21:00:00'),
('Cena Viernes - Berberechos y Salmon', '21:00:00'),
('Cena Sábado - Huevos', '21:00:00'),
('Cena Domingo - Ternera', '21:00:00');

-- Cena Lunes
INSERT INTO meal_items (meal_id, food_id, amount_g, total_kcal, total_protein, total_carbs, total_fat) VALUES
(9, 2, 400, 824, 88, 0, 52.4);

-- Cena Martes
INSERT INTO meal_items (meal_id, food_id, amount_g, total_kcal, total_protein, total_carbs, total_fat) VALUES
(10, 1, 400, 384, 80, 0, 7.2);

-- Cena Miércoles
INSERT INTO meal_items (meal_id, food_id, amount_g, total_kcal, total_protein, total_carbs, total_fat) VALUES
(11, 4, 400, 540, 116, 0, 4.8);

-- Cena Jueves
INSERT INTO meal_items (meal_id, food_id, amount_g, total_kcal, total_protein, total_carbs, total_fat) VALUES
(12, 5, 400, 660, 124, 0, 14.4);

-- Cena Viernes (Berberechos y Salmón Ahumado con vegetales)
INSERT INTO meal_items (meal_id, food_id, amount_g, total_kcal, total_protein, total_carbs, total_fat) VALUES
(13, 7, 80, 24.8, 0.8, 4.8, 0.24),
(13, 8, 20, 17.6, 0.32, 5.52, 0.02),
(13, 9, 125, 21.25, 0.525, 1.275, 0.075),
(13, 10, 115, 308.34, 17.64, 4.158, 1.25),
(13, 11, 126, 231.84, 23.94, 0.63, 10.71),
(13, 12, 60, 10.8, 0.54, 2.34, 0.12);

-- Cena Sábado
INSERT INTO meal_items (meal_id, food_id, amount_g, total_kcal, total_protein, total_carbs, total_fat) VALUES
(14, 3, 301, 451.5, 37.625, 1.505, 33.431);

-- Cena Domingo
INSERT INTO meal_items (meal_id, food_id, amount_g, total_kcal, total_protein, total_carbs, total_fat) VALUES
(15, 6, 400, 720, 108, 0, 32);

-- ========================
-- Archivo: tentempie_pipas.sql
-- ========================

-- Insertar alimento "Pipas"
INSERT INTO foods (name, kcal_per_100g, protein_per_100g, carbs_per_100g, fat_per_100g) VALUES
('Pipas', 635, 28.9, 5.5, 53.7);

-- Insertar comida tipo tentempié nocturno
INSERT INTO meals (name, time) VALUES
('Tentempié Nocturno - Pipas', '22:30:00');

-- Insertar item de comida (25g de pipas)
INSERT INTO meal_items (meal_id, food_id, amount_g, total_kcal, total_protein, total_carbs, total_fat) VALUES
(16, 30, 25, 158.75, 7.2225, 1.375, 13.425);
-- ========================
-- CLASIFICACIÓN PROTEÍNA ANIMAL/VEGETAL (EJECUTAR TRAS INSERTAR DATOS)
-- ========================
-- Desactivar modo seguro
SET SQL_SAFE_UPDATES = 0;
UPDATE foods SET protein_source = 'animal' WHERE name IN (
    'Salmon', 'Dorada', 'Huevos', 'Pechuga de Pollo', 'Pechuga de Pavo',
    'Solomillo de Ternera', 'Yogur natural', 'Queso Fresco Batido',
    'Queso Burgos desnat.', 'Berberechos', 'Salmon ahumado',
    'Atún (lata)', 'Huevo entero (1 huevo)', 'Claras de huevo (2 claras)'
);

UPDATE foods SET protein_source = 'vegetal' WHERE name IN (
    'Lenteja pardina', 'Garbanzos', 'Judia Mungo', 'Judia Verde', 'Alubia roja', 'Frijoles negros',
    'Quinoa real', 'Trío de quinoa', 'Pipas', 'Semillas de cáñamo', 'Almendras',
    'Avena', 'Açaí', 'Maca', 'Alga espirulina'
);

UPDATE foods SET protein_source = 'mixto' WHERE name IN ('Chocolate negro');
UPDATE foods SET protein_source = 'sin_proteina'
WHERE protein_per_100g IS NULL OR protein_per_100g = 0;



