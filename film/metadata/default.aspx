<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.FilmMetadataPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: film\metadata\default.aspx
Version: 20160516
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
       <a class="selected" href="../../film/metadata/">Film Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../scene/metadata/?film=<%=listFilms.SelectedValue%>">Conversation Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../utterance/metadata/?film=<%=listFilms.SelectedValue%>">L3occurence Metadata</a>
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

        <div>
          <div class="label">Select a Film</div> 
          <asp:DropDownList ID="listFilms" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listFilms_SelectedIndexChanged" />
        </div>

        <div>
          <div class="label">or enter a new Film Id</div>
          <asp:TextBox ID="txtFilm" runat="server" />
          <asp:Button ID="btnAddFilm" runat="server" Text="Add" OnClick="btnAddFilm_Click" />
        </div>

      </div>

      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="panelMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div class="question">
          <div class="label">Film Title</div>
          <asp:TextBox ID="txtTitle" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">Film Description</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <div class="label">Film URL</div>
        <asp:HyperLink ID="linkUrl" runat="server" Target="_blank"/>
    
        <div>
          <span class="label">Info created: </span>
          <asp:Label ID="lblInfoCreated" runat="server" />

          <span class="label"> - Info Updated: </span>
          <asp:Label ID="lblInfoUpdated" runat="server" />
        </div>

        <%-- ITrafilmMetadata --%>

        <div class="question">
          <div class="label">Keywords (comma-separated)</div>
          <asp:TextBox ID="txtKeywords" runat="server" Columns="150"></asp:TextBox>
        </div>

        <%-- IFilmMetadata --%>

        <div class="question">
          <div class="label">Title in Spanish</div>
          <asp:TextBox ID="txtTitle_es" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">Title in Catalan</div>
          <asp:TextBox ID="txtTitle_ca" runat="server" Columns="150"></asp:TextBox>
        </div>

        <%-- ... --%>


        <div class="question">
          <div class="label">Film duration (h:m:s.f)</div>
          <asp:TextBox ID="txtDuration" runat="server"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">Directors (comma-separated)</div>
          <asp:TextBox ID="txtDirectors" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">Scriptwriters (comma-separated)</div>
          <asp:TextBox ID="txtScriptwriters" runat="server" Columns="150"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">Production countries</div>
          <asp:Panel runat="server" ScrollBars="Auto" Height="100">
            <asp:CheckBoxList ID="clistProductionCountries" runat="server" 
              DataSourceID="xmlCountries" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">Production companies (comma-separated)</div>
          <asp:TextBox ID="txtProductionCompanies" runat="server" Columns="150"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">Box office</div>
          <asp:TextBox ID="txtBoxOffice" runat="server"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">Year released</div>
          <asp:TextBox ID="txtYear" runat="server"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">Source languages</div>
          <asp:Panel runat="server" Height="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistSourceLanguages" runat="server" 
              DataSourceID="xmlLanguages" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">Year translated</div>
          <asp:TextBox ID="txtYearTranslated" runat="server"></asp:TextBox>
        </div>
        
        <div class="question">
          <div class="label">Dubbed languages</div>
          <asp:Panel runat="server" Height="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistDubbedLanguages" runat="server" 
              DataSourceID="xmlLanguages" DataTextField="Value" DataValueField="Value" 
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"
              />
           </asp:Panel>
        </div>
        
        <div class="question">
          <div class="label">Subtitled languages</div>
          <asp:Panel runat="server" Height="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistSubtitledLanguages" runat="server" 
              DataSourceID="xmlLanguages" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>   
        

        <%-- Calculated from Conversations --%>
        
        <div>
          <div class="label">Conversations' duration (h:m:s.f) (Calculated from Conversations)</div>
          <asp:Label ID="lblConversationsDuration" runat="server"></asp:Label>
        </div>                            

        <div>
          <div class="label">Count of Conversations (Calculated)</div>
          <asp:Label ID="lblConversationCount" runat="server"></asp:Label>
        </div>


       <%-- Conversations list --%>                  

        <asp:Repeater ID="repeaterConversations" runat="server">
          <HeaderTemplate>
            <div class="label">List of Conversations<div>
          </HeaderTemplate>
          <ItemTemplate>
            <a href="../../scene/metadata/?film=<%#Eval("filmId")%>&scene=<%#Eval("sceneId")%>"><%#Eval("sceneId")%></a>&nbsp;&nbsp;
          </ItemTemplate>
        </asp:Repeater>


        <%-- SAVE BUTTON --%>
           
        <div>
          <asp:Button ID="btnSave" runat="server"
            Text="Save metadata"
            Font-Bold="true"
            height="50"
            OnClick="btnSave_Click"
            />
        </div>

        <%-- EXTRA PADDING AT THE END --%>
        <br />
        <br />

      </asp:Panel>
    
    </form>

  </body>

</html>
