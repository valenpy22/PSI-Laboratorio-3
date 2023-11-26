function finalImg = combineImages(detailImg, colorImg, largeScaleImg, shadowMaskImg)
    % combineImages Combina imágenes de detalle, color, escala grande y máscara de sombras.
    %
    %   finalImg = combineImages(detailImg, colorImg, largeScaleImg, shadowMaskImg)
    %   toma una imagen de detalle ('detailImg'), una imagen de color ('colorImg'), 
    %   una imagen de escala grande ('largeScaleImg'), y una máscara de sombras 
    %   ('shadowMaskImg') y las combina para formar una imagen final mejorada ('finalImg').
    %
    %   Entradas:
    %       detailImg - Una imagen que contiene detalles finos de la escena original.
    %       colorImg - Una imagen que proporciona la corrección de color para la escena.
    %       largeScaleImg - Una imagen que contiene las características de iluminación a gran escala.
    %       shadowMaskImg - Una imagen binaria que sirve como máscara para las regiones de sombras.
    %
    %   Salida:
    %       finalImg - La imagen resultante después de combinar las entradas.
    %
    %   Proceso:
    %       1. Preserva los detalles de 'detailImg' en las regiones donde 'shadowMaskImg' indica 
    %          ausencia de sombra.
    %       2. Preserva la iluminación de 'largeScaleImg' donde 'shadowMaskImg' indica presencia de sombra.
    %       3. Combina las dos imágenes preservadas para mantener los detalles y la iluminación adecuada.
    %       4. Ajusta los colores utilizando 'colorImg' para mejorar la apariencia de la imagen combinada.
    %       5. Normaliza la imagen combinada para que los valores de los píxeles estén en el rango 0-255.
    %       6. Convierte la imagen normalizada a tipo de dato uint8, adecuado para la visualización de imágenes.
    %
    %   Nota:
    %       Todas las imágenes de entrada deben tener el mismo tamaño y tipo de dato para que la 
    %       combinación sea exitosa.

    % Preservar los detalles donde no hay sombras (valores bajos en shadowMaskImg)
    detailPreserved = detailImg .* ~shadowMaskImg;
    
    % Preservar la iluminación de la imagen sin flash donde hay sombras (valores altos en shadowMaskImg)
    largeScalePreserved = largeScaleImg .* shadowMaskImg;
    
    % Combinar las dos imágenes preservadas
    combinedImg = detailPreserved + largeScalePreserved;
    
    % Ajustar colores utilizando la imagen de color para toda la imagen combinada
    % La imagen de color se asume que es una imagen que proporciona corrección de color
    finalImg = combinedImg .* colorImg;
   
    % Normalizar el resultado en el rango 0-255
    finalImg = finalImg - min(finalImg(:));
    finalImg = finalImg / max(finalImg(:)) * 255;
    finalImg = uint8(finalImg);
end
