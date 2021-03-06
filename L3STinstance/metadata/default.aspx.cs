﻿//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: L3STinstance\metadata\default.aspx.cs
//Version: 20171130

using Metadata.CXML;
using Trafilm.Metadata;
using Trafilm.Metadata.Models;

using System;
using System.Globalization;
using System.IO;
using System.Linq;

namespace Trafilm.Gallery
{
  public partial class L3STinstanceMetadataPage : BaseMetadataPage
  {

    #region --- Initialization ---

    protected void Page_Load(object sender, EventArgs e)
    {
      filmStorage = new CXMLFragmentStorage<IFilm, Film>(Server.MapPath("~/film/films.cxml"), Server.MapPath("~/film/metadata"), "*.cxml");
      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Server.MapPath("~/conversation/conversations.cxml"), Server.MapPath("~/conversation/metadata"), listFilms.SelectedValue + ".*.cxml");
      l3STinstanceStorage = new CXMLFragmentStorage<IL3STinstance, L3STinstance>(Server.MapPath("~/L3STinstance/L3STinstances.cxml"), Server.MapPath("~/L3STinstance/metadata"), listConversations.SelectedValue + ".*.cxml");
      l3TTinstanceStorage = new CXMLFragmentStorage<IL3TTinstance, L3TTinstance>(Server.MapPath("~/L3TTinstance/L3TTinstances.cxml"), Server.MapPath("~/L3TTinstance/metadata"), listL3STinstances.SelectedValue + ".*.cxml");

      if (!IsPostBack)
      {
        UpdateFilmsList(listFilms, "film", !IsPostBack);
        listFilms_SelectedIndexChanged(listFilms, null);

        UpdateConversationsList(listConversations, "conversation", !IsPostBack);
        listConversations_SelectedIndexChanged(listConversations, null);

        UpdateL3STinstancesList(listL3STinstances, "L3STinstance", !IsPostBack);
        listL3STinstances_SelectedIndexChanged(listL3STinstances, null);
      }

      bool canSave = IsUserAllowedToSave("L3STinstance");
      panelInstructions.Visible = canSave;
      panelMetadata.Enabled = canSave;
      panelAdd.Visible = canSave;
      panelSave.Visible = canSave; //stays hidden if its parent panelMetadata is not visible (i.e. nothing is selected)

      bool hasSelectedL3STinstance = (listL3STinstances.SelectedIndex > 0);
      btnRename.Visible = IsUserAllowedToRename("L3STinstance") && hasSelectedL3STinstance;

      UpdateVideoUI();
    }

    #endregion

    #region --- Methods ---

    #region Add

    public void AddL3STinstance()
    {
      string l3STinstancePartialId = txtL3STinstance.Text.Trim().Replace(".", "");
      if (l3STinstancePartialId.Length == 0) return;

      string filmId = listFilms.SelectedValue;
      string conversationId = listConversations.SelectedValue;
      string L3STinstanceId = conversationId + "." + l3STinstancePartialId; //that conversationId already contains the filmId in it

      txtL3STinstance.Text = "";

      CreateL3STinstance(filmId, conversationId, L3STinstanceId, ((listL3STinstances.SelectedIndex > 0) && cbClone.Checked) ? GetMetadataFromUI() : null);
      SelectL3STinstance(L3STinstanceId);

      //initialize Title, Description and Tags from Conversation, allow further editing//
      if (!cbClone.Checked)
      {
        IConversation conversation = conversationStorage[conversationId];
        txtTitle.Text = conversation.Title;
        txtDescription.Text = conversation.Description;
        txtTags.Text = UI.GetCommaSeparated(conversation.Tags);
      } 
    }

    #endregion

    public void Rename()
    {
      //TODO
    }

    #region Selection

    public void SelectConversation(string conversationId)
    {
      UpdateConversationsList(listConversations, conversationId); //update list since it may not be up-to-date
      listConversations_SelectedIndexChanged(listConversations, null);
    }

    public void SelectL3STinstance(string L3STinstanceId)
    {
      UpdateL3STinstancesList(listL3STinstances, L3STinstanceId); //update list since it may not be up-to-date
      listL3STinstances_SelectedIndexChanged(listL3STinstances, null);
    }

    #endregion

    #region Linked Data

    public void LinkData(IL3STinstance metadata)
    {
      string key = metadata.ReferenceId;

      IConversation conversation = conversationStorage[metadata.ConversationReferenceId];
      conversation.Film = filmStorage[metadata.FilmReferenceId];
      metadata.Conversation = conversation; //this updates calculated properties (must be set after the above calculation)

      l3TTinstanceStorage = new CXMLFragmentStorage<IL3TTinstance, L3TTinstance>(Server.MapPath("~/L3TTinstance/L3TTinstances.cxml"), Server.MapPath("~/L3TTinstance/metadata"), key + ".*.cxml");
      metadata.L3TTinstances = l3TTinstanceStorage.Values; //this updates calculated properties //assumes "l3TTinstanceStorage" has been updated
    }

    #endregion

    #region Load

    public void DisplayMetadata(string l3STinstanceId)
    {
      IL3STinstance metadata = l3STinstanceStorage[l3STinstanceId];
      LinkData(metadata);
      DisplayMetadata(metadata);
    }

    public void DisplayMetadata(IL3STinstance metadata)
    {
      string key = metadata.ReferenceId;

      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, metadata.Title);
      UI.Load(txtImageUrl, metadata.Image);
      UI.Load(linkUrl, GetL3STinstanceUri(metadata.FilmReferenceId, metadata.ConversationReferenceId, key));
      UI.Load(txtDescription, metadata.Description);

      //ITrafilmMetadata//

      //No need to show L3STinstance.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list

      UI.Load(lblInfoCreated, metadata.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, metadata.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));

      UI.LoadContent(listMetadataEditors, metadata.MetadataEditors);

      UI.Load(txtTranscription, metadata.Transcription);

      UI.Load(txtTags, metadata.Tags);

      UI.Load(txtRemarks, metadata.Remarks);

      //IL3STinstance//

      UI.Load(listFilms, metadata.FilmReferenceId);
      UI.Load(listConversations, metadata.ConversationReferenceId);

      UI.Load(lblConversationStartTime, metadata.ConversationStartTime.ToString());
      UI.Load(lblConversationDuration, metadata.ConversationDuration);

      UI.Load(lblL1language, metadata.L1language);

      UI.Load(listL3STlanguageType, metadata.L3STlanguageType);
      UI.Load(txtL3STlanguage, metadata.L3STlanguage);

      UI.Load(clistL3STconstructedBasedOn, metadata.L3STconstructedBasedOn);

      UI.Load(listL3STaudienceUnderstanding, metadata.L3STaudienceUnderstanding);
      UI.Load(listL3STmessageUnderstanding, metadata.L3STmessageUnderstanding);
      UI.Load(listL3STmeaningDecipherable, metadata.L3STmeaningDecipherable);

      UI.Load(listL3STspeakerPerformance, metadata.L3STspeakerPerformance);

      UI.Load(clistL3STmode, metadata.L3STmode);

      UI.Load(clistL3STrepresented, metadata.L3STrepresented);
      UI.Load(clistL3STrepresentationsOral, metadata.L3STrepresentationsOral);
      UI.Load(clistL3STrepresentationsVisual, metadata.L3STrepresentationsVisual);

      UI.Load(clistL3STfunctions, metadata.L3STfunctions);
      UI.Load(clistL3STconversationFeatures, metadata.L3STconversationFeatures);

      UI.Load(listL3STsources, metadata.L3STsources);

      //Calculated properties//

      UI.Load(lblL3TTinstanceCount, metadata.L3TTinstanceCount.ToString());
    }

    #endregion

    #region Save

    public IL3STinstance GetMetadataFromUI()
    {
      IL3STinstance metadata = new L3STinstance();
      string key = listL3STinstances.SelectedValue;
      string filmReferenceId = listFilms.SelectedValue;
      string conversationReferenceId = listConversations.SelectedValue;

      //ICXMLMetadata//

      metadata.Title = txtTitle.Text;
      metadata.Image = txtImageUrl.Text;
      metadata.Url = GetL3STinstanceUri(filmReferenceId, conversationReferenceId, key);
      metadata.Description = txtDescription.Text;

      //ITrafilmMetadata//

      metadata.ReferenceId = key;

      metadata.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      metadata.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);

      metadata.MetadataEditors = UI.GetContent(listMetadataEditors);

      metadata.Transcription = txtTranscription.Text;

      metadata.Tags = UI.GetCommaSeparated(txtTags);

      metadata.Remarks = txtRemarks.Text;

      //IL3STinstanceMetadata//

      metadata.FilmReferenceId = filmReferenceId;
      metadata.ConversationReferenceId = conversationReferenceId;

      metadata.L3STlanguageType = listL3STlanguageType.SelectedValue;
      metadata.L3STlanguage = txtL3STlanguage.Text;

      metadata.L3STconstructedBasedOn = UI.GetSelected(clistL3STconstructedBasedOn);

      metadata.L3STaudienceUnderstanding = listL3STaudienceUnderstanding.SelectedValue;
      metadata.L3STmessageUnderstanding = listL3STmessageUnderstanding.SelectedValue;
      metadata.L3STmeaningDecipherable = listL3STmeaningDecipherable.SelectedValue;

      metadata.L3STspeakerPerformance = listL3STspeakerPerformance.SelectedValue;

      metadata.L3STmode = UI.GetSelected(clistL3STmode);

      metadata.L3STrepresented = UI.GetSelected(clistL3STrepresented);
      metadata.L3STrepresentationsOral = UI.GetSelected(clistL3STrepresentationsOral);
      metadata.L3STrepresentationsVisual = UI.GetSelected(clistL3STrepresentationsVisual);

      metadata.L3STfunctions = UI.GetSelected(clistL3STfunctions);
      metadata.L3STconversationFeatures = UI.GetSelected(clistL3STconversationFeatures);

      metadata.L3STsources = listL3STsources.SelectedValue;

      //Calculated properties//

      LinkData(metadata);

      return metadata;
    }

    public void Save()
    {
      lblInfoUpdated.Text = DateTime.UtcNow.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      UI.AppendUserName(listMetadataEditors);
      l3STinstanceStorage[listL3STinstances.SelectedValue] = (IL3STinstance)GetMetadataFromUI();
    }

    public void SaveCollection()
    {
      ICXMLMetadataStorage<IL3STinstance> allL3STinstancesStorage = new CXMLFragmentStorage<IL3STinstance, L3STinstance>(Server.MapPath("~/L3STinstance/L3STinstances.cxml"), Server.MapPath("~/L3STinstance/metadata"), "*.cxml");
      SaveCollection(Server.MapPath("~/L3STinstance/L3STinstances.cxml"), "Trafilm Gallery: L3ST-instances", L3STinstanceMetadataFacets.GetCXMLFacetCategories(), allL3STinstancesStorage.Values);
    }

    public void UpdateVideoUI()
    {
      //Video download/upload UI stays hidden if their parent panelMetadata is not visible (i.e. nothing is selected)
      string conversationId = listConversations.SelectedValue;
      string l1Language = ""; //txtL1language.Text //TODO: copy into L3STinstance metadata the L1language from film grandparent (edit model and show in form etc.)
      bool videoDownloadVisible = panelVideoDownload.Visible = IsUserAllowedToViewVideo() && ConversationL1videoExists(conversationId, l1Language);
      UI.Load(linkVideo, GetConversationL1videoUri(conversationId, l1Language));
      bool videoUploadVisible = panelVideoUpload.Visible = IsUserAllowedToUploadConversationL1video();
      panelVideo.Visible = videoDownloadVisible || videoUploadVisible; //need to use local variables above, else it is always false
    }

    #endregion

    #endregion

    #region --- Events ---

    protected void listFilms_SelectedIndexChanged(object sender, EventArgs e)
    {
      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Server.MapPath("~/conversation/conversations.cxml"), Server.MapPath("~/conversation/metadata"), listFilms.SelectedValue + ".*.cxml");

      bool visible = (listFilms.SelectedIndex > 0);
      panelConversationId.Visible = visible;
      SelectConversation(null);
    }

    protected void listConversations_SelectedIndexChanged(object sender, EventArgs e)
    {
      l3STinstanceStorage = new CXMLFragmentStorage<IL3STinstance, L3STinstance>(Server.MapPath("~/L3STinstance/L3STinstances.cxml"), Server.MapPath("~/L3STinstance/metadata"), listConversations.SelectedValue + ".*.cxml");

      bool visible = (listConversations.SelectedIndex > 0);
      panelL3STinstanceId.Visible = visible;
      SelectL3STinstance(null); //this will also hide panelMetadata
    }

    protected void listL3STinstances_SelectedIndexChanged(object sender, EventArgs e)
    {
      bool visible = (listL3STinstances.SelectedIndex > 0);
      panelMetadata.Visible = visible;
      cbClone.Visible = visible;
      if (visible)
      {
        DisplayMetadata(listL3STinstances.SelectedValue);
        UpdateRepeater(repeaterL3TTinstances, l3TTinstanceStorage.Keys.Select(x => new { filmId = listFilms.SelectedValue, conversationId = listConversations.SelectedValue, l3STinstanceId = listL3STinstances.SelectedValue, L3TTinstanceId = x }));
      }
    }

    protected void btnAddL3STinstance_Click(object sender, EventArgs e)
    {
      if (!IsUserAllowedToSave("L3STinstance")) return;

      AddL3STinstance();
    }

    protected void btnRename_Click(object sender, EventArgs e)
    {
      if (!IsUserAllowedToRename("L3STinstance")) return;

      Rename();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      if (!IsUserAllowedToSave("L3STinstance")) return;

      Save();
      SaveCollection(); //TODO: should move this to code that generated DeepZoom gallery

      string uploadResult = UploadVideo(uploadVideo, GetConversationL1videoFilename(listConversations.SelectedValue, "")); //txtL1language.Text //TODO: copy into L3STinstance metadata the L1language from film grandparent (edit model and show in form etc.)
      labelStatus.Text = uploadResult;
      panelStatus.Visible = (uploadResult != "");

      DisplayMetadata(listL3STinstances.SelectedValue); //Reload saved data on the UI to confirm what was saved. This is also important to update any calculated fields that make use of the edited object's metadata values
      UpdateVideoUI(); //need to update the video UI here too (else when it is uploaded for the first time it won't show download link)
    }

    #endregion

  }

}