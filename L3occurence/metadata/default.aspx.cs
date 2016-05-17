//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: L3occurence\metadata\default.aspx.cs
//Version: 20160517

using Metadata.CXML;
using Trafilm.Metadata;
using Trafilm.Metadata.Models;
using Trafilm.Metadata.Utils;

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
      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"conversation\conversations.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"conversation\metadata"), listFilms.SelectedValue + ".*.cxml");
      L3occurenceStorage = new CXMLFragmentStorage<IL3occurence, L3occurence>(Path.Combine(Request.PhysicalApplicationPath, @"L3occurence\L3occurences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3occurence\metadata"), listFilms.SelectedValue + ".*.cxml");

      UpdateFilmsList(listFilms, (IsPostBack) ? listFilms.SelectedValue : "film", !IsPostBack);
      if (!IsPostBack)
        listFilms_SelectedIndexChanged(listFilms, null);

      if (!IsPostBack)
      {
        UpdateConversationsList(listConversations, "conversation", !IsPostBack);
        listConversations_SelectedIndexChanged(listConversations, null);

        UpdateL3occurencesList(listL3occurences, "L3occurence", !IsPostBack);
        listL3occurences_SelectedIndexChanged(listL3occurences, null);
      }
    }

    #endregion

    #region --- Methods ---

    public void AddL3occurence()
    {
      string filmId = listFilms.SelectedValue;
      string conversationId = listConversations.SelectedValue;
      string L3occurenceId = conversationId + "." + txtL3occurence.Text; //that conversationId already contains the filmId in it
      txtL3occurence.Text = "";

      CreateL3occurence(filmId, conversationId, L3occurenceId, ((listL3occurences.SelectedIndex > 0) && cbClone.Checked) ? GetMetadataFromUI() : null);
      SelectL3occurence(L3occurenceId);
    }

    public void SelectConversation(string conversationId)
    {
      UpdateConversationsList(listConversations, conversationId); //update list since it may not be up-to-date
      listConversations_SelectedIndexChanged(listConversations, null);
    }

    public void SelectL3occurence(string L3occurenceId)
    {
      UpdateL3occurencesList(listL3occurences, L3occurenceId); //update list since it may not be up-to-date
      listL3occurences_SelectedIndexChanged(listL3occurences, null);
    }

    #region Load

    public void DisplayMetadata(string L3occurenceId)
    {
      DisplayMetadata(L3occurenceStorage[L3occurenceId]);
    }

    public void DisplayMetadata(IL3occurence metadata)
    {
      string key = metadata.ReferenceId;

      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, metadata.Title);
      //Not showing any Image field
      UI.Load(linkUrl, new Uri("http://gallery.trafilm.net/?L3occurence=" + key));
      UI.Load(txtDescription, metadata.Description);

      //ITrafilmMetadata//

      //No need to show L3occurence.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list
      UI.Load(lblInfoCreated, metadata.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, metadata.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(txtKeywords, metadata.Keywords);

      //IL3occurence//

      UI.Load(listFilms, metadata.FilmReferenceId);
      UI.Load(listConversations, metadata.ConversationReferenceId);

      UI.Load(txtStartTime, metadata.StartTime.ToString(L3occurenceMetadata.DEFAULT_POSITION_FORMAT));
      UI.Load(txtDuration, metadata.Duration.ToString(L3occurenceMetadata.DEFAULT_DURATION_FORMAT));

      UI.Load(listL3kind, metadata.L3kind);

      UI.Load(listLmainLanguage, metadata.LmainLanguage);
      UI.Load(listLmainMode, metadata.LmainMode);

      UI.Load(cbL2sameAsL3ST, metadata.L2sameAsL3ST);
      UI.Load(cbL3STconveyedAsL3TT, metadata.L3STconveyedAsL3TT);

      UI.Load(listL3languageType, metadata.L3languageType);
      UI.Load(txtL3language, metadata.L3language);

      UI.Load(clistL3constructedBasedOn, metadata.L3constructedBasedOn);

      UI.Load(listL3audienceUnderstanding, metadata.L3audienceUnderstanding);
      UI.Load(listL3messageUnderstanding, metadata.L3messageUnderstanding);
      UI.Load(listL3meaningDecipherable, metadata.L3meaningDecipherable);

      UI.Load(listL3speakerPerformance, metadata.L3speakerPerformance);

      UI.Load(clistL3mode, metadata.L3mode);
      UI.Load(listL3STmodeChange, metadata.L3STmodeChange);

      UI.Load(clistL3represented, metadata.L3represented);
      UI.Load(clistL3representationsOral, metadata.L3representationsOral);
      UI.Load(clistL3representationsVisual, metadata.L3representationsVisual);

      UI.Load(clistL3functions, metadata.L3functions);
    }

    #endregion

    #region Save

    public IL3occurence GetMetadataFromUI()
    {
      IL3occurence metadata = new L3occurence();
      string key = listL3occurences.SelectedValue;

      //ICXMLMetadata//

      metadata.Title = txtTitle.Text;
      metadata.Image = ""; //TODO
      metadata.Url = new Uri("http://gallery.trafilm.net/?L3occurence=" + key); //TODO: could set to jump to movie time
      metadata.Description = txtDescription.Text;

      //ITrafilmMetadata//

      metadata.ReferenceId = key;
      metadata.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      metadata.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      metadata.Keywords = UI.GetCommaSeparated(txtKeywords);

      //Imetadata//

      metadata.ConversationReferenceId = listConversations.SelectedValue;

      metadata.FilmReferenceId = listFilms.SelectedValue;
      metadata.ConversationReferenceId = listConversations.SelectedValue;

      metadata.StartTime = txtStartTime.Text.ToNullableTimeSpan(L3occurenceMetadata.DEFAULT_POSITION_FORMAT);
      metadata.Duration = txtDuration.Text.ToNullableTimeSpan(L3occurenceMetadata.DEFAULT_DURATION_FORMAT);

      metadata.L3kind = listL3kind.SelectedValue;

      metadata.LmainLanguage = listLmainLanguage.SelectedValue;
      metadata.LmainMode = listLmainMode.SelectedValue;

      metadata.L2sameAsL3ST = cbL2sameAsL3ST.Checked;
      metadata.L3STconveyedAsL3TT = cbL3STconveyedAsL3TT.Checked;

      metadata.L3languageType = listL3languageType.SelectedValue;
      metadata.L3language = txtL3language.Text;

      metadata.L3constructedBasedOn = UI.GetSelected(clistL3constructedBasedOn);

      metadata.L3audienceUnderstanding = listL3audienceUnderstanding.SelectedValue;
      metadata.L3messageUnderstanding = listL3messageUnderstanding.SelectedValue;
      metadata.L3meaningDecipherable = listL3meaningDecipherable.SelectedValue;

      metadata.L3speakerPerformance = listL3speakerPerformance.SelectedValue;

      metadata.L3mode = UI.GetSelected(clistL3mode);
      metadata.L3STmodeChange = listL3STmodeChange.SelectedValue;

      metadata.L3represented = UI.GetSelected(clistL3represented);
      metadata.L3representationsOral = UI.GetSelected(clistL3representationsOral);
      metadata.L3representationsVisual = UI.GetSelected(clistL3representationsVisual);

      metadata.L3functions = UI.GetSelected(clistL3functions);

      return metadata;
    }

    public void Save()
    {
      lblInfoUpdated.Text = DateTime.UtcNow.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      L3occurenceStorage[listL3occurences.SelectedValue] = (IL3occurence)GetMetadataFromUI();
    }

    public void SaveCollection()
    {
      SaveCollection(Path.Combine(Request.PhysicalApplicationPath, "L3occurence/L3occurences.cxml"), "Trafilm Gallery L3occurences", L3occurence.MakeL3occurenceFacetCategories(), L3occurenceStorage.Values);
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
      L3occurenceStorage = new CXMLFragmentStorage<IL3occurence, L3occurence>(Path.Combine(Request.PhysicalApplicationPath, @"L3occurence\L3occurences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3occurence\metadata"), listConversations.SelectedValue + ".*.cxml");

      bool visible = (listConversations.SelectedIndex > 0);
      panelL3occurenceId.Visible = visible;
      SelectL3occurence(null); //this will also hide panelMetadata
    }

    protected void listL3occurences_SelectedIndexChanged(object sender, EventArgs e)
    {
      bool visible = (listL3occurences.SelectedIndex > 0);
      panelMetadata.Visible = visible;
      cbClone.Visible = visible;
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