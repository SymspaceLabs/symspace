using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

namespace TOAR.Controlls
{
    [CreateAssetMenu(fileName = "TouchInputData", menuName = "ScriptableObjects/Input/TouchInputData", order = 1)]
    public class TouchInputData : ScriptableObject
    {
        public delegate void LeftSwipe();
        public delegate void RightSwipe();
        public delegate void UpSwipe();
        public delegate void DownSwipe();

        public LeftSwipe leftSwipe;
        public RightSwipe rightSwipe;
        public UpSwipe upSwipe;
        public DownSwipe downSwipe;
        
        [SerializeField]
        private int _touchCount = 1;
        [SerializeField]
        private float _swipeDistance = 400.0f;
        [SerializeField]
        private float _interval = 1.0f;

        private Vector2 _startPosition;
        private Vector2 _touchDirection;
        private float _distanceX;
        private float _distanceY;

        private DateTime _startTouchTime;

        public float Interval
        {
            set
            {
                _interval = value;
            }

            get
            {
                return _interval;
            }
        }

        public int TouchCount
        {
            set
            {
                _touchCount = value;
            }

            get
            {
                return _touchCount;
            }
        }

        public float SwipeDistance
        {
            get
            {
                return _swipeDistance;
            }

            set
            {
                _swipeDistance = value;
            }
        }

        public void Update()
        {
            if (Input.touchCount == _touchCount)
            {
                var touch = Input.GetTouch(0);

                if (touch.phase == TouchPhase.Began)
                {
                    _startPosition = touch.position;
                    _startTouchTime = DateTime.Now;
                }
                else if (touch.phase == TouchPhase.Moved || touch.phase == TouchPhase.Stationary)
                {
                    // get the moved direction compared to the initial touch position
                    var direction = touch.position - _startPosition;
                    // get the signed x direction
                    // if(direction.x >= 0) 1 else -1
                    _touchDirection.x = (int)Mathf.Sign(direction.x);
                    _touchDirection.y = (int)Mathf.Sign(direction.y);
                }
                else if(touch.phase == TouchPhase.Ended)
                {
                    var endTime = DateTime.Now;
                    var seconds = (endTime - _startTouchTime).TotalSeconds;
                    _distanceX = Mathf.Abs(_startPosition.x - touch.position.x);
                    _distanceY = Mathf.Abs(_startPosition.y - touch.position.y);

                    if(_distanceX > _distanceY && _distanceY <= _distanceX * 0.5f && seconds <= _interval)
                    {
                        if (_touchDirection.x < 0)
                        {
                            Debug.Log("Left swipe!!! distance:" + _distanceX);

                            if (_distanceX >= _swipeDistance)
                                leftSwipe?.Invoke();
                        }
                        else if (_touchDirection.x > 0)
                        {
                            Debug.Log("Right swipe!!! distance:" + _distanceX);

                            if (_distanceX >= _swipeDistance)
                                rightSwipe?.Invoke();
                        }
                    }
                    else
                    {
                        if (_touchDirection.y < 0)
                        {
                            Debug.Log("Down swipe!!! distance:" + _distanceY);

                            if (_distanceY >= _swipeDistance)
                                downSwipe?.Invoke();

                        }
                        else if (_touchDirection.y > 0)
                        {
                            Debug.Log("Up swipe!!! distance:" + _distanceY);

                            if (_distanceY >= _swipeDistance)
                                upSwipe?.Invoke();
                        }
                    }
                }
            }
        }
    }

}
