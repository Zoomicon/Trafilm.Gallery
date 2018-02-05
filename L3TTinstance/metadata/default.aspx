<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.L3TTinstanceMetadataPage" %>

<!DOCTYPE html>

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: L3TTinstance\metadata\default.aspx
Version: 20180205
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Metadata | L3TT-instances</title>
    
    <meta name="viewport" content="width=400, user-scalable=yes, initial-scale=1" />

    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <asp:XmlDataSource ID="xmlL2language" runat="server" DataFile="~/metadata/L2language.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL2mode" runat="server" DataFile="~/metadata/L2mode.xml" XPath="Facet/String" />  
    <asp:XmlDataSource ID="xmlBlockbuster" runat="server" DataFile="~/metadata/Blockbuster.xml" XPath="Facet/String" />      
    <asp:XmlDataSource ID="xmlYesNo" runat="server" DataFile="~/metadata/YesNo.xml" XPath="Facet/String" />    
    <asp:XmlDataSource ID="xmlL3TTlanguageType" runat="server" DataFile="~/metadata/L3TTlanguageType.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTconstructedBasedOn" runat="server" DataFile="~/metadata/L3constructedBasedOn.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTaudienceUnderstanding" runat="server" DataFile="~/metadata/L3audienceUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTmessageUnderstanding" runat="server" DataFile="~/metadata/L3messageUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTmeaningDecipherable" runat="server" DataFile="~/metadata/L3meaningDecipherable.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTspeakerPerformance" runat="server" DataFile="~/metadata/L3speakerPerformance.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTmode" runat="server" DataFile="~/metadata/L3mode.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmodeChange" runat="server" DataFile="~/metadata/L3STmodeChange.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTrepresented" runat="server" DataFile="~/metadata/L3represented.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTrepresentationsOral" runat="server" DataFile="~/metadata/L3representationsOral.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTrepresentationsVisual" runat="server" DataFile="~/metadata/L3representationsVisual.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTfunctions" runat="server" DataFile="~/metadata/L3functions.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTconversationFeatures" runat="server" DataFile="~/metadata/L3conversationFeatures.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3TTsources" runat="server" DataFile="~/metadata/L3sources.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlConversationDuration" runat="server" DataFile="~/metadata/ConversationDuration.xml" XPath="Facet/String" />


    <%-- WEBFORM --%>

    <form id="form1" defaultbutton="btnSave" defaultfocus="listL3TTinstances" runat="server">

      <%-- STATUS MESSAGE --%>

      <asp:Panel runat="server" ID="panelStatus" CssClass="status" Visible="false">
        <asp:Label ID="labelStatus" runat="server"/>
      </asp:Panel>


      <%-- NAVIGATION MENU --%>

      <div class="navigation">
        <a href="http://trafilm.net" target="trafilm"><img src="http://trafilm.net/App_Themes/trafilm/img/logo.png" height="18" /></a>
        <a href="../../film/metadata/?film=<%=listFilms.SelectedValue%>">Films</a>
        <a href="../../conversation/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>">Conversations</a>
        <a href="../../L3STinstance/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>&L3STinstance=<%=listL3STinstances.SelectedValue%>">L3ST-instances</a>
        <a class="selected" href="../../L3TTinstance/metadata/">L3TT-instances</a>
        <a href="https://repositori.upf.edu/handle/10230/28223" target="trafilm guide" class="guide">Guide</a>
      </div>


      <%-- LOGIN STATUS --%>

      <div>
        <asp:LoginName ID="loginName" runat="server" FormatString="Welcome {0}!" /> [<asp:LoginStatus ID="loginStatus" runat="server"/>]
      </div>


      <%-- INSTRUCTIONS BOX --%>

      <asp:Panel ID="panelInstructions" runat="server" Visible="false" CssClass="instructions">
        Please fill in the following information for the L3TT-instance of your choice. Select it using the dropdown lists.<br />
        Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering L3TT-instances.<br />
        Don't forget to press the SAVE METADATA button. Thank you!
      </asp:Panel>


      <%-- INFO BOX --%>

      <div class="bar">

        <div>
          <div class="label">Select a Film</div>
          <asp:DropDownList ID="listFilms" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listFilms_SelectedIndexChanged" />
        </div>
        
        <asp:Panel runat="server" ID="panelConversationId" Visible="false">
          <div>
            <div class="label">Select a Conversation</div> 
            <asp:DropDownList ID="listConversations" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listConversations_SelectedIndexChanged" />
          </div>

          <asp:Panel runat="server" ID="panelL3STinstanceId" Visible="false">
            <div>
              <div class="label">Select an L3ST-instance</div> 
              <asp:DropDownList ID="listL3STinstances" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listL3STinstances_SelectedIndexChanged" />
            </div>

            <asp:Panel runat="server" ID="panelL3TTinstanceId" Visible="false">
              <div class="label">Select an L3TT-instance</div> 
              <asp:DropDownList ID="listL3TTinstances" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listL3TTinstances_SelectedIndexChanged" />

              <asp:Panel ID="panelAdd" runat="server">
                <div class="label">or add new L3TT-instance Id (e.g. <i>SpanishDub</i> or <i>SpanishSub</i> - do not include the Film Id, Conversation Id and L3ST-instance Id prefixes)</div>
                <asp:TextBox ID="txtL3TTinstance" runat="server" MaxLength="50" />
                <br />
                <asp:Button ID="btnAddL3TTinstance" runat="server" Text="Add" OnClick="btnAddL3TTinstance_Click" />
                &nbsp;
                <asp:CheckBox ID="cbClone" Text="Copy from selected" runat="server" Visible="false" />
                &nbsp;&nbsp;
                <asp:Button ID="btnRename" runat="server" Text="Rename selected" OnClick="btnRename_Click" />
              </asp:Panel>
            </asp:Panel>

          </asp:Panel>
        </asp:Panel>

      </div>


      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="panelMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div class="question" id="Title">
          <div class="label">1. L3TT-instance Title</div>
          <div class="tip">
            Free text descriptive title (&lt;50 characters)
            <a href="#Title" class="openhelp">&#x26e8;</a>
            <div class="help">
              Provide a short descriptive title for the L3-instance, e.g. partial transcription or key words.
            </div>
          </div>
          <asp:TextBox ID="txtTitle" runat="server" />
        </div>

        <div class="calculated" id="Description">
          <div class="label">Description (Calculated from L3ST-instance)</div>
          <div class="tip">Free text brief description (<200 characters)</div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" ReadOnly="true" />
        </div>

        <div class="calculated" id="URL">
          <div class="label">L3TT-instance URL</div>
          <div class="tip">Metadata item URL, right-click to copy URL address</div>
          <asp:HyperLink ID="linkUrl" runat="server" Target="_blank" />
        </div>

        <div class="calculated" id="Image">
          <div class="label">Image URL (Calculated from L3ST-instance)</div>
          <asp:Label ID="lblImageUrl" runat="server" />
        </div>   


        <%-- IL3TTinstanceMetadata --%>

        <div class="question" id="FilmTitleTT">
          <div class="label">2. Film Title TT</div>
          <div class="tip">
            <a href="#FilmTitleTT" class="openhelp">&#x26e8;</a>
            <div class="help">
              Provide the official title for the version you are analysing (dubbed, subtitled, audio described
              or subtitled for the deaf and hard of hearing).
            </div>
          </div>
          <asp:TextBox ID="txtFilmTitleTT" runat="server" />
        </div>


        <div class="question" id="L2language">
          <div class="label">3. L2 language</div>
          <div class="tip">
            What language is L2 in?
            <a href="#L2language" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>
                List of real languages, plus <i>Unintelligible</i> (e.g., gibberish), plus <i>Silent</i>, plus <i>Other</i>
              </p>
              <p>
                Select from a long list of options. If the option you need is not on the list select “Other”, and then type
                the required language in Tags. When inserting a language, please specify in order of more general to more specific,
                in those cases that need specifying; e.g. Spanish South American Chile, or English US Southern Georgia. Only be as
                specific as you need to be and know for sure.
              </p>
            </div>
          </div>
          <asp:DropDownList 
            ID="listL2language" runat="server"
            DataSourceID="xmlL2language" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question" id="L2mode">
          <div class="label">4. L2 mode</div>
          <div class="tip">
            Mode of L2?
            <a href="#L2mode" class="openhelp">&#x26e8;</a>
            <div class="help">
              Select one of the four options. Each option then requires a full analysis of its own.
              The dubbed version will be one analysis; the subtitled version will be treated as a completely different
              version of the same L3ST-instance even if L2 is the same for the dubbed and the subtitled version.
            </div>
          </div>
          <asp:DropDownList 
            ID="listL2mode" runat="server"
            DataSourceID="xmlL2mode" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question" id="DistributionCountriesTT">
          <div class="label">5. Distribution countries (TT)</div>
          <div class="tip">
            Full name(s), insert a comma (,) between different countries
            <a href="#DistributionCountriesTT" class="openhelp">&#x26e8;</a>
            <div class="help">
              Insert the name of the distribution (dubbed/subtitled, etc. version)
              country. If there is more than one destination country for the same translated version, separate
              each country by using commas (,). The system interprets the comma sign as separating different
              values or answers within the text of the same item (question).
            </div>
          </div>
          <asp:TextBox ID="txtDistributionCountriesTT" runat="server" />
        </div>

        <div class="question" id="YearTTreleased">
          <div class="label">6. Year TT released</div>
          <div class="tip">
            <a href="#YearTTreleased" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>Type in four digit year the film production was first released.</p>
              <p>This item is repeated in Form 1 (ST Film Metadata), for comparison.</p>
            </div>
          </div>
          <asp:TextBox ID="txtYearTTreleased" runat="server" />
        </div>


        <div class="question" id="FilmTTblockbuster">
          <div class="label">7. Film TT Blockbuster</div>
          <div class="tip">
            Is the TT version ranked in the top 20 where distributed?
            <a href="#FilmTTblockbuster" class="openhelp">&#x26e8;</a>
            <div class="help">
              This item is repeated in Form 1 (ST Film Metadata), for comparison.
            </div>
          </div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:DropDownList ID="listBlockbusterTT" runat="server"
              DataSourceID="xmlBlockbuster" DataTextField="Value" DataValueField="Value"
              />
           </asp:Panel>
        </div>


        <div class="label" id="ConversationStartTime">
          <div class="label">Conversation start time (min) (Calculated from Conversation)</div>
          <div class="tip">What part of the film is the Conversation in? (i.e. how many minutes from the start)</div>
          <asp:Label ID="lblConversationStartTime" runat="server" />
        </div>

        <div class="label" id="ConversationEndTime">
          <div class="label">Conversation duration (sec) (Calculated from Conversation)</div>
          <div class="tip">How long does the Conversation last? (if L3ST instances are interrupted by other speech, count total seconds from onset to end of final L3ST-instance)</div>
          <asp:Label ID="lblConversationDuration" runat="server" />
        </div>


        <div class="question" id="L2sameAsL3ST">
          <div class="label">8. L2 same as L3ST</div>
          <div class="tip">
            Is L2 same language as L3ST?
            <a href="#L2sameAsL3ST" class="openhelp">&#x26e8;</a>
            <div class="help">
              This data is important as L2 coinciding with L3ST tends to be an interesting, complicating factor.
            </div>
          </div>
          <asp:DropDownList 
            ID="listL2sameAsL3ST" runat="server"
            DataSourceID="xmlYesNo" DataTextField="Title" DataValueField="Value" />
        </div>

        <div class="question" id="L3STconveyedAsL3TT">
          <div class="label">9. L3ST conveyed as L3TT</div>
          <div class="tip">
            Has L3ST been conveyed as some sort of L3TT in the TT?
            <a href="#L3STconveyedAsL3TT" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>This item is asking whether or not L3 has been obliterated (e.g. deleted, naturalized or rendered as L2).</p>
              <p>This item is asking in very general terms if there is a corresponding L3 in TT for L3-occurrence in ST.</p>
              <p>If the answer is NO it means there is no L3 in TT (of any sort) for a given L3ST-occurrence.</p>
              <p>The reason for asking this question is because it is linked to the questions that come after it, asking what L3 is like (asking about its features).</p>
              <p>Answering NO to this item means the result in the TT is either omission or L2. The solution in TT, whatever it is, does not "stand out" from L2 in any way, either because it has been deleted or naturalised and translated in L2. For subtitles, the answer is NO if the solution is considered to "hide" the feature of multilingualism and the result is that the TT audience is not (cannot be) aware that there is language variation going on in the film (between L1 and L3, rendered by L2/L3 variation in the TT).</p>
              <p>The clearest case would be for the L3ST to be subtitled in L2. (answer NO for this item)</p>
              <p>The doubtful (subjective) case would be omission in the subtitle (zero subtitle). It would be for the researcher to decide whether such an omission leads to L3 being "hidden" because the viewer cannot distinguish L1 from L3 aurally (answer NO for this item), or, alternatively, whether omission in the subtitle is meant for the viewer of the subtitled version to rely on the audio to notice (literally, hear) the presence of L3. If the analysis wishes to express that L3 is rendered in TT (L1-L3 & L2-L3 such that language variation is kept) by means of "inviting" the viewer (or relying on the viewer) to hear L3 with no subtitled words to read, as a legitimate subtitling strategy, then the answer to this item would be YES for omission in this case.</p>
            </div>
          </div>
          <asp:DropDownList 
            ID="listL3STconveyedAsL3TT" runat="server"
            DataSourceID="xmlYesNo" DataTextField="Title" DataValueField="Value" />
        </div>


        <div class="question" id="L3TTlanguageType">
          <div class="label">10. L3TT language type</div>
          <div class="tip">
            With L2 as main language (L-main), what type of language is L3TT?
            <a href="#L3TTlanguageType" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>This item is to filter L3 searches, according to three large groups: (1) Real languages (e.g. Italian, Latin, Esperanto), with actual speakers, originally, outside the world of fiction. Languages like Esperanto are included in this category. (2) Constructed in fiction, made up, e.g. Star Trek Klingon). (3) A variety of the main language, by user (dialect) or by use (sociolect); importantly, for this analysis, clearly distinguishable from the main language, e.g. Cockney English, gangster slang, highly technical jargon. For one or a few characters only. (4) Conditioned: Real language production and/or perception is conditioned by cognitive, articulatory, hearing (or external factors e.g. speaking with mouth full, a hostage who has a gag), caused by extreme tiredness or under extreme pressure (nerves, overexcitement), or under the influence, mumbling, muttering, sobbing, etc. to come across as slurred speech, unclear, incoherent, as/or too fast/too slow: a transitory or permanent condition.</p>
              <p>This item is repeated in Form 3, for comparison.</p>
            </div>
          </div>
          <asp:DropDownList 
            ID="listL3TTlanguageType" runat="server"
            DataSourceID="xmlL3TTlanguageType" DataTextField="Title" DataValueField="Value" />
        </div>

        <div class="question" id="L3TTlanguage">
          <div class="label">11. L3TT language</div>
          <div class="tip">
            Which language is L3TT?
            <a href="#L3TTlanguage" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>Free text, type in the language for this particular L3ST-instance, e.g. Swedish, Korean, Klingon, Elvish, Dothraki, OR “unknown”. Type in a single word for the language, in English, with a capital first letter. If you cannot recognise the language, then type in the word <i>unknown</i>.</p>
              <p>This item is repeated in Form 3, for comparison.</p>
            </div>
          </div>
          <asp:TextBox ID="txtL3TTlanguage" runat="server" />
        </div>


        <div class="question" id="L3TTconstructedBasedOn">
          <div class="label">12. L3TT constructed based on</div>
          <div class="tip">
            If L3TT is “constructed”, is it based on any of the following options?
            <a href="#L3TTconstructedBasedOn" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>Options include L1 and L2 combinations, and other relevant distinctions such as historical or pseudo-historical (e.g. Lord of the Rings, Conan, or Game of Thrones-style L3 constructed languages, etc.). Gibberish is for unintelligible speech, normally interpreted as deliberately unintelligible (nonsense). “From scratch” is for L3-constructed not based on any ‘real’ language (e.g. R2D2 in Star Wars). If “Other” is selected, maybe it is interesting to add why and how, in the “Remarks for L3ST analysis” item.</p>
              <p>This item is repeated in Form 3, for comparison.</p>
            </div>
          </div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTconstructedBasedOn" runat="server" 
              DataSourceID="xmlL3TTconstructedBasedOn" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question" id="L3TTaudienceUnderstanding">
          <div class="label">13. L3TT meant to be understood</div>
          <div class="tip">
            Is L3TT meant to be understood by most of the audience?
            <a href="#L3TTaudienceUnderstanding" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>This item is asking about the comprehensibility of the L3 utterance for the intended audience without the aid of diegetic or non-diegetic translation or explanation.</p>
              <p>This item is repeated Form 3, for comparison.</p>
            </div>
          </div>
          <asp:DropDownList 
            ID="listL3TTaudienceUnderstanding" runat="server"
            DataSourceID="xmlL3TTaudienceUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question" id="L3TTmessageUnderstanding">
          <div class="label">14. L3TT message required for understanding</div>
          <div class="tip">
            Does L3TT carry a meaningful message or one that requires it to be understood?
            <a href="#L3TTmessageUnderstanding" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>Regardless of whether L3 can be understood (“meant to be understood” item) this item is asking whether the audience needs to know what is being said, even if it can be understood but not necessary or vice versa, cannot be understood but should be, or both can be and needs to be understood.</p>
              <p>This item is repeated in Form 3, for comparison.</p>
            </div>
          </div>
          <asp:DropDownList 
            ID="listL3TTmessageUnderstanding" runat="server"
            DataSourceID="xmlL3TTmessageUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question" id="L3TTmeaningDecipherable">
          <div class="label">15. L3TT meaning decipherable</div>
          <div class="tip">
            Can the (pragmatic) meaning of L3TT be deciphered by other means?
            <a href="#L3TTmeaningDecipherable" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>Even if the utterance is not meant to be understood verbally (due to its “foreignness”) can the message be decoded by non-verbal means or because it is (somehow) translated? By "translated" here we mean in the broadest sense of the word, ranging from literal foreign rendering to free rendering to interlingual or intralingual paraphrase.</p>
              <p>This item is repeated in Form 3, for comparison.</p>
            </div>
          </div>
          <asp:DropDownList 
            ID="listL3TTmeaningDecipherable" runat="server"
            DataSourceID="xmlL3TTmeaningDecipherable" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question" id="L3TTspeakerPerformance">
          <div class="label">16. Quality of L3TT speaker performance</div>
          <div class="tip">
            How well is the L3TT spoken?
            <a href="#L3TTspeakerPerformance" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>Three options, to know whether the L3 is spoken natively or very well; not well; quite bad, communicatively incompetent or not even serious or realistic portrayal of the language.</p>
              <p>When in doubt, for example between “very well” and “not well”, or between “not well” and “farcical”, the determining factor must be the importance of the distinction in relation to the story, the script, character portrayal, the nature of the scene, etc.</p>
              <p>This item is repeated in Form 3, for comparison.</p>
            </div>
          </div>
          <asp:DropDownList 
            ID="listL3TTspeakerPerformance" runat="server"
            DataSourceID="xmlL3TTspeakerPerformance" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question" id="L3TTmode">
          <div class="label">17. L3TT mode, written/spoken, diegetic</div>
          <div class="tip">
            Mode of L3TT?
            <a href="#L3TTmode" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>Here we are asking a two-in-one about whether L3 is spoken or written and whether it is within the fiction of the story or directly addressed to the audience. In the case of L3 it is unlikely that it will be non-diegetic, although the translation of L3 could be.</p>
              <p>This item is repeated in Form 3, for comparison.</p>
            </div>
          </div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTmode" runat="server" 
              DataSourceID="xmlL3TTmode" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question" id="L3TTrepresented">
          <div class="label">18. L3TT merely represented</div>
          <div class="tip">
            There is no actual L3TT, but there are clues
            <a href="#L3TTrepresented" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>There is no L3ST as such, strictly speaking, but it is hinted at by certain "clues" verbally (in the L1) or non-verbally (to be seen or heard). In the scene characters may be portrayed as not understanding each other even if the audience hears them all speaking the audience’s language (the main language of the film).</p>
              <p>This item is repeated in Form 3, for comparison.</p>
            </div>
          </div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTrepresented" runat="server" 
              DataSourceID="xmlL3TTrepresented" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question" id="L3TTrepresentedOrally">
          <div class="label">19. L3TT merely represented orally</div>
          <div class="tip">
            If “oral” selected for question on “L3TT represented”, specify how:
            <a href="#L3TTrepresentedOrally" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>This item is logically dependent on the answer provided for item “L3ST represented” and is inquiring about the various possibilities of oral representation of L3 by oral means.</p>
              <p>This item is repeated in Form 3, for comparison.</p>
            </div>
          </div>
          <div class="tip"></div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTrepresentationsOral" runat="server" 
              DataSourceID="xmlL3TTrepresentationsOral" DataTextField="Title" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question" id="L3TTrepresentedVisually">
          <div class="label">20. L3TT represented: visual</div>
          <div class="tip">
            If “visual” selected for question on “L3TT represented”, specify how:
            <a href="#L3TTrepresentedVisually" class="openhelp">&#x26e8;</a>
            <div class="help">
              Specify how the L3 is represented visually, for particularly relevant cases.
            </div>
          </div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTrepresentationsVisual" runat="server" 
              DataSourceID="xmlL3TTrepresentationsVisual" DataTextField="Value" DataValueField="Value" 
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"
              />
           </asp:Panel>
        </div>


        <div class="question" id="L3TTfunctions">
          <div class="label">21. L3TT functions</div>
          <div class="tip">
            What are the functions for this particular instance of L3TT?
            <a href="#L3TTfunctions" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>Any functions not provided as options, or if there are doubts or more than one possibility can all be recorded in L3TT Tags, or, if problematic, in “Remarks for L3ST analysis” item.</p>
              <p>Plot (twist) involves a shift (twist) in the story/narrative because of the L3;</p>
              <p>Suspense means the audience’s lack of understanding of L3 is used to create suspensea until they can find out what is involved.</p>
              <p>Dramatic effect means dramatic impact of communication barrier, e.g. creating misunderstanding, frustration, prejudice, missed opportunities, etc. among the characters.</p>
              <p>This item is repeated in Form 3, for comparison.</p>
            </div>
          </div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTfunctions" runat="server"
              DataSourceID="xmlL3TTfunctions" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question" id="L3TTconversationFeatures">
          <div class="label">22. Conversation features for L3TT-instance</div>
          <div class="tip">
            Conversation types or features (functional or otherwise) related to L3TT presence
            <a href="#L3TTconversationFeatures" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>Especially recommendable for any relevant information that is needed to fully appreciate the presence of L3 in the scene, or even in the larger context of the film.</p>
              <p>Make sure to match the tags for ST and TT, where that is the case, because any differences will be processed automatically as changes occurring between the ST and the TT on this point, to illustrate how the solution adopted for the translated version affects the nature of the conversation, i.e. producing diminished humour, or taboo, etc.</p>
              <p>This item is repeated in Form 3, for comparison.</p>
            </div>
          </div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3TTconversationFeatures" runat="server"
              DataSourceID="xmlL3TTconversationFeatures" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question" id="L3TTsources">
          <div class="label">23. L3TT sources <i>(with or without main language mix)</i></div>
          <div class="tip">
            Choose the description that best explains the number of sources (on or off screen, oral or written) and whether the main language is mixed with L3 (Main language, or “main”, is L2 for L3TT-instances)
            <a href="#L3TTsources" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>The point of the wide range of possible answers is to get information regarding how many speakers (sources) there are, how many modes (oral or written) are used, as well as how they combine, all in the same item. One must realise the question says “choose the option that best describes (i.e. if there is more than one option then only choose the ‘best’, and if there is no exact option, choose the closest approximation).</p>
              <p>Same character/source = one only (person or source)</p>
              <p>Different = more than one person or source / another one</p>
              <p>A “Source” may be a character speaking or a written message.</p>
              
              Alternative wording for these options: 
               <ul>
              <li>One L3 from one oral source</li>
              <li>One L3 from different oral sources</li>
              <li>Only one written instance of L3</li>
              <li>L3, spoken and written</li>
              <li>Bilingual (L3&main) from one source</li>
              <li>Sources (pl.) take turns in different languages</li>
              <li>Interlingual rendering from different sources</li>
              <li>Rephrase interlingually from one source</li>
              <li>Sources (pl.); fake or faulty translation</li>
              <li>Fake or faulty interlingual self-translation</li>
              <li>Non-diegetic interlingual translation</li>
              </ul>

              i.e. We are asking about these options:
              <ul>
              <li>1 source, oral only (1 mode)</li>
              <li>2 or more onscreen sources, oral only (1 mode)</li>
              <li>1 written source (1 mode, 1 source)</li>
              <li>2 or more written sources (1 mode, 2 or more sources)</li>
              <li>Combined sources: oral (on or off screen) & written</li>
              <li>Combined sources: on & off screen oral (1 mode, oral, 2 or more sources)</li>
              </ul>
              <p>This item is repeated in Form 3, for comparison.</p>
            </div>
          </div>
          <asp:DropDownList
            ID="listL3TTsources" runat="server"
            DataSourceID="xmlL3TTsources" DataTextField="Title" DataValueField="Value"
            />
        </div>


        <%-- Calculated from L3STinstance --%>
        
        <div class="calculated" id="L3languageTypeChange">
          <div class="label">L3 language type change (Calculated from L3ST-instance and L3TT-instance)</div>
          <div class="tip">L3ST language type: change in TT</div>
          <asp:ListBox ID="listL3languageTypeChange" runat="server" Enabled="false" />
        </div>
                
        <div class="calculated" id="L3modeChange">
          <div class="label">L3 mode change (Calculated from L3ST-instance and L3TT-instance)</div>
          <div class="tip">L3ST mode: change in TT</div>
          <asp:ListBox ID="listL3modeChange" runat="server" Enabled="false" />
        </div>

        <div class="calculated" id="L3functionsChange">
          <div class="label">L3 functions change (Calculated from L3ST-instance and L3TT-instance)</div>
          <div class="tip">L3ST functions: change in TT</div>
          <asp:ListBox ID="listL3functionsChange" runat="server" Enabled="false" />
        </div>

        <div class="calculated" id="L3conversationFeaturesChange">
          <div class="label">Conversation features for L3-instance change (Calculated from L3ST-instance and L3TT-instance)</div>
          <div class="tip">Conversation features for L3ST-instance: change in TT</div>
          <asp:ListBox ID="listL3conversationFeaturesChange" runat="server" Enabled="false" />
        </div>
        
        <div class="calculated" id="L3sourcesChange">
          <div class="label">L3 sources change (Calculated from L3ST-instance and L3TT-instance)</div>
          <div class="tip">L3ST sources: change in TT</div>
          <asp:ListBox ID="listL3sourcesChange" runat="server" Enabled="false" />
        </div>


        <%-- ITrafilmMetadata --%>

        <div class="question" id="Transcription">
          <div class="label">24. Transcription </div>
          <div class="tip">
            Transcription for the specific L3TT-instance
            <a href="#Transcription" class="openhelp">&#x26e8;</a>
            <div class="help">
              If possible, copy here the transcript of the words uttered in L3 for this instance.
            </div>
          </div>
          <asp:TextBox ID="txtTranscription" runat="server" TextMode="MultiLine" Rows="5" />
        </div>

        <div class="question" id="Tags">
          <div class="label">25. Tags</div>
          <div class="tip">
            Keywords or other labels for filtering purposes , insert a comma (,) between different ones
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
          <div class="label">26. Remarks </div>
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


        <%-- Video clip --%>

        <asp:Panel ID="panelVideo" runat="server" Visible="false">
          <div class="question" id="videoURL">
            <div class="label">Video for TT conversation (L2)</div>
  
            <asp:Panel ID="panelVideoDownload" runat="server" Visible="false">
              <div class="tip">Click link to open video or right click to save .mp4 file</div>
              <asp:HyperLink ID="linkVideo" runat="server" Target="_blank" />
            </asp:Panel>
        
            <asp:Panel ID="panelVideoUpload" runat="server" Visible="false">
              <div class="tip">Select video file (.mp4 only) to upload on "Save" (replaces any existing video if selected)</div>
              <asp:FileUpload id="uploadVideo" runat="server" />
            </asp:Panel>
          </div>        
        </asp:Panel>


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

      </asp:Panel>
    
    </form>

  </body>

</html>
