//Project: Trafilm.Gallery (http://trafilm.net)
//Filename: utterance\metadata\default.aspx.cs
//Version: 20160510

using Trafilm.Metadata;
using Trafilm.Metadata.Models;
using Metadata.CXML;

using System;
using System.IO;
using System.Linq;
using System.Web;
using System.Globalization;
using System.Collections.Generic;

namespace Trafilm.Gallery
{
  public partial class UtteranceMetadataPage : BaseMetadataPage
  {

    private string path = HttpContext.Current.Server.MapPath("~/utterance/metadata");

    protected void Page_Load(object sender, EventArgs e)
    {
      _listItems = listUtterances; //allow the ancestor class to access our listUtterances UI object 
      
      if (!IsPostBack)
      {
        var itemPleaseSelect = new[] { new { Filename = "* Please select..." } };

        var items = Directory.EnumerateFiles(path, "*.cxml") //Available in .NET4, more efficient than GetFiles
                             .Select(f => new { Filename = Path.GetFileName(f) });

        listUtterances.DataSource = itemPleaseSelect.Concat(items);

        listUtterances.DataBind(); //must call this

        if (Request.QueryString["item"] != null)
          listUtterances.SelectedValue = Request.QueryString["item"]; //must do after listUtterances.DataBind
      }
    }
  
    protected void listUtterances_SelectedIndexChanged(object sender, EventArgs e)
    {
      UpdateSelection();
    }

    protected void listFilm_SelectedIndexChanged(object sender, EventArgs e)
    {
      //TODO: update scene selection dropdown list from film
    }

    protected void listScene_SelectedIndexChanged(object sender, EventArgs e)
    {
     //TODO: update selected Film from Scene
    }

    #region UI

    public override void ShowMetadataUI(bool visible)
    {
      if (uiMetadata != null)
        uiMetadata.Visible = visible;

      linkUrl.Visible = visible;
    }

    #endregion

    #region --- Load ---

    public override void DisplayMetadata(string key)
    {
      DisplayMetadata(key, LoadUtterance(key));
    }

    private IUtterance LoadUtterance(string key)
    {
      throw new NotImplementedException(); //TODO
    }

    public void DisplayMetadata(string key, IUtterance utterance)
    {
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

      UI.Load(listL3type, utterance.L3type);

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

    #region --- Save ---

    public override ICXMLMetadata ExtractMetadata(string key)
    {
      IUtterance utterance = new Utterance();

      //ICXMLMetadata//

      utterance.Title = txtTitle.Text;
      utterance.Image = "../utterance/" + key + "/" + key + "_thumb.jpg"; //TODO
      utterance.Url = new Uri("http://gallery.trafilm.net/?utterance=" + key); //TODO: could set to jump to movie time
      utterance.Description = txtDescription.Text;

      //ITrafilmMetadata//

      utterance.ReferenceId = key;
      string folderPath = Path.Combine(path, key); //TODO
      utterance.InfoCreated = DateTime.ParseExact(lblInfoCreated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      utterance.InfoUpdated = DateTime.ParseExact(lblInfoUpdated.Text, CXML.DEFAULT_DATETIME_FORMAT, CultureInfo.InvariantCulture);
      utterance.Keywords = UI.GetCommaSeparated(txtKeywords);

      //IUtterance//

      utterance.SceneReferenceId = listScenes.SelectedValue;

      utterance.FilmReferenceId = listFilms.SelectedValue;
      utterance.SceneReferenceId = listScenes.SelectedValue;

      utterance.L3type = listL3type.SelectedValue;

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

    protected void btnSave_Click(object sender, EventArgs e)
    {
      lblInfoUpdated.Text = DateTime.Now.ToString(CXML.DEFAULT_DATETIME_FORMAT);
      DoSave();
    }

    public override void Report()
    {
      Report("../utterances.cxml", "Trafilm Gallery Utterances", Utterance.MakeUtteranceFacetCategories(), LoadUtterances());
    }

    private IEnumerable<ICXMLMetadata> LoadUtterances()
    {
      throw new NotImplementedException(); //TODO
    }

    #endregion

  }

}