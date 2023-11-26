function [detailLayer, filteredIntensity] = extractDetails(intensityImage)
    % extractDetails Extrae la capa de detalles y la intensidad filtrada de una imagen de intensidad.
    %
    %   [detailLayer, filteredIntensity] = extractDetails(intensityImage)
    %   procesa una imagen de intensidad para obtener una capa de detalles y una versión filtrada
    %   de la imagen de intensidad, que resalta y separa los detalles finos de la imagen original.
    %
    %   Entrada:
    %       intensityImage - Una imagen de intensidad que se desea procesar. 
    %                        Debe estar en formato de imagen en grises.
    %
    %   Salidas:
    %       detailLayer - Una imagen que resalta los detalles de la imagen original.
    %       filteredIntensity - Una versión suavizada de la imagen de intensidad.
    %
    %   Proceso:
    %       1. Convierte la imagen de intensidad al tipo de dato 'double' para un procesamiento preciso.
    %       2. Calcula el logaritmo de la imagen de intensidad para amplificar los detalles.
    %       3. Define los parámetros para un filtro bilateral en función del tamaño de la imagen.
    %       4. Aplica un filtro gaussiano para obtener una versión suavizada de la intensidad logarítmica.
    %       5. Resta la intensidad logarítmica filtrada de la intensidad logarítmica original para 
    %          obtener la capa de detalles en el dominio logarítmico.
    %       6. Transforma la capa de detalles y la intensidad filtrada de vuelta al dominio lineal.
    %       7. Normaliza ambos componentes para la visualización.
    %
    %   Notas:
    %       - La suma de un pequeño valor antes de calcular el logaritmo evita el logaritmo de cero.
    %       - La normalización de la capa de detalles y de la intensidad filtrada facilita la visualización.
    %       - El tamaño y la varianza del filtro gaussiano están configurados para un efecto de suavizado general.

    % Asegurando que la imagen sea de doble precisión
    intensityImage = double(intensityImage);

    % Calculando el logaritmo de la imagen de intensidad
    logIntensity = log10(intensityImage + 0.0001);

    % Definir el tamaño de la imagen
    % [height, width] = size(intensityImage);
    % imgDiagonal = sqrt(height^2 + width^2);

    % Definir los parámetros del filtro bilateral
    % sigmaSpatial = 0.015 * imgDiagonal; % Varianza espacial del 1.5% de la diagonal de la imagen
    % sigmaRange = 0.1; % Varianza de intensidad sugerida por Durand y Dorsey

    % Se aplica filtro gaussiano
    filtro_gaussiano = fspecial('gaussian', 21, 9);

    % Aplicar el filtro 
    filteredLogIntensity = imfilter(logIntensity, filtro_gaussiano, 'replicate');

    % Obtener la capa de detalles en el dominio logarítmico restando
    logDetailLayer = logIntensity - filteredLogIntensity;

    % Transformar la capa de detalles de vuelta al dominio lineal
    detailLayer = exp(logDetailLayer);

    % Opcionalmente, normalizar la capa de detalles para la visualización
    detailLayer = mat2gray(detailLayer);

    % Obtener la capa a gran escala
    filteredIntensity = exp(filteredLogIntensity);

    % Normalizar
    filteredIntensity = mat2gray(filteredIntensity);
end
