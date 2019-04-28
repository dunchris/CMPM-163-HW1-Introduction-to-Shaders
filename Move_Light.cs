using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Move_Light : MonoBehaviour
{
    Transform trans;
    float rad;
    // Start is called before the first frame update
    void Start()
    {
        trans = gameObject.GetComponent<Transform>();
        rad = 0;
    }

    // Update is called once per frame
    void Update()
    {
        //Move lights based on sine function
        rad = Mathf.Sin((1.0f*Time.time) % 2*Mathf.PI);
        trans.position = new Vector3(trans.position.x + rad, trans.position.y, trans.position.z);
    }
}
