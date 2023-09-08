using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARFoundation;

namespace TOAR.AR
{
    [System.Serializable]
    public struct Clothes
    {
        public int idClothes;
        public string name;
        public UnityEngine.XR.ARFoundation.Samples.BoneController controller;
    }

    public class ClothesController : MonoBehaviour
    {
        [SerializeField]
        private List<Clothes> m_Clothes;
        [SerializeField]
        private int m_ActiveIndex = 0;

        public void InitializeSkeletonJoints()
        {
            m_ActiveIndex = 0;

            if (PlayerPrefs.HasKey("ActiveClothesIndex"))
            {
                m_ActiveIndex = PlayerPrefs.GetInt("ActiveClothesIndex");
            }

            foreach (var clothes in m_Clothes)
            {
                clothes.controller.InitializeSkeletonJoints();
            }
        }

        public int ActiveIndex
        {
            get
            {
                return m_ActiveIndex;
            }

            set
            {
                m_ActiveIndex = value;
            }
        }

        public UnityEngine.XR.ARFoundation.Samples.BoneController GetActiveBoneController()
        {
            m_ActiveIndex = 0;

            if (PlayerPrefs.HasKey("ActiveClothesIndex"))
            {
                m_ActiveIndex = PlayerPrefs.GetInt("ActiveClothesIndex");
            }

            return m_Clothes[m_ActiveIndex].controller;
        }

        public void ApplyBodyPose(ARHumanBody body)
        {
            foreach (var clothes in m_Clothes)
            {
                clothes.controller.ApplyBodyPose(body);
            }
        }

        // Start is called before the first frame update
        void Start()
        {
            m_ActiveIndex = 0;

            if (PlayerPrefs.HasKey("ActiveClothesIndex"))
            {
                m_ActiveIndex = PlayerPrefs.GetInt("ActiveClothesIndex");
            }
        }

        // Update is called once per frame
        void Update()
        {
            for (var i = 0; i < m_Clothes.Count; i++)
            {
                if(i == m_ActiveIndex)
                {
                    m_Clothes[i].controller.gameObject.SetActive(true);
                }
                else
                {
                    m_Clothes[i].controller.gameObject.SetActive(false);
                }
            }
        }
    }
}

