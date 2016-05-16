//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: scene\metadata\default.aspx.cs
//Version: 20160516

using Metadata.CXML;
using Trafilm.Metadata;
using Trafilm.Metadata.Models;
using Trafilm.Metadata.Utils;

using System;
using System.Globalization;
using System.IO;
using System.Linq;

namespace Trafilm.Gallery
{
  public partial class SceneMetadataPage : BaseMetadataPage
  {

    #region --- Initialization ---

    protected void Page_Load(object sender, EventArgs e)
    {
      filmStorage = new CXMLFragmentStorage<IFilm, Film>(Path.Combine(Request.PhysicalApplicationPath, @"film\films.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"film\metadata"), "*.cxml");
      sceneStorage = new CXMLFragmentStorage<IScene, Scene>(Path.Combine(Request.PhysicalApplicationPath, @"scene\scenes.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"scene\metadata"), listFilms.SelectedValue + ".*.cxml");
      utteranceStorage = new CXMLFragmentStorage<IUtterance, Utterance>(Path.Combine(Request.PhysicalApplicationPath, @"utterance\utterances.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"utterance\metadata"), listFilms.SelectedValue + ".*.cxml");

      if (!IsPostBack)
      {
        UpdateFilmsList(listFilms, "film", !IsPostBack);
        listFilms_SelectedIndexChanged(listFilms, null);

        UpdateScenesList(listScenes, "scene", !IsPostBack);
        listScenes_SelectedIndexChanged(listScenes, null);
      }
    }

    #endregion

    #region --- Methods ---

    public void AddScene()
    {
      string filmId = listFilms.SelectedValue;
      string sceneId = filmId + "." + txtScene.Text;
      txtScene.Text = "";

      CreateScene(filmId, sceneId);
      SelectScene(sceneId);
    }

    public void SelectScene(string sceneId)
    {
      UpdateScenesList(listScenes, sceneId); //update list since it may not be up-to-date
      listScenes_SelectedIndexChanged(listScenes, null);
    }

    #region Load

    public void DisplayMetadata(string sceneId)
    {
      DisplayMetadata(sceneStorage[sceneId]);
    }

    public void DisplayMetadata(IScene scene)
    {
      string key = scene.ReferenceId;

      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, scene.Title);
      //Not showing any Image field
      UI.Load(linkUrl, new Uri("http://gallery.trafilm.net/?scene=" + key));
      UI.Load(txtDescription, scene.Description);

      //ITrafilmMetadata//

      //No need to show scene.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list
      UI.Load(lblInfoCreated, scene.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, scene.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(txtKeywords, scene.Keywords);

      //IScene//

      UI.Load(listFilms, scene.FilmReferenceId);

      UI.Load(txtStartTime, scene.StartTime.ToString(SceneMetadata.DEFAULT_POSITION_FORMAT));
      UI.Load(txtDuration, scene.Duration.ToString(SceneMetadata.DEFAULT_DURATION_FORMAT));

      UI.Load(cbL1languagePresent, scene.L1languagePresent);
      UI.Load(cbL2languagePresent, scene.L2languagePresent);

      UI.Load(listSpeakingCharactersCount, scene.SpeakingCharactersCount);
      UI.Load(listL3speakingCharactersCount, scene.L3speakingCharactersCount);

      //Calculatable from Utterances//

      UI.Load(lblL3languagesCount, CalculateL3languagesCount(key).ToString());
      clistL3languages.DataSource = CalculateL3languages(key);

      UI.Load(lblL3languageTypesCount, CalculateL3languageTypesCount(key).ToString());
      clistL3languageTypes.DataSource = CalculateL3languageTypes(key);

      UI.Load(lblUtteranceCount, CalculateUtteranceCount(key).ToString());
    }

    #endregion

    #region Save

    public ICXMLMetadata GetMetadataFromUI()
    {
      IScene scene = new Scene();
      string key = listFilms.SelectedValue;

      //ICXMLMetadata//

      scene.Title = txtTitle.Text;
      scene.Image = ""; //TODO
      scene.Url = new Uri("http://gallery.trafilm.net/?scene=" + key); //TODO: could set to jump to movie time
      scene.Description = txtDescription.Text;

      //ITrafilmMetadata//

      scene.ReferenceId = key;
      scene.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      scene.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      scene.Keywords = UI.GetCommaSeparated(txtKeywords);

      //IScene//

      scene.FilmReferenceId = listFilms.SelectedValue;

      scene.StartTime = txtStartTime.Text.ToNullableTimeSpan(SceneMetadata.DEFAULT_POSITION_FORMAT);
      scene.Duration = txtDuration.Text.ToNullableTimeSpan(SceneMetadata.DEFAULT_DURATION_FORMAT);

      scene.L1languagePresent = cbL1languagePresent.Checked;
      scene.L2languagePresent = cbL2languagePresent.Checked;

      scene.SpeakingCharactersCount = listSpeakingCharactersCount.SelectedValue; //e.g. 1, 2, 3, more than 3
      scene.L3speakingCharactersCount = listL3speakingCharactersCount.SelectedValue; //e.g. 1, 2, 3, more than 3

      //Calculatable from Utterances//

      scene.L3languagesCount = CalculateL3languagesCount(key);
      scene.L3languages = CalculateL3languages(key);

      scene.L3languageTypesCount = CalculateL3languageTypesCount(key);
      scene.L3languageTypes = CalculateL3languageTypes(key);

      scene.UtteranceCount = CalculateUtteranceCount(key);

      return scene;
    }

    public void Save()
    {
      lblInfoUpdated.Text = DateTime.UtcNow.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      sceneStorage[listScenes.SelectedValue] = (IScene)GetMetadataFromUI();
    }

    public void SaveCollection()
    {
      SaveCollection(Path.Combine(Request.PhysicalApplicationPath, "scene/scenes.cxml"), "Trafilm Gallery Scenes", Scene.MakeSceneFacetCategories(), sceneStorage.Values);
    }

    #endregion

    #region Calculated from Utterances

    private int CalculateL3languagesCount(string key) //TODO
    {
      return 0;
    }

    private string[] CalculateL3languages(string key) //TODO
    {
      return new string[] { };
    }

    private int CalculateL3languageTypesCount(string key) //TODO
    {
      return 0;
    }

    private string[] CalculateL3languageTypes(string key) //TODO
    {
      return new string[] { };
    }

    private int CalculateUtteranceCount(string key)
    {
      return utteranceStorage.Count;
    }

    #endregion

    #endregion

    #region --- Events ---

    protected void listFilms_SelectedIndexChanged(object sender, EventArgs e)
    {
      sceneStorage = new CXMLFragmentStorage<IScene, Scene>(Path.Combine(Request.PhysicalApplicationPath, @"scene\scenes.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"scene\metadata"), listFilms.SelectedValue + ".*.cxml");

      bool visible = (listFilms.SelectedIndex > 0);
      panelSceneId.Visible = visible;
      if (visible)
        SelectScene(null); //this will also hide panelMetadata
    }

    protected void listScenes_SelectedIndexChanged(object sender, EventArgs e)
    {
      utteranceStorage = new CXMLFragmentStorage<IUtterance, Utterance>(Path.Combine(Request.PhysicalApplicationPath, @"utterance\utterances.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"utterance\metadata"), listFilms.SelectedValue + ".*.cxml");

      bool visible = (listScenes.SelectedIndex > 0);
      panelMetadata.Visible = visible;
      if (visible)
      {
        DisplayMetadata(listScenes.SelectedValue);
        UpdateRepeater(repeaterUtterances, utteranceStorage.Keys.Select(x=> new { filmId=listFilms.SelectedValue, sceneId=listScenes.SelectedValue, utteranceId = x }) );
      }
    }

    protected void btnAddScene_Click(object sender, EventArgs e)
    {
      AddScene();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      Save();
      SaveCollection();
    }

    #endregion

  }
}