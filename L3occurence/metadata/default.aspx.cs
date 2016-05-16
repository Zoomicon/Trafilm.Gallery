//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: L3occurence\metadata\default.aspx.cs
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

      CreateL3occurence(filmId, conversationId, L3occurenceId);
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

    public void DisplayMetadata(IL3occurence L3occurence)
    {
      string key = L3occurence.ReferenceId;

      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, L3occurence.Title);
      //Not showing any Image field
      UI.Load(linkUrl, new Uri("http://gallery.trafilm.net/?L3occurence=" + key));
      UI.Load(txtDescription, L3occurence.Description);

      //ITrafilmMetadata//

      //No need to show L3occurence.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list
      UI.Load(lblInfoCreated, L3occurence.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, L3occurence.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(txtKeywords, L3occurence.Keywords);

      //IL3occurence//

      UI.Load(listFilms, L3occurence.FilmReferenceId);
      UI.Load(listConversations, L3occurence.ConversationReferenceId);

      UI.Load(listL3kind, L3occurence.L3kind);

      UI.Load(listLmainLanguage, L3occurence.LmainLanguage);
      UI.Load(listLmainMode, L3occurence.LmainMode);

      UI.Load(cbL2sameAsL3ST, L3occurence.L2sameAsL3ST);
      UI.Load(cbL3STconveyedAsL3TT, L3occurence.L3STconveyedAsL3TT);

      UI.Load(listL3languageType, L3occurence.L3languageType);
      UI.Load(txtL3language, L3occurence.L3language);

      UI.Load(clistL3constructedBasedOn, L3occurence.L3constructedBasedOn);

      UI.Load(listL3audienceUnderstanding, L3occurence.L3audienceUnderstanding);
      UI.Load(listL3messageUnderstanding, L3occurence.L3messageUnderstanding);
      UI.Load(listL3meaningDeciphered, L3occurence.L3meaningDeciphered);

      UI.Load(listL3speakerPerformance, L3occurence.L3speakerPerformance);

      UI.Load(clistL3mode, L3occurence.L3mode);
      UI.Load(listL3STmodeChange, L3occurence.L3STmodeChange);

      UI.Load(clistL3represented, L3occurence.L3represented);
      UI.Load(clistL3representationsOral, L3occurence.L3representationsOral);
      UI.Load(clistL3representationsVisual, L3occurence.L3representationsVisual);

      UI.Load(clistL3functions, L3occurence.L3functions);
    }

    #endregion

    #region Save

    public ICXMLMetadata GetMetadataFromUI()
    {
      IL3occurence L3occurence = new L3occurence();
      string key = listFilms.SelectedValue;

      //ICXMLMetadata//

      L3occurence.Title = txtTitle.Text;
      L3occurence.Image = ""; //TODO
      L3occurence.Url = new Uri("http://gallery.trafilm.net/?L3occurence=" + key); //TODO: could set to jump to movie time
      L3occurence.Description = txtDescription.Text;

      //ITrafilmMetadata//

      L3occurence.ReferenceId = key;
      L3occurence.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      L3occurence.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      L3occurence.Keywords = UI.GetCommaSeparated(txtKeywords);

      //IL3occurence//

      L3occurence.ConversationReferenceId = listConversations.SelectedValue;

      L3occurence.FilmReferenceId = listFilms.SelectedValue;
      L3occurence.ConversationReferenceId = listConversations.SelectedValue;

      L3occurence.L3kind = listL3kind.SelectedValue;

      L3occurence.LmainLanguage = listLmainLanguage.SelectedValue;
      L3occurence.LmainMode = listLmainMode.SelectedValue;

      L3occurence.L2sameAsL3ST = cbL2sameAsL3ST.Checked;
      L3occurence.L3STconveyedAsL3TT = cbL3STconveyedAsL3TT.Checked;

      L3occurence.L3languageType = listL3languageType.SelectedValue;
      L3occurence.L3language = txtL3language.Text;

      L3occurence.L3constructedBasedOn = UI.GetSelected(clistL3constructedBasedOn);

      L3occurence.L3audienceUnderstanding = listL3audienceUnderstanding.SelectedValue;
      L3occurence.L3messageUnderstanding = listL3messageUnderstanding.SelectedValue;
      L3occurence.L3meaningDeciphered = listL3meaningDeciphered.SelectedValue;

      L3occurence.L3speakerPerformance = listL3speakerPerformance.SelectedValue;

      L3occurence.L3mode = UI.GetSelected(clistL3mode);
      L3occurence.L3STmodeChange = listL3STmodeChange.SelectedValue;

      L3occurence.L3represented = UI.GetSelected(clistL3represented);
      L3occurence.L3representationsOral = UI.GetSelected(clistL3representationsOral);
      L3occurence.L3representationsVisual = UI.GetSelected(clistL3representationsVisual);

      L3occurence.L3functions = UI.GetSelected(clistL3functions);

      return L3occurence;
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
      if (visible)
        SelectConversation(null);
    }

    protected void listConversations_SelectedIndexChanged(object sender, EventArgs e)
    {
      L3occurenceStorage = new CXMLFragmentStorage<IL3occurence, L3occurence>(Path.Combine(Request.PhysicalApplicationPath, @"L3occurence\L3occurences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3occurence\metadata"), listConversations.SelectedValue + ".*.cxml");

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