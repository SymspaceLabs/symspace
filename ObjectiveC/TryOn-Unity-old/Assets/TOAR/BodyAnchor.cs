using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

namespace TOAR
{
    public class BodyAnchor : MonoBehaviour
    {
        [SerializeField] private LookAt m_LookAt;

        [SerializeField] private TextMeshPro m_Title;

        #region Public

        public string Title
        {
            set
            {
                m_Title.text = value;
            }
        }

        #endregion
    }

}
