<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FilmMetadataPage.aspx.cs" Inherits="Trafilm.Gallery.FilmMetadataPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
Project: Trafilm.Gallery (http://trafilm.net)
Filename: film\metadata\default.aspx
Version: 20160509
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Gallery - Film Metadata</title>

    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>
    <asp:XmlDataSource ID="xmlCountries" runat="server" DataFile="~/metadata/Countries.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlLanguages" runat="server" DataFile="~/metadata/Languages.xml" XPath="Facet/String" />

    <%-- NAVIGATION MENU --%>
    <div class="navigation">
       <a href="../../film/metadata/">Film Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a class="selected" href="../../scene/metadata/">Scene Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../utterance/metadata/">Utterance Metadata</a>
    </div>

    <%-- INSTRUCTION BOX --%>
    <div class="instructions">
    Please fill in the following information for the clip of your choice. Select the clip from the dropdown list.<br />
    Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering clips.<br />
    Don't forget to press the SAVE METADATA button. Thank you!
    </div>

    <form id="form1" runat="server">

      <%-- INFO BOX --%>
      <div class="bar">

        <div class="label">Film</div> 
        <asp:DropDownList ID="listFilms" runat="server" AutoPostBack="True" 
          DataTextField="Filename" DataValueField="Filename" 
          OnSelectedIndexChanged="listFilms_SelectedIndexChanged"
          />

        <br />

        <div class="label">Url</div>
        <asp:HyperLink ID="linkUrl" runat="server" Target="_blank"/>
    
        <div>
          <span class="label"><%=Trafilm.Metadata.TrafilmMetadataFacets.FACET_INFO_CREATED%>: </span>
          <asp:Label ID="lblInfoCreated" runat="server" />
          <span class="label"> - <%=Trafilm.Metadata.TrafilmMetadataFacets.FACET_INFO_UPDATED%>: </span>
          <asp:Label ID="lblInfoUpdated" runat="server" />
        </div>

      </div>

      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="uiMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div>
          <div class="label">Title</div>
          <asp:TextBox ID="txtTitle" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div>
          <div class="label">Description</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <%-- ITrafilmMetadata --%>

        <div>
          <div class="label"><%=Trafilm.Metadata.TrafilmMetadataFacets.FACET_KEYWORDS%> (comma-separated)</div>
          <asp:TextBox ID="txtKeywords" runat="server" Columns="150"></asp:TextBox>
        </div>

        <%-- IFilmMetadata --%>

        <div>
          <div class="label"><%=Trafilm.Metadata.FilmMetadataFacets.FACET_TITLE_ES%></div>
          <asp:TextBox ID="txtTitle_es" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div>
          <div class="label"><%=Trafilm.Metadata.FilmMetadataFacets.FACET_TITLE_CA%></div>
          <asp:TextBox ID="txtTitle_ca" runat="server" Columns="150"></asp:TextBox>
        </div>

        <%-- ... --%>


        <div>
          <div class="label"><%=Trafilm.Metadata.FilmMetadataFacets.FACET_DURATION%></div>
          <asp:TextBox ID="txtDuration" runat="server"></asp:TextBox>
        </div>


        <div>
          <div class="label"><%=Trafilm.Metadata.FilmMetadataFacets.FACET_DIRECTORS%> (comma-separated)</div>
          <asp:TextBox ID="txtDirectors" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div>
          <div class="label"><%=Trafilm.Metadata.FilmMetadataFacets.FACET_SCRIPTWRITERS%> (comma-separated)</div>
          <asp:TextBox ID="txtScriptwriters" runat="server" Columns="150"></asp:TextBox>
        </div>


        <div style="float: left">
          <div class="label"><%=Trafilm.Metadata.FilmMetadataFacets.FACET_PRODUCTION_COUNTRIES%></div>
          <asp:Panel runat="server" 
            Height="450" Width="250"
            ScrollBars="Auto"
            >
            <asp:CheckBoxList ID="clistProductionCountries" runat="server" 
              DataSourceID="xmlCountries" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>

        <div>
          <div class="label"><%=Trafilm.Metadata.FilmMetadataFacets.FACET_PRODUCTION_COMPANIES%> (comma-separated)</div>
          <asp:TextBox ID="txtProductionCompanies" runat="server" Columns="150"></asp:TextBox>
        </div>


        <div>
          <div class="label"><%=Trafilm.Metadata.FilmMetadataFacets.FACET_BOX_OFFICE%></div>
          <asp:TextBox ID="txtBoxOffice" runat="server"></asp:TextBox>
        </div>

        <div>
          <div class="label"><%=Trafilm.Metadata.FilmMetadataFacets.FACET_YEAR%></div>
          <asp:TextBox ID="txtYear" runat="server"></asp:TextBox>
        </div>


        <div style="float: left">
          <div class="label"><%=Trafilm.Metadata.FilmMetadataFacets.FACET_SOURCE_LANGUAGES%></div>
          <asp:Panel runat="server" 
            Height="450" Width="250"
            ScrollBars="Auto"
            >
            <asp:CheckBoxList ID="clistSourceLanguages" runat="server" 
              DataSourceID="xmlLanguages" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>


        <div>
          <div class="label"><%=Trafilm.Metadata.FilmMetadataFacets.FACET_YEAR_TRANSLATED%></div>
          <asp:TextBox ID="txtYearTranslated" runat="server"></asp:TextBox>
        </div>
        
        <div style="float: left">
          <div class="label"><%=Trafilm.Metadata.FilmMetadataFacets.FACET_DUBBED_LANGUAGES%></div>
          <asp:Panel runat="server" 
            Height="450" Width="250"
            ScrollBars="Auto"
            >
            <asp:CheckBoxList ID="clistDubbedLanguages" runat="server" 
              DataSourceID="xmlLanguages" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>
        
        <div style="float: left">
          <div class="label"><%=Trafilm.Metadata.FilmMetadataFacets.FACET_SUBTITLED_LANGUAGES%></div>
          <asp:Panel runat="server" 
            Height="450" Width="250"
            ScrollBars="Auto"
            >
            <asp:CheckBoxList ID="clistSubtitledLanguages" runat="server" 
              DataSourceID="xmlLanguages" DataTextField="Value" DataValueField="Value" 
              />
           </asp:Panel>
        </div>   
        

        <%-- Calculatable from Scenes --%>

        <div>
          <div class="label"><%=Trafilm.Metadata.FilmMetadataFacets.FACET_SCENE_COUNT%></div>
          <asp:Label ID="lblSceneCount" runat="server"></asp:Label>
        </div>
        
        <div>
          <div class="label"><%=Trafilm.Metadata.FilmMetadataFacets.FACET_SCENES_DURATION%></div>
          <asp:Label ID="lblScenesDuration" runat="server"></asp:Label>
        </div>                            


        <%-- SAVE BUTTON --%>
           
        <div>
          <asp:Button ID="btnSave" runat="server"
            Text="Save metadata"
            Font-Bold="true"
            height="50"
            OnClick="btnSave_Click"
            />
          &nbsp;
          &nbsp;
          <i>Gallery contents are updated once a day from saved metadata</i>
        </div>

        <%-- EXTRA PADDING AT THE END --%>
        <br />
        <br />

      </asp:Panel>
    
    </form>

  </body>

</html>
