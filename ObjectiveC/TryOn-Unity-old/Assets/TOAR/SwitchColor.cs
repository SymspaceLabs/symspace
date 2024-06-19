using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwitchColor : MonoBehaviour
{
    [SerializeField] private Renderer m_Renderer;
    [SerializeField] private List<Material> m_Materials = new List<Material>();

    public void ChangeColor(int index)
    {
        if(m_Renderer == null || m_Materials.Count <= index || index < 0) return;

        m_Renderer.sharedMaterial = m_Materials[index];
    }
    // Start is called before the first frame update
    void Start()
    {
        ChangeColor(0);
    }
}
