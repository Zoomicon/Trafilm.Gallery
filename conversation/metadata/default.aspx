<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.ConversationMetadataPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: conversation\metadata\default.aspx
Version: 20160608
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Gallery - Conversation Metadata</title>
    
    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <asp:XmlDataSource ID="xmlCount" runat="server" DataFile="~/metadata/Count.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlYesNo" runat="server" DataFile="~/metadata/YesNo.xml" XPath="Facet/String" />
    
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
      Move the mouse over a question to see tooltip for it.
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
            <div class="label">or enter a new Conversation Id (e.g. <i>ExplainingThePlan</i> - do not include the Film Id prefix)</div>
            <asp:TextBox ID="txtConversation" runat="server" />
            <asp:Button ID="btnAddConversation" runat="server" Text="Add" OnClick="btnAddConversation_Click" />
            &nbsp;
            <asp:CheckBox ID="cbClone" Text="Copy from selected" runat="server" Visible="false" />
          </asp:Panel>
        </asp:Panel>

      </div>

      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="panelMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div class="question">
          <div class="label">1. Conversation Title (optional)</div>
          <asp:TextBox ID="txtTitle" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">2. Conversation Description (optional)</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <div class="label">Conversation URL</div>
        <asp:HyperLink ID="linkUrl" runat="server" Target="_blank"/>
    
        <%-- TODO: maybe add image control and upload image action here? %>    


        <%-- ITrafilmMetadata --%>

        <div>
          <span class="label">Info created: </span>
          <asp:Label ID="lblInfoCreated" runat="server" />

          <span class="label"> - Info Updated: </span>
          <asp:Label ID="lblInfoUpdated" runat="server" />
        </div>

        <div class="question">
          <div class="label">3. Transcription </div>
          <div class="tip">Transcription for the specific conversation (OPTIONAL)</div>
          <asp:TextBox ID="txtTranscription" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>

        <div class="question">
          <div class="label">4. Keywords</div>
          <div class="tip">Comma-separated list of keywords to help identify this item (OPTIONAL)</div>
          <asp:TextBox ID="txtKeywords" runat="server" Columns="150"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">5. Remarks </div>
          <div class="tip">Remarks on the metadata (OPTIONAL)</div>
          <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Rows="5" Columns="110" />
        </div>


        <%-- IConversationMetadata --%>

        <div class="question">
          <div class="label">6. Conversation Start Time (h:m:s)</div>
          <asp:TextBox ID="txtStartTime" runat="server" Columns="25"></asp:TextBox>
        </div>

        <div class="question">
          <div class="label">7. Conversation Duration (h:m:s)</div>
          <asp:TextBox ID="txtDuration" runat="server" Columns="25"></asp:TextBox>
        </div>
        

        <div class="question">
          <div class="label">8. L1 language present</div>
          <div class="tip">Is L1 language present in the conversation?</div>
          <asp:DropDownList 
            ID="listL1LanguagePresent" runat="server"
            DataSourceID="xmlYesNo" DataTextField="Value" DataValueField="Value"
            />
        </div>

        <div class="question">
          <div class="label">9. L2 language present</div>
          <div class="tip">Is L2 language present in the conversation?</div>
          <asp:DropDownList 
            ID="listL2LanguagePresent" runat="server"
            DataSourceID="xmlYesNo" DataTextField="Value" DataValueField="Value"
            />
        </div>


        <div class="question">
          <div class="label">10. Speaking characters: count</div>
          <div class="info">How many persons are speaking?</div>
          <asp:DropDownList 
            ID="listSpeakingCharactersCount" runat="server"
            DataSourceID="xmlCount" DataTextField="Value" DataValueField="Value"
            />
        </div>

        <div class="question">
          <div class="label">11. L3ST-speaking characters: count</div>
          <div class="info">How many persons are speaking some form of L3ST?</div>
          <asp:DropDownList 
            ID="listL3speakingCharactersCount" runat="server"
            DataSourceID="xmlCount" DataTextField="Value" DataValueField="Value"
            />
        </div>
        

        <%-- Calculated from L3STinstances --%>

        <div>
          <div class="label">L3ST languages: count (Calculated from L3ST-instances)</div>
          <div class="tip">Count of L3ST languages in Conversation</div>
          <asp:Label ID="lblL3languagesCount" runat="server"></asp:Label>
        </div>  

        <div>
          <div class="label">L3ST languages (Calculated from L3ST-instances)</div>
          <div class="tip">L3ST languages in Conversation</div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:ListBox ID="listL3languages" runat="server" Enabled="false" />
          </asp:Panel>
        </div>    


        <div>
          <div class="label">L3ST language types: count (Calculated from L3ST-instances)</div>
          <div class="tip">Count of L3ST language types in Conversation</div>
          <asp:Label ID="lblL3languageTypesCount" runat="server"></asp:Label>
        </div> 
        
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
        
        
        <%-- L3STinstances list --%>                  

        <asp:Repeater ID="repeaterL3STinstances" runat="server">
          <HeaderTemplate>
            <div class="label">List of L3ST-instances<div>
          </HeaderTemplate>
          <ItemTemplate>
            <a href="../../L3STinstance/metadata/?film=<%#Eval("filmId")%>&conversation=<%#Eval("conversationId")%>&L3STinstance=<%#Eval("L3STinstanceId")%>"><%#Eval("L3STinstanceId")%></a>&nbsp;&nbsp;
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
