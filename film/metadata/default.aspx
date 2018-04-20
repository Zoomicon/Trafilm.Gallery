<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.FilmMetadataPage" %>
<%@ Import namespace="Trafilm.Gallery" %>

<!DOCTYPE html>

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: film\metadata\default.aspx
Version: 20180205
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


    <%-- WEBFORM --%>

    <form id="form1" defaultbutton="btnSave" defaultfocus="listFilms" runat="server">

      <%-- STATUS MESSAGE --%>

      <asp:Panel runat="server" ID="panelStatus" CssClass="status" Visible="false">
        <asp:Label ID="labelStatus" runat="server"/>
      </asp:Panel>


      <%-- NAVIGATION MENU --%>

      <div class="navigation">
        <a href="http://trafilm.net" target="trafilm"><img src="http://trafilm.net/App_Themes/trafilm/img/logo.png" height="18" /></a>
        <a class="selected" href="../../film/metadata/">Films</a>
        <a href="../../conversation/metadata/?film=<%=listFilms.SelectedValue%>">Conversations</a>
        <a href="../../L3STinstance/metadata/?film=<%=listFilms.SelectedValue%>">L3ST-instances</a>
        <a href="../../L3TTinstance/metadata/?film=<%=listFilms.SelectedValue%>">L3TT-instances</a>
        <a href="https://repositori.upf.edu/handle/10230/28223" target="trafilm guide" class="guide">Guide</a>
      </div>


      <%-- LOGIN STATUS --%>

      <div>
        <asp:LoginName ID="loginName" runat="server" FormatString="Welcome {0}!" /> [<asp:LoginStatus ID="loginStatus" runat="server"/>]
      </div>


      <%-- INSTRUCTION BOX --%>

      <asp:Panel ID="panelInstructions" runat="server" Visible="false" CssClass="instructions">
        Please fill in the following information for the film of your choice. Select it using the dropdown list.<br />
        Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering film.<br />
        Don't forget to press the SAVE METADATA button. Thank you!
      </asp:Panel>


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
            <a href="#Title" class="openhelp">&#x26e8;</a>
            <div class="help">
              Select a title from the gallery to complete missing data for that title, OR, introduce a new film title. 
              Type in the official title name for the new title as it appeared for the Source Text (e.g. Inglourious Basterds). 
              Copy from Imdb or similar source. Press the “add” button if you are adding a new Film or TV Title.
            </div>
          </div>
          <asp:TextBox ID="txtTitle" runat="server" />
        </div>

        <div class="question" id="Description">
          <div class="label">2. Film Description</div>
          <div class="tip">
            Synopsis and relevant information
            <a href="#Description" class="openhelp">&#x26e8;</a>
            <div class="help">
              Essential information to identify the film and its basic characteristics.
              Type in text freely or copy from a trusted source (attributing the source).
            </div>
          </div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" />
        </div>

        <div class="calculated" id="URL">
          <div class="label">Film URL</div>
          <div class="tip">Metadata item URL, right-click to copy URL address</div>
          <asp:HyperLink ID="linkUrl" runat="server" Target="_blank" />
        </div>

        <div class="question" id="PosterImage">
          <div class="label">3. Film Poster URL</div>
          <div class="tip">
            Provide a link to an image for the film poster
            <a href="#PosterImage" class="openhelp">&#x26e8;</a>
            <div class="help">
              The image is essential in order to visualize the film in the TraFilm Gallery.
              The image must be a link ending in .jpg. It is advisable to search for the film title in Wikipedia;
              click on the poster or the film and then click on the image again.
              The URL you have to copy starts with https://upload.wikimedia.org/wikipedia... 
            </div>
          </div>
          <asp:TextBox ID="txtImageUrl" runat="server" />
        </div>


        <%-- IFilmMetadata --%>

        <div class="question" id="Type">
          <div class="label">4. Type</div>
          <div class="tip">
            Select type of "film" metadata item
            <a href="#Type" class="openhelp">&#x26e8;</a>
            <div class="help">
              TraFilm mainly focuses on feature films but will also accept short films or TV films and series.
              TV series must be entered at this level by season,
              i.e. each full season for a TV series is treated as “one film”.
            </div>
          </div>
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
            <a href="#Duration" class="openhelp">&#x26e8;</a>
            <div class="help">
              Type in just 3 digits, (e.g. 115) to show how long the films lasts, measured in minutes, or two digits if 
              the film lasts less than 100 minutes (e.g. 88). This item is a bit like asking how many pages a book 
              has. In another form you will be asked to enter in the Conversation Start Time, also as minutes. 
              You must make sure that your film duration is always a higher number than any Conversation Start 
              Time, for the analysis to be coherent.
            </div>
          </div>
          <asp:TextBox ID="txtDuration" runat="server" />
        </div>


        <div class="question" id="Series">
          <div class="label">6. Series</div>
          <div class="tip">
            If the film belongs to a series or 'saga', what is the name for the related series of films?<br />
            When Type is "TV series season", enter the TV series title
            <a href="#Series" class="openhelp">&#x26e8;</a>
            <div class="help">
              For example, for the Series Game of Thrones, you just type in “Game of Thrones”.
              That way all seasons of the same series will be linked by this item.
            </div>
          </div>
          <asp:TextBox ID="txtSeries" runat="server" />
        </div>


        <div class="question" id="Directors">
          <div class="label">7. Director(s)</div>
          <div class="tip">
            Full name(s), insert a comma (,) between different directors
            <a href="#Directors" class="openhelp">&#x26e8;</a>
            <div class="help">
              Type in the film director’s given name and family name. If there is more than one director, 
              separate each director’s name by using commas (,). The system interprets the comma sign as separating
              different values or answers within the text of the same item (question).
            </div>
          </div>
          <asp:TextBox ID="txtDirectors" runat="server" />
        </div>

        <div class="question" id="Scriptwriters">
          <div class="label">8. Scriptwriter(s)</div>
          <div class="tip">
            Full name(s), insert a comma (,) between different scriptwriters
            <a href="#Scriptwriters" class="openhelp">&#x26e8;</a>
            <div class="help">
              Provide the scriptwriter’s given name and family name. If there is more than one scriptwriter, 
              separate each full name by using commas (,). The system interprets the comma sign as separating
              different values or answers within the text of the same item (question).
            </div>
          </div>
          <asp:TextBox ID="txtScriptwriters" runat="server" />
        </div>


        <div class="question" id="ProductionCountries">
          <div class="label">9. Production countries</div>
          <div class="tip">
            Full name(s), insert a comma (,) between different countries
            <a href="#ProductionCountries" class="openhelp">&#x26e8;</a>
            <div class="help">
              Provide the name of the production country, in English. If there is more than one country, 
              separate each one by using commas (,). The system interprets the comma sign as separating 
              different values or answers within the “free” text answering the same item (question).
            </div>
          </div>
          <asp:TextBox ID="txtProductionCountries" runat="server" />
        </div>

        <div class="question" id="ProductionCompanies">
          <div class="label">10. Production companies</div>
          <div class="tip">
            Full name, insert a comma (,) between different production companies
            <a href="#ProductionCompanies" class="openhelp">&#x26e8;</a>
            <div class="help">
              Provide the name of the production company. If there is more than one company, separate each 
              one by using commas (,). The system interprets the comma sign as separating different values or
              answers within the text of the same item (question).
            </div>
          </div>
          <asp:TextBox ID="txtProductionCompanies" runat="server" />
        </div>


        <div class="question" id="Blockbuster">
          <div class="label">11. Blockbuster</div>
          <div class="tip">
            Is the film ranked in the top 20 where first released (ST)?
            <a href="#Blockbuster" class="openhelp">&#x26e8;</a>
            <div class="help">
              Choose one of the three options provided. This item is repeated in Form 4 (L3TT-instance Metadata), for comparison.
            </div>
          </div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:DropDownList ID="listBlockbuster" runat="server"
              DataSourceID="xmlBlockbuster" DataTextField="Value" DataValueField="Value"
              />
           </asp:Panel>
        </div>


        <div class="question" id="YearSTreleased">
          <div class="label">12. Year ST released</div>
          <div class="tip">
            When was the film first released commercially?
            <a href="#YearSTreleased" class="openhelp">&#x26e8;</a>
            <div class="help">
              Type in the year the film production was first released. This item is repeated in Form 4
              (L3TT-instance Metadata), for comparison.
            </div>
          </div>
          <asp:TextBox ID="txtYear" runat="server" />
        </div>


        <div class="question" id="L1language">
          <div class="label">13. Main language (L1)</div>
          <div class="tip">
            What is the main language of the film? (used as Source Text for Dubbing or Subtitling)
            <a href="#L1language" class="openhelp">&#x26e8;</a>
            <div class="help"> <!-- TODO: check again text -->
              Choose from list of languages. L1 is the main language of the ST and this item is “mirrored” in Form 4 as “L2 language, what language is L2 in?”,
              asking for the main language of the TT, to enable a direct connection between L1 and the L2s of its corresponding translated versions. This item (L1)
              is thus the “parent” of every version of it (each case of L2) according to how many different languages and AVT types (i.e. dubbing, subtitling, audio description, subtitling SDH)
              are introduced into the database. When inserting a language, please specify in order of more general to more specific, in those cases that need specifying; e.g. Spanish South American Chile,
              or English US Southern Georgia. Only be as specific as you need to be and know for sure. 
            </div>
          </div>
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
        
        <%-- ConversationCount shown in parentheses next to title of respective list below --%>


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
          <div class="tip">
            Keywords or other labels for filtering purposes, insert a comma (,) between different ones
            <a href="#Tags" class="openhelp">&#x26e8;</a>
            <div class="help">
              This item is repeated in every form, and is meant to be used by analysts to either
              (i) signal special distinguishing features,
                  especially those which are not picked up by the answers to all of the other items; or 
              (ii) to personalise a researcher’s own special interest so that a “corpus” may be retrieved through certain keywords.
            </div>
          </div>
          <asp:TextBox ID="txtTags" runat="server" />
        </div>

        <div class="question" id="Remarks">
          <div class="label">15. Remarks</div>
          <div class="tip">
            Issues concerning the analysis or the metadata form design
            <a href="#Remarks" class="openhelp">&#x26e8;</a>
            <div class="help">
              This item is repeated in every form, and meant to be used by analysts to either
              (i) warn of alternatives for answering questions in the items that are not included among the options
              provided in the dropdown menus or checkbox lists (multiple choice); or 
              (ii) alert of any issues in the system.
            </div>
          </div>
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
          <br />
          <br />
        </div>

      </asp:Panel>
    
    </form>

  </body>

</html>
