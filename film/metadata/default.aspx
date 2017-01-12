<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.FilmMetadataPage" %>
<%@ Import namespace="Trafilm.Gallery" %>

<!DOCTYPE html>

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: film\metadata\default.aspx
Version: 20170112
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Metadata | Films</title>
    
    <meta name="viewport" content="width=400, user-scalable=yes, initial-scale=1" />

    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <asp:XmlDataSource ID="xmlType" runat="server" DataFile="~/metadata/FilmType.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL1language" runat="server" DataFile="~/metadata/L1language.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlBlockbuster" runat="server" DataFile="~/metadata/Blockbuster.xml" XPath="Facet/String" />      

    <%-- NAVIGATION MENU --%>

    <div class="navigation">
       <a class="selected" href="../../film/metadata/">Film Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../conversation/metadata/?film=<%=listFilms.SelectedValue%>">Conversation Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../L3STinstance/metadata/?film=<%=listFilms.SelectedValue%>">L3ST-instance Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../L3TTinstance/metadata/?film=<%=listFilms.SelectedValue%>">L3TT-instance Metadata</a>
    </div>

    <%-- INSTRUCTION BOX --%>

    <div class="instructions">
      Please fill in the following information for the film of your choice. Select it using the dropdown list.<br />
      Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering film.<br />
      Don't forget to press the SAVE METADATA button. Thank you!
    </div>

    <form id="form1" runat="server">

      <%-- LOGIN STATUS --%>

      <asp:LoginName ID="loginName" runat="server" FormatString="Welcome {0}!" /> [<asp:LoginStatus ID="loginStatus" runat="server"/>]

      <%-- INFO BOX --%>

      <div class="bar">

        <div>
          <div class="label">Select a Film</div> 
          <asp:DropDownList ID="listFilms" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listFilms_SelectedIndexChanged" />
        </div>

        <asp:Panel ID="panelAdd" runat="server">
          <div class="label">or enter a new Film Id (e.g. <i>Ocean's Eleven</i>)</div>
          <asp:TextBox ID="txtFilm" runat="server" MaxLength="50" />
          <br />
          <asp:Button ID="btnAddFilm" runat="server" Text="Add" OnClick="btnAddFilm_Click" />
          &nbsp;
          <asp:CheckBox ID="cbClone" Text="Copy from selected" runat="server" Visible="false" />
          &nbsp;&nbsp;
          <asp:Button ID="btnRename" runat="server" Text="Rename selected" OnClick="btnRename_Click" />
        </asp:Panel>

      </div>

      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="panelMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div class="question" id="Title">
          <div class="label">1. Title</div>
          <div class="tip">
            Full official film title<br />
            For TV series enter series title and season number (e.g. Game of Thrones - Season 01)
          </div>
          <asp:TextBox ID="txtTitle" runat="server" />
        </div>

        <div class="question" id="Description">
          <div class="label">2. Film Description</div>
          <div class="tip">Synopsis and relevant information</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" />
        </div>

        <div class="calculated" id="URL">
          <div class="label">Film URL</div>
          <div class="tip">Metadata item URL, right-click to copy URL address</div>
          <asp:HyperLink ID="linkUrl" runat="server" Target="_blank" />
        </div>

        <div class="question" id="PosterImage">
          <div class="label">3. Film Poster URL</div>
          <div class="tip">Provide a link to an image for the film poster</div>
          <asp:TextBox ID="txtImageUrl" runat="server" />
        </div>


        <%-- IFilmMetadata --%>

        <div class="question" id="Type">
          <div class="label">4. Type</div>
          <div class="tip">Select type of "film" metadata item</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:DropDownList ID="listType" runat="server"
              DataSourceID="xmlType" DataTextField="Value" DataValueField="Value"
              />
           </asp:Panel>
        </div>


        <div class="question" id="Duration">
          <div class="label">5. Duration (min)</div>
          <div class="tip">
            How long does the film last? (in minutes)<br />
            When Type is "TV series season", enter duration of longest episode in that season            
          </div>
          <asp:TextBox ID="txtDuration" runat="server" />
        </div>


        <div class="question" id="Series">
          <div class="label">6. Series</div>
          <div class="tip">
            If the film belongs to a series or 'saga', what is the name for the related series of films?<br />
            When Type is "TV series season", enter the TV series title
          </div>
          <asp:TextBox ID="txtSeries" runat="server" />
        </div>


        <div class="question" id="Directors">
          <div class="label">7. Director(s)</div>
          <div class="tip">Full name(s), insert a comma (,) between different directors</div>
          <asp:TextBox ID="txtDirectors" runat="server" />
        </div>

        <div class="question" id="Scriptwriters">
          <div class="label">8. Scriptwriter(s)</div>
          <div class="tip">Full name(s), insert a comma (,) between different scriptwriters</div>
          <asp:TextBox ID="txtScriptwriters" runat="server" />
        </div>


        <div class="question" id="ProductionCountries">
          <div class="label">9. Production countries</div>
          <div class="tip">Full name(s), insert a comma (,) between different countries</div>
          <asp:TextBox ID="txtProductionCountries" runat="server" />
        </div>

        <div class="question" id="ProductionCompanies">
          <div class="label">10. Production companies</div>
          <div class="tip">Full name, insert a comma (,) between different production companies</div>
          <asp:TextBox ID="txtProductionCompanies" runat="server" />
        </div>


        <div class="question" id="Blockbuster">
          <div class="label">11. Blockbuster</div>
          <div class="tip">Is the film ranked in the top 20 where first released (ST)?</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:DropDownList ID="listBlockbuster" runat="server"
              DataSourceID="xmlBlockbuster" DataTextField="Value" DataValueField="Value"
              />
           </asp:Panel>
        </div>


        <div class="question" id="YearSTreleased">
          <div class="label">12. Year ST released</div>
          <div class="tip">When was the film first released commercially?</div>
          <asp:TextBox ID="txtYear" runat="server" />
        </div>


        <div class="question" id="L1language">
          <div class="label">13. Main (L1) language</div>
          <div class="tip">What is the main language of the film? (used as Source Text for Dubbing or Subtitling)</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:DropDownList ID="listL1language" runat="server"
              DataSourceID="xmlL1language" DataTextField="Value" DataValueField="Value"
              />
           </asp:Panel>
        </div>


        <%-- Calculated from Conversations.L3STinstances.L3TTinstances --%>

        <div class="calculated" id="L2dubbedLanguages">
          <div class="label">L2-Dubbed languages</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:ListBox ID="listL2dubbedLanguages" runat="server" Enabled="false" />
           </asp:Panel>
        </div>
        
        <div class="calculated" id="L2subtitledLanguages">
          <div class="label">L2-Subtitled languages</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:ListBox ID="listL2subtitledLanguages" runat="server" Enabled="false" />
           </asp:Panel>
        </div>   


        <%-- Calculated from Conversations --%>
        
        <%-- //Count shown in parentheses next to title of respective list
        <div class="calculated" id="ConversationCount">
          <div class="label">Count of Conversations (Calculated)</div>
          <asp:Label ID="lblConversationCount" runat="server" />
        </div>
        --%>

        <%-- ITrafilmMetadata --%>


        <%-- //Film Transcription not available for copyright and for metadata size reasons
        <div class="question" id="Transcription">
          <div class="label">14. Transcription </div>
          <div class="tip">Transcription for the whole film</div>
          <asp:TextBox ID="txtTranscription" runat="server" TextMode="MultiLine" Rows="5" />
        </div>
        --%>

        <div class="question" id="Tags">
          <div class="label">14. Tags</div>
          <div class="tip">Keywords or other labels for filtering purposes, insert a comma (,) between different ones</div>
          <asp:TextBox ID="txtTags" runat="server" />
        </div>

        <div class="question" id="Remarks">
          <div class="label">15. Remarks</div>
          <div class="tip">Issues concerning the analysis or the metadata form design</div>
          <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Rows="5" />
        </div>


        <div class="calculated" id="InfoDates">
          <span class="label">Info created: </span>
          <asp:Label ID="lblInfoCreated" runat="server" />

          <span class="label"> - Info Updated: </span>
          <asp:Label ID="lblInfoUpdated" runat="server" />
        </div>

        <div class="calculated" id="MetadataEditors">
          <div class="label">Metadata Editors</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:ListBox ID="listMetadataEditors" runat="server" Enabled="false" />
           </asp:Panel>
        </div>


        <%-- SAVE BUTTON --%>
           
        <asp:Panel ID="panelSave" runat="server">
          <br />
          <asp:Button ID="btnSave" runat="server"
            Text="Save metadata"
            Font-Bold="true"
            height="50"
            OnClick="btnSave_Click"
            />
          &nbsp;
          &nbsp;
          <i>Gallery contents are updated periodically during the day from saved metadata</i>
          <br /><br />
        </asp:Panel>


        <%-- Conversations list --%>                  

        <div class="calculated" id="Conversations">
          <div class="label">Conversations (#<asp:Label ID="lblConversationCount" runat="server" />)</div>
          <asp:Repeater ID="repeaterConversations" runat="server">
            <ItemTemplate>
              <a href="../../conversation/metadata/?film=<%#Eval("filmId")%>&conversation=<%#Eval("conversationId")%>"><%#Eval("conversationId").ToString().TrimStart(Eval("filmId").ToString() + ".")%></a>&nbsp;&nbsp;
            </ItemTemplate>
          </asp:Repeater>
        </div>


        <%-- EXTRA PADDING AT THE END --%>
        <br />
        <br />

      </asp:Panel>
    
    </form>

  </body>

</html>
