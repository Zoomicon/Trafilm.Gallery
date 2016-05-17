//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: film\metadata\default.aspx.cs
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
  public partial class FilmMetadataPage : BaseMetadataPage
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
      }
    }

    #endregion

    #region --- Methods ---

    public void AddFilm()
    {
      string filmId = txtFilm.Text;
      txtFilm.Text = "";

      CreateFilm(filmId, ((listFilms.SelectedIndex > 0) && cbClone.Checked) ? GetMetadataFromUI() : null);
      SelectFilm(filmId);
    }

    public void SelectFilm(string filmId)
    {
      UpdateFilmsList(listFilms, filmId); //update list since it may not be up-to-date
      listFilms_SelectedIndexChanged(listFilms, null);
    }

    #region Load

    public void DisplayMetadata(string filmId)
    {
       DisplayMetadata(filmStorage[filmId]);
    }

    public void DisplayMetadata(IFilm metadata)
    {
      string key = metadata.ReferenceId;

      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, metadata.Title);
      //Not showing any Image field
      UI.Load(linkUrl, new Uri("http://gallery.trafilm.net/?film=" + key));
      UI.Load(txtDescription, metadata.Description);

      //ITrafilmMetadata//

      //No need to show film.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list
      UI.Load(lblInfoCreated, metadata.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, metadata.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(txtKeywords, metadata.Keywords);

      //IFilm//

      UI.Load(txtTitle_es, metadata.Title_es);
      UI.Load(txtTitle_ca, metadata.Title_ca);
      //...

      UI.Load(txtDuration, metadata.Duration.ToString(FilmMetadata.DEFAULT_DURATION_FORMAT));

      UI.Load(txtDirectors, metadata.Directors);
      UI.Load(txtScriptwriters, metadata.Scriptwriters);

      UI.Load(clistProductionCountries, metadata.ProductionCountries);
      UI.Load(txtProductionCompanies, metadata.ProductionCompanies);

      UI.Load(txtBoxOffice, metadata.BoxOffice);
      UI.Load(txtYear, metadata.Year.ToString());

      UI.Load(clistSourceLanguages, metadata.SourceLanguages);

      UI.Load(txtYearTranslated, metadata.YearTranslated.ToString());
      UI.Load(clistDubbedLanguages, metadata.DubbedLanguages);
      UI.Load(clistSubtitledLanguages, metadata.SubtitledLanguages);

      //Calculatable from Conversations//

      UI.Load(lblConversationCount, CalculateConversationCount(key).ToString());
      UI.Load(lblConversationsDuration, CalculateConversationsDuration(key).ToString(ConversationMetadata.DEFAULT_DURATION_FORMAT));
    }
 
    #endregion

    #region Save

    public IFilm GetMetadataFromUI()
    {
      IFilm metadata = new Film();
      string key = listFilms.SelectedValue;

      //ICXMLMetadata//

      metadata.Title = txtTitle.Text;
      metadata.Image = ""; //TODO
      metadata.Url = new Uri("http://gallery.trametadata.net/?film=" + key);
      metadata.Description = txtDescription.Text;

      //ITrametadataMetadata//

      metadata.ReferenceId = key;

      metadata.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      metadata.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);

      metadata.Keywords = UI.GetCommaSeparated(txtKeywords);

      //IFilm//

      metadata.Title_es = txtTitle_es.Text;
      metadata.Title_ca = txtTitle_ca.Text;
      //...

      metadata.Duration = txtDuration.Text.ToNullableTimeSpan(FilmMetadata.DEFAULT_DURATION_FORMAT);

      metadata.Directors = UI.GetCommaSeparated(txtDirectors);
      metadata.Scriptwriters = UI.GetCommaSeparated(txtScriptwriters);

      metadata.ProductionCountries = UI.GetSelected(clistProductionCountries);
      metadata.ProductionCompanies = UI.GetCommaSeparated(txtProductionCompanies);

      metadata.BoxOffice = txtBoxOffice.Text;
      metadata.Year = txtYear.Text.ToNullableInt();

      metadata.SourceLanguages = UI.GetSelected(clistSourceLanguages);

      metadata.YearTranslated = txtYearTranslated.Text.ToNullableInt();
      metadata.DubbedLanguages = UI.GetSelected(clistDubbedLanguages);
      metadata.SubtitledLanguages = UI.GetSelected(clistSubtitledLanguages);

      //Calculatable from Conversations//

      metadata.ConversationCount = CalculateConversationCount(key);
      metadata.ConversationsDuration = CalculateConversationsDuration(key);

      return metadata;
    }

    public void Save()
    {
      lblInfoUpdated.Text = DateTime.UtcNow.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      filmStorage[listFilms.SelectedValue] = (IFilm)GetMetadataFromUI();
    }

    public void SaveCollection()
    {
      SaveCollection(Path.Combine(Request.PhysicalApplicationPath, @"film\films.cxml"), "Trafilm Gallery Films", Film.MakeFilmFacetCategories(), filmStorage.Values);
    }

    #endregion

    #region Calculated from Conversations

    private int CalculateConversationCount(string key)
    {
      return conversationStorage.Count;
    }

    private TimeSpan CalculateConversationsDuration(string key) //TODO
    {
      TimeSpan duration = TimeSpan.Zero;
      foreach (IConversation conversation in conversationStorage.Values)
        if (conversation.Duration != null)
          duration += (TimeSpan)conversation.Duration;
      return duration;
    }

    #endregion

    #endregion

    #region --- Events ---

    protected void listFilms_SelectedIndexChanged(object sender, EventArgs e)
    {
      conversationStorage = new CXMLFragmentStorage<IConversation, Conversation>(Path.Combine(Request.PhysicalApplicationPath, @"conversation\conversations.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"conversation\metadata"), listFilms.SelectedValue + ".*.cxml");
      L3occurenceStorage = new CXMLFragmentStorage<IL3occurence, L3occurence>(Path.Combine(Request.PhysicalApplicationPath, @"L3occurence\L3occurences.cxml"), Path.Combine(Request.PhysicalApplicationPath, @"L3occurence\metadata"), listFilms.SelectedValue + ".*.cxml");

      bool visible = (listFilms.SelectedIndex > 0);
      panelMetadata.Visible = visible;
      cbClone.Visible = visible;
      if (visible)
      {
        DisplayMetadata(listFilms.SelectedValue);
        UpdateRepeater(repeaterConversations, conversationStorage.Keys.Select(x => new { filmId = listFilms.SelectedValue, conversationId = x }) );
      }
    }

    protected void btnAddFilm_Click(object sender, EventArgs e)
    {
      AddFilm();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      Save();
      SaveCollection();
    }

    #endregion

  }

}