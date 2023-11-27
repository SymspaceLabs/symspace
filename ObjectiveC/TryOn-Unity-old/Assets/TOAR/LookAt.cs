using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace TOAR
{
    public class LookAt : MonoBehaviour
    {
        [SerializeField] private Transform m_Target;

        private Transform m_Transfrom;

        #region Private

        private void Awake()
        {
            m_Transfrom = GetComponent<Transform>();

            if (m_Target == null)
            {
                m_Target = Camera.main.transform;
            }
        }

        private void FixedUpdate()
        {
            if (m_Target != null && m_Transfrom != null)
            {
                m_Transfrom.LookAt(m_Target, Vector3.up);
            }
        }

        #endregion
    }
}
