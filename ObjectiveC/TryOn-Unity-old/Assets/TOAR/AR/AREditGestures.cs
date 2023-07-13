using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace XRCasino.AR
{
    public class AREditGestures : MonoBehaviour
    {
        public delegate void TurnGestureAction(float turnAngleDelta);
        public TurnGestureAction turnGesture;
        public delegate void PinchGestureAction(float pinchDistanceDelta);
        public PinchGestureAction pinchGesture;
        public delegate void RaycastGroundPlane();
        public RaycastGroundPlane raycastGround;

        [SerializeField]
        private float _pinchTurnRatio = Mathf.PI / 2;
        [SerializeField]
        private float minTurnAngle = 3;
        [SerializeField]
        private float _pinchRatio = 1;
        [SerializeField]
        private float _minPinchDistance = 3;
        [SerializeField]
        private float _maxScale = 15;
        [SerializeField]
        private float _minScale = 0.5f;

        [SerializeField]
        private float _panRatio = 1;
        [SerializeField]
        float _minPanDistance = 0;
        [SerializeField]
        public float _speed = 30.0f;

        [SerializeField]
        private Transform _targetTransform;
        [SerializeField]
        private Transform m_BoundingBox;


        private float _turnAngleDelta;
        private float _turnAngle;
        private float _pinchDistanceDelta;
        private float _pinchDistance;

        public void RealScale()
        {
            _targetTransform.transform.localScale = new Vector3(_maxScale, _maxScale, _maxScale);
        }

        public void DefaultScale()
        {
            _targetTransform.transform.localScale = new Vector3(1, 1, 1);
        }

        public void Calculate()
        {
            _pinchDistance = _pinchDistanceDelta = 0;
            _turnAngle = _turnAngleDelta = 0;

            if (Input.touchCount == 1)
            {
                Touch touch1 = Input.touches[0];

                if (touch1.phase == TouchPhase.Moved)
                {
                    transform.Rotate(0, _speed * Time.deltaTime * -Input.GetTouch(0).deltaPosition.x, 0, Space.Self);
                    turnGesture(-touch1.deltaPosition.x);
                }
            }
            // if two fingers are touching the screen at the same time ...
            if (Input.touchCount == 2)
            {
                Touch touch1 = Input.touches[0];
                Touch touch2 = Input.touches[1];

                // ... if at least one of them moved ...
                if (touch1.phase == TouchPhase.Moved || touch2.phase == TouchPhase.Moved)
                {
                    // ... check the delta distance between them ...
                    _pinchDistance = Vector2.Distance(touch1.position, touch2.position);
                    float prevDistance = Vector2.Distance(touch1.position - touch1.deltaPosition,
                                                          touch2.position - touch2.deltaPosition);
                    _pinchDistanceDelta = _pinchDistance - prevDistance;

                    // ... if it's greater than a minimum threshold, it's a pinch!
                    if (Mathf.Abs(_pinchDistanceDelta) > _minPinchDistance)
                    {
                        _pinchDistanceDelta *= _pinchRatio;
                        Debug.Log("SKTRX Pinch gesture " + _pinchDistanceDelta);

                        Vector3 scale = _targetTransform.transform.localScale;
                        scale.x += _pinchDistanceDelta / 200.0f * scale.x;
                        scale.y += _pinchDistanceDelta / 200.0f * scale.y;
                        scale.z += _pinchDistanceDelta / 200.0f * scale.z;

                        if (scale.x > _maxScale)
                        {
                            scale.x = _maxScale;
                            scale.y = _maxScale;
                            scale.z = _maxScale;
                        }
                        else if (scale.x < _minScale)
                        {
                            scale.x = _minScale;
                            scale.y = _minScale;
                            scale.z = _minScale;
                        }

                        _targetTransform.transform.localScale = scale;

                        if (pinchGesture != null)
                        {
                            pinchGesture(_pinchDistanceDelta);
                        }
                    }
                    else
                    {
                        _pinchDistance = _pinchDistanceDelta = 0;
                    }
                    /*
                    // ... or check the delta angle between them ...
                    _turnAngle = Angle(touch1.position, touch2.position);
                    float prevTurn = Angle(touch1.position - touch1.deltaPosition,
                                           touch2.position - touch2.deltaPosition);
                    _turnAngleDelta = Mathf.DeltaAngle(prevTurn, _turnAngle);

                    // ... if it's greater than a minimum threshold, it's a turn!
                    if (Mathf.Abs(_turnAngleDelta) > minTurnAngle)
                    {
                        _turnAngleDelta *= _pinchTurnRatio;
                        Debug.Log("SKTRX Turn gesture " + _turnAngleDelta);
                        Vector3 eulerAngle = _targetTransform.transform.eulerAngles;
                        eulerAngle.y -= _turnAngleDelta * 3.0f;
                        _targetTransform.transform.eulerAngles = eulerAngle;

                        if (turnGesture != null)
                        {
                            turnGesture(_turnAngleDelta);
                        }
                    }
                    else
                    {
                        _turnAngle = _turnAngleDelta = 0;
                    }
                    */
                }
            }
        }

        private float Angle(Vector2 pos1, Vector2 pos2)
        {
            Vector2 from = pos2 - pos1;
            Vector2 to = new Vector2(1, 0);

            float result = Vector2.Angle(from, to);
            Vector3 cross = Vector3.Cross(from, to);

            if (cross.z > 0)
            {
                result = 360f - result;
            }

            return result;
        }

        private void Update()
        {
            if (_targetTransform != null)
                Calculate();
        }

        private void OnEnable()
        {
            m_BoundingBox.gameObject.SetActive(true);
        }

        private void OnDisable()
        {
            m_BoundingBox.gameObject.SetActive(false);
        }
    }
}

