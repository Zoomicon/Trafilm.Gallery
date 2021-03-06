﻿//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: L3TTinstance\metadata\default.aspx.cs
//Version: 20171130

using Metadata.CXML;
using Trafilm.Metadata;
using Trafilm.Metadata.Models;
using Trafilm.Metadata.Utils;

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
      filmStorage = new CXMLFragmentStorage<IFilm, Film>(Server.MapPath("~/film/films.cxml"), Server.MapPath("~/film/metadata"), "*.cxml");
      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Server.MapPath("~/conversation/conversations.cxml"), Server.MapPath("~/conversation/metadata"), listFilms.SelectedValue + ".*.cxml");
      l3STinstanceStorage = new CXMLFragmentStorage<IL3STinstance, L3STinstance>(Server.MapPath("~/L3STinstance/L3STinstances.cxml"), Server.MapPath("~/L3STinstance/metadata"), listL3STinstances.SelectedValue + ".*.cxml");
      l3TTinstanceStorage = new CXMLFragmentStorage<IL3TTinstance, L3TTinstance>(Server.MapPath("~/L3TTinstance/L3TTinstances.cxml"), Server.MapPath("~/L3TTinstance/metadata"), listConversations.SelectedValue + ".*.cxml");

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

      bool canSave = IsUserAllowedToSave("L3TTinstance");
      panelInstructions.Visible = canSave;
      panelMetadata.Enabled = canSave;
      panelAdd.Visible = canSave;
      panelSave.Visible = canSave; //stays hidden if its parent panelMetadata is not visible (i.e. nothing is selected)

      bool hasSelectedL3TTinstance = (listL3TTinstances.SelectedIndex > 0);
      btnRename.Visible = IsUserAllowedToRename("L3TTinstance") && hasSelectedL3TTinstance;

      UpdateVideoUI();
    }

    #endregion

    #region --- Methods ---

    #region Add

    public void AddL3TTinstance()
    {
      string l3TTinstancePartialId = txtL3TTinstance.Text.Trim().Replace(".", "");
      if (l3TTinstancePartialId.Length == 0) return;

      string filmId = listFilms.SelectedValue;
      string conversationId = listConversations.SelectedValue;
      string l3STinstanceId = listL3STinstances.SelectedValue;
      string l3TTinstanceId = l3STinstanceId + "." + l3TTinstancePartialId; //that l3STinstanceId already contains the filmId and conversationId in it

      txtL3TTinstance.Text = "";

      CreateL3TTinstance(filmId, conversationId, l3STinstanceId, l3TTinstanceId, ((listL3TTinstances.SelectedIndex > 0) && cbClone.Checked) ? GetMetadataFromUI() : null);
      SelectL3TTinstance(l3TTinstanceId);

      btnRename.Visible = IsUserAllowedToRename("L3TTinstance") && (listL3STinstances.SelectedIndex > 0);

      //initialize Tags from L3STinstance, allow further editing//
      if (!cbClone.Checked)
      {
        IL3STinstance l3STinstance = l3STinstanceStorage[l3STinstanceId];
        txtTags.Text = UI.GetCommaSeparated(l3STinstance.Tags);
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

    #endregion

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
      UI.Load(lblImageUrl, metadata.Image);
      UI.Load(linkUrl, GetL3TTinstanceUri(metadata.FilmReferenceId, metadata.ConversationReferenceId, metadata.L3STinstanceReferenceId, key));
      UI.Load(txtDescription, metadata.Description);

      //ITrafilmMetadata//

      //No need to show L3TTinstance.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list

      UI.Load(lblInfoCreated, metadata.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, metadata.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));

      UI.LoadContent(listMetadataEditors, metadata.MetadataEditors);

      UI.Load(txtTranscription, metadata.Transcription);

      UI.Load(txtTags, metadata.Tags);

      UI.Load(txtRemarks, metadata.Remarks);

      //IL3TTinstance//

      UI.Load(listFilms, metadata.FilmReferenceId);
      UI.Load(listConversations, metadata.ConversationReferenceId);
      UI.Load(listL3STinstances, metadata.L3STinstanceReferenceId);

      UI.Load(txtFilmTitleTT, metadata.FilmTitleTT);

      UI.Load(listL2language, metadata.L2language);
      UI.Load(listL2mode, metadata.L2mode);

      UI.Load(txtDistributionCountriesTT, metadata.DistributionCountriesTT);
      UI.Load(txtYearTTreleased, metadata.YearTTreleased.ToString());
      UI.Load(listBlockbusterTT, metadata.BlockbusterTT);

      UI.Load(lblConversationStartTime, metadata.ConversationStartTime.ToString());
      UI.Load(lblConversationDuration, metadata.ConversationDuration);

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
      UI.Load(clistL3TTconversationFeatures, metadata.L3TTconversationFeatures);

      UI.Load(listL3TTsources, metadata.L3TTsources);

      //Calculated properties//

      UI.LoadContent(listL3languageTypeChange, metadata.L3languageTypeChange);
      UI.LoadContent(listL3modeChange, metadata.L3modeChange);
      UI.LoadContent(listL3functionsChange, metadata.L3functionsChange);
      UI.LoadContent(listL3conversationFeaturesChange, metadata.L3conversationFeaturesChange);
      UI.LoadContent(listL3sourcesChange, metadata.L3sourcesChange);
    }

    #endregion

    #region Save

    public IL3TTinstance GetMetadataFromUI()
    {
      IL3TTinstance metadata = new L3TTinstance();
      string key = listL3TTinstances.SelectedValue;
      string filmReferenceId = listFilms.SelectedValue;
      string conversationReferenceId = listConversations.SelectedValue;
      string l3STinstanceReferenceId = listL3STinstances.SelectedValue;

      //ICXMLMetadata//

      metadata.Title = txtTitle.Text;
      //metadata.Image calculated from L3STinstance
      metadata.Url = GetL3TTinstanceUri(filmReferenceId, conversationReferenceId, l3STinstanceReferenceId, key);
      //metadata.Description calculated from L3STinstance

      //ITrafilmMetadata//

      metadata.ReferenceId = key;

      metadata.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      metadata.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);

      metadata.MetadataEditors = UI.GetContent(listMetadataEditors);

      metadata.Transcription = txtTranscription.Text;

      metadata.Tags = UI.GetCommaSeparated(txtTags);

      metadata.Remarks = txtRemarks.Text;

      //IL3TTinstanceMetadata//

      metadata.FilmReferenceId = filmReferenceId;
      metadata.ConversationReferenceId = conversationReferenceId;
      metadata.L3STinstanceReferenceId = l3STinstanceReferenceId;

      metadata.FilmTitleTT= txtFilmTitleTT.Text;

      metadata.L2language = listL2language.SelectedValue;
      metadata.L2mode = listL2mode.SelectedValue;

      metadata.DistributionCountriesTT = UI.GetCommaSeparated(txtDistributionCountriesTT);
      metadata.YearTTreleased = txtYearTTreleased.Text.ToNullableInt();
      metadata.BlockbusterTT = listBlockbusterTT.SelectedValue;

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
      metadata.L3TTconversationFeatures = UI.GetSelected(clistL3TTconversationFeatures);

      metadata.L3TTsources = listL3TTsources.SelectedValue;

      //Calculated properties//

      LinkData(metadata);

      return metadata;
    }

    public void Save()
    {
      lblInfoUpdated.Text = DateTime.UtcNow.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      UI.AppendUserName(listMetadataEditors);
      l3TTinstanceStorage[listL3TTinstances.SelectedValue] = (IL3TTinstance)GetMetadataFromUI();
    }

    public void SaveCollection()
    {
      ICXMLMetadataStorage<IL3TTinstance> allL3TTinstancesStorage = new CXMLFragmentStorage<IL3TTinstance, L3TTinstance>(Server.MapPath("~/L3TTinstance/L3TTinstances.cxml"), Server.MapPath("~/L3TTinstance/metadata"), "*.cxml");
      SaveCollection(Server.MapPath("~/L3TTinstance/L3TTinstances.cxml"), "Trafilm Gallery: L3TT-instances", L3TTinstanceMetadataFacets.GetCXMLFacetCategories(), allL3TTinstancesStorage.Values);
    }

    public void UpdateVideoUI()
    {
      //Video download/upload UI stays hidden if their parent panelMetadata is not visible (i.e. nothing is selected)
      string conversationId = listConversations.SelectedValue;
      string l2Language = listL2language.SelectedValue;
      string l2Mode = listL2mode.SelectedValue;
      bool videoDownloadVisible = panelVideoDownload.Visible = IsUserAllowedToViewVideo() && ConversationL2videoExists(conversationId, l2Language, l2Mode);
      UI.Load(linkVideo, GetConversationL2videoUri(conversationId, l2Language, l2Mode));
      bool videoUploadVisible = panelVideoUpload.Visible = IsUserAllowedToUploadConversationL2video();
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
      SelectL3STinstance(null);
    }

    protected void listL3STinstances_SelectedIndexChanged(object sender, EventArgs e)
    {
      l3TTinstanceStorage = new CXMLFragmentStorage<IL3TTinstance, L3TTinstance>(Server.MapPath("~/L3TTinstance/L3TTinstances.cxml"), Server.MapPath("~/L3TTinstance/metadata"), listL3STinstances.SelectedValue + ".*.cxml");

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
      if (!IsUserAllowedToSave("L3TTinstance")) return;

      AddL3TTinstance();
    }

    protected void btnRename_Click(object sender, EventArgs e)
    {
      if (!IsUserAllowedToRename("L3STinstance")) return;

      Rename();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      if (!IsUserAllowedToSave("L3TTinstance")) return;

      Save();
      SaveCollection(); //TODO: should move this to code that generated DeepZoom gallery

      string uploadResult = UploadVideo(uploadVideo, GetConversationL2videoFilename(listConversations.SelectedValue, listL2language.SelectedValue, listL2mode.SelectedValue));
      labelStatus.Text = uploadResult;
      panelStatus.Visible = (uploadResult != "");

      DisplayMetadata(listL3TTinstances.SelectedValue); //Reload saved data on the UI to confirm what was saved. This is also important to update any calculated fields that make use of the edited object's metadata values
      UpdateVideoUI(); //need to update the video UI here too (else when it is uploaded for the first time it won't show download link)
    }

    #endregion

  }

}