//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: utterance\metadata\default.aspx.cs
//Version: 20160512

using Trafilm.Metadata;
using Trafilm.Metadata.Models;
using Metadata.CXML;

using System;
using System.IO;
using System.Globalization;

namespace Trafilm.Gallery
{
  public partial class UtteranceMetadataPage : BaseMetadataPage
  {

    #region --- Initialization ---

    protected void Page_Load(object sender, EventArgs e)
    {
      filmStorage = new CXMLFragmentStorage<IFilm, Film>(Path.Combine(Request.PhysicalApplicationPath, "film/films.cxml"), Path.Combine(Request.PhysicalApplicationPath, "film/metadata"), "*.cxml");
      sceneStorage = new CXMLFragmentStorage<IScene, Scene>(Path.Combine(Request.PhysicalApplicationPath, "scene/scenes.cxml"), Path.Combine(Request.PhysicalApplicationPath, "scene/metadata"), listFilms.SelectedValue + ".*.cxml");
      utteranceStorage = new CXMLFragmentStorage<IUtterance, Utterance>(Path.Combine(Request.PhysicalApplicationPath, "utterance/utterances.cxml"), Path.Combine(Request.PhysicalApplicationPath, "utterance/metadata"), listScenes.SelectedValue + ".*.cxml");

      if (!IsPostBack)
      {
        UpdateFilmsList(listFilms);
        UpdateScenesList(listScenes);
        UpdateUtterancesList(listUtterances);
      }
    }

    #endregion

    #region --- Methods ---

    public void AddUtterance()
    {
      string filmId = listFilms.SelectedValue;
      string sceneId = listScenes.SelectedValue;
      string utteranceId = sceneId + "." + txtUtterance.Text; //that sceneId already contains the filmId in it

      if (utteranceStorage.Keys.Contains(utteranceId))
        listUtterances.SelectedValue = utteranceId;
      else
      {
        IUtterance utterance = new Utterance();
        utterance.Clear();
        utterance.Title = utteranceId;
        utterance.FilmReferenceId = filmId;
        utterance.SceneReferenceId = sceneId;
        utterance.ReferenceId = utteranceId;

        utteranceStorage[utteranceId] = utterance;
      }
    }

    #region Load

    public void DisplayMetadata(string key)
    {
      DisplayMetadata(utteranceStorage[key]);
    }

    public void DisplayMetadata(IUtterance utterance)
    {
      string key = utterance.ReferenceId;

      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, utterance.Title);
      //Not showing any Image field
      UI.Load(linkUrl, new Uri("http://trafilm.net/gallery/?utterance=" + key));
      UI.Load(txtDescription, utterance.Description);

      //ITrafilmMetadata//

      //No need to show utterance.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list
      UI.Load(lblInfoCreated, utterance.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, utterance.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(txtKeywords, utterance.Keywords);

      //IUtterance//

      UI.Load(listFilms, utterance.FilmReferenceId);
      UI.Load(listScenes, utterance.SceneReferenceId);

      UI.Load(listL3kind, utterance.L3kind);

      UI.Load(listLmainLanguage, utterance.LmainLanguage);
      UI.Load(listLmainMode, utterance.LmainMode);

      UI.Load(cbL2sameAsL3ST, utterance.L2sameAsL3ST);
      UI.Load(cbL3STconveyedAsL3TT, utterance.L3STconveyedAsL3TT);

      UI.Load(listL3languageType, utterance.L3languageType);
      UI.Load(txtL3language, utterance.L3language);

      UI.Load(clistL3constructedBasedOn, utterance.L3constructedBasedOn);

      UI.Load(listL3audienceUnderstanding, utterance.L3audienceUnderstanding);
      UI.Load(listL3messageUnderstanding, utterance.L3messageUnderstanding);
      UI.Load(listL3meaningDeciphered, utterance.L3meaningDeciphered);

      UI.Load(listL3speakerPerformance, utterance.L3speakerPerformance);

      UI.Load(clistL3mode, utterance.L3mode);
      UI.Load(listL3STmodeChange, utterance.L3STmodeChange);

      UI.Load(clistL3represented, utterance.L3represented);
      UI.Load(clistL3representationsOral, utterance.L3representationsOral);
      UI.Load(clistL3representationsVisual, utterance.L3representationsVisual);

      UI.Load(clistL3functions, utterance.L3functions);
    }

    #endregion

    #region Save

    public ICXMLMetadata GetMetadataFromUI()
    {
      IUtterance utterance = new Utterance();
      string key = listFilms.SelectedValue;

      //ICXMLMetadata//

      utterance.Title = txtTitle.Text;
      utterance.Image = ""; //TODO
      utterance.Url = new Uri("http://gallery.trafilm.net/?utterance=" + key); //TODO: could set to jump to movie time
      utterance.Description = txtDescription.Text;

      //ITrafilmMetadata//

      utterance.ReferenceId = key;
      utterance.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      utterance.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      utterance.Keywords = UI.GetCommaSeparated(txtKeywords);

      //IUtterance//

      utterance.SceneReferenceId = listScenes.SelectedValue;

      utterance.FilmReferenceId = listFilms.SelectedValue;
      utterance.SceneReferenceId = listScenes.SelectedValue;

      utterance.L3kind = listL3kind.SelectedValue;

      utterance.LmainLanguage = listLmainLanguage.SelectedValue;
      utterance.LmainMode = listLmainMode.SelectedValue;

      utterance.L2sameAsL3ST = cbL2sameAsL3ST.Checked;
      utterance.L3STconveyedAsL3TT = cbL3STconveyedAsL3TT.Checked;

      utterance.L3languageType = listL3languageType.SelectedValue;
      utterance.L3language = txtL3language.Text;

      utterance.L3constructedBasedOn = UI.GetSelected(clistL3constructedBasedOn);

      utterance.L3audienceUnderstanding = listL3audienceUnderstanding.SelectedValue;
      utterance.L3messageUnderstanding = listL3messageUnderstanding.SelectedValue;
      utterance.L3meaningDeciphered = listL3meaningDeciphered.SelectedValue;

      utterance.L3speakerPerformance = listL3speakerPerformance.SelectedValue;

      utterance.L3mode = UI.GetSelected(clistL3mode);
      utterance.L3STmodeChange = listL3STmodeChange.SelectedValue;

      utterance.L3represented = UI.GetSelected(clistL3represented);
      utterance.L3representationsOral = UI.GetSelected(clistL3representationsOral);
      utterance.L3representationsVisual = UI.GetSelected(clistL3representationsVisual);

      utterance.L3functions = UI.GetSelected(clistL3functions);

      return utterance;
    }

    public void Save()
    {
      utteranceStorage[listUtterances.SelectedValue] = (IUtterance)GetMetadataFromUI();
    }

    public void Report()
    {
      Report(Path.Combine(Request.PhysicalApplicationPath, "utterance/utterances.cxml"), "Trafilm Gallery Utterances", Utterance.MakeUtteranceFacetCategories(), utteranceStorage.Values);
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
      bool visible = (listScenes.SelectedIndex > 0);
      panelUtteranceId.Visible = visible;
      if (visible)
        UpdateUtterancesList(listUtterances);
    }

    protected void listUtterances_SelectedIndexChanged(object sender, EventArgs e)
    {
      bool visible = (listUtterances.SelectedIndex > 0);
      panelMetadata.Visible = visible;
      if (visible)
        DisplayMetadata(listUtterances.SelectedValue);
    }

    protected void btnAddUtterance_Click(object sender, EventArgs e)
    {
      AddUtterance();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      lblInfoUpdated.Text = DateTime.Now.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      Save();
    }

    #endregion

  }

}