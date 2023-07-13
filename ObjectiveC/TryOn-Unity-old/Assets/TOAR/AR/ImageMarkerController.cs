using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace TOAR.AR
{
    [System.Serializable]
    public struct MarkerGameObject
    {
        public string name;
        public Transform objectTransform;
    }

    public class ImageMarkerController : MonoBehaviour
    {
        [SerializeField]
        private List<MarkerGameObject> _markers;


        public void HideAll()
        {
            foreach(var marker in _markers)
            {
                marker.objectTransform.gameObject.SetActive(false);
            }
        }

        public void Show(string name)
        {
            foreach (var marker in _markers)
            {
                if(marker.name == name)
                {
                    marker.objectTransform.gameObject.SetActive(true);
                }
                else
                {
                    marker.objectTransform.gameObject.SetActive(false);
                }
            }
        }

        // Start is called before the first frame update
        void Start()
        {
            HideAll();
        }
    }

}
