using System;
using System.Collections.Generic;
using UnityEngine;
using FlurrySDK;

namespace TOAR
{
    public class FlurryManager : MonoBehaviour
    {

#if UNITY_ANDROID
#if DEVELOPMENT_BUILD || UNITY_EDITOR
        private readonly string FLURRY_API_KEY = "4KB38CV4DB2FFHCCM2BS";
#else
        private readonly string FLURRY_API_KEY = "4KB38CV4DB2FFHCCM2BS";
#endif
#elif UNITY_IPHONE
#if DEVELOPMENT_BUILD || UNITY_EDITOR
        private readonly string FLURRY_API_KEY = "4KB38CV4DB2FFHCCM2BS";
#else
        private readonly string FLURRY_API_KEY = "4KB38CV4DB2FFHCCM2BS";
#endif
#else
    private readonly string FLURRY_API_KEY = null;
#endif

        private static FlurryManager _instance = null;

        public static FlurryManager Instance
        {
            get
            {
                return _instance;
            }
        }

        private void Awake()
        {
            if (_instance == null)
            {
                _instance = this;
                DontDestroyOnLoad(this.gameObject);
                Init();
            }
            else
            {
                Destroy(gameObject);
            }
        }

        private void Init()
        {
            // Note: When enabling Messaging, Flurry Android should be initialized by using AndroidManifest.xml.
            // Initialize Flurry once.
            new Flurry.Builder()
                      .WithCrashReporting(true)
                      .WithLogEnabled(true)
                      .WithLogLevel(Flurry.LogLevel.VERBOSE)
                      .WithMessaging(true)
                      .Build(FLURRY_API_KEY);

            // Example to get Flurry versions.
            Debug.Log("AgentVersion: " + Flurry.GetAgentVersion());
            Debug.Log("ReleaseVersion: " + Flurry.GetReleaseVersion());

            // Set user preferences.
            //Flurry.SetAge(36);
            //Flurry.SetGender(Flurry.Gender.Female);
            Flurry.SetReportLocation(true);

            // Set user properties.
            Flurry.UserProperties.Set(Flurry.UserProperties.PROPERTY_REGISTERED_USER, "True");
            /*
            // Set Messaging listener
            Flurry.SetMessagingListener(new ARPFlurryMessagingListener());

            // Log Flurry events.
            Flurry.EventRecordStatus status = Flurry.LogEvent("Unity Event");
            Debug.Log("Log Unity Event status: " + status);

            // Log Flurry timed events with parameters.
            IDictionary<string, string> parameters = new Dictionary<string, string>();
            parameters.Add("Author", "Flurry");
            parameters.Add("Status", "Registered");
            status = Flurry.LogEvent("Unity Event Params Timed", parameters, true);
            Debug.Log("Log Unity Event with parameters timed status: " + status);
            
            Flurry.EndTimedEvent("Unity Event Params Timed");
            */
        }
    }

    public class ARPFlurryMessagingListener : Flurry.IFlurryMessagingListener
    {
        // If you would like to handle the notification yourself, return true to notify Flurry
        // you've handled it, and Flurry will not show the notification.
        public bool OnNotificationReceived(Flurry.FlurryMessage message)
        {
            Debug.Log("Flurry Messaging Notification Received: " + message.Title);
            return false;
        }

        // If you would like to handle the notification yourself, return true to notify Flurry
        // you've handled it, and Flurry will not launch the app or "click_action" activity.
        public bool OnNotificationClicked(Flurry.FlurryMessage message)
        {
            Debug.Log("Flurry Messaging Notification Clicked: " + message.Title);
            return false;
        }

        public void OnNotificationCancelled(Flurry.FlurryMessage message)
        {
            Debug.Log("Flurry Messaging Notification Cancelled: " + message.Title);
        }

        public void OnTokenRefresh(string token)
        {
            Debug.Log("Flurry Messaging Token Refresh: " + token);
        }

        public void OnNonFlurryNotificationReceived(IDisposable nonFlurryMessage)
        {
            Debug.Log("Flurry Messaging Non-Flurry Notification.");
        }
    }
}

