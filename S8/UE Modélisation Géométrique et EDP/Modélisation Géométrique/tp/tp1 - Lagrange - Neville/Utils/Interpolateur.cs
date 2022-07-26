using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System;
using UnityEngine.UI;


public class Interpolateur : MonoBehaviour
{
    // Pas d'échantillonnage 
    public float pas = 1/100;
    // Conteneur des points cliqués
    public GameObject Donnees;
    // Les points (X,Y) cliqués
    private List<float> X = new List<float>();
    private List<float> Y = new List<float>();
    public enum EInterpolationType { Lagrange, Neville };
    public EInterpolationType InterpolationType = EInterpolationType.Lagrange;
    public enum EParametrisationType { Reguliere, Distance, RacineDistance, Tchebytcheff, None}
    public EParametrisationType ParametrisationType = EParametrisationType.Reguliere;

    // Pour le dessin des courbes
    private List<Vector3> P2DRAW = new List<Vector3>();
    // UI
    public Text text;

    //////////////////////////////////////////////////////////////////////////
    // fonction : buildParametrisationReguliere                             //
    // semantique : construit la parametrisation reguliere et les           //
    //              échantillons de temps selon cette parametrisation       //
    // params :                                                             //
    //          - int nbElem : nombre d'elements de la parametrisation      //
    //          - float pas : pas d'échantillonage                          //
    // sortie :                                                             //
    //          - List<float> T : parametrisation reguliere                 //
    //          - List<float> tToEval : echantillon sur la parametrisation  //
    //////////////////////////////////////////////////////////////////////////
    (List<float>, List<float>) buildParametrisationReguliere(int nbElem, float pas)
    {
        // Vecteur des pas temporels
        List<float> T = new List<float>();
        // Echantillonage des pas temporels
        List<float> tToEval = new List<float>();

        // Construction des pas temporels
        float tcour = 0.0f;
        for(int i = 0; i < nbElem; i++){
            T.Add(i);
        }

        // Construction des échantillons
        for (int j=0; j < T.Count-1; j++) {
            tcour = T[j];
            while (tcour < T[j+1]) {
                tToEval.Add(tcour);
                tcour += pas;
            }
        }
        return (T, tToEval);
    }

    //////////////////////////////////////////////////////////////////////////
    // fonction : buildParametrisationDistance                              //
    // semantique : construit la parametrisation sur les distances et les   //
    //              échantillons de temps selon cette parametrisation       //
    // params :                                                             //
    //          - int nbElem : nombre d'elements de la parametrisation      //
    //          - float pas : pas d'échantillonage                          //
    // sortie :                                                             //
    //          - List<float> T : parametrisation distances                 //
    //          - List<float> tToEval : echantillon sur la parametrisation  //
    //////////////////////////////////////////////////////////////////////////
    (List<float>, List<float>) buildParametrisationDistance(int nbElem, float pas)
    {
        // Vecteur des pas temporels
        List<float> T = new List<float>();
        // Echantillonage des pas temporels
        List<float> tToEval = new List<float>();

        // Construction des pas temporels
        float d = 0.0f;
        float tcour = 0.0f; 
        T.Add(tcour);
        for (int i = 0; i < nbElem-1; i++) {
            d = (float) Mathf.Sqrt(Mathf.Pow(X[i+1]-X[i],2) + Mathf.Pow(Y[i+1]-Y[i],2));
            tcour = tcour + d; 
            T.Add(tcour);
        }

        // Construction des échantillons
        for (int j=0; j < T.Count-1; j++) {
            tcour = T[j];
            while (tcour < T[j+1]) {
                tToEval.Add(tcour);
                tcour += pas;
            }
        }
        return (T, tToEval);
    }

    ////////////////////////////////////////////////////////////////////////////
    // fonction : buildParametrisationRacineDistance                          //
    // semantique : construit la parametrisation sur les racines des distances//
    //              et les échantillons de temps selon cette parametrisation  //
    // params :                                                               //
    //          - int nbElem : nombre d'elements de la parametrisation        //
    //          - float pas : pas d'échantillonage                            //
    // sortie :                                                               //
    //          - List<float> T : parametrisation racines distances           //
    //          - List<float> tToEval : echantillon sur la parametrisation    //
    ////////////////////////////////////////////////////////////////////////////
    (List<float>, List<float>) buildParametrisationRacineDistance(int nbElem, float pas)
    {
        // Vecteur des pas temporels
        List<float> T = new List<float>();
        // Echantillonage des pas temporels
        List<float> tToEval = new List<float>();

        // Construction des pas temporels
        float d = 0.0f;
        float tcour = 0.0f; 
        T.Add(tcour);
        for (int i = 0; i < nbElem-1; i++) {
            d = (float) Mathf.Sqrt(Mathf.Sqrt(Mathf.Pow(X[i+1]-X[i],2) + Mathf.Pow(Y[i+1]-Y[i],2)));
            tcour = tcour+d; 
            T.Add(tcour);
        }

        // Construction des échantillons
        for (int j=0; j < T.Count-1; j++) {
            tcour = T[j];
            while (tcour < T[j+1]) {
                tToEval.Add(tcour);
                tcour += pas;
            }
        }
        return (T, tToEval);
    }

    //////////////////////////////////////////////////////////////////////////
    // fonction : buildParametrisationTchebycheff                           //
    // semantique : construit la parametrisation basée sur Tchebycheff      //
    //              et les échantillons de temps selon cette parametrisation//
    // params :                                                             //
    //          - int nbElem : nombre d'elements de la parametrisation      //
    //          - float pas : pas d'échantillonage                          //
    // sortie :                                                             //
    //          - List<float> T : parametrisation Tchebycheff               //
    //          - List<float> tToEval : echantillon sur la parametrisation  //
    //////////////////////////////////////////////////////////////////////////
    (List<float>, List<float>) buildParametrisationTchebycheff(int nbElem, float pas)
    {
        // Vecteur des pas temporels
        List<float> T = new List<float>();
        // Echantillonage des pas temporels
        List<float> tToEval = new List<float>();

        // Construction des pas temporels
        float ti = 0.0f; 
        for (int i=0; i < nbElem; i++) {
            ti = (float) Mathf.Cos(((2*i+1)*Mathf.PI)/(2*(nbElem-1)+2));
            T.Add(ti);
        }
        T.Sort();

        // Construction des échantillons
        float tcour = 0.0f;
        for (int j=0; j< nbElem-1; j++) {
            tcour = T[j];
            while (tcour < T[j+1]) {
                tToEval.Add(tcour);
                tcour += pas;
            }
        }

        return (T, tToEval);
    }

    //////////////////////////////////////////////////////////////////////////
    // fonction : applyLagrangeParametrisation                              //
    // semantique : applique la subdivion de Lagrange aux points (x,y)      //
    //              placés en paramètres en suivant les temps indiqués      //
    // params :                                                             //
    //          - List<float> X : liste des abscisses des points            //
    //          - List<float> Y : liste des ordonnées des points            //
    //          - List<float> T : temps de la parametrisation               //
    //          - List<float> tToEval : échantillon des temps sur T         //
    // sortie : rien                                                        //
    //////////////////////////////////////////////////////////////////////////
  void applyLagrangeParametrisation(List<float> X, List<float> Y, List<float> T, List<float> tToEval)
    {
        for (int i = 0; i < tToEval.Count; ++i)
        {
            // Calcul de xpoint et ypoint
            float xpoint = lagrange(tToEval[i], T, X);
            float ypoint = lagrange(xpoint, X, Y);
            Vector3 pos = new Vector3(xpoint, 0.0f, ypoint);
            P2DRAW.Add(pos);
        }
    }

    //////////////////////////////////////////////////////////////////////////
    // fonction : applyNevilleParametrisation                               //
    // semantique : applique la subdivion de Neville aux points (x,y)       //
    //              placés en paramètres en suivant les temps indiqués      //
    // params :                                                             //
    //          - List<float> X : liste des abscisses des points            //
    //          - List<float> Y : liste des ordonnées des points            //
    //          - List<float> T : temps de la parametrisation               //
    //          - List<float> tToEval : échantillon des temps sur T         //
    // sortie : rien                                                        //
    //////////////////////////////////////////////////////////////////////////
    void applyNevilleParametrisation(List<float> X, List<float> Y, List<float> T, List<float> tToEval)
    {
        for (int i = 0; i < tToEval.Count; ++i)
        {
            // Appliquer neville a l'echantillon i
            Vector2 v = neville(X, Y, T, tToEval[i]);
            Vector3 pos = new Vector3(v[0], 0.0f, v[1]);
            P2DRAW.Add(pos);
        }
    }

    //////////////////////////////////////////////////////////////////////////
    // fonction : lagrange                                                  //
    // semantique : calcule la valeur en x du polynome de Lagrange passant  //
    //              par les points de coordonnées (X,Y)                     //
    // params :                                                             //
    //          - float x : point dont on cherche l'ordonnée                //
    //          - List<float> X : liste des abscisses des points            //
    //          - List<float> Y : liste des ordonnées des points            //
    // sortie : valeur en x du polynome de Lagrange passant                 //
    //          par les points de coordonnées (X,Y)                         //
    //////////////////////////////////////////////////////////////////////////
    private float lagrange(float x, List<float> X, List<float> Y)
    {
        float res = 0.0f;
        for(int i = 0; i < X.Count; ++i) {
            float Li = 1.0f;
            for(int j = 0; j< X.Count; ++j){
                if (j!=i){
                    Li *= ((x-X[j])/(X[i]-X[j]));
                }
            }
            res += Y[i]*Li; 
        }
        return res;
    }

    //////////////////////////////////////////////////////////////////////////
    // fonction : neville                                                   //
    // semantique : calcule le point atteint par la courbe en t sachant     //
    //              qu'elle passe par les (X,Y) en T                        //
    // params :                                                             //
    //          - List<float> X : liste des abscisses des points            //
    //          - List<float> Y : liste des ordonnées des points            //
    //          - List<float> T : liste des temps de la parametrisation         //
    //          - t : temps ou on cherche le point de la courbe             //
    // sortie : point atteint en t de la courbe                             //
    //////////////////////////////////////////////////////////////////////////
    private Vector2 neville(List<float> X, List<float> Y, List<float> T, float t)
    {
        List<float> ypoints = new List<float>();
        for(int i=0; i < Y.Count; i++) {
            ypoints.Add(Y[i]);
        }
        for (int ligne=0 ; ligne < X.Count; ligne++) {
            for(int col=0; col < X.Count - ligne - 1; col ++){
                ypoints[col] = (T[col+1+ligne] - t)/(T[col+1+ligne] - T[col]) * ypoints[col]
                                + (t - T[col])/(T[col+1+ligne] - T[col]) * ypoints[col+1];
            }
        }
        float x = lagrange(t, T, X);
        return new Vector2(x,ypoints[0]);
    }

    //////////////////////////////////////////////////////////////////////////
    //////////////////////// NE PAS TOUCHER !!! //////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return))
        {
            var ListePointsCliques = GameObject.Find("Donnees").GetComponent<Points>();
            List<float> T = new List<float>();
            List<float> tToEval = new List<float>();

            if (ListePointsCliques.X.Count > 0)
            {
                X = ListePointsCliques.X;
                Y = ListePointsCliques.Y;

                if (InterpolationType == EInterpolationType.Lagrange)
                {
                    switch (ParametrisationType)
                    {
                        case EParametrisationType.None:
                            List<float> x = new List<float>();
                            List<float> y = new List<float>();
                            var xmax = 10.0f;
                            var xcur = -10.0f;
                            while(xcur < xmax) {
                                xcur+=pas;
                                x.Add(xcur);
                            }
                            for (int i = 0; i < x.Count; i++)
                            {
                                y.Add(lagrange(x[i], X, Y));
                            }

                            for (int i = 0; i < x.Count; ++i)
                            {
                                Vector3 pos = new Vector3(x[i], 0.0f, y[i]);
                                P2DRAW.Add(pos);
                            }
                            break;
                        case EParametrisationType.Reguliere:
                            (T, tToEval) = buildParametrisationReguliere(X.Count, pas);
                            applyLagrangeParametrisation(X, Y, T, tToEval);
                            break;
                        case EParametrisationType.Distance:
                            (T, tToEval) = buildParametrisationDistance(X.Count, pas);
                            applyLagrangeParametrisation(X, Y, T, tToEval);
                            break;
                        case EParametrisationType.RacineDistance:
                            (T, tToEval) = buildParametrisationRacineDistance(X.Count, pas);
                            applyLagrangeParametrisation(X, Y, T, tToEval);
                            break;
                        case EParametrisationType.Tchebytcheff:
                            (T, tToEval) = buildParametrisationTchebycheff(X.Count, pas);
                            applyLagrangeParametrisation(X, Y, T, tToEval);
                            break;
                    }

                } else if (InterpolationType == EInterpolationType.Neville) {

                    switch (ParametrisationType)
                    {
                        case EParametrisationType.Reguliere:
                            (T, tToEval) = buildParametrisationReguliere(X.Count, pas);
                            applyNevilleParametrisation(X, Y, T, tToEval);
                            break;
                        case EParametrisationType.Distance:
                            (T, tToEval) = buildParametrisationDistance(X.Count, pas);
                            applyNevilleParametrisation(X, Y, T, tToEval);
                            break;
                        case EParametrisationType.RacineDistance:
                            (T, tToEval) = buildParametrisationRacineDistance(X.Count, pas);
                            applyNevilleParametrisation(X, Y, T, tToEval);
                            break;
                        case EParametrisationType.Tchebytcheff:
                            (T, tToEval) = buildParametrisationTchebycheff(X.Count, pas);
                            applyNevilleParametrisation(X, Y, T, tToEval);
                            break;
                        case EParametrisationType.None:
                            text.text = "Vous devez choisir un type de parametrisation pour utiliser Neville";
                            break;
                    }
                }
            }
          }
    }

    //////////////////////////////////////////////////////////////////////////
    //////////////////////// NE PAS TOUCHER !!! //////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.blue;
        for(int i = 0; i < P2DRAW.Count - 1; ++i)
        {
            Gizmos.DrawLine(P2DRAW[i], P2DRAW[i+1]);

        }
    }
}
