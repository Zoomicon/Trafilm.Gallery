//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: conversation\metadata\default.aspx.cs
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
  public partial class ConversationMetadataPage : BaseMetadataPage
  {

    #region --- Initialization ---

    protected void Page_Load(object sender, EventArgs e)
    {
      filmStorage = new CXMLFragmentStorage<IFilm, Film>(Path.Combine(Request.PhysicalApplicationPath, @"film\films.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"film\metadata"), "*.cxml");
      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"conversation\conversations.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"conversation\metadata"), listFilms.SelectedValue + ".*.cxml");
      L3occurenceStorage = new CXMLFragmentStorage<IL3occurence, L3occurence>(Path.Combine(Request.PhysicalApplicationPath, @"L3occurence\L3occurences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3occurence\metadata"), listFilms.SelectedValue + ".*.cxml");

      if (!IsPostBack)
      {
        UpdateFilmsList(listFilms, "film", !IsPostBack);
        listFilms_SelectedIndexChanged(listFilms, null);

        UpdateConversationsList(listConversations, "conversation", !IsPostBack);
        listConversations_SelectedIndexChanged(listConversations, null);
      }
    }

    #endregion

    #region --- Methods ---

    public void AddConversation()
    {
      string filmId = listFilms.SelectedValue;
      string conversationId = filmId + "." + txtConversation.Text;
      txtConversation.Text = "";

      CreateConversation(filmId, conversationId);
      SelectConversation(conversationId);
    }

    public void SelectConversation(string conversationId)
    {
      UpdateConversationsList(listConversations, conversationId); //update list since it may not be up-to-date
      listConversations_SelectedIndexChanged(listConversations, null);
    }

    #region Load

    public void DisplayMetadata(string conversationId)
    {
      DisplayMetadata(conversationStorage[conversationId]);
    }

    public void DisplayMetadata(IConversation conversation)
    {
      string key = conversation.ReferenceId;

      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, conversation.Title);
      //Not showing any Image field
      UI.Load(linkUrl, new Uri("http://gallery.trafilm.net/?conversation=" + key));
      UI.Load(txtDescription, conversation.Description);

      //ITrafilmMetadata//

      //No need to show conversation.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list
      UI.Load(lblInfoCreated, conversation.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, conversation.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(txtKeywords, conversation.Keywords);

      //IConversation//

      UI.Load(listFilms, conversation.FilmReferenceId);

      UI.Load(txtStartTime, conversation.StartTime.ToString(ConversationMetadata.DEFAULT_POSITION_FORMAT));
      UI.Load(txtDuration, conversation.Duration.ToString(ConversationMetadata.DEFAULT_DURATION_FORMAT));

      UI.Load(cbL1languagePresent, conversation.L1languagePresent);
      UI.Load(cbL2languagePresent, conversation.L2languagePresent);

      UI.Load(listSpeakingCharactersCount, conversation.SpeakingCharactersCount);
      UI.Load(listL3speakingCharactersCount, conversation.L3speakingCharactersCount);

      //Calculatable from L3occurences//

      UI.Load(lblL3languagesCount, CalculateL3languagesCount(key).ToString());
      clistL3languages.DataSource = CalculateL3languages(key);

      UI.Load(lblL3languageTypesCount, CalculateL3languageTypesCount(key).ToString());
      clistL3languageTypes.DataSource = CalculateL3languageTypes(key);

      UI.Load(lblL3occurenceCount, CalculateL3occurenceCount(key).ToString());
    }

    #endregion

    #region Save

    public ICXMLMetadata GetMetadataFromUI()
    {
      IConversation conversation = new Conversation();
      string key = listFilms.SelectedValue;

      //ICXMLMetadata//

      conversation.Title = txtTitle.Text;
      conversation.Image = ""; //TODO
      conversation.Url = new Uri("http://gallery.trafilm.net/?conversation=" + key); //TODO: could set to jump to movie time
      conversation.Description = txtDescription.Text;

      //ITrafilmMetadata//

      conversation.ReferenceId = key;
      conversation.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      conversation.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      conversation.Keywords = UI.GetCommaSeparated(txtKeywords);

      //IConversation//

      conversation.FilmReferenceId = listFilms.SelectedValue;

      conversation.StartTime = txtStartTime.Text.ToNullableTimeSpan(ConversationMetadata.DEFAULT_POSITION_FORMAT);
      conversation.Duration = txtDuration.Text.ToNullableTimeSpan(ConversationMetadata.DEFAULT_DURATION_FORMAT);

      conversation.L1languagePresent = cbL1languagePresent.Checked;
      conversation.L2languagePresent = cbL2languagePresent.Checked;

      conversation.SpeakingCharactersCount = listSpeakingCharactersCount.SelectedValue; //e.g. 1, 2, 3, more than 3
      conversation.L3speakingCharactersCount = listL3speakingCharactersCount.SelectedValue; //e.g. 1, 2, 3, more than 3

      //Calculatable from L3occurences//

      conversation.L3languagesCount = CalculateL3languagesCount(key);
      conversation.L3languages = CalculateL3languages(key);

      conversation.L3languageTypesCount = CalculateL3languageTypesCount(key);
      conversation.L3languageTypes = CalculateL3languageTypes(key);

      conversation.L3occurenceCount = CalculateL3occurenceCount(key);

      return conversation;
    }

    public void Save()
    {
      lblInfoUpdated.Text = DateTime.UtcNow.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      conversationStorage[listConversations.SelectedValue] = (IConversation)GetMetadataFromUI();
    }

    public void SaveCollection()
    {
      SaveCollection(Path.Combine(Request.PhysicalApplicationPath, "conversation/conversations.cxml"), "Trafilm Gallery Conversations", Conversation.MakeConversationFacetCategories(), conversationStorage.Values);
    }

    #endregion

    #region Calculated from L3occurences

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

    private int CalculateL3occurenceCount(string key)
    {
      return L3occurenceStorage.Count;
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
        SelectConversation(null); //this will also hide panelMetadata
    }

    protected void listConversations_SelectedIndexChanged(object sender, EventArgs e)
    {
      L3occurenceStorage = new CXMLFragmentStorage<IL3occurence, L3occurence>(Path.Combine(Request.PhysicalApplicationPath, @"L3occurence\L3occurences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3occurence\metadata"), listFilms.SelectedValue + ".*.cxml");

      bool visible = (listConversations.SelectedIndex > 0);
      panelMetadata.Visible = visible;
      if (visible)
      {
        DisplayMetadata(listConversations.SelectedValue);
        UpdateRepeater(repeaterL3occurences, L3occurenceStorage.Keys.Select(x=> new { filmId=listFilms.SelectedValue, conversationId=listConversations.SelectedValue, L3occurenceId = x }) );
      }
    }

    protected void btnAddConversation_Click(object sender, EventArgs e)
    {
      AddConversation();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      Save();
      SaveCollection();
    }

    #endregion

  }
}