function A=read_image(file)
   % file : fichier .png
   % A : image au format double (matrice)
   
   A=imread(file);
   A=im2double(A);

   figure(1)
   imshow(A)
   title('Image')
 
 end
