using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.SceneManagement;
using System.IO;

namespace TOAR.SceneLoading
{
    public static class LoadingSceneManager
    {
        private const string k_LoadingSceneError = "ERROR: Loading scene name:{0}  stack trace {1}";
        private const string k_LoadingSceneName = "Loading";

        static float s_progress;
        static AsyncOperation m_loadingOperation;
        static string m_TargetSceneName;

        public static void Load(string sceneName, LoadSceneMode mode = LoadSceneMode.Single, bool showPreloader = false)
        {
            LoadSceneAsync(sceneName, mode, showPreloader);
        }

        public static void LoadSceneAsync(string sceneName, LoadSceneMode mode = LoadSceneMode.Single, bool showPreloader = false, bool unload = true, Action<Scene> loadCompleted = null)
        {
            if (showPreloader)
                LoadLoadingSceneAsync(sceneName, mode, loadCompleted);
            else
                LoadTargetSceneAsync(sceneName, mode, unload, loadCompleted);
        }

        static async void LoadLoadingSceneAsync(string sceneName, LoadSceneMode mode = LoadSceneMode.Single, Action<Scene> loadCompleted = null)
        {
            try
            {
                AsyncOperation asyncOpLoading = SceneManager.LoadSceneAsync(k_LoadingSceneName, mode);
                asyncOpLoading.allowSceneActivation = true;

                while (!asyncOpLoading.isDone)
                {
                    await Task.Yield();
                }

                if (mode == LoadSceneMode.Additive)
                {
                    var activeScene = SceneManager.GetActiveScene();
                    var newActiveScene = SceneManager.GetSceneByName(k_LoadingSceneName);
                    SceneManager.SetActiveScene(newActiveScene);
                    AsyncOperation asyncOpUnLoading = SceneManager.UnloadSceneAsync(activeScene.name);

                    while (!asyncOpUnLoading.isDone)
                    {
                        await Task.Yield();
                    }
                }

                LoadTargetSceneAsync(sceneName, mode, true, loadCompleted);
            }
            catch
            {
                var errorMessage = String.Format(k_LoadingSceneError, sceneName, StackTraceUtility.ExtractStackTrace());
                Debug.LogError(errorMessage);
            }
        }

        static async void LoadTargetSceneAsync(string sceneName, LoadSceneMode mode = LoadSceneMode.Single, bool unload = true,  Action<Scene> loadCompleted = null)
        {
            try
            {
                m_loadingOperation = SceneManager.LoadSceneAsync(sceneName, mode);
                m_loadingOperation.allowSceneActivation = true;

                while (!m_loadingOperation.isDone)
                {
                    s_progress = m_loadingOperation.progress;
                    await Task.Yield();
                }

                if (mode == LoadSceneMode.Additive && unload)
                {
                    var activeScene = SceneManager.GetActiveScene();
                    var newActiveScene = SceneManager.GetSceneByName(sceneName);
                    SceneManager.SetActiveScene(newActiveScene);
                    AsyncOperation asyncOpUnLoading = SceneManager.UnloadSceneAsync(activeScene.name);

                    while (!asyncOpUnLoading.isDone)
                    {
                        await Task.Yield();
                    }
                }

                loadCompleted?.Invoke(SceneManager.GetActiveScene());
            }
            catch
            {
                var errorMessage = String.Format(k_LoadingSceneError, sceneName, StackTraceUtility.ExtractStackTrace());
                Debug.LogError(errorMessage);
            }
        }

        public static float Progress => s_progress;
        public static string SceneName => m_TargetSceneName;
    }
}

