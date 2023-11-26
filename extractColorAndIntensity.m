function [color, intensity] = extractColorAndIntensity(imagePath)
    % extractColorAndIntensity Extrae información de color normalizado e intensidad de una imagen.
    %
    %   [color, intensity] = extractColorAndIntensity(imagePath)
    %   lee una imagen desde la ubicación especificada por 'imagePath' y calcula dos componentes:
    %   la intensidad de la imagen y los canales de color normalizados por esta intensidad.
    %
    %   Entrada:
    %       imagePath - Una cadena de texto que representa la ruta del archivo de la imagen a procesar.
    %
    %   Salidas:
    %       color - Una imagen de tres canales con los valores de color normalizados por la intensidad.
    %       intensity - Una matriz de una canal que representa la intensidad de la imagen.
    %
    %   Proceso:
    %       1. Leer la imagen y convertirla al tipo de dato 'double' para el procesamiento.
    %       2. Separar los canales de color rojo, verde y azul.
    %       3. Calcular la intensidad como el valor máximo de los tres canales de color en cada píxel.
    %       4. Ajustar los píxeles con intensidad cero a un pequeño valor para evitar la división por cero.
    %       5. Normalizar cada canal de color por la intensidad ajustada.
    %       6. Concatenar los canales de color normalizados para formar la imagen de color de salida.
    %
    %   Nota:
    %       Se suma un pequeño valor a la intensidad antes de la normalización para evitar dividir por cero.
    
    % Leer la imagen
    RGB = im2double(imread(imagePath));
    
    % Separar los canales de color

    R = RGB(:,:,1);
    G = RGB(:,:,2);
    B = RGB(:,:,3);

    % Calcular la intensidad
    intensity = max(RGB, [], 3);

    % Se cambian los valores para no dividir por 0
    intensity(intensity == 0) = 0.001;

    norm_R = R ./ (intensity + 0.001);
    norm_G = G ./ (intensity + 0.001);
    norm_B = B ./ (intensity + 0.001);

    % Se mezclan los 3 canales
    color = cat(3, norm_R, norm_G, norm_B);
end