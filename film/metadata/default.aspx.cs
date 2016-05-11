﻿//Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
//Filename: film\metadata\default.aspx.cs
//Version: 20160511

using Trafilm.Metadata;
using Trafilm.Metadata.Models;
using Metadata.CXML;

using System;
using System.IO;
using System.Globalization;

namespace Trafilm.Gallery
{
  public partial class FilmMetadataPage : BaseMetadataPage
  {

    #region --- Initialization ---

    protected void Page_Load(object sender, EventArgs e)
    {
      filmStorage = new CXMLFragmentStorage<IFilm, Film>(Path.Combine(Request.PhysicalApplicationPath, "film/films.cxml"), Path.Combine(Request.PhysicalApplicationPath, "film/metadata"), "*.cxml");

      if (!IsPostBack)
      {
        UpdateFilmsList(listFilms);

        SelectFromQueryString(listFilms, null, null);
      }

      panelMetadata.Visible = (listFilms.SelectedIndex > 0);


      sceneStorage = new CXMLFragmentStorage<IScene, Scene>(Path.Combine(Request.PhysicalApplicationPath, "scene/scenes.cxml"), Path.Combine(Request.PhysicalApplicationPath, "scene/metadata"), listFilms.SelectedValue + ".*.cxml");
    }

    #endregion

    #region --- Methods ---

    public void AddFilm()
    {
      string filmId = txtFilm.Text;

      if (filmStorage.Keys.Contains(filmId))
      {
        UpdateFilmsList(listFilms);
        listFilms.SelectedValue = filmId;
      }
      else
      {
        IFilm film = new Film();
        film.Clear();
        film.Title = filmId;
        film.ReferenceId = filmId;

        filmStorage[filmId] = film;
      }
    }

    #region Load

    public void DisplayMetadata(string key)
    {
       DisplayMetadata(filmStorage[key]);
    }

    public void DisplayMetadata(IFilm film)
    {
      string key = film.ReferenceId;

      //ICXMLMetadata//

      //Ignoring the Id field, since some Pivot Tools expect it to be sequential
      UI.Load(txtTitle, film.Title);
      //Not showing any Image field
      UI.Load(linkUrl, new Uri("http://trafilm.net/gallery/?film=" + key));
      UI.Load(txtDescription, film.Description);

      //ITrafilmMetadata//

      //No need to show film.ReferenceId since we calculate and show the URL, plus the ReferenceId is used as the key and shown at the dropdown list
      UI.Load(lblInfoCreated, film.InfoCreated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(lblInfoUpdated, film.InfoUpdated.ToString(CXML.DEFAULT_DATETIME_FORMAT));
      UI.Load(txtKeywords, film.Keywords);

      //IFilm//

      UI.Load(txtTitle_es, film.Title_es);
      UI.Load(txtTitle_ca, film.Title_ca);
      //...

      UI.Load(txtDuration, film.Duration.ToString("HH:MM:SS"));

      UI.Load(txtDirectors, film.Directors);
      UI.Load(txtScriptwriters, film.Scriptwriters);

      UI.Load(clistProductionCountries, film.ProductionCountries);
      UI.Load(txtProductionCompanies, film.ProductionCompanies);

      UI.Load(txtBoxOffice, film.BoxOffice);
      UI.Load(txtYear, film.Year.ToString());

      UI.Load(clistSourceLanguages, film.SourceLanguages);

      UI.Load(txtYearTranslated, film.YearTranslated.ToString());
      UI.Load(clistDubbedLanguages, film.DubbedLanguages);
      UI.Load(clistSubtitledLanguages, film.SubtitledLanguages);

      //Calculatable from Scenes//

      UI.Load(lblSceneCount, CalculateSceneCount(key).ToString());
      UI.Load(lblScenesDuration, CalculateScenesDuration(key).ToString(@"hh\:mm\:ss"));
    }
 
    #endregion

    #region Save

    public ICXMLMetadata GetMetadataFromUI()
    {
      IFilm film = new Film();
      string key = listFilms.SelectedValue;

      //ICXMLMetadata//

      film.Title = txtTitle.Text;
      film.Image = ""; //TODO
      film.Url = new Uri("http://gallery.trafilm.net/?film=" + key);
      film.Description = txtDescription.Text;

      //ITrafilmMetadata//

      film.ReferenceId = key;

      try { film.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture); }
      catch { film.InfoCreated = DateTime.Now; }

      try { film.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture); }
      catch { film.InfoUpdated = DateTime.Now; }

      film.Keywords = UI.GetCommaSeparated(txtKeywords);

      //IFilm//

      film.Title_es = txtTitle_es.Text;
      film.Title_ca = txtTitle_ca.Text;
      //...

      film.Duration = txtDuration.Text.ToNullableTimeSpan(@"hh\:mm\:ss");

      film.Directors = UI.GetCommaSeparated(txtDirectors);
      film.Scriptwriters = UI.GetCommaSeparated(txtScriptwriters);

      film.ProductionCountries = UI.GetSelected(clistProductionCountries);
      film.ProductionCompanies = UI.GetCommaSeparated(txtProductionCompanies);

      film.BoxOffice = txtBoxOffice.Text;
      film.Year = txtYear.Text.ToNullableInt();

      film.SourceLanguages = UI.GetSelected(clistSourceLanguages);

      film.YearTranslated = txtYearTranslated.Text.ToNullableInt();
      film.DubbedLanguages = UI.GetSelected(clistDubbedLanguages);
      film.SubtitledLanguages = UI.GetSelected(clistSubtitledLanguages);

      //Calculatable from Scenes//

      film.SceneCount = CalculateSceneCount(key);
      film.ScenesDuration = CalculateScenesDuration(key);

      return film;
    }

    public void Save()
    {
      lblInfoUpdated.Text = DateTime.Now.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      filmStorage[listFilms.SelectedValue] = (IFilm)GetMetadataFromUI();
    }

    public void Report()
    {
      Report(Path.Combine(Request.PhysicalApplicationPath, "film/films.cxml"), "Trafilm Gallery Films", Film.MakeFilmFacetCategories(), filmStorage.Values);
    }

    #endregion

    #region Calculated from Scenes

    private int CalculateSceneCount(string key) //TODO
    {
      return sceneStorage.Count;
    }

    private TimeSpan CalculateScenesDuration(string key) //TODO
    {
      TimeSpan duration = TimeSpan.Zero;
      foreach (IScene scene in sceneStorage.Values)
        if (scene.Duration != null)
          duration += (TimeSpan)scene.Duration;
      return duration;
    }

    #endregion

    #endregion

    #region --- Events ---

    protected void listFilms_SelectedIndexChanged(object sender, EventArgs e)
    {
      DisplayMetadata(listFilms.SelectedValue);
    }

    protected void btnAddFilm_Click(object sender, EventArgs e)
    {
      AddFilm();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
      Save();
    }

    #endregion

  }

}