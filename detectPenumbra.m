function penumbra_mask = detectPenumbra(flash_img, no_flash_img, umbra_mask)
    % detectPenumbra Detecta la penumbra en imágenes basado en la comparación de gradientes.
    %
    %   penumbra_mask = detectPenumbra(flash_img, no_flash_img, umbra_mask)
    %   devuelve una máscara binaria que indica la ubicación de la penumbra en la imagen.
    %   La función compara imágenes tomadas con y sin flash, y usa una máscara de umbra existente.
    %
    %   Entradas:
    %       flash_img - Una imagen RGB o en escala de grises tomada con flash.
    %       no_flash_img - Una imagen RGB o en escala de grises de la misma escena sin flash.
    %       umbra_mask - Una máscara binaria que indica la ubicación de la umbra (sombra total).
    %
    %   Salida:
    %       penumbra_mask - Una máscara binaria que indica la ubicación de la penumbra.
    %
    %   Proceso:
    %       1. Convierte las imágenes de entrada a escala de grises si son RGB.
    %       2. Calcula la magnitud del gradiente para ambas imágenes.
    %       3. Suaviza las magnitudes del gradiente con un filtro gaussiano.
    %       4. Identifica candidatos a penumbra donde el gradiente de la imagen con flash es más fuerte.
    %       5. Establece un vecindario basado en la diagonal de la imagen para detectar penumbra cerca de umbra.
    %       6. Crea filtros de caja y aplica convolución para identificar píxeles de umbra y su proximidad.
    %       7. Combina las detecciones de penumbra basadas en la proximidad con umbra y en objetos pequeños.
    %       8. Opcional: Remueve los píxeles de umbra de la máscara de penumbra.
    %
    %   Nota:
    %       Las imágenes de entrada deben tener el mismo tamaño y corresponder a la misma escena.
    
    % Convertir a escala de grises si son imágenes RGB
    if size(flash_img, 3) == 3
        flash_img_gray = rgb2gray(flash_img);
    else
        flash_img_gray = flash_img;
    end

    if size(no_flash_img, 3) == 3
        no_flash_img_gray = rgb2gray(no_flash_img);
    else
        no_flash_img_gray = no_flash_img;
    end

    % Calcular la magnitud del gradiente para ambas imágenes
    [Gmag_f, ~] = imgradient(flash_img_gray);
    [Gmag_nf, ~] = imgradient(no_flash_img_gray);

    % Suavizar las magnitudes de los gradientes
    Gmag_f_smoothed = imgaussfilt(Gmag_f, sqrt(2));
    Gmag_nf_smoothed = imgaussfilt(Gmag_nf, sqrt(2));

    % Identificar candidatos a píxeles de penumbra donde el gradiente de la imagen con flash es más fuerte
    candidate_penumbra = Gmag_f_smoothed > Gmag_nf_smoothed;

    % Determinar el tamaño del vecindario basado en la diagonal de la foto
    photo_diag = sqrt(size(flash_img, 1)^2 + size(flash_img, 2)^2);
    % small_neighborhood_size = round(0.007 * photo_diag); % para objetos pequeños
    large_neighborhood_size = round(0.01 * photo_diag); % para proximidad a umbra

    % Crear filtros de caja para el vecindario
    % small_box_filter = ones(small_neighborhood_size, small_neighborhood_size);
    large_box_filter = ones(large_neighborhood_size, large_neighborhood_size);

    % Convolver la máscara de umbra con un filtro de caja para encontrar píxeles cercanos a umbra
    umbra_neighbors = conv2(double(umbra_mask), large_box_filter, 'same') > 0;

    % Mantener solo los candidatos a píxeles de penumbra que están cerca de píxeles de umbra
    penumbra_close_to_umbra = candidate_penumbra & umbra_neighbors;

    % Detectar penumbra pura para objetos pequeños
    % high_gradient_neighbors = conv2(double(candidate_penumbra), small_box_filter, 'same');
    % pure_penumbra_threshold = 0.8 * (small_neighborhood_size^2);

    % Combinar ambas detecciones de penumbra
    penumbra_mask = penumbra_close_to_umbra;

    % Opcionalmente, se pueden remover los píxeles de umbra de la máscara de penumbra
    %penumbra_mask = penumbra_mask & umbra_mask;
end
