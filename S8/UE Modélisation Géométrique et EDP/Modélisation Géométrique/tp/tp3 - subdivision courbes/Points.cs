using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Permet de stocker les coordonnees des points selectionnes a l'écran en vue d'un traitement
public class Points : MonoBehaviour
{
    // Objet qui sera instancie sur un clic
    public GameObject particle;
    // Listes memoires des coordonnees
    public List<float> X = new List<float>();
    public List<float> Y = new List<float>();

    // Methode appellee au debut du programme
    void Start()
    {
        
    }

    // Methode appellee a chaque pas de simulation
    void Update()
    {
        Vector3 mousePos = new Vector3(Input.mousePosition.x, Input.mousePosition.y, 0f);

        if (Input.GetButtonDown("Fire1"))
        {
            Vector3 wordPos;
            Ray ray = Camera.main.ScreenPointToRay(mousePos);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit, 1000f))
            {
                wordPos = hit.point;
            }
            else
            {
                wordPos = Camera.main.ScreenToWorldPoint(mousePos);
            }
            Instantiate(particle, wordPos, Quaternion.identity);
            X.Add(wordPos.x);
            Y.Add(wordPos.z);
        }
    }
}
