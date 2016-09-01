<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.FilmMetadataPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: film\metadata\default.aspx
Version: 20160901
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Metadata | Films</title>

    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <asp:XmlDataSource ID="XmlL1language" runat="server" DataFile="~/metadata/L1language.xml" XPath="Facet/String" />

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
      Please fill in the following information for the film of your choice. Select the film from the dropdown list.<br />
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
          <asp:TextBox ID="txtFilm" runat="server" />
          <asp:Button ID="btnAddFilm" runat="server" Text="Add" OnClick="btnAddFilm_Click" />
          &nbsp;
          <asp:CheckBox ID="cbClone" Text="Copy from selected" runat="server" Visible="false" />
          &nbsp;
          <asp:Button ID="btnRename" runat="server" Text="Rename selected" OnClick="btnRename_Click" />
        </asp:Panel>

      </div>

      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="panelMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div class="question">
          <div class="label">1. Film Title</div>
          <div class="tip">Full official film title</div>
          <asp:TextBox ID="txtTitle" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">2. Film Description</div>
          <div class="tip">Synopsis and relevant information</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <div class="label">Film URL</div>
        <asp:HyperLink ID="linkUrl" runat="server" Target="_blank"/>

        <div class="question">
          <div class="label">3. Film Poster URL</div>
          <div class="tip">Provide a link to an image for the film poster</div>
          <asp:TextBox ID="txtImageUrl" runat="server" Columns="150"></asp:TextBox>
        </div>


        <%-- IFilmMetadata --%>

        <div class="question">
          <div class="label">0. Title in Spanish</div>
          <asp:TextBox ID="txtTitle_es" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">0. Title in Catalan</div>
          <asp:TextBox ID="txtTitle_ca" runat="server" Columns="150"></asp:TextBox>
        </div>

        <%-- ... --%>


        <div class="question">
          <div class="label">4. Film duration (h:m:s)</div>
          <div class="tip">How long does the film last? (in hours:minutes:seconds)</div>
          <asp:TextBox ID="txtDuration" runat="server"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">5. Director(s)</div>
          <div class="tip">Full name(s), insert a comma (,) between different directors</div>
          <asp:TextBox ID="txtDirectors" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">6. Scriptwriter(s)</div>
          <div class="tip">Full name(s), insert a comma (,) between different scriptwriters</div>
          <asp:TextBox ID="txtScriptwriters" runat="server" Columns="150"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">7. Production countries</div>
          <div class="tip">Full name(s), insert a comma (,) between different countries</div>
          <asp:TextBox ID="txtProductionCountries" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">8. Production companies</div>
          <div class="tip">Full name, insert a comma (,) between different production companies</div>
          <asp:TextBox ID="txtProductionCompanies" runat="server" Columns="150"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">9. Box office</div>
          <div class="tip">Box office (ticket sales in US Dollars) where the film was originally released</div>
          <asp:TextBox ID="txtBoxOffice" runat="server"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">10. Year ST released</div>
          <div class="tip">When was the film first released commercially?</div>
          <asp:TextBox ID="txtYear" runat="server"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">11. Main (L1) language</div>
          <div class="tip">What is the main language of the film? (used as Source Text for Dubbing or Subtitling)</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:DropDownList ID="listL1language" runat="server"
              DataSourceID="xmlL1language" DataTextField="Value" DataValueField="Value"
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">0. Year TT released in Spain</div>
          <asp:TextBox ID="txtYearTranslated" runat="server"></asp:TextBox>
        </div>
                

        <%-- Calculated from Conversations.L3STinstances.L3TTinstances --%>

        <div>
          <div class="label">L2-Dubbed languages</div>
          <asp:Panel runat="server" ScrollBars="Auto" Style="max-height: 100px">
            <asp:ListBox ID="listL2dubbedLanguages" runat="server" Enabled="false" />
           </asp:Panel>
        </div>
        
        <div>
          <div class="label">L2-Subtitled languages</div>
          <asp:Panel runat="server" ScrollBars="Auto" Style="max-height: 100px">
            <asp:ListBox ID="listL2subtitledLanguages" runat="server" Enabled="false" />
           </asp:Panel>
        </div>   


        <%-- Calculated from Conversations --%>
        
        <div>
          <div class="label">Conversations' duration (h:m:s) (Calculated from Conversations)</div>
          <asp:Label ID="lblConversationsDuration" runat="server"></asp:Label>
        </div>                            

        <div>
          <div class="label">Count of Conversations (Calculated)</div>
          <asp:Label ID="lblConversationCount" runat="server"></asp:Label>
        </div>


        <%-- ITrafilmMetadata --%>

        <asp:Panel ID="panelNoFilmTranscription" runat="server" Visible="false"> <%-- Film Transcription not available for copyright reasons --%>
          <div class="question">
            <div class="label">xx. Transcription </div>
            <div class="tip">Transcription for the whole film</div>
            <asp:TextBox ID="txtTranscription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
          </div>
        </asp:Panel>

        <div class="question">
          <div class="label">12. Tags</div>
          <div class="tip">Keywords or other labels for filtering purposes, insert a comma (,) between different ones</div>
          <asp:TextBox ID="txtKeywords" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">13. Remarks</div>
          <div class="tip">Issues concerning the analysis or the metadata form design</div>
          <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>


        <div>
          <span class="label">Info created: </span>
          <asp:Label ID="lblInfoCreated" runat="server" />

          <span class="label"> - Info Updated: </span>
          <asp:Label ID="lblInfoUpdated" runat="server" />
        </div>

        <div>
          <div class="label">Metadata Editors</div>
          <asp:Panel runat="server" ScrollBars="Auto" Style="max-height: 100px">
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
          <br />
        </asp:Panel>

        <br />

        <%-- Conversations list --%>                  

        <div>
          <asp:Repeater ID="repeaterConversations" runat="server">
            <HeaderTemplate>
              <div class="label">List of Conversations<div>
            </HeaderTemplate>
            <ItemTemplate>
              <a href="../../conversation/metadata/?film=<%#Eval("filmId")%>&conversation=<%#Eval("conversationId")%>"><%#Eval("conversationId")%></a>&nbsp;&nbsp;
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
