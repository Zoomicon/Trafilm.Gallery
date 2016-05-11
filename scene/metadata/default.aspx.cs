//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: scene\metadata\default.aspx.cs
//Version: 20160511

using Metadata.CXML;
using Trafilm.Metadata.Models;
using Trafilm.Metadata;

using System;
using System.IO;
using System.Globalization;

namespace Trafilm.Gallery
{
  public partial class SceneMetadataPage : BaseMetadataPage
  {

    #region --- Initialization ---

    protected void Page_Load(object sender, EventArgs e)
    {
      filmStorage = new CXMLFragmentStorage<IFilm, Film>(Path.Combine(Request.PhysicalApplicationPath, "film/films.cxml"), Path.Combine(Request.PhysicalApplicationPath, "film/metadata"), "*.cxml");
      sceneStorage = new CXMLFragmentStorage<IScene, Scene>(Path.Combine(Request.PhysicalApplicationPath, "scene/scenes.cxml"), Path.Combine(Request.PhysicalApplicationPath, "scene/metadata"), listFilms.SelectedValue + ".*.cxml");

      if (!IsPostBack)
      {
        UpdateFilmsList(listFilms);
        UpdateScenesList(listScenes);
      }

      utteranceStorage = new CXMLFragmentStorage<IUtterance, Utterance>(Path.Combine(Request.PhysicalApplicationPath, "utterance/utterances.cxml"), Path.Combine(Request.PhysicalApplicationPath, "utterance/metadata"), listFilms.SelectedValue + ".*.cxml");
    }

    #endregion

    #region --- Methods ---

    public void AddScene()
    {
      string filmId = listFilms.SelectedValue;
      string sceneId = filmId + "." + txtScene.Text;

      if (sceneStorage.Keys.Contains(sceneId))
        listScenes.SelectedValue = sceneId;
      else
      {
        IScene scene = new Scene();
        scene.Clear();
        scene.Title = sceneId;
        scene.FilmReferenceId = filmId;
        scene.ReferenceId = sceneId;

        sceneStorage[sceneId] = scene;
      }
    }

    #region Load

    public void DisplayMetadata(string key)
    {
       DisplayMetadata(sceneStorage[key]);
    }

    public void DisplayMetadata(IScene scene)
    {
      string key = scene.ReferenceId;

      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, scene.Title);
      //Not showing any Image field
      UI.Load(linkUrl, new Uri("http://trafilm.net/gallery/?scene=" + key));
      UI.Load(txtDescription, scene.Description);

      //ITrafilmMetadata//

      //No need to show scene.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list
      UI.Load(lblInfoCreated, scene.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, scene.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(txtKeywords, scene.Keywords);

      //IScene//

      UI.Load(listFilms, scene.FilmReferenceId);

      UI.Load(txtStartTime, scene.StartTime.ToString(@"HH\:MM\:SS\.FF")); //TODO: get from SceneFacets?
      UI.Load(txtDuration, scene.Duration.ToString(@"MM\:SS\.FF")); //TODO: get from Trafilm.Metadata

      UI.Load(cbL1sourceLanguagePresent, scene.L1sourceLanguagePresent);
      UI.Load(cbL2translatedLanguagePresent, scene.L2translatedLanguagePresent);

      UI.Load(listSpeakingCharactersCount, scene.SpeakingCharactersCount);
      UI.Load(listL3speakingCharactersCount, scene.L3speakingCharactersCount);

      //Calculatable from Utterances//

      UI.Load(lblL3otherLanguagesCount, CalculateL3otherLanguagesCount(key).ToString());
      UI.Load(clistL3otherLanguages, CalculateL3otherLanguages(key));

      UI.Load(lblL3otherTypesCount, CalculateL3otherTypesCount(key).ToString());
      UI.Load(clistL3otherTypes, CalculateL3otherTypes(key));

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

      scene.StartTime = TimeSpan.ParseExact(txtStartTime.Text, @"HH\:MM\:SS\.FF", CultureInfo.InvariantCulture); //TODO: get from Trafilm.Metadata
      scene.Duration = TimeSpan.ParseExact(txtDuration.Text, @"MM\:SS\.FF", CultureInfo.InvariantCulture); //TODO: get from Trafilm.Metadata

      scene.L1sourceLanguagePresent = cbL1sourceLanguagePresent.Checked;
      scene.L2translatedLanguagePresent = cbL2translatedLanguagePresent.Checked;

      scene.SpeakingCharactersCount = listSpeakingCharactersCount.SelectedValue; //e.g. 1, 2, 3, more than 3
      scene.L3speakingCharactersCount = listL3speakingCharactersCount.SelectedValue; //e.g. 1, 2, 3, more than 3

      //Calculatable from Utterances//

      scene.L3otherLanguagesCount = CalculateL3otherLanguagesCount(key);
      scene.L3otherLanguages = CalculateL3otherLanguages(key);

      scene.L3otherTypesCount = CalculateL3otherTypesCount(key);
      scene.L3otherTypes = CalculateL3otherTypes(key);

      scene.UtteranceCount = CalculateUtteranceCount(key);

      return scene;
    }

    public void Save()
    {
      lblInfoUpdated.Text = DateTime.Now.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      sceneStorage[listScenes.SelectedValue] = (IScene)GetMetadataFromUI();
    }

    public void Report()
    {
      Report(Path.Combine(Request.PhysicalApplicationPath, "scene/scenes.cxml"), "Trafilm Gallery Scenes", Scene.MakeSceneFacetCategories(), sceneStorage.Values);
    }

    #endregion

    #region Calculated from Utterances

    private int CalculateL3otherLanguagesCount(string key) //TODO
    {
      throw new NotImplementedException();
    }

    private string[] CalculateL3otherLanguages(string key) //TODO
    {
      throw new NotImplementedException();
    }

    private int CalculateL3otherTypesCount(string key) //TODO
    {
      throw new NotImplementedException();
    }

    private string[] CalculateL3otherTypes(string key) //TODO
    {
      throw new NotImplementedException();
    }

    private int CalculateUtteranceCount(string key) //TODO
    {
      throw new NotImplementedException();
    }

    #endregion

    #endregion

    #region --- Events ---

    protected void listFilms_SelectedIndexChanged(object sender, EventArgs e)
    {
      bool visible = (listFilms.SelectedIndex > 0);
      panelSceneId.Visible = visible;
      if (visible)
        UpdateScenesList(listScenes);
    }

    protected void listScenes_SelectedIndexChanged(object sender, EventArgs e)
    {
      DisplayMetadata(listScenes.SelectedValue);
    }

    protected void btnAddScene_Click(object sender, EventArgs e)
    {
      AddScene();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      Save();
    }

    #endregion

  }
}