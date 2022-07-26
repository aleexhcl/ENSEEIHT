using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CalculHodographe : MonoBehaviour
{
    // Nombre de subdivision dans l'algo de DCJ
    public int NombreDeSubdivision = 3;
    // Liste des points composant la courbe de l'hodographe
    private List<Vector3> ListePoints = new List<Vector3>();
    // Donnees i.e. points cliqués

    public GameObject Donnees;
    public GameObject particle;

    //////////////////////////////////////////////////////////////////////////
    // fonction : DeCasteljauSub                                            //
    // semantique : renvoie la liste des points composant la courbe         //
    //              approximante selon un nombre de subdivision données     //
    // params : - List<float> X : abscisses des point de controle           //
    //          - List<float> Y : odronnees des point de controle           //
    //          - int nombreDeSubdivision : nombre de subdivision           //
    // sortie :                                                             //
    //          - (List<float>, List<float>) : liste des abscisses et liste //
    //            des ordonnées des points composant la courbe              //
    //////////////////////////////////////////////////////////////////////////
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

    //////////////////////////////////////////////////////////////////////////
    // fonction : Hodographe                                                //
    // semantique : renvoie la liste des vecteurs vitesses entre les paires //
    //              consécutives de points de controle                      //
    //              approximante selon un nombre de subdivision données     //
    // params : - List<float> X : abscisses des point de controle           //
    //          - List<float> Y : odronnees des point de controle           //
    //          - float Cx : offset d'affichage en x                        //
    //          - float Cy : offset d'affichage en y                        //
    // sortie :                                                             //
    //          - (List<float>, List<float>) : listes composantes des       //
    //            vecteurs vitesses sous la forme (Xs,Ys)                   //
    //////////////////////////////////////////////////////////////////////////
    (List<float>, List<float>) Hodographe(List<float> X, List<float> Y, float Cx = 1.5f, float Cy = 0.0f)
    {
        List<float> XSortie = new List<float>();
        List<float> YSortie = new List<float>();

        int n = X.Count; 
        for (int i=0;i<X.Count-1;i++){
            XSortie.Add(n*(X[i+1] - X[i]));
            YSortie.Add(n*(Y[i+1] - Y[i]));
        }

        float t = 0.5f; 
        for (int ligne=0 ; ligne < YSortie.Count; ligne++) {
            for(int col=0; col < YSortie.Count - ligne -1; col++){
                YSortie[col] = (1 - t) * YSortie[col] + t * YSortie[col+1];
                XSortie[col] = (1 - t) * XSortie[col] + t * XSortie[col+1];
            }
        }
        
        return (XSortie, YSortie);
    }

    //////////////////////////////////////////////////////////////////////////
    //////////////////////////// NE PAS TOUCHER //////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    void Start()
    {
        
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return))
        {
            Instantiate(particle, new Vector3(1.5f, -4.0f, 0.0f), Quaternion.identity);
            var ListePointsCliques = GameObject.Find("Donnees").GetComponent<Points>();
            if (ListePointsCliques.X.Count > 0)
            {
                List<float> XSubdivision = new List<float>();
                List<float> YSubdivision = new List<float>();
                List<float> dX = new List<float>();
                List<float> dY = new List<float>();
                
                (dX, dY) = Hodographe(ListePointsCliques.X, ListePointsCliques.Y);

                (XSubdivision, YSubdivision) = DeCasteljauSub(dX, dY, NombreDeSubdivision);
                for (int i = 0; i < XSubdivision.Count; ++i)
                {
                    ListePoints.Add(new Vector3(XSubdivision[i], -4.0f, YSubdivision[i]));
                }
            }

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
