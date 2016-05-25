<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.FilmMetadataPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: film\metadata\default.aspx
Version: 20160525
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Gallery - Film Metadata</title>

    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <asp:XmlDataSource ID="xmlCountries" runat="server" DataFile="~/metadata/Countries.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="XmlL1language" runat="server" DataFile="~/metadata/L1language.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlLanguages" runat="server" DataFile="~/metadata/Languages.xml" XPath="Facet/String" />

    <%-- NAVIGATION MENU --%>

    <div class="navigation">
       <a class="selected" href="../../film/metadata/">Film Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../conversation/metadata/?film=<%=listFilms.SelectedValue%>">Conversation Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../L3SToccurrence/metadata/?film=<%=listFilms.SelectedValue%>">L3ST-occurrence Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../L3TToccurrence/metadata/?film=<%=listFilms.SelectedValue%>">L3TT-occurrence Metadata</a>
    </div>

    <%-- INSTRUCTION BOX --%>

    <div class="instructions">
      Please fill in the following information for the film of your choice. Select the film from the dropdown list.<br />
      Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering film.<br />
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
          &nbsp;
          <asp:CheckBox ID="cbClone" Text="Copy from selected" runat="server" Visible="false" />
        </div>

      </div>

      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="panelMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div class="question">
          <div class="label">1. Film Title</div>
          <asp:TextBox ID="txtTitle" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">2. Film Description</div>
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
          <div class="label">3. Keywords (comma-separated)</div>
          <div class="tip">Enter OPTIONAL list of keywords to help identify this item</div>
          <asp:TextBox ID="txtKeywords" runat="server" Columns="150"></asp:TextBox>
        </div>

        <%-- IFilmMetadata --%>

        <div class="question">
          <div class="label">4. Title in Spanish</div>
          <asp:TextBox ID="txtTitle_es" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">5. Title in Catalan</div>
          <asp:TextBox ID="txtTitle_ca" runat="server" Columns="150"></asp:TextBox>
        </div>

        <%-- ... --%>


        <div class="question">
          <div class="label">6. Film duration (h:m:s)</div>
          <asp:TextBox ID="txtDuration" runat="server"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">7. Directors (comma-separated)</div>
          <asp:TextBox ID="txtDirectors" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">8. Scriptwriters (comma-separated)</div>
          <asp:TextBox ID="txtScriptwriters" runat="server" Columns="150"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">9. Production countries</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistProductionCountries" runat="server" 
              DataSourceID="xmlCountries" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"
              />
           </asp:Panel>
        </div>

        <div class="question">
          <div class="label">10. Production companies (comma-separated)</div>
          <asp:TextBox ID="txtProductionCompanies" runat="server" Columns="150"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">11. Box office</div>
          <div class="tip">Box office where the film was originally released</div>
          <asp:TextBox ID="txtBoxOffice" runat="server"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">12. Year released</div>
          <asp:TextBox ID="txtYear" runat="server"></asp:TextBox>
        </div>


        <div class="question">
          <div class="label">13. L1/Source language</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:DropDownList ID="listL1language" runat="server"
              DataSourceID="xmlL1language" DataTextField="Value" DataValueField="Value"
              />
           </asp:Panel>
        </div>


        <div class="question">
          <div class="label">14. Year translated</div>
          <asp:TextBox ID="txtYearTranslated" runat="server"></asp:TextBox>
        </div>
        
        <div class="question">
          <div class="label">15. L2-Dubbed languages</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL2dubbedLanguages" runat="server" 
              DataSourceID="xmlLanguages" DataTextField="Value" DataValueField="Value" 
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"
              />
           </asp:Panel>
        </div>
        
        <div class="question">
          <div class="label">16. L2-Subtitled languages</div>
          <asp:Panel runat="server" MaxHeight="100" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL2subtitledLanguages" runat="server" 
              DataSourceID="xmlLanguages" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="10" RepeatDirection="Vertical"               
              />
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


       <%-- Conversations list --%>                  

        <asp:Repeater ID="repeaterConversations" runat="server">
          <HeaderTemplate>
            <div class="label">List of Conversations<div>
          </HeaderTemplate>
          <ItemTemplate>
            <a href="../../conversation/metadata/?film=<%#Eval("filmId")%>&conversation=<%#Eval("conversationId")%>"><%#Eval("conversationId")%></a>&nbsp;&nbsp;
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
