using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;

namespace XRCasino.AR
{
    public class ARTapToPlace : MonoBehaviour
    {
        [SerializeField]
        private bool m_IsActive = false;
        [SerializeField]
        private TrackableType m_TrackableType = TrackableType.Planes;
        [SerializeField]
        private GameObject m_PlacementIndicator;
        [SerializeField]
        private List<GameObject> m_InstantiateObjectPrefabs;
        [SerializeField]
        private UnityEvent m_ObjectPlacedEvent;
        [SerializeField]
        private int m_ActiveIndex = 0;
        private ARSessionOrigin m_SessionOrigin;
        private ARRaycastManager m_RaycastManager;
        private Pose m_IndicatorPose;
        private bool m_ShowPlacementIndicator = false;
        private GameObject m_Container;
        private TouchPhase m_TouchPhase = TouchPhase.Canceled;

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

        public int ArtsCount
        {
            get
            {
                return m_InstantiateObjectPrefabs.Count;
            }
        }

        public bool IsActive
        {
            get
            {
                return  m_IsActive;
            }
        } 

        public void SetActiveIndex(string index)
        {
            ActiveIndex = int.Parse(index);
            Debug.Log("####Set Active index:" + ActiveIndex.ToString() + " in string:" + index);
        }

        public void StartScanning()
        {
            if (!IsActive)
                StartCoroutine(ActivateCourutine());
        }

        public void StopScanning()
        {
            m_IsActive = false;
        }

        public void SpawnObject()
        {
            PlaceObject();
        }

        public void Reset()
        {
            m_IsActive = false;
            if (m_Container != null)
                DestroyImmediate(m_Container);
            /*
            var containers = FindObjectsOfType<ARContainerCotroller>();
            Debug.Log("##Reset Count:" + containers.Length);

            foreach (var obj in containers)
            {
                Destroy(obj.gameObject);
            }

            m_Container = null;
            */
            StartCoroutine(ActivateCourutine());
        }

        // Start is called before the first frame update
        void Start()
        {
            m_SessionOrigin = FindObjectOfType<ARSessionOrigin>();
            m_RaycastManager = FindObjectOfType<ARRaycastManager>();

            //PlaceObject();
        }

        // Update is called once per frame
        void Update()
        {
            if (IsActive)
            {
                if (m_Container == null && m_RaycastManager != null && m_PlacementIndicator != null)
                {
                    UpdatePlacementPose();
                    UpdatePlacementIndicator();
                   // m_ArResetButton.SetActive(false);
                  //  m_ArScaleButton.SetActive(false);
                    //Debug.Log("### IsActive = true Container is Null");
                }
                else
                {
                    m_PlacementIndicator.SetActive(false);
                   // m_ArResetButton.SetActive(true);
                   // m_ArScaleButton.SetActive(true);
                    //Debug.Log("### IsActive = true Container isn't Null");
                }

#if UNITY_EDITOR

                //Debug.Log("UNITY_EDITOR");
                if (m_Container == null && Input.GetKeyDown(KeyCode.N))
                {
                    Debug.Log("### Space");
                    PlaceObject();
                }
                else
                {
                    //Debug.Log("UNITY_EDITOR 0");
                }

#else
            if (m_Container == null && m_ShowPlacementIndicator && Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Began)
            {
                m_TouchPhase = TouchPhase.Began;
            }
            else if (m_Container == null && m_ShowPlacementIndicator && Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Ended && m_TouchPhase == TouchPhase.Began)
            {
                Debug.Log("### Touch");
                PlaceObject();
            }

#endif

            }
            else
            {
                m_PlacementIndicator.SetActive(false);
            }
        }

        private IEnumerator ActivateCourutine()
        {
            yield return new WaitForSeconds(2.0f);
            m_IsActive = true;
        }

        private void PlaceObject()
        {
            var position = m_IndicatorPose.position;
            position.y -= 0.05f;
            m_Container = Instantiate(m_InstantiateObjectPrefabs[m_ActiveIndex], position, m_IndicatorPose.rotation);
            m_IsActive = false;
            m_ObjectPlacedEvent?.Invoke();
        }

        private void UpdatePlacementIndicator()
        {
            if (m_ShowPlacementIndicator)
            {
                m_PlacementIndicator.SetActive(true);
                m_PlacementIndicator.transform.SetPositionAndRotation(m_IndicatorPose.position, m_IndicatorPose.rotation);
            }
            else
            {
                m_PlacementIndicator.SetActive(false);
            }
        }

        private void UpdatePlacementPose()
        {
            //Debug.Log("##UpdatePlacementPose");
            var screenCenter = Camera.main.ViewportToScreenPoint(new Vector3(0.5f, 0.5f));
            var hits = new List<ARRaycastHit>();
            m_RaycastManager.Raycast(screenCenter, hits, m_TrackableType);
            m_ShowPlacementIndicator = hits.Count > 0;
            //Debug.Log("##Hits count:" + hits.Count.ToString() + " is Show Placement Indicator:" + m_ShowPlacementIndicator.ToString());

            if (m_ShowPlacementIndicator)
            {
                m_IndicatorPose = hits[0].pose;
                var cameraForward = Camera.main.transform.forward;
                var cameraBearing = new Vector3(cameraForward.x, 0, cameraForward.z).normalized;
                m_IndicatorPose.rotation = Quaternion.LookRotation(cameraBearing);
                //Debug.Log("Pose:" + m_IndicatorPose.ToString() + " Position:" + m_IndicatorPose.position.ToString() + " Rotation:" + m_IndicatorPose.rotation.eulerAngles.ToString());
            }
        }
    }
}

