//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: utterance\metadata\default.aspx.cs
//Version: 20160516

using Metadata.CXML;
using Trafilm.Metadata;
using Trafilm.Metadata.Models;

using System;
using System.Globalization;
using System.IO;

namespace Trafilm.Gallery
{
  public partial class L3occurenceMetadataPage : BaseMetadataPage
  {

    #region --- Initialization ---

    protected void Page_Load(object sender, EventArgs e)
    {
      filmStorage = new CXMLFragmentStorage<IFilm, Film>(Path.Combine(Request.PhysicalApplicationPath, @"film\films.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"film\metadata"), "*.cxml");
      sceneStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"scene\scenes.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"scene\metadata"), listFilms.SelectedValue + ".*.cxml");
      utteranceStorage = new CXMLFragmentStorage<IL3occurence, L3occurence>(Path.Combine(Request.PhysicalApplicationPath, @"utterance\utterances.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"utterance\metadata"), listFilms.SelectedValue + ".*.cxml");

      UpdateFilmsList(listFilms, (IsPostBack) ? listFilms.SelectedValue : "film", !IsPostBack);
      if (!IsPostBack)
        listFilms_SelectedIndexChanged(listFilms, null);

      if (!IsPostBack)
      {
        UpdateConversationsList(listConversations, "scene", !IsPostBack);
        listConversations_SelectedIndexChanged(listConversations, null);

        UpdateL3occurencesList(listL3occurences, "utterance", !IsPostBack);
        listL3occurences_SelectedIndexChanged(listL3occurences, null);
      }
    }

    #endregion

    #region --- Methods ---

    public void AddL3occurence()
    {
      string filmId = listFilms.SelectedValue;
      string sceneId = listConversations.SelectedValue;
      string utteranceId = sceneId + "." + txtL3occurence.Text; //that sceneId already contains the filmId in it
      txtL3occurence.Text = "";

      CreateL3occurence(filmId, sceneId, utteranceId);
      SelectL3occurence(utteranceId);
    }

    public void SelectConversation(string sceneId)
    {
      UpdateConversationsList(listConversations, sceneId); //update list since it may not be up-to-date
      listConversations_SelectedIndexChanged(listConversations, null);
    }

    public void SelectL3occurence(string utteranceId)
    {
      UpdateL3occurencesList(listL3occurences, utteranceId); //update list since it may not be up-to-date
      listL3occurences_SelectedIndexChanged(listL3occurences, null);
    }

    #region Load

    public void DisplayMetadata(string utteranceId)
    {
      DisplayMetadata(utteranceStorage[utteranceId]);
    }

    public void DisplayMetadata(IL3occurence utterance)
    {
      string key = utterance.ReferenceId;

      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, utterance.Title);
      //Not showing any Image field
      UI.Load(linkUrl, new Uri("http://gallery.trafilm.net/?utterance=" + key));
      UI.Load(txtDescription, utterance.Description);

      //ITrafilmMetadata//

      //No need to show utterance.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list
      UI.Load(lblInfoCreated, utterance.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, utterance.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(txtKeywords, utterance.Keywords);

      //IL3occurence//

      UI.Load(listFilms, utterance.FilmReferenceId);
      UI.Load(listConversations, utterance.ConversationReferenceId);

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
      IL3occurence utterance = new L3occurence();
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

      //IL3occurence//

      utterance.ConversationReferenceId = listConversations.SelectedValue;

      utterance.FilmReferenceId = listFilms.SelectedValue;
      utterance.ConversationReferenceId = listConversations.SelectedValue;

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
      lblInfoUpdated.Text = DateTime.UtcNow.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      utteranceStorage[listL3occurences.SelectedValue] = (IL3occurence)GetMetadataFromUI();
    }

    public void SaveCollection()
    {
      SaveCollection(Path.Combine(Request.PhysicalApplicationPath, "utterance/utterances.cxml"), "Trafilm Gallery L3occurences", L3occurence.MakeL3occurenceFacetCategories(), utteranceStorage.Values);
    }

    #endregion

    #endregion

    #region --- Events ---

    protected void listFilms_SelectedIndexChanged(object sender, EventArgs e)
    {
      sceneStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"scene\scenes.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"scene\metadata"), listFilms.SelectedValue + ".*.cxml");

      bool visible = (listFilms.SelectedIndex > 0);
      panelConversationId.Visible = visible;
      if (visible)
        SelectConversation(null);
    }

    protected void listConversations_SelectedIndexChanged(object sender, EventArgs e)
    {
      utteranceStorage = new CXMLFragmentStorage<IL3occurence, L3occurence>(Path.Combine(Request.PhysicalApplicationPath, @"utterance\utterances.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"utterance\metadata"), listConversations.SelectedValue + ".*.cxml");

      bool visible = (listConversations.SelectedIndex > 0);
      panelL3occurenceId.Visible = visible;
      if (visible)
        SelectL3occurence(null); //this will also hide panelMetadata
    }

    protected void listL3occurences_SelectedIndexChanged(object sender, EventArgs e)
    {
      bool visible = (listL3occurences.SelectedIndex > 0);
      panelMetadata.Visible = visible;
      if (visible)
        DisplayMetadata(listL3occurences.SelectedValue);
    }

    protected void btnAddL3occurence_Click(object sender, EventArgs e)
    {
      AddL3occurence();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      Save();
      SaveCollection();
    }

    #endregion

  }

}