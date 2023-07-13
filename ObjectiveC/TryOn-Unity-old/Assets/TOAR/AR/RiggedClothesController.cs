using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RiggedClothesController : MonoBehaviour
{
    [SerializeField]
    private List<GameObject> m_Clothes;
    [SerializeField]
    private int m_ActiveIndex;
    
    public int ActiveIndex
    {
        set
        {
            m_ActiveIndex = value;
            UpdateActiveClothes();
        }

        get
        {
            return m_ActiveIndex;
        }
    }

    private void UpdateActiveClothes()
    {
        foreach(var cloth in m_Clothes)
        {
            cloth.SetActive(false);
        }

        m_Clothes[m_ActiveIndex].SetActive(true);
    }

    private void Start()
    {
        m_ActiveIndex = 0;
        UpdateActiveClothes();
    }
}
