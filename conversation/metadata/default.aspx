<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.ConversationMetadataPage" %>
<%@ Import namespace="Trafilm.Gallery" %>

<!DOCTYPE html>

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: conversation\metadata\default.aspx
Version: 20171201
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Metadata | Conversations</title>
    
    <meta name="viewport" content="width=400, user-scalable=yes, initial-scale=1" />
    
    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <%-- <asp:XmlDataSource ID="xmlLanguageSources" runat="server" DataFile="~/metadata/LanguageSources.xml" XPath="Facet/String" /> --%>
    <asp:XmlDataSource ID="xmlDuration" runat="server" DataFile="~/metadata/ConversationDuration.xml" XPath="Facet/String" />
    

    <%-- WEBFORM --%>

    <form id="form1" defaultbutton="btnSave" defaultfocus="listConversations" runat="server">

      <%-- STATUS MESSAGE --%>

      <asp:Panel runat="server" ID="panelStatus" CssClass="status" Visible="false">
        <asp:Label ID="labelStatus" runat="server"/>
      </asp:Panel>


      <%-- NAVIGATION MENU --%>

      <div class="navigation">
        <a href="http://trafilm.net" target="trafilm"><img src="http://trafilm.net/App_Themes/trafilm/img/logo.png" height="18" /></a>
        <a href="../../film/metadata/?film=<%=listFilms.SelectedValue%>">Films</a>
        <a class="selected" href="../../conversation/metadata/">Conversations</a>
        <a href="../../L3STinstance/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>">L3ST-instances</a>
        <a href="../../L3TTinstance/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>">L3TT-instances</a>
        <a href="https://repositori.upf.edu/handle/10230/28223" target="trafilm guide" class="guide">Guide</a>
      </div>


      <%-- LOGIN STATUS --%>

      <div>
        <asp:LoginName ID="loginName" runat="server" FormatString="Welcome {0}!" /> [<asp:LoginStatus ID="loginStatus" runat="server"/>]
      </div>


      <%-- INSTRUCTION BOX --%>

      <asp:Panel ID="panelInstructions" runat="server" Visible="false" CssClass="instructions">
        Please fill in the following information for the Conversation of your choice. Select it using the dropdown lists.<br />
        Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering Conversations.<br />
        Don't forget to press the SAVE METADATA button. Thank you!
      </asp:Panel>

      
      <%-- INFO BOX --%>

      <div class="bar">

        <div>
          <div class="label">Select a Film</div> 
          <asp:DropDownList ID="listFilms" runat="server" AutoPostBack="True" OnSelectedIndexChanged ="listFilms_SelectedIndexChanged" />
        </div>

        <asp:Panel runat="server" ID="panelConversationId" Visible="false">
          <div class="label">Select a Conversation</div> 
          <asp:DropDownList ID="listConversations" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listConversations_SelectedIndexChanged" />

          <asp:Panel ID="panelAdd" runat="server">
            <div class="label">or enter a new Conversation Id (e.g. <i>Explaining the plan</i> - do not include the Film Id prefix)</div>
            <asp:TextBox ID="txtConversation" runat="server" MaxLength="50" />
            <br />
            <asp:Button ID="btnAddConversation" runat="server" Text="Add" OnClick="btnAddConversation_Click" />
            &nbsp;
            <asp:CheckBox ID="cbClone" Text="Copy from selected" runat="server" Visible="false" />
            &nbsp;&nbsp;
            <asp:Button ID="btnRename" runat="server" Text="Rename selected" OnClick="btnRename_Click" />
          </asp:Panel>
        </asp:Panel>

      </div>

      
      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="panelMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div class="question" id="Title">
          <div class="label">1. Conversation Title</div>
          <div class="tip">
            <a href="#Title" class="openhelp">&#x26e8;</a>
            <div class="help">
              Free text. Provide a title for the Conversation to serve as a reference. For some cases, they are 
              well known for the name of the scene, e.g. “the lake scene” in Love Actually. Notice that another 
              key reference for Conversations is its Start Time. Although we allow for the possibility of two 
              conversations starting at the same time, this is an infrequent case, so Start Time is actually a 
              good reference for identifying each conversation. However, giving it a name can make it easier to 
              remember, provides additional data when it is a descriptive title, and disambiguates the slim 
              chance that two conversations start at the same time.
            </div>
          </div>
          <asp:TextBox ID="txtTitle" runat="server" />
        </div>
       
        <div class="question" id="Description">
          <div class="label">2. Conversation Description</div>
          <div class="tip">
            <a href="#Title" class="openhelp">&#x26e8;</a>
            <div class="help">
              Provide a few relevant words about the nature of the conversation to enable a better 
              understanding of L3 instances, ST and TT. If you can “describe” the Conversation by means of 
              keywords or tags you do not need to fill in the item “Conversation description”. You can go 
              straight to “Conversation Tags”.
            </div>
          </div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" />
        </div>

        <div class="calculated" id="URL">
          <div class="label">Conversation URL</div>
          <div class="tip">Metadata item URL, right-click to copy URL address</div>
          <asp:HyperLink ID="linkUrl" runat="server" Target="_blank" />
        </div>

        <%--
        <div class="question" id="Image">
          <div class="label">3. Image URL</div>
          <asp:TextBox ID="txtImageUrl" runat="server" />
        </div>
        --%>


        <%-- IConversationMetadata --%>

        <div class="calculated" id="FilmOrSeasonTitle">
          <div class="label">Film/Season title</div>
          <div class="tip">Title of Film or TV series season</div>
          <asp:Label ID="lblFilmOrSeasonTitle" runat="server" />
        </div>

        <div class="question" id="SeasonEpisodeName">
          <div class="label">3. Season episode name</div>
          <div class="tip">
            For TV series seasons, enter episode number and name (preferrably as originally numbered)
            <a href="#SeasonEpisodeName" class="openhelp">&#x26e8;</a>
            <div class="help">
              Enter the title of the episode and or its number.
            </div>
          </div>
          <asp:TextBox ID="txtSeasonEpisodeName" runat="server" />
        </div>

        <div class="question" id="StartTime">
          <div class="label">4. Start time (min)</div>
          <div class="tip">
            What part of the film is the Conversation in? (i.e. how many minutes from the start)
            <a href="#StartTime" class="openhelp">&#x26e8;</a>
            <div class="help">
              Start Time is calculated as the lapse of time from the beginning of the film to the beginning of the 
              Conversation containing the L3-instance. Type in (as “free” text) up to 3 digits to show in minutes
              the moment when the Conversation starts if you count from the beginning of the film. 
            </div>
          </div>
          <asp:TextBox ID="txtStartTime" runat="server" />
        </div>

        <div class="question" id="Duration">
          <div class="label">5. Duration (sec)</div>
          <div class="tip">
            How long does the Conversation last? (if L3ST instances are interrupted by other speech, count total seconds from onset to end of final L3ST-instance)
            <a href="#Duration" class="openhelp">&#x26e8;</a>
            <div class="help">
              A Conversation (3 min. max. = 180 sec.) is comprised of the L3-instance with or without other utterances 
              in the main language or other L3s. Conversations and Clips for TraFilm cannot last longer than 3 minutes.
              For conversations lasting longer than 3 minutes we encourage analysts to find a way of splitting the
              conversation somehow, within reasonable parameters, of course.
            </div>
          </div>
          <asp:DropDownList
            ID="listDuration" runat="server"
            DataSourceID="xmlDuration" DataTextField="Title" DataValueField="Value"
            />
        </div>
        
        <%--
        <div class="question" id="LanguageSources">
          <div class="label">6. Language sources <i>(oral &amp; written)</i></div>
          <div class="tip">How many “language sources” are there, i.e. characters speaking (total amount in any language) in this conversation, but also counting other relevant sources like narrator or written words?</div>
          <asp:DropDownList
            ID="listLanguageSources" runat="server"
            DataSourceID="xmlLanguageSources" DataTextField="Title" DataValueField="Value"
            />
        </div>
        --%>


        <%-- Calculated from L3STinstances --%>

        <%-- L3STlanguagesCount shown in parentheses next to title of respective list below --%>

        <div class="calculated" id="L3STlanguages">
          <div class="label">L3ST languages (#<asp:Label ID="lblL3STlanguagesCount" runat="server" /> - Calculated from L3ST-instances)</div>
          <div class="tip">L3ST languages in Conversation</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:ListBox ID="listL3STlanguages" runat="server" Enabled="false" />
          </asp:Panel>
        </div>    

         <%-- L3STlanguageTypesCount shown in parentheses next to title of respective list below --%>
        
        <div class="calculated" id="L3STlanguageTypes">
          <div class="label">L3ST language types (# <asp:Label ID="lblL3STlanguageTypesCount" runat="server" /> - Calculated from L3ST-instances)</div>
          <div class="tip">L3ST language types in Conversation</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:ListBox ID="listL3STlanguageTypes" runat="server" Enabled="false" />
           </asp:Panel>
        </div>

        <%-- L3STinstanceCount shown in parentheses next to title of respective list below --%>


        <%-- ITrafilmMetadata --%>

        <%--
        <div class="question" id="Transcription">
          <div class="label">7. Transcription </div>
          <div class="tip">Transcription for the specific conversation</div>
          <asp:TextBox ID="txtTranscription" runat="server" TextMode="MultiLine" Rows="5" />
        </div>
        --%>

        <div class="question" id="Tags">
          <div class="label">6. Tags</div>
          <div class="tip">
            Keywords or other labels for filtering purposes , insert a comma (,) between different ones
            <a href="#Tags" class="openhelp">&#x26e8;</a>
            <div class="help">
              This item is repeated in every form, and meant to be used by analysts to either
              (i) signal special distinguishing features,
                  especially those which are not picked up by the answers to all of the other items; or 
              (ii) to personalise a researcher’s own special interest so that a “corpus” may be retrieved through certain keywords.
            </div>
          </div>
          <asp:TextBox ID="txtTags" runat="server" />
        </div>

        <div class="question" id="Remarks">
          <div class="label">7. Remarks </div>
          <div class="tip">
            Issues concerning the analysis or the metadata form design
            <a href="#Remarks" class="openhelp">&#x26e8;</a>
            <div class="help">
              This item is repeated in every form, and meant to be used by analysts to either
              (i) warn of alternatives for answering questions in the items that are not included among the options
              provided in the dropdown menus or the checkbox lists (multiple choices); or 
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

        
        <%-- L3STinstances list --%>                  

        <div class="calculated" id="L3STinstances">
          <div class="label">L3ST-instances (#<asp:Label ID="lblL3STinstanceCount" runat="server" />)</div>          
          <asp:Repeater ID="repeaterL3STinstances" runat="server">
            <ItemTemplate>
              <a href="../../L3STinstance/metadata/?film=<%#Eval("filmId")%>&conversation=<%#Eval("conversationId")%>&L3STinstance=<%#Eval("L3STinstanceId")%>"><%#Eval("L3STinstanceId").ToString().TrimStart(Eval("conversationId").ToString() + ".")%></a>&nbsp;&nbsp;
            </ItemTemplate>
          </asp:Repeater>
          <br />
          <br />
        </div>

      </asp:Panel>
    
    </form>

  </body>

</html>
