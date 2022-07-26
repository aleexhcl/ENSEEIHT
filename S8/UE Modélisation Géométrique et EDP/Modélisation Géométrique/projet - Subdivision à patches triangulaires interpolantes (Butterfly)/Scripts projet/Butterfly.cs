using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class Butterfly : MonoBehaviour
{
    public GameObject particle;
    public bool autoGenerateGrid;
    public int nbIt = 1;

    // Coordonnees des points
    private List<Vector3> Points = new List<Vector3>();

    // Numéro des Faces (Liste des Points dans l'ordre horaire)
    private List<List<int>> Faces = new List<List<int>>();

    // Numéro des Arêtes (Liste des Points dans l'ordre croissant)
    private List<List<int>> Aretes = new List<List<int>>();

    // Poids des Points
    float w = 1/16f;
    List<float> poids = new List<float>();

    // type de butterfly
    private enum Cas { PASBORD, BORD, UNTRI, DEUXTRI, DEUXTROISTRI }; 

    // Renvoie la liste des faces adjacentes à une arête
    List<int> findFaces(int idA) {
        List<int> ans = new List<int>();
       
        for (int i = 0; i < Faces.Count; ++i) {
            if (ans.Count == 2) {
                break;
            } 

            if (Faces[i].Contains(Aretes[idA][0]) & Faces[i].Contains(Aretes[idA][1])) {
                ans.Add(i);
            }
        }

        return ans;
    }

    // Renvoie la liste des arêtes qui compose une face
    List<int> findAretes(int idF, List<int> mem) {
        List<int> ans = new List<int>();

        int p1 = Faces[idF][0];
        int p2 = Faces[idF][1];
        int p3 = Faces[idF][2];
       
        for (int i = 0; i < Aretes.Count; ++i) {
            if (ans.Count == 3) {
                break;
            } 

            if ((Aretes[i][0] == p1 & Aretes[i][1] == p2) | (Aretes[i][1] == p1 & Aretes[i][0] == p2) | 
                (Aretes[i][0] == p2 & Aretes[i][1] == p3) | (Aretes[i][1] == p2 & Aretes[i][0] == p3) |
                (Aretes[i][0] == p3 & Aretes[i][1] == p1) | (Aretes[i][1] == p3 & Aretes[i][0] == p1)) {
                    if (!mem.Contains(i)) {
                        ans.Add(i);
                    }
            }
        }

        return ans;
    }

    // vrai si le point appartient à la face 
    bool pointDansFace(int idP, int idF) {
        bool res = false; 
        List<int> ar = findAretes(idF, new List<int>());
        for (int i=0; i < ar.Count; i++){
            if ((idP == Aretes[ar[i]][0]) | (idP == Aretes[ar[i]][1])){
                res = true; 
            }
        }
        return res; 
    }

    // renvoie les triangles adajacents au triangle idF autres que dans mem
    List<int> triangleAdja(int idF, List<int> mem){
        List<int> ans = new List<int>();
        List<int> ar = findAretes(idF, new List<int>() );
        for (int i=0; i < ar.Count ;i++){
            List<int> triad = findFaces(ar[i]);
            for(int j=0;j < triad.Count;j++){
                if((triad[j] != idF) && (!mem.Contains(triad[j]))){
                    ans.Add(triad[j]); 
                }
            }
        }
        return ans;
    }

    List<float> poidsNvPoint = new List<float>(); 
    List<int> butterflyNvPoint = new List<int>();

    // renvoie le cas de subdivision du point considéré en fonction de l'arete
    Cas findCas(int idE) {
        Cas cas = new Cas();
        List<int> butterfly = new List<int>();
        List<int> edges = new List<int>();

        butterfly.Add(Aretes[idE][0]); // P1
        butterfly.Add(Aretes[idE][1]); // P2
        int P1 = Aretes[idE][0]; 
        int P2 = Aretes[idE][1]; 
        edges.Add(idE); 

        // faces adjacentes 
        List<int> triangles = findFaces(idE);

        if (triangles.Count == 1) {
            cas = Cas.BORD;
            int t0 = triangles[0];
            List<int> memTri = new List<int>();
            memTri.Add(t0);
            List<int> t0Adj = triangleAdja(t0, memTri);
            if (t0Adj.Count == 2) {
                int f0 = t0Adj[0];
                int f1 = t0Adj[1];
                memTri.Add(f0);
                memTri.Add(f1);
                List<int> f0Ajd = triangleAdja(f0, memTri);
                List<int> f1Ajd = triangleAdja(f1, memTri);
                if ((f0Ajd.Count == 0) | (f1Ajd.Count == 0)) {
                    poidsNvPoint = new List<float>() {1/2f, 1/2f};
                    butterflyNvPoint = butterfly;
                } else {
                    poidsNvPoint = new List<float>() {9/16f, 9/16f, -1/16f, -1/16f};
                    butterfly.Add(0);
                    butterfly.Add(0);
                    int f2 = f0Ajd[0];
                    int f3 = f1Ajd[0];
                    for (int i=0; i<3; i++) {
                        int pf2 = Faces[f2][i];
                        int pf3 = Faces[f3][i];
                        if (!pointDansFace(pf2, f0)) {
                            butterfly[2] = pf2;
                        }
                        if (!pointDansFace(pf3, f1)) {
                            butterfly[3] = pf3;
                        }
                    }
                    butterflyNvPoint = butterfly;
                }
            } else {
                poidsNvPoint = new List<float>() {1/2f, 1/2f};
                butterflyNvPoint = butterfly;
            }
        }

        else { 
            int t0 = triangles[0];
            int t1 = triangles[1];
            List<int> memTri = new List<int>();
            memTri.Add(t0);
            memTri.Add(t1); 
            List<int> t0Adj = triangleAdja(t0, memTri);
            List<int> t1Adj = triangleAdja(t1, memTri);
            if ((t0Adj.Count == 2) && (t1Adj.Count == 2)) {
                cas = Cas.PASBORD;
            } else if ((t0Adj.Count == 2 && t1Adj.Count == 1) | (t0Adj.Count == 1 && t1Adj.Count == 2)) {
                if ((t0Adj.Count == 1) && (t1Adj.Count == 2)) {
                    t1 = triangles[0];
                    t0 = triangles[1];
                    t0Adj = triangleAdja(t0, memTri);
                    t1Adj = triangleAdja(t1, memTri);
                }
                cas = Cas.UNTRI;
                poidsNvPoint = new List<float>() {3/8f, 5/8f, 3/16f, -1/8f, -1/16f, 1/16f, -1/16f};
                butterfly.Add(0);
                butterfly.Add(0);
                butterfly.Add(0);
                butterfly.Add(0);
                butterfly.Add(0);
                int f0 = t0Adj[0];
                int f1 = t0Adj[1];
                int f2 = t1Adj[0];
                if (!pointDansFace(butterfly[1], f2)) {
                    butterfly[0] = Aretes[idE][1];
                    butterfly[1] = Aretes[idE][0];
                }
                if (!pointDansFace(butterfly[1], f0)) {
                    f0 = t0Adj[1];
                    f1 = t0Adj[0];
                }
                for (int i=0; i<3; i++) {
                    int pf0 = Faces[f0][i];
                    if (pointDansFace(pf0, f1)) {
                        butterfly[2] = pf0;
                    } else if (!pointDansFace(pf0, t0)) {
                        butterfly[3] = pf0;
                    }
                    int pf1 = Faces[f1][i];
                    if (!pointDansFace(pf1, f0) && !pointDansFace(pf1, t0)) {
                        butterfly[4] = pf1;
                    }
                    int pf2 = Faces[f2][i];
                    if (pointDansFace(pf2, t1) && !pointDansFace(pf2, t0)) {
                        butterfly[5] = pf2;
                    }
                    if (!pointDansFace(pf2, t1)) {
                        butterfly[6] = pf2;
                    }
                }
                butterflyNvPoint = butterfly; 

            } else if ((t0Adj.Count == 2 && t1Adj.Count == 0) | (t0Adj.Count == 0 && t1Adj.Count == 2)) {
                if ((t0Adj.Count == 0) && (t1Adj.Count == 2)) {
                    t1 = triangles[0];
                    t0 = triangles[1];
                    t0Adj = triangleAdja(t0, memTri);
                    t1Adj = triangleAdja(t1, memTri);
                }
                cas = Cas.DEUXTRI;
                poidsNvPoint = new List<float>() {1/2f, 1/2f, 1/4f, -1/8f, -1/8f};
                int f0 = t0Adj[0];
                int f1 = t0Adj[1];
                butterfly.Add(0);
                butterfly.Add(0);
                butterfly.Add(0);
                for (int i=0;i<3; i++){
                    int pf0 = Faces[f0][i];
                    if (pointDansFace(pf0, f1)){
                        butterfly[2] = pf0;
                    } else if (!pointDansFace(pf0, t0)) {
                        butterfly[3] = pf0;
                    }
                    int pf1 = Faces[f1][i];
                    if (!pointDansFace(pf1, f0) && !pointDansFace(pf1, t0)){
                        butterfly[4] = pf1;
                    }
                }
                butterflyNvPoint = butterfly; 
            } else {
                cas = Cas.DEUXTROISTRI; 
                poidsNvPoint = new List<float>() {1/2f, 1/2f};
                butterflyNvPoint = butterfly; 
            }
        }
        return cas; 
    }


    // Ajoute les Points d'une face qui ne sont pas déjà utilisés (-> butterfly)
    List<int> ajoutPoint(List<int> mem, int idF) {
        List<int> ans = mem;
        List<int> face = Faces[idF];
        for (int j = 0; j < face.Count; ++j) {
            // Ajoute le Dernier Points
            int num = face[j];
            if (!ans.Contains(num)) {
                ans.Add(num);
            }
        }
        return ans;
    }

    // Butterfly
    Vector3 applyButterfly(int e){
        Vector3 p = new Vector3(0, 0, 0);
        Cas cas = findCas(e); 

        if (cas == Cas.PASBORD) {
           
            // On instancie le modèle butterfly
            List<int> butterfly = new List<int>();
            List<int> edges = new List<int>();

            // Ajout de P1 et P2
            butterfly.Add(Aretes[e][0]); // P1
            butterfly.Add(Aretes[e][1]); // P2

            // On trouve les deux faces associés à une arête
            List<int> triangles = findFaces(e);

            // On mémorise les arêtes que l'on a déjà trouvé
            edges.Add(e);

            //Debug.Log("OK !");

            // Itération 1
            for (int i = 0; i < triangles.Count; ++i) {
                // On met à jours les points
                butterfly = ajoutPoint(butterfly, triangles[i]);

                // On Trouve les arêtes associés à une face (qui ne sont pas en mémoire)
                List<int> tmp = findAretes(triangles[i], edges);
                //Debug.Log("Nb d'arêtes à une face : " + tmp.Count);

                // On les ajoute dans la mémoire
                for (int k = 0; k < tmp.Count; ++k) {
                    edges.Add(tmp[k]);
                }
            }

            //Debug.Log("OK !");
            //Debug.Log("Nombre d'arêtes après la première itération :" + edges.Count);

            int nbEdges = edges.Count;

            // Itération 2
            for (int i = 1; i < nbEdges; ++i) {
                // On calcule les points de niveau 2
                triangles = findFaces(edges[i]);
                //Debug.Log("Nombre de nouveau triangles dans l'itération " + i + " : " + triangles.Count);
                
                for (int j = 0; j < triangles.Count; ++j) {
                    // On met à jours les points
                    butterfly = ajoutPoint(butterfly, triangles[j]);

                    // On trouve les arêtes associés à une face (qui ne sont pas en mémoire)
                    List<int> tmp = findAretes(triangles[j], edges);

                    // On les ajoute dans la mémoire
                    for (int k = 0; k < tmp.Count; ++k) {
                        edges.Add(tmp[k]);
                    }
                }
            }        

            //Debug.Log("OK !");
            // DEBUG
            //Debug.Log(butterfly.Count);

            for (int i = 0; i < butterfly.Count; ++i) {
                //Debug.Log("Point : " + butterfly[i] + " : [" + Points[butterfly[i]][0] + ", " + Points[butterfly[i]][1] + ", " + Points[butterfly[i]][2] + "]");
            }

            for (int i = 0; i < edges.Count; ++i) {
                //Debug.Log("Arête : " + edges[i] + " : [" + Aretes[edges[i]][0] + ", " + Aretes[edges[i]][1] + "]");
            }

            // On a construit notre modèle pour l'arête donné
            /*for (int i = 0; i < butterfly.Count; ++i) {
                for (int j = 0; j < 3; ++j) {
                    p[j] += poids[i] * Points[butterfly[i]][j];
                }
                //Debug.Log("p " + i + " : [" + p[0] + ", " + p[1] + ", " + p[2] + "]");
            }*/
            
            for (int i = 0; i < butterfly.Count; ++i) {
            for (int j = 0; j < 3; ++j) {
                p[j] += poids[i] * Points[butterfly[i]][j];
                
            }
                //Debug.Log("p " + i + " : [" + p[0] + ", " + p[1] + ", " + p[2] + "]");
            }
        }
        else {
            for (int i = 0; i < butterflyNvPoint.Count; ++i) {
                for (int j = 0; j < 3; ++j) {
                    p[j] += poidsNvPoint[i] * Points[butterflyNvPoint[i]][j];
                }
            }
        }

        //Debug.Log("p : [" + p[0] + ", " + p[1] + ", " + p[2] + "]");

        return p;
    }

    void figure1() {
        Points.Add(new Vector3(0.0f, 1.0f, 0.0f)); // 0
        Points.Add(new Vector3(1.0f, 0.0f, 0.0f)); // 1
        Points.Add(new Vector3(0.0f, 0.0f, 1.0f)); // 2       
        Points.Add(new Vector3(-1.0f, 0.0f, 0.0f)); // 3
        Points.Add(new Vector3(0.0f, 0.0f, -1.0f)); // 4
        Points.Add(new Vector3(0.0f, -1.0f, 0.0f)); // 5
        
        Faces.Add(new List<int>() {0, 1, 2});
        Faces.Add(new List<int>() {0, 2, 3});
        Faces.Add(new List<int>() {0, 3, 4});
        Faces.Add(new List<int>() {0, 4, 1});
        Faces.Add(new List<int>() {1, 5, 2});
        Faces.Add(new List<int>() {2, 5, 3});
        Faces.Add(new List<int>() {3, 5, 4});
        Faces.Add(new List<int>() {4, 5, 1});

        Aretes.Add(new List<int>() {0, 1});            
        Aretes.Add(new List<int>() {0, 2});
        Aretes.Add(new List<int>() {0, 3});
        Aretes.Add(new List<int>() {0, 4});
        Aretes.Add(new List<int>() {1, 2});
        Aretes.Add(new List<int>() {2, 3});            
        Aretes.Add(new List<int>() {3, 4});            
        Aretes.Add(new List<int>() {1, 4});
        Aretes.Add(new List<int>() {1, 5});
        Aretes.Add(new List<int>() {2, 5});            
        Aretes.Add(new List<int>() {3, 5});            
        Aretes.Add(new List<int>() {4, 5});
    }

    void figure2() {
        Points.Add(new Vector3(-3.0f, 1.5f, 1.0f));//0
        Points.Add(new Vector3(-1.0f, 0.5f, 1.0f));
        Points.Add(new Vector3(1.0f, 0.5f, 1.0f));
        Points.Add(new Vector3(3.0f, 1.5f, 1.0f));
        Points.Add(new Vector3(-2.0f, 1.0f, -1.0f));
        Points.Add(new Vector3(0.0f, 0.0f, -1.0f)); //5
        Points.Add(new Vector3(2.0f, 1.0f, -1.0f));

        Faces.Add(new List<int>() {0, 1, 4});
        Faces.Add(new List<int>() {1, 2, 5});
        Faces.Add(new List<int>() {2, 3, 6});
        Faces.Add(new List<int>() {1, 5, 4});
        Faces.Add(new List<int>() {2, 6, 5});

        Aretes.Add(new List<int>() {0, 1});
        Aretes.Add(new List<int>() {0, 4});
        Aretes.Add(new List<int>() {1, 2});
        Aretes.Add(new List<int>() {1, 4});
        Aretes.Add(new List<int>() {1, 5});
        Aretes.Add(new List<int>() {2, 3});
        Aretes.Add(new List<int>() {2, 5});
        Aretes.Add(new List<int>() {2, 6});
        Aretes.Add(new List<int>() {3, 6});
        Aretes.Add(new List<int>() {4, 5});
        Aretes.Add(new List<int>() {5, 6});
    }

    void figure3() {
        Points.Add(new Vector3(-1.0f, 0.0f, 0.0f));//0
        Points.Add(new Vector3(1.0f, 0.0f, 0.0f));
        Points.Add(new Vector3(0.0f, 1.0f, -1.0f));
        Points.Add(new Vector3(2.0f, 1.5f, -1.0f));
        Points.Add(new Vector3(-2.0f, 1.5f, -1.0f));
        Points.Add(new Vector3(0.0f, 0.5f, 1.0f)); //5
        Points.Add(new Vector3(2.0f, 0.5f, 1.0f));

        Faces.Add(new List<int>() {0, 1, 2});
        Faces.Add(new List<int>() {0, 2, 4});
        Faces.Add(new List<int>() {1, 3, 2});
        Faces.Add(new List<int>() {5, 1, 0});
        Faces.Add(new List<int>() {5, 6, 1});

        Aretes.Add(new List<int>() {0, 1});
        Aretes.Add(new List<int>() {0, 4});
        Aretes.Add(new List<int>() {0, 2});
        Aretes.Add(new List<int>() {2, 4});
        Aretes.Add(new List<int>() {2, 3});
        Aretes.Add(new List<int>() {1, 3});
        Aretes.Add(new List<int>() {0, 5});
        Aretes.Add(new List<int>() {1, 5});
        Aretes.Add(new List<int>() {1, 2});
        Aretes.Add(new List<int>() {5, 6});
        Aretes.Add(new List<int>() {1, 6});
    }

    void figure4() {
        Points.Add(new Vector3(-0.5f, 0.0f, 0.0f));//0
        Points.Add(new Vector3(0.5f, 0.0f, 0.0f));
        Points.Add(new Vector3(0.0f, 0.5f, 1.0f));
        Points.Add(new Vector3(-1.0f, 0.5f, -1.0f));
        Points.Add(new Vector3(0.0f, 0.0f, -1.0f));
        Points.Add(new Vector3(1.0f, 0.5f, 0-1.0f));

        Faces.Add(new List<int>() {0, 1, 4});
        Faces.Add(new List<int>() {0, 4, 3});
        Faces.Add(new List<int>() {1, 5, 4});
        Faces.Add(new List<int>() {2, 1, 0});

        Aretes.Add(new List<int>() {0, 1});
        Aretes.Add(new List<int>() {0, 4});
        Aretes.Add(new List<int>() {0, 3});
        Aretes.Add(new List<int>() {3, 4});
        Aretes.Add(new List<int>() {1, 4});
        Aretes.Add(new List<int>() {1, 5});
        Aretes.Add(new List<int>() {4, 5});
        Aretes.Add(new List<int>() {2, 1});
        Aretes.Add(new List<int>() {0, 2});
    }

    void figure5() {
        Points.Add(new Vector3(-0.5f, 0.0f, 0.0f));//0
        Points.Add(new Vector3(0.5f, 0.0f, 0.0f));
        Points.Add(new Vector3(0.0f, 0.5f, 1.0f));
        Points.Add(new Vector3(0.0f, 0.0f, -1.0f));

        Points.Add(new Vector3(-1.0f, 0.0f, -1.0f));
        
        Points.Add(new Vector3(1.0f, 0.0f, -1.0f));

        Faces.Add(new List<int>() {0, 1, 3});
        Faces.Add(new List<int>() {0, 1, 2});

        Faces.Add(new List<int>() {0, 3, 4});
        
        Faces.Add(new List<int>() {1, 5, 3});

        Aretes.Add(new List<int>() {0, 1});
        Aretes.Add(new List<int>() {0, 3});
        Aretes.Add(new List<int>() {0, 2});
        Aretes.Add(new List<int>() {1, 2});
        Aretes.Add(new List<int>() {1, 3});

        Aretes.Add(new List<int>() {3, 4});
        Aretes.Add(new List<int>() {0, 4});
        
        Aretes.Add(new List<int>() {1, 5});
        Aretes.Add(new List<int>() {3, 5});

    }

    //////////////////////////////////////////////////////////////////////////
    ////////////////////////// LANCEMENT FIGURES /////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    void Start()
    {
        if (autoGenerateGrid)
        {
            poids = new List<float>() {1/2f, 1/2f, 2f * w, 2f * w, -w, -w, -w, -w};

            figure2();

            for (int i = 0; i < Points.Count; ++i) {
                Instantiate(particle, Points[i], Quaternion.identity);
            }
        }
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return))
        {
            for (int it = 0; it < nbIt; ++it) {
                List<List<int>> newFaces = new List<List<int>>();
                List<List<int>> newEdges = new List<List<int>>();
                List<int> memEdges = new List<int>(); // On garde en mémoire les arêtes que l'on a déjà faite

                int n = Faces.Count;

                /*if (it == 0) {
                    n = 1;
                }*/

                // Faces
                for (int idF = 0; idF < n; ++idF) {
                    //Debug.Log(idF);
                    List<int> edges = findAretes(idF, new List<int>());

                    //Debug.Log(Aretes[edges[0]][0] + "" + Aretes[edges[1]][1] + "" + Aretes[edges[2]][0]);

                    List<int> newPoint = new List<int>(); // L'ensemble des points dans la nouvelle face (= 6)
                    List<List<int>> ne = new List<List<int>>(); // 9 Nouvelles arêtes

                    // Arête
                    for (int idE = 0; idE < 3; ++idE) {
                        //Debug.Log(idE);
                        int A = Aretes[edges[idE]][0];
                        int B = Aretes[edges[idE]][1];

                        if (!newPoint.Contains(A)) {
                            newPoint.Add(A);
                            //Debug.Log(A);
                        } else {
                            newPoint.Add(B);
                            //Debug.Log(B);
                        }

                        int X = Points.Count;

                        // Nouveau Point
                        Vector3 p = applyButterfly(edges[idE]);
                        if (!memEdges.Contains(edges[idE])) { // Vraiment un nouveau point
                            Points.Add(p);
                            Instantiate(particle, p, Quaternion.identity);
                            memEdges.Add(edges[idE]);
                            
                            // Divise les Arêtes
                            ne.Add(new List<int>() {Math.Min(A, X), Math.Max(A, X)});
                            ne.Add(new List<int>() {Math.Min(B, X), Math.Max(B, X)});
                        } else { // Déja calculé
                            X = Points.IndexOf(p);
                        } 
                        // On stocke en mémoire
                        newPoint.Add(X);

                    }

                    // Nouvelles Arêtes
                    int n1 = newPoint[1];
                    int n2 = newPoint[3];
                    int n3 = newPoint[5];
                    ne.Add(new List<int>() {Math.Min(n1, n2), Math.Max(n1, n2)});
                    ne.Add(new List<int>() {Math.Min(n2, n3), Math.Max(n2, n3)});
                    ne.Add(new List<int>() {Math.Min(n3, n1), Math.Max(n3, n1)});

                    for (int e = 0; e < ne.Count; ++e) {
                        newEdges.Add(ne[e]);
                    }

                    /*
                    if (it > 0 & (idF + 1) % 4 == 0) {
                        // Nouvelles Faces
                        newFaces.Add(new List<int>() {newPoint[0], newPoint[5], newPoint[1]});
                        newFaces.Add(new List<int>() {newPoint[1], newPoint[5], newPoint[3]});
                        newFaces.Add(new List<int>() {newPoint[1], newPoint[3], newPoint[2]});
                        newFaces.Add(new List<int>() {newPoint[5], newPoint[4], newPoint[3]});
                        
                    } else {
                        // Nouvelles Faces
                        newFaces.Add(new List<int>() {newPoint[0], newPoint[1], newPoint[3]});
                        newFaces.Add(new List<int>() {newPoint[3], newPoint[5], newPoint[2]});
                        newFaces.Add(new List<int>() {newPoint[1], newPoint[4], newPoint[5]});
                        newFaces.Add(new List<int>() {newPoint[1], newPoint[5], newPoint[3]});
                    }*/

                }

                for (int ide1=0 ; ide1<newEdges.Count; ide1++) {
                        int p10 = newEdges[ide1][0];
                        int p11 = newEdges[ide1][1];
                        for (int ide2=ide1+1; ide2 <newEdges.Count; ide2++) {
                            int p20 = newEdges[ide2][0];
                            int p21 = newEdges[ide2][1];
                            if (p10 == p20) {
                                for (int ide3=ide2+1; ide3<newEdges.Count; ide3++) {
                                    int p30 = newEdges[ide3][0];
                                    int p31 = newEdges[ide3][1];
                                    if (((p11 == p30) && (p21 == p31)) | ((p11 == p31) && (p21 == p30))) {
                                        newFaces.Add( new List<int>() {p10, p11, p21});
                                    }
                                }
                            } else if (p10 == p21) {
                                for (int ide3=ide2+1; ide3<newEdges.Count; ide3++) {
                                    int p30 = newEdges[ide3][0];
                                    int p31 = newEdges[ide3][1];
                                    if (((p11 == p30) && (p20 == p31)) | ((p11 == p31) && (p20 == p30))) {
                                        newFaces.Add( new List<int>() {p10, p11, p20});
                                    }
                                }
                            } else if (p11 == p20) {
                                for (int ide3=ide2+1; ide3<newEdges.Count; ide3++) {
                                    int p30 = newEdges[ide3][0];
                                    int p31 = newEdges[ide3][1];
                                    if (((p10 == p30) && (p21 == p31)) | ((p10 == p31) && (p21 == p30))) {
                                        newFaces.Add( new List<int>() {p10, p11, p21});
                                    }
                                }
                            } else if (p11 == p21) {
                                for (int ide3=ide2+1; ide3<newEdges.Count; ide3++) {
                                    int p30 = newEdges[ide3][0];
                                    int p31 = newEdges[ide3][1];
                                    if (((p10 == p30) && (p20 == p31)) | ((p10 == p31) && (p20 == p30))) {
                                        newFaces.Add( new List<int>() {p10, p11, p20});
                                    }
                                }
                            }

                        }
                    }

                //Debug.Log(newEdges.Count);
                //Debug.Log(newFaces.Count);
                //Debug.Log(Points.Count);
                Aretes = new List<List<int>>(newEdges);
                Faces = new List<List<int>>(newFaces);
            }
        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        
        for (int i = 0; i < Faces.Count; ++i) {
            Gizmos.DrawLine(Points[Faces[i][0]], Points[Faces[i][1]]);
            Gizmos.DrawLine(Points[Faces[i][1]], Points[Faces[i][2]]);
            Gizmos.DrawLine(Points[Faces[i][2]], Points[Faces[i][0]]);
        }
        /*
        for (int i = 0; i < Aretes.Count; ++i) {
            Gizmos.DrawLine(Points[Aretes[i][0]], Points[Aretes[i][1]]);
        }*/
    }
}
