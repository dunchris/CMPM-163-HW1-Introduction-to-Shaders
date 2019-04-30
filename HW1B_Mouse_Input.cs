using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HW1B_Mouse_Input : MonoBehaviour
{
    Renderer render;
    float i;
    // Start is called before the first frame update
    void Start()
    {
        i = 0;
        render = GetComponent<Renderer>();

        render.material.shader = Shader.Find("CMPM131HW1/Mosquito Shader");
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            i += 1;
            Debug.Log(i);
        }
        else if (Input.GetMouseButtonDown(1))
        {
            i -= 1;
            if (i < 1)
                i = 1;
            Debug.Log(i);
        }


        render.material.SetFloat("_mX", Input.mousePosition.x);
        render.material.SetFloat("_mY", Input.mousePosition.y);
        render.material.SetFloat("_MouseButtonPressed", i);


    }
}
