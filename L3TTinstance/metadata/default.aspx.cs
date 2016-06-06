//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: L3TTinstance\metadata\default.aspx.cs
//Version: 20160606

using Metadata.CXML;
using Trafilm.Metadata;
using Trafilm.Metadata.Models;

using System;
using System.Globalization;
using System.IO;

namespace Trafilm.Gallery
{
  public partial class L3TTinstanceMetadataPage : BaseMetadataPage
  {

    #region --- Initialization ---

    protected void Page_Load(object sender, EventArgs e)
    {
      filmStorage = new CXMLFragmentStorage<IFilm, Film>(Path.Combine(Request.PhysicalApplicationPath, @"film\films.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"film\metadata"), "*.cxml");
      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"conversation\conversations.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"conversation\metadata"), listFilms.SelectedValue + ".*.cxml");
      l3STinstanceStorage = new CXMLFragmentStorage<IL3STinstance, L3STinstance>(Path.Combine(Request.PhysicalApplicationPath, @"L3STinstance\L3STinstances.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3STinstance\metadata"), listL3STinstances.SelectedValue + ".*.cxml");
      l3TTinstanceStorage = new CXMLFragmentStorage<IL3TTinstance, L3TTinstance>(Path.Combine(Request.PhysicalApplicationPath, @"L3TTinstance\L3TTinstances.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3TTinstance\metadata"), listConversations.SelectedValue + ".*.cxml");

      if (!IsPostBack)
      {
        UpdateFilmsList(listFilms, "film", !IsPostBack);
        listFilms_SelectedIndexChanged(listFilms, null);

        UpdateConversationsList(listConversations, "conversation", !IsPostBack);
        listConversations_SelectedIndexChanged(listConversations, null);

        UpdateL3STinstancesList(listL3STinstances, "L3STinstance", !IsPostBack);
        listL3STinstances_SelectedIndexChanged(listL3STinstances, null);

        UpdateL3TTinstancesList(listL3TTinstances, "L3TTinstance", !IsPostBack);
        listL3TTinstances_SelectedIndexChanged(listL3TTinstances, null);
      }

      panelMetadata.Enabled = IsUserAllowedToSave("L3TTinstance");
    }

    #endregion

    #region --- Methods ---

    public void AddL3TTinstance()
    {
      string filmId = listFilms.SelectedValue;
      string conversationId = listConversations.SelectedValue;
      string l3STinstanceId = listL3STinstances.SelectedValue;
      string l3TTinstanceId = l3STinstanceId + "." + txtL3TTinstance.Text; //that l3STinstanceId already contains the filmId and conversationId in it
      txtL3TTinstance.Text = "";

      CreateL3TTinstance(filmId, conversationId, l3STinstanceId, l3TTinstanceId, ((listL3TTinstances.SelectedIndex > 0) && cbClone.Checked) ? GetMetadataFromUI() : null);
      SelectL3TTinstance(l3TTinstanceId);
    }

    public void SelectConversation(string conversationId)
    {
      UpdateConversationsList(listConversations, conversationId); //update list since it may not be up-to-date
      listConversations_SelectedIndexChanged(listConversations, null);
    }

    public void SelectL3STinstance(string l3STinstanceId)
    {
      UpdateL3STinstancesList(listL3STinstances, l3STinstanceId); //update list since it may not be up-to-date
      listL3STinstances_SelectedIndexChanged(listL3STinstances, null);
    }

    public void SelectL3TTinstance(string L3TTinstanceId)
    {
      UpdateL3TTinstancesList(listL3TTinstances, L3TTinstanceId); //update list since it may not be up-to-date
      listL3TTinstances_SelectedIndexChanged(listL3TTinstances, null);
    }

    #region Linked Data

    public void LinkData(IL3TTinstance metadata)
    {
      string key = metadata.L3STinstanceReferenceId;
      metadata.L3STinstance = l3STinstanceStorage[key]; //this updates calculated properties
    }

    #endregion

    #region Load

    public void DisplayMetadata(string L3TTinstanceId)
    {
      IL3TTinstance metadata = l3TTinstanceStorage[L3TTinstanceId];
      LinkData(metadata);
      DisplayMetadata(metadata);
    }

    public void DisplayMetadata(IL3TTinstance metadata)
    {
      string key = metadata.ReferenceId;

      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, metadata.Title);
      //Not showing any Image field
      UI.Load(linkUrl, GetL3TTinstanceUri(key));
      UI.Load(txtDescription, metadata.Description);

      //ITrafilmMetadata//

      //No need to show L3TTinstance.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list
      UI.Load(lblInfoCreated, metadata.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, metadata.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));

      UI.Load(txtTranscription, metadata.Transcription);

      UI.Load(txtKeywords, metadata.Keywords);

      UI.Load(txtRemarks, metadata.Remarks);

      //IL3TTinstance//

      UI.Load(listFilms, metadata.FilmReferenceId);
      UI.Load(listConversations, metadata.ConversationReferenceId);
      UI.Load(listL3STinstances, metadata.L3STinstanceReferenceId);

      UI.Load(listL2language, metadata.L2language);
      UI.Load(listL2mode, metadata.L2mode);

      UI.Load(listL2sameAsL3ST, metadata.L2sameAsL3ST);
      UI.Load(listL3STconveyedAsL3TT, metadata.L3STconveyedAsL3TT);

      UI.Load(listL3TTlanguageType, metadata.L3TTlanguageType);
      UI.Load(txtL3TTlanguage, metadata.L3TTlanguage);

      UI.Load(clistL3TTconstructedBasedOn, metadata.L3TTconstructedBasedOn);

      UI.Load(listL3TTaudienceUnderstanding, metadata.L3TTaudienceUnderstanding);
      UI.Load(listL3TTmessageUnderstanding, metadata.L3TTmessageUnderstanding);
      UI.Load(listL3TTmeaningDecipherable, metadata.L3TTmeaningDecipherable);

      UI.Load(listL3TTspeakerPerformance, metadata.L3TTspeakerPerformance);

      UI.Load(clistL3TTmode, metadata.L3TTmode);

      UI.Load(clistL3TTrepresented, metadata.L3TTrepresented);
      UI.Load(clistL3TTrepresentationsOral, metadata.L3TTrepresentationsOral);
      UI.Load(clistL3TTrepresentationsVisual, metadata.L3TTrepresentationsVisual);

      UI.Load(clistL3TTfunctions, metadata.L3TTfunctions);

      //Calculated properties//

      UI.LoadContent(listL3STlanguageTypeChange, metadata.L3STlanguageTypeChange);
      UI.LoadContent(listL3STmodeChange, metadata.L3STmodeChange);
      UI.LoadContent(listL3STfunctionsChange, metadata.L3STfunctionsChange);
    }

    #endregion

    #region Save

    public IL3TTinstance GetMetadataFromUI()
    {
      IL3TTinstance metadata = new L3TTinstance();
      string key = listL3TTinstances.SelectedValue;

      //ICXMLMetadata//

      metadata.Title = txtTitle.Text;
      metadata.Image = "../L3TTinstance/image/" + key + ".png";
      metadata.Url = GetL3TTinstanceUri(key);
      metadata.Description = txtDescription.Text;

      //ITrafilmMetadata//

      metadata.ReferenceId = key;
      metadata.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      metadata.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);

      metadata.Transcription = txtTranscription.Text;

      metadata.Keywords = UI.GetCommaSeparated(txtKeywords);

      metadata.Remarks = txtRemarks.Text;

      //IL3TTinstanceMetadata//

      metadata.FilmReferenceId = listFilms.SelectedValue;
      metadata.ConversationReferenceId = listConversations.SelectedValue;
      metadata.L3STinstanceReferenceId = listL3STinstances.SelectedValue;

      metadata.L2language = listL2language.SelectedValue;
      metadata.L2mode = listL2mode.SelectedValue;

      metadata.L2sameAsL3ST = listL2sameAsL3ST.SelectedValue;
      metadata.L3STconveyedAsL3TT = listL3STconveyedAsL3TT.SelectedValue;

      metadata.L3TTlanguageType = listL3TTlanguageType.SelectedValue;
      metadata.L3TTlanguage = txtL3TTlanguage.Text;

      metadata.L3TTconstructedBasedOn = UI.GetSelected(clistL3TTconstructedBasedOn);

      metadata.L3TTaudienceUnderstanding = listL3TTaudienceUnderstanding.SelectedValue;
      metadata.L3TTmessageUnderstanding = listL3TTmessageUnderstanding.SelectedValue;
      metadata.L3TTmeaningDecipherable = listL3TTmeaningDecipherable.SelectedValue;

      metadata.L3TTspeakerPerformance = listL3TTspeakerPerformance.SelectedValue;

      metadata.L3TTmode = UI.GetSelected(clistL3TTmode);

      metadata.L3TTrepresented = UI.GetSelected(clistL3TTrepresented);
      metadata.L3TTrepresentationsOral = UI.GetSelected(clistL3TTrepresentationsOral);
      metadata.L3TTrepresentationsVisual = UI.GetSelected(clistL3TTrepresentationsVisual);

      metadata.L3TTfunctions = UI.GetSelected(clistL3TTfunctions);

      //Calculated properties//

      LinkData(metadata);

      return metadata;
    }

    public void Save()
    {
      lblInfoUpdated.Text = DateTime.UtcNow.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      l3TTinstanceStorage[listL3TTinstances.SelectedValue] = (IL3TTinstance)GetMetadataFromUI();
    }

    public void SaveCollection()
    {
      SaveCollection(Path.Combine(Request.PhysicalApplicationPath, "L3TTinstance/L3TTinstances.cxml"), "Trafilm Gallery L3TTinstances", L3TTinstanceMetadataFacets.GetCXMLFacetCategories(), l3TTinstanceStorage.Values);
    }

    #endregion

    #endregion

    #region --- Events ---

    protected void listFilms_SelectedIndexChanged(object sender, EventArgs e)
    {
      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"conversation\conversations.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"conversation\metadata"), listFilms.SelectedValue + ".*.cxml");

      bool visible = (listFilms.SelectedIndex > 0);
      panelConversationId.Visible = visible;
      SelectConversation(null);
    }

    protected void listConversations_SelectedIndexChanged(object sender, EventArgs e)
    {
      l3STinstanceStorage = new CXMLFragmentStorage<IL3STinstance, L3STinstance>(Path.Combine(Request.PhysicalApplicationPath, @"L3STinstance\L3STinstances.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3STinstance\metadata"), listConversations.SelectedValue + ".*.cxml");

      bool visible = (listConversations.SelectedIndex > 0);
      panelL3STinstanceId.Visible = visible;
      SelectL3STinstance(null);
    }

    protected void listL3STinstances_SelectedIndexChanged(object sender, EventArgs e)
    {
      l3TTinstanceStorage = new CXMLFragmentStorage<IL3TTinstance, L3TTinstance>(Path.Combine(Request.PhysicalApplicationPath, @"L3TTinstance\L3TTinstances.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3TTinstance\metadata"), listL3STinstances.SelectedValue + ".*.cxml");

      bool visible = (listL3STinstances.SelectedIndex > 0);
      panelL3TTinstanceId.Visible = visible;
      SelectL3TTinstance(null); //this will also hide panelMetadata
    }

    protected void listL3TTinstances_SelectedIndexChanged(object sender, EventArgs e)
    {
      bool visible = (listL3TTinstances.SelectedIndex > 0);
      panelMetadata.Visible = visible;
      cbClone.Visible = visible;
      if (visible)
        DisplayMetadata(listL3TTinstances.SelectedValue);
    }

    protected void btnAddL3TTinstance_Click(object sender, EventArgs e)
    {
      AddL3TTinstance();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      if (!IsUserAllowedToSave("L3TTinstance")) return;

      Save();
      SaveCollection();
      DisplayMetadata(listL3TTinstances.SelectedValue); //Reload saved data on the UI to confirm what was saved. This is also important to update any calculated fields that make use of the edited object's metadata values
    }

    #endregion

  }

}