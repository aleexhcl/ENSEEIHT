function [vep,vap]=calc_vep(mat)
    [vep, vap] = eig(mat);
    vap = diag(vap);
    [vap, indord] = sort(vap,'descend');
    vep = vep(:,indord);
end