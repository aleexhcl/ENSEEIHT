% Ce programme est le script principal permettant d'illustrer
% un algorithme de reconnaissance de chiffres.

% Nettoyage de l'espace de travail
clear all; close all;

% Repertories contenant les donnees et leurs lectures
addpath('Data');
addpath('Utils')

rng('shuffle')


% Bruit
sig0=0.2;

%tableau des scores de classification
% intialisation aléatoire pour affichage
r=rand(6,5);
r2=rand(6,5);

DM = [];
dist = zeros(6,5);
distk = zeros(6,5);

for k=1:5
    % Definition des donnees
    file=['D' num2str(k)]

    % Recuperation des donnees
    disp('Generation de la base de donnees');
    sD=load(file);
    D=sD.(file);
    %

    % Bruitage des données
    Db= D+sig0*randn(size(D));

    %%%%%%%%%%%%%%%%%%%%%%%
    % Analyse des donnees
    %%%%%%%%%%%%%%%%%%%%%%%
    disp('PCA : calcul du sous-espace');
    %%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%

    [l,c] = size(Db);
    Dbmoy = sum(Db,2)/c;
    DM = [DM Dbmoy];
    Dbc = Db - Dbmoy;
    Sigma = Dbc*Dbc'/c;
    [vep,vap] = calc_vep(Sigma); 
    precapprox = 0.7;
    m = 1;
    while(abs(1-sqrt(vap(m)/vap(1))-precapprox) > 0.01 && m < l)
        m = m+1;
    end
    V = vap(1:m);
    W = vep(:,1:m);

    %%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%

    disp('kernel PCA : calcul du sous-espace');
    %%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
    % données Db , noyau lineaire K(i,j) = k(xi,xj) = xi'*xj , phi = id 
    K = Db'*Db;
    A = zeros(c,c)+1;
    Kc = K - A*K - K*A + A*K*A;
    [vepk,vapk] = calc_vep(Kc);

    rangk = rank(Kc);
    precapprox = 0.7;
    m = 1;
    while(abs(1-sqrt(vap(m)/vap(1))-precapprox) > 0.01 && m < c)
        m = m+1;
    end
    m = min(rangk, m);
    alpha = zeros(c,m);
    for i=1:m
        alpha(:,i) = vepk(:,i)/sqrt(vapk(i));
    end

    %%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Reconnaissance de chiffres
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Lecture des chiffres à reconnaitre
    disp('test des chiffres :');
    tes(:,1) = importerIm('test1.jpg',1,1,16,16);
    tes(:,2) = importerIm('test2.jpg',1,1,16,16);
    tes(:,3) = importerIm('test3.jpg',1,1,16,16);
    tes(:,4) = importerIm('test4.jpg',1,1,16,16);
    tes(:,5) = importerIm('test5.jpg',1,1,16,16);
    tes(:,6) = importerIm('test9.jpg',1,1,16,16);

    for tests=1:6
        % Bruitage
        tes(:,tests)=tes(:,tests)+sig0*randn(length(tes(:,tests)),1);

        % Classification depuis ACP
        %%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
        disp('PCA : classification');
        C = tes(:,tests);
        d = norm(C - W*W'*C)/norm(C);
        dist(tests,k) = d;

        if(tests==k)
            figure(100+k)
            subplot(1,2,1);
            imshow(reshape(tes(:,tests),[16,16]));
            subplot(1,2,2);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%

        % Classification depuis kernel ACP
        %%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
        disp('kernel PCA : classification');

        proj = zeros(c,1);
        % projection de phi(x) - m sur K
        for i = 1:m
            s1 = 0;
            for p = 1:m
                s1 = s1 + alpha(i,p)*fun_k(C,Db(:,p));
            end
            s2 = 0;
            for p = 1:m
                s = 0;
                for j = 1:c
                    s = s + fun_k(Db(:,j),Db(:,p));
                end
                s2 = s2 + alpha(i,p)*s;
            end
            proj = proj + (s1 - s2/c)*vepk(:,i);
        end
        
        % norme de phi(x) - m au carre
        s1 = 0;
        for i = 1:c
            s1 = s1 + fun_k(C,Db(:,i));
        end
        s2 = 0;
        for i = 1:c
            for j = 1:c
                s2 = s2 + fun_k(Db(:,i),Db(:,j));
            end
        end
        npm = fun_k(C,C) - s1*(2/c) + s2/(pow2(c));

        % norme de proj - (phi(x) - m) au carre
        np = npm - pow2(norm(proj));

        distk(tests,k) = np/npm;

        %%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%
    end

end

for tests = 1:6
    [~, ind] = min(dist(tests,:))
    [~, ind] = min(distk(tests,:))
end

r = dist; 
r2 = distk;

% Affichage du résultat de l'analyse par PCA
couleur = hsv(6);

figure(11)
for tests=1:6
     hold on
     plot(1:5, r(tests,:),  '+', 'Color', couleur(tests,:));
     hold off
 
     for i = 1:4
        hold on
         plot(i:0.1:(i+1),r(tests,i):(r(tests,i+1)-r(tests,i))/10:r(tests,i+1), 'Color', couleur(tests,:),'LineWidth',2)
         hold off
     end
     hold on
     if(tests==6)
       testa=9;
     else
       testa=tests;  
     end
     text(5,r(tests,5),num2str(testa));
     hold off
 end

% Affichage du résultat de l'analyse par kernel PCA
figure(12)
for tests=1:6
     hold on
     plot(1:5, r2(tests,:),  '+', 'Color', couleur(tests,:));
     hold off
 
     for i = 1:4
        hold on
         plot(i:0.1:(i+1),r2(tests,i):(r2(tests,i+1)-r2(tests,i))/10:r2(tests,i+1), 'Color', couleur(tests,:),'LineWidth',2)
         hold off
     end
     hold on
     if(tests==6)
       testa=9;
     else
       testa=tests;  
     end
     text(5,r2(tests,5),num2str(testa));
     hold off
 end
