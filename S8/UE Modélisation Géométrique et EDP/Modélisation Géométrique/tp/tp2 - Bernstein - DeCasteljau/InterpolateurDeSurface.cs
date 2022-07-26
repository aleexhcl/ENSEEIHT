using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System;
using UnityEngine.UI;

public class InterpolateurDeSurface : MonoBehaviour
{
    public GameObject particle;
    public float[,] X;
    public float[,] Hauteurs;
    public float[,] Z;
    public bool autoGenerateGrid;
    private float Pas =0.1f;
    private List<List<Vector3>> ListePoints = new List<List<Vector3>>();

    long KparmiN(int k, int n)
    {
        decimal result = 1;
        for (int i = 1; i <= k; i++)
        {
            result *= n - (k - i);
            result /= i;
        }
        return (long)result;
    }

    List<float> buildEchantillonnage()
    {
        List<float> tToEval = new List<float>();
        float t = 0.0f;
        while(t <= 1){
            tToEval.Add(t);
            t+= Pas;
        }
        return tToEval;
    }

    float evalBernstein(int n, int k, float t){
        return KparmiN(k, n)*Mathf.Pow(1-t, (float) n-k)*Mathf.Pow(t, (float) k);
    }

    void surfaces() {
        int n = X.GetLength(0);
        int m = X.GetLength(1);
        List<Vector3> ListePointsU = new List<Vector3>();
        List<float> tToEval = buildEchantillonnage();
        float HPi; 
        float XPi; 
        float ZPi;
        float Huv; 
        float Xuv;  
        float Zuv; 
        foreach(float u in tToEval){
            ListePointsU = new List<Vector3>();
            foreach(float v in tToEval){
                Huv = 0.0f; 
                Xuv = 0.0f;  
                Zuv = 0.0f; 
                for (int i=0; i<n; i++){
                    HPi =0.0f; 
                    XPi =0.0f; 
                    ZPi =0.0f; 
                    for(int j=0; j<m; j++){
                        XPi += X[i,j] * evalBernstein(n,j,u);
                        ZPi += Z[i,j] * evalBernstein(n,j,u);
                        HPi += Hauteurs[i,j] * evalBernstein(n,j,u);
                    }
                    Xuv += XPi * evalBernstein(n,i,v);
                    Zuv += ZPi * evalBernstein(n,i,v);
                    Huv += HPi * evalBernstein(n,i,v);
                }
                ListePointsU.Add(new Vector3(Xuv, Huv, Zuv));
            }
            ListePoints.Add(ListePointsU); 
        } 
    }

    (List<float>, List<float>) DeCasteljauSub(List<float> X, List<float> Y, int nombreDeSubdivision)
    {
        List<float> XSortie = new List<float>();
        List<float> YSortie = new List<float>();
        List<float> xL = new List<float>();
        List<float> yL = new List<float>();
        List<float> xR = new List<float>();
        List<float> yR = new List<float>();

        for (int i=0;i<X.Count;i++){
            XSortie.Add(X[i]);
            YSortie.Add(Y[i]);
        }

        float t = 0.5f; 
        for(int sub=0; sub<nombreDeSubdivision; sub++){
            xL.Clear();
            yL.Clear();
            xR.Clear();
            yR.Clear();
            xL.Add(XSortie[0]);
            yL.Add(YSortie[0]);
            xR.Add(XSortie[XSortie.Count-1]);
            yR.Add(YSortie[YSortie.Count-1]);

            for (int ligne=0 ; ligne < YSortie.Count-1; ligne++) {
                for(int col=0; col < YSortie.Count-ligne-1; col++){
                    YSortie[col] = (1 - t) * YSortie[col] + t * YSortie[col+1];
                    XSortie[col] = (1 - t) * XSortie[col] + t * XSortie[col+1];
                }
                xL.Add(XSortie[0]);
                yL.Add(YSortie[0]);
                xR.Add(XSortie[YSortie.Count-ligne-2]);
                yR.Add(YSortie[YSortie.Count-ligne-2]);
            }
            XSortie.Clear();
            xR.Reverse();
            XSortie.AddRange(xL);
            XSortie.AddRange(xR);
            YSortie.Clear();
            yR.Reverse();
            YSortie.AddRange(yL);
            YSortie.AddRange(yR);
        }

        return (XSortie, YSortie);
    }

    void surfaces2() {
        int n = X.GetLength(0);
        List<float> tToEval = buildEchantillonnage();
        List<float> lX = new List<float>();
        List<float> lZ = new List<float>();
        List<float> lH = new List<float>();
        List<float> HSub = new List<float>();
        List<float> XSub1 = new List<float>();
        List<float> XSub2 = new List<float>();
        List<float> ZSub = new List<float>();

        for(int i=0; i<n; i++){
            lX.Clear();
            lZ.Clear();
            lH.Clear();
            List<Vector3> ListePointsI = new List<Vector3>();
            for(int j=0; j<n; j++){
                lX.Add(X[i,j]);
                lZ.Add(Z[i,j]);
                lH.Add(Hauteurs[i,j]);
            }

            (XSub1, ZSub) = DeCasteljauSub(lX, lZ, 3);
            (XSub2, HSub) = DeCasteljauSub(lX, lH, 3);

            for(int k =0; k<XSub1.Count(); k++){
                ListePointsI.Add(new Vector3(XSub1[k], HSub[k], ZSub[k]));
            }
            ListePoints.Add(ListePointsI); 
        }

        for(int i=0; i<n; i++){
            lX.Clear();
            lZ.Clear();
            lH.Clear();
            List<Vector3> ListePointsI = new List<Vector3>();
            for(int j=0; j<n; j++){
                lX.Add(X[j,i]);
                lZ.Add(Z[j,i]);
                lH.Add(Hauteurs[j,i]);
            }

            (XSub1, ZSub) = DeCasteljauSub(lX, lZ, 3);
            (XSub2, HSub) = DeCasteljauSub(lX, lH, 3);

            for(int k =0; k<XSub1.Count(); k++){
                ListePointsI.Add(new Vector3(XSub1[k], HSub[k], ZSub[k]));
            }
            ListePoints.Add(ListePointsI); 
        }

        for(int i=0; i<ListePoints[0].Count(); i++){
            lX.Clear();
            lZ.Clear();
            lH.Clear();
            List<Vector3> ListePointsI = new List<Vector3>();
            for(int j=0; j<n; j++){
                lX.Add((ListePoints[j][i]).x); 
                lZ.Add(ListePoints[j][i].z); 
                lH.Add(ListePoints[j][i].y); 
            }

            (XSub1, ZSub) = DeCasteljauSub(lX, lZ, 3);
            (XSub2, HSub) = DeCasteljauSub(lX, lH, 3);

            for(int k =0; k<XSub1.Count(); k++){
                ListePointsI.Add(new Vector3(XSub1[k], HSub[k], ZSub[k]));
            }
            ListePoints.Add(ListePointsI); 
        } 

        for(int i=0; i<ListePoints[0].Count(); i++){
            lX.Clear();
            lZ.Clear();
            lH.Clear();
            List<Vector3> ListePointsI = new List<Vector3>();
            for(int j=n; j<n*2; j++){
                lX.Add((ListePoints[j][i]).x); 
                lZ.Add(ListePoints[j][i].z); 
                lH.Add(ListePoints[j][i].y); 
            }

            (XSub1, ZSub) = DeCasteljauSub(lX, lZ, 3);
            (XSub2, HSub) = DeCasteljauSub(lX, lH, 3);

            for(int k =0; k<XSub1.Count(); k++){
                ListePointsI.Add(new Vector3(XSub1[k], HSub[k], ZSub[k]));
            }
            ListePoints.Add(ListePointsI); 
        } 

    }

    void Start()
    {
        if (autoGenerateGrid)
        {
            int n = 5;
            X = new float[5, 5];
            Hauteurs = new float[5, 5];
            Z = new float[5, 5];
            for (int i = 0; i < n; ++i)
            {
                X[i, 0] = 0.00f;
                X[i, 1] = 0.25f;
                X[i, 2] = 0.50f;
                X[i, 3] = 0.75f;
                X[i, 4] = 1.00f;

                Z[0, i] = 0.00f;
                Z[1, i] = 0.25f;
                Z[2, i] = 0.50f;
                Z[3, i] = 0.75f;
                Z[4, i] = 1.00f;
            }
            for (int i = 0; i < n; ++i)
            {
                for (int j = 0; j < n; ++j)
                {
                    float XC2 = (X[i, j] - (1.0f / 2.0f)) * (X[i, j] - (1.0f / 2.0f));
                    float ZC2 = (Z[i, j] - (1.0f / 2.0f)) * (Z[i, j] - (1.0f / 2.0f));
                    Hauteurs[i, j] = (float)Math.Exp(-(XC2 + ZC2));
                    Instantiate(particle, new Vector3(X[i, j], Hauteurs[i, j], Z[i, j]), Quaternion.identity);
                }
            }
            surfaces2(); 
        } else {

        }
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return))
        {
            
        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.blue;
            for (int j = 0; j < ListePoints.Count; ++j)
            {
                for (int i = 0; i < ListePoints[j].Count - 1; ++i)
                {
                    
                    Gizmos.DrawLine(ListePoints[j][i], ListePoints[j][i + 1]);
                }
            }
        
    }
}
