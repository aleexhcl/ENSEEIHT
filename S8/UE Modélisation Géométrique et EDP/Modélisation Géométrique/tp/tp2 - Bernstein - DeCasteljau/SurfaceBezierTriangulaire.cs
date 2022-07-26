using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class SurfaceBezierTriangulaire : MonoBehaviour
{
    // Pas d'échantillonage construire la parametrisation
    public float pas = 1/10;
    // Liste des points composant la courbe
    private List<Vector3> ListePoints = new List<Vector3>();
    // Donnees i.e. points cliqués
    public GameObject Donnees;

    public float hauteur = -0.4f; 
    public float pashaut = 0.25f; 

    List<float> buildEchantillonnage()
    {
        List<float> tToEval = new List<float>();
        float t = 0.0f;
        while(t <= 1){
            tToEval.Add(t);
            t+= pas;
        }
        return tToEval;
    }

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

    float bernstein(int n, int i, int j, float t) {
        return Mathf.Pow(1-t, (float) i)*Mathf.Pow(t, (float) j);
    }

    int facto(int n) {
        if (n==0 || n==1) {
            return 1;
        } else {
            return n*facto(n-1);
        }
    }

    (List<float>, List<float>) DeCasteljauSub(List<float> X, List<float> Y)
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
        for(int sub=0; sub<3; sub++){
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

    void Start()
    {
        
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
        for (int i = 0; i < ListePoints.Count - 1; ++i)
        {
            Gizmos.DrawLine(ListePoints[i], ListePoints[i + 1]);
        }
    }
} 