using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Script qui permet de zoomer avec la molette de la souris
public class Zoom : MonoBehaviour
{

    private float scrollSpeed = 4.0f;
    private float cameraDistance = 0f;
    
    void Update()
    {
        cameraDistance = Input.GetAxis("Mouse ScrollWheel") * scrollSpeed;
        transform.Translate(new Vector3(0,0, cameraDistance));
    }
}
