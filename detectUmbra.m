function [umbraMask, deltaI] = detectUmbra(flash, noflash)
    % detectUmbra Detecta áreas de umbra en imágenes basándose en la diferencia de intensidad.
    %
    %   [umbraMask, deltaI] = detectUmbra(flash, noflash)
    %   calcula una máscara binaria que representa las áreas de umbra y la diferencia
    %   de intensidad entre la imagen con flash y sin flash.
    %
    %   Entradas:
    %       flash - Una imagen tomada con flash.
    %       noflash - Una imagen de la misma escena tomada sin flash.
    %
    %   Salidas:
    %       umbraMask - Una máscara binaria donde los píxeles de la umbra son marcados como 1.
    %       deltaI - La diferencia de intensidad entre las imágenes con flash y sin flash.
    %
    %   Proceso:
    %       1. Convierte las imágenes de entrada al tipo de dato 'double' y a escala de grises.
    %       2. Calcula la diferencia de intensidad entre las dos imágenes.
    %       3. Calcula y suaviza el histograma de la diferencia de intensidad.
    %       4. Establece un umbral grueso basado en el valor máximo de deltaI.
    %       5. Encuentra el segundo mínimo local en el histograma suavizado antes del umbral grueso.
    %       6. Establece el valor del umbral de la umbra basado en el histograma.
    %       7. Genera la máscara binaria de umbra utilizando el umbral determinado.
    %
    %   Nota:
    %       Las imágenes de entrada deben ser del mismo tamaño y estar alineadas para que la
    %       comparación sea válida.

    flash = im2double(flash);
    noflash = im2double(noflash);

    flash = im2gray(flash);
    noflash = im2gray(noflash);
    
    deltaI = flash;

    % Calcular el histograma de deltaI con 128 bins
    [counts, binEdges] = histcounts(deltaI, 128);

    % Aplicar un filtro gaussiano al histograma para suavizarlo
    sigma = sqrt(2); % Varianza de dos bins
    binWidth = binEdges(2) - binEdges(1); % El ancho de cada bin
    gaussianFilter = fspecial('gaussian', [1, round(6*sigma/binWidth)], sigma);
    smoothedHistogram = conv(counts, gaussianFilter, 'same');

    % Establecer un umbral grueso de 0.2
    coarseThreshold = 0.2 * max(deltaI(:));

    % Encontrar el bin correspondiente al umbral grueso
    coarseThresholdBin = find(binEdges >= coarseThreshold, 1, 'first');

    % Inicializar contador de mínimos locales encontrados
    cont = 0;
    umbraThresholdBin = NaN;

    % Encontrar el segundo mínimo local en el histograma antes del umbral grueso
    for i = 2:(coarseThresholdBin-1)
        if smoothedHistogram(i) < smoothedHistogram(i-1) && smoothedHistogram(i) < smoothedHistogram(i+1)
            % Se incrementa el mínimo local
            cont = cont + 1;
            if cont == 2 
                umbraThresholdBin = i;
                break;
            end
        end
    end

    % Si no se encuentran valores mínimos, se toma en cuenta el umbral
    % encontrado al principio
    if isnan(umbraThresholdBin)
        umbraThresholdValue = coarseThreshold;
    else
        % Convertir el índice del bin de umbral a un valor de umbral real para la imagen
        umbraThresholdValue = binEdges(umbraThresholdBin);
    end

    % Crear una máscara binaria para la umbra
    umbraMask = deltaI < umbraThresholdValue;
end