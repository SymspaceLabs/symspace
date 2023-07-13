using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using XRCasino.AR;
using UnityEngine.Events;

namespace TOAR.UI
{
    [System.Serializable]
    public struct NativeCommand{
        public string Command;
        public UnityEvent Event;

        public void TrimCommand()
        {
            Command = Command.Trim();
        }

        public void CommandToLower()
        {
            Command = Command.ToLower();
        }
    }
    public class UIArtController : MonoBehaviour
    {
        [SerializeField]
        private List<NativeCommand> m_CommandsList = new List<NativeCommand>();
        [SerializeField]
        private ARTapToPlace m_ArTapToPlace;
        public Button AlertButton;

        private void Awake() 
        {
            if(m_ArTapToPlace != null)
            {
                m_ArTapToPlace.StartScanning();
            }

            for(var i = 0; i < m_CommandsList.Count; i++)
            {
                m_CommandsList[i].TrimCommand();
            }
        }
        // Start is called before the first frame update
        void Start()
        {
            AlertButton.onClick.AddListener(ShowAlert);
        }

        void ShowAlert()=>IOSTryOnBridge.ShowAlert("Hello", "World");

        public void ChangeActiveIndex(string activeIndex)
        {
            var index = int.Parse(activeIndex);

            if(m_ArTapToPlace != null)
            {
                m_ArTapToPlace.ActiveIndex = index;
            }
        }

        public void NextArtAction()
        {
            if(m_ArTapToPlace != null)
            {
                if(m_ArTapToPlace.ActiveIndex >= (m_ArTapToPlace.ArtsCount - 1)) m_ArTapToPlace.ActiveIndex = 0;
                else m_ArTapToPlace.ActiveIndex++;

                m_ArTapToPlace.Reset();
            }
        }

        public void PreviousArtAction()
        {
            if(m_ArTapToPlace != null)
            {
                if(m_ArTapToPlace.ActiveIndex <= 0) m_ArTapToPlace.ActiveIndex = (m_ArTapToPlace.ArtsCount - 1);
                else m_ArTapToPlace.ActiveIndex--;
                m_ArTapToPlace.Reset();
            }
        }

        public void NativeCommand(string message)
        {
            var commadString = message.ToLower().Trim();

            var command = m_CommandsList.Find(c => c.Command == commadString);
            Debug.LogError("@@@@Command:" + command.Command + " message:" + message);
            command.Event?.Invoke();
        }
    }
}
