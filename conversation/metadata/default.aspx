<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.ConversationMetadataPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: conversation\metadata\default.aspx
Version: 20161007
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Metadata | Conversations</title>
    
    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <%-- <asp:XmlDataSource ID="xmlLanguageSources" runat="server" DataFile="~/metadata/LanguageSources.xml" XPath="Facet/String" /> --%>
    <asp:XmlDataSource ID="xmlDuration" runat="server" DataFile="~/metadata/ConversationDuration.xml" XPath="Facet/String" />
    

    <%-- NAVIGATION MENU --%>

    <div class="navigation">
       <a href="../../film/metadata/?film=<%=listFilms.SelectedValue%>">Film Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a class="selected" href="../../conversation/metadata/">Conversation Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../L3STinstance/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>">L3ST-instance Metadata</a>
       &nbsp;&nbsp;-&nbsp;&nbsp;
       <a href="../../L3TTinstance/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>">L3TT-instance Metadata</a>
    </div>


    <%-- INSTRUCTION BOX --%>

    <div class="instructions">
      Please fill in the following information for the Conversation of your choice. Select the Conversation from the dropdown list.<br />
      Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering Conversations.<br />
      Don't forget to press the SAVE METADATA button. Thank you!
    </div>

    <form id="form1" runat="server">

      <%-- LOGIN STATUS --%>

      <asp:LoginName ID="loginName" runat="server" FormatString="Welcome {0}!" /> [<asp:LoginStatus ID="loginStatus" runat="server"/>]

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
            <asp:TextBox ID="txtConversation" runat="server" />
            <asp:Button ID="btnAddConversation" runat="server" Text="Add" OnClick="btnAddConversation_Click" />
            &nbsp;
            <asp:CheckBox ID="cbClone" Text="Copy from selected" runat="server" Visible="false" />
            &nbsp;
            <asp:Button ID="btnRename" runat="server" Text="Rename selected" OnClick="btnRename_Click" />
          </asp:Panel>
        </asp:Panel>

      </div>

      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="panelMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <%--
        <div class="question">
          <div class="label">1. Conversation Title</div>
          <asp:TextBox ID="txtTitle" runat="server" Columns="150" />
        </div>

        <div class="question">
          <div class="label">2. Conversation Description</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>
        --%>

        <div class="label">Conversation URL</div>
        <asp:HyperLink ID="linkUrl" runat="server" Target="_blank" />

        <%--
        <div class="question">
          <div class="label">3. Image URL</div>
          <asp:TextBox ID="txtImageUrl" runat="server" Columns="150" />
        </div>
        --%>


        <%-- IConversationMetadata --%>

        <div class="question">
          <div class="label">3. Start time (min)</div>
          <div class="tip">What part of the film is the Conversation in? (i.e. how many minutes from the start)</div>
          <asp:TextBox ID="txtStartTime" runat="server" Columns="25" />
        </div>

        <div class="question">
          <div class="label">4. Duration (sec)</div>
          <div class="tip">How long does the Conversation last? (if L3ST instances are interrupted by other speech, count total seconds from onset to end of final L3ST-instance)</div>
          <asp:DropDownList
            ID="listDuration" runat="server"
            DataSourceID="xmlDuration" DataTextField="Title" DataValueField="Value"
            />
        </div>
        
        <%--
        <div class="question">
          <div class="label">6. Language sources <i>(oral &amp; written)</i></div>
          <div class="tip">How many “language sources” are there, i.e. characters speaking (total amount in any language) in this conversation, but also counting other relevant sources like narrator or written words?</div>
          <asp:DropDownList
            ID="listLanguageSources" runat="server"
            DataSourceID="xmlLanguageSources" DataTextField="Title" DataValueField="Value"
            />
        </div>
        --%>


        <%-- Calculated from L3STinstances --%>

        <%-- //don't need to display the count since there list of items is also shown
        <div>
          <div class="label">L3ST languages: count (Calculated from L3ST-instances)</div>
          <div class="tip">Count of L3ST languages in Conversation</div>
          <asp:Label ID="lblL3languagesCount" runat="server"></asp:Label>
        </div>  
        --%>

        <div>
          <div class="label">L3ST languages (Calculated from L3ST-instances)</div>
          <div class="tip">L3ST languages in Conversation</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:ListBox ID="listL3languages" runat="server" Enabled="false" />
          </asp:Panel>
        </div>    

         <%-- //don't need to display the count since there list of items is also shown
        <div>
          <div class="label">L3ST language types: count (Calculated from L3ST-instances)</div>
          <div class="tip">Count of L3ST language types in Conversation</div>
          <asp:Label ID="lblL3languageTypesCount" runat="server"></asp:Label>
        </div>
        --%>
        
        <div>
          <div class="label">L3ST language types (Calculated from L3ST-instances)</div>
          <div class="tip">L3ST language types in Conversation</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:ListBox ID="listL3languageTypes" runat="server" Enabled="false" />
           </asp:Panel>
        </div>


        <div>
          <div class="label">Count of L3ST-instances (Calculated)</div>
          <asp:Label ID="lblL3STinstanceCount" runat="server"></asp:Label>
        </div>
        

        <%-- ITrafilmMetadata --%>

        <%--
        <div class="question">
          <div class="label">7. Transcription </div>
          <div class="tip">Transcription for the specific conversation</div>
          <asp:TextBox ID="txtTranscription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <div class="question">
          <div class="label">8. Tags</div>
          <div class="tip">Keywords or other labels for filtering purposes , insert a comma (,) between different ones</div>
          <asp:TextBox ID="txtTags" runat="server" Columns="150" />
        </div>

        <div class="question">
          <div class="label">9. Remarks </div>
          <div class="tip">Issues concerning the analysis or the metadata form design</div>
          <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>
        --%>


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
          <br /><br />
        </asp:Panel>

        
        <%-- L3STinstances list --%>                  

        <div>
          <asp:Repeater ID="repeaterL3STinstances" runat="server">
            <HeaderTemplate>
              <div class="label">List of L3ST-instances<div>
            </HeaderTemplate>
            <ItemTemplate>
              <a href="../../L3STinstance/metadata/?film=<%#Eval("filmId")%>&conversation=<%#Eval("conversationId")%>&L3STinstance=<%#Eval("L3STinstanceId")%>"><%#Eval("L3STinstanceId")%></a>&nbsp;&nbsp;
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
