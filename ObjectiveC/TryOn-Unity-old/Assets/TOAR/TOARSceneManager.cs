using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace TOAR.Scene
{
    public class TOARSceneManager : MonoBehaviour
    {
        
        private static TOARSceneManager m_Instance = null;
        
        public static TOARSceneManager Instance
        {
            get
            {
                return m_Instance;
            }
        }

        private void Awake()
        {
            if (m_Instance == null)
            {
                m_Instance = this;
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
            UnityEngine.SceneManagement.SceneManager.activeSceneChanged += (arg0, scene) =>
            {
                Debug.Log("### Loaded scene name:" + SceneManager.GetActiveScene().name);
            };
        }

        public void LoadScene(string sceneName)
        {
            Debug.Log("### Load scene name:" + sceneName);
            UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(sceneName);
        }
        
        public void SwitchColor(string code)
        {
            var index = int.Parse(code);
            Debug.Log("### Load scene name:" + index);
            SwitchColor color = GameObject.FindObjectOfType<SwitchColor>();

            if (color != null)
            {
                color.ChangeColor(index);
            }
        }
    }
}

