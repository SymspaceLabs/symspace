using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARFoundation.Samples;

namespace TOAR.AR
{
    public class ARSupportManager : MonoBehaviour
    {
        [SerializeField]
        private ARHumanBodyManager _humanBodyManager;
        [SerializeField]
        private HumanBodyTracker _humanBodyTracker;

        private bool _isSupportHumanBodyTracking = true;
        // Start is called before the first frame update
        void Start()
        {
            if (IsSupportHumanBodyTracking != _isSupportHumanBodyTracking)
            {
                _isSupportHumanBodyTracking = IsSupportHumanBodyTracking;
                SetActiveBodyTracking(_isSupportHumanBodyTracking);
            }
        }

        private void LateUpdate()
        {
            if(IsSupportHumanBodyTracking != _isSupportHumanBodyTracking)
            {
                _isSupportHumanBodyTracking = IsSupportHumanBodyTracking;
                SetActiveBodyTracking(_isSupportHumanBodyTracking);
            }
        }

        void SetActiveBodyTracking(bool isActive)
        {
            if (isActive)
            {
                Debug.Log("Body tracking is supported. To determine supported features, please access BodyManagerDescriptor properties.");
                _humanBodyTracker.gameObject.SetActive(true);
                _humanBodyManager.enabled = true;
            }
            else
            {
                Debug.Log("Body tracking is not supported");
                _humanBodyTracker.gameObject.SetActive(false);
                _humanBodyManager.enabled = false;
            }
        }

        bool IsSupportHumanBodyTracking
        {
            get
            {
                return _humanBodyManager.descriptor != null ? true : false;
            }
        }
    }

}
