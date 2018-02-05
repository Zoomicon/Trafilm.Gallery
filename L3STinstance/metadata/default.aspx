<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="Trafilm.Gallery.L3STinstanceMetadataPage" %>
<%@ Import namespace="Trafilm.Gallery" %>

<!DOCTYPE html>

<!--
Project: Trafilm.Gallery (http://github.com/zoomicon/Trafilm.Gallery)
Filename: L3STinstance\metadata\default.aspx
Version: 20171130
-->

<html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Trafilm Metadata | L3ST-instances</title>

    <meta name="viewport" content="width=400, user-scalable=yes, initial-scale=1" />

    <link href="../../css/metadata.css" rel="stylesheet" type="text/css" />
  </head>

  <body>

    <%-- DATA SOURCES --%>

    <asp:XmlDataSource ID="xmlL3STlanguageType" runat="server" DataFile="~/metadata/L3STlanguageType.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STconstructedBasedOn" runat="server" DataFile="~/metadata/L3constructedBasedOn.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STaudienceUnderstanding" runat="server" DataFile="~/metadata/L3audienceUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmessageUnderstanding" runat="server" DataFile="~/metadata/L3messageUnderstanding.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmeaningDecipherable" runat="server" DataFile="~/metadata/L3meaningDecipherable.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STspeakerPerformance" runat="server" DataFile="~/metadata/L3speakerPerformance.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STmode" runat="server" DataFile="~/metadata/L3mode.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STrepresented" runat="server" DataFile="~/metadata/L3represented.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STrepresentationsOral" runat="server" DataFile="~/metadata/L3representationsOral.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STrepresentationsVisual" runat="server" DataFile="~/metadata/L3representationsVisual.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STfunctions" runat="server" DataFile="~/metadata/L3functions.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STconversationFeatures" runat="server" DataFile="~/metadata/L3conversationFeatures.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlL3STsources" runat="server" DataFile="~/metadata/L3sources.xml" XPath="Facet/String" />
    <asp:XmlDataSource ID="xmlConversationDuration" runat="server" DataFile="~/metadata/ConversationDuration.xml" XPath="Facet/String" />


    <%-- WEBFORM --%>

    <form id="form1" defaultbutton="btnSave" defaultfocus="listL3STinstances" runat="server">

      <%-- STATUS MESSAGE --%>

      <asp:Panel runat="server" ID="panelStatus" CssClass="status" Visible="false">
        <asp:Label ID="labelStatus" runat="server"/>
      </asp:Panel>


      <%-- NAVIGATION MENU --%>

      <div class="navigation">
        <a href="http://trafilm.net" target="trafilm"><img src="http://trafilm.net/App_Themes/trafilm/img/logo.png" height="18" /></a>
        <a href="../../film/metadata/?film=<%=listFilms.SelectedValue%>">Films</a>
        <a href="../../conversation/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>">Conversations</a>
        <a class="selected" href="../../L3STinstance/metadata/">L3ST-instances</a>
        <a href="../../L3TTinstance/metadata/?film=<%=listFilms.SelectedValue%>&conversation=<%=listConversations.SelectedValue%>&L3STinstance=<%=listL3STinstances.SelectedValue%>">L3TT-instances</a>
        <a href="https://repositori.upf.edu/handle/10230/28223" target="trafilm guide" class="guide">Guide</a>
      </div>


      <%-- LOGIN STATUS --%>

      <div>
        <asp:LoginName ID="loginName" runat="server" FormatString="Welcome {0}!" /> [<asp:LoginStatus ID="loginStatus" runat="server"/>]
      </div>

      <%-- INSTRUCTIONS BOX --%>

      <asp:Panel ID="panelInstructions" runat="server" Visible="false" CssClass="instructions">
        Please fill in the following information for the L3ST-instance of your choice. Select it using the dropdown lists.<br />
        Try to fill the metadata as fully and accurately as possible, as they will be used for searching and filtering L3ST-instances.<br />
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
            <div class="label">Select an L3ST-instance</div> 
            <asp:DropDownList ID="listL3STinstances" runat="server" AutoPostBack="True" OnSelectedIndexChanged="listL3STinstances_SelectedIndexChanged" />

            <asp:Panel ID="panelAdd" runat="server">
              <div class="label">or add new L3ST-instance Id (e.g. <i>Speaking Chinese</i> - do not include the Film Id and Conversation Id prefixes)</div>
              <asp:TextBox ID="txtL3STinstance" runat="server" MaxLength="50" />
              <br />
              <asp:Button ID="btnAddL3STinstance" runat="server" Text="Add" OnClick="btnAddL3STinstance_Click" />
              &nbsp;
              <asp:CheckBox ID="cbClone" Text="Copy from selected" runat="server" Visible="false" />
              &nbsp;&nbsp;
              <asp:Button ID="btnRename" runat="server" Text="Rename selected" OnClick="btnRename_Click" />
            </asp:Panel>
          </asp:Panel>

        </asp:Panel>

      </div>

      
      <%-- METADATA INPUT UI --%>

      <asp:Panel ID="panelMetadata" runat="server" Visible="false">

        <%-- ICXMLMetadata--%>

        <div class="question" id="Title">
          <div class="label">1. L3ST-instance Title</div>
          <div class="tip">
            Free text descriptive title (&lt;50 characters)
            <a href="#Title" class="openhelp">&#x26e8;</a>
            <div class="help">
              Just as for the Conversation Title, but a bit more specific to the case of the L3-instance,
              e.g. partial transcription of the utterance, or description in pragmatic terms (e.g. insult, interruption, pun).
            </div>
          </div>
          <asp:TextBox ID="txtTitle" runat="server" />
        </div>

        <div class="question" id="Description">
          <div class="label">2. L3ST-instance Description</div>
          <div class="tip">
            Free text brief description (<200 characters)
            <a href="#Description" class="openhelp">&#x26e8;</a>
            <div class="help">
             Be careful to avoid redundant information, i.e. provided by other items in the questionnaire, such as
              items 1, 4 and 5: the language or language type for L3, or item 19, the “Tags for L3ST-instance features” item.
            </div>
          </div>
          <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" />
        </div>

        <div class="calculated" id="URL">
          <div class="label">L3ST-instance URL</div>
          <div class="tip">Metadata item URL, right-click to copy URL address</div>
          <asp:HyperLink ID="linkUrl" runat="server" Target="_blank" />
        </div>

        <div class="question" id="Image">
          <div class="label">3. Image URL</div>
          <div class="tip">
            <a href="#Image" class="openhelp">&#x26e8;</a>
            <div class="help">
            This item is provided in case it is convenient to include a reference image at Conversation level.
            </div>
          </div>
          <asp:TextBox ID="txtImageUrl" runat="server" />
        </div>


        <%-- IL3STinstanceMetadata --%>

        <div class="calculated" id="ConversationStartTime">
          <div class="label">Conversation start time (min) (Calculated from Conversation)</div>
          <div class="tip">What part of the film is the Conversation in? (i.e. how many minutes from the start)</div>
          <asp:Label ID="lblConversationStartTime" runat="server" />
        </div>

        <div class="calculated" id="ConversationDuration">
          <div class="label">Conversation duration (sec) (Calculated from Conversation)</div>
          <div class="tip">How long does the Conversation last? (if L3ST instances are interrupted by other speech, count total seconds from onset to end of final L3ST-instance)</div>
          <asp:Label ID="lblConversationDuration" runat="server" />
        </div>


        <div class="calculated" id="L1 language">
          <div class="label">L1 language (Calculated from Film)</div>
          <div class="tip">What language is L1 in?</div>
          <asp:Label ID="lblL1language" runat="server" />
        </div>


        <div class="question" id="L3STlanguageType">
          <div class="label">4. L3ST language type</div>
          <div class="tip">
            With L1 as main language (L-main), what type of language is L3ST?
            <a href="#L3STlanguageType" class="openhelp">&#x26e8;</a>
            <div class="help">
            This item is to filter L3 searches, according to the following groups:
            <ol>
            <li>Real languages (e.g. Italian, Latin, Esperanto), with actual speakers, originally, outside the world of fiction.
                Languages like Esperanto are included in this category.</li>
            <li>Constructed in fiction, made up, e.g. Star Trek Klingon).</li>
            <li>A variety of the main language, by user (dialect) or by use (sociolect); also idiolects and peculiar styles;
                importantly, for this analysis, clearly distinguishable from the main language, e.g. Cockney English, gangster slang, highly technical jargon.
                For one or a few characters only.</li>
            <li>Conditioned: Real language production and/or perception is conditioned by cognitive, articulatory, hearing (or external factors
                e.g. speaking with mouth full, a hostage who has a gag), caused by extreme tiredness or under extreme pressure (nerves, overexcitement),
                or under the influence, mumbling, muttering, sobbing, etc. to come across as slurred speech, unclear, incoherent, as/or too fast/too slow.
                Transitory or permanent condition.</li>
            </ol>
            <p>This item is repeated in Form 4, for comparison.</p> 
            </div>
          </div>
          <asp:DropDownList 
            ID="listL3STlanguageType" runat="server"
            DataSourceID="xmlL3STlanguageType" DataTextField="Title" DataValueField="Value" />
        </div>

        <div class="question" id="L3STlanguage">
          <div class="label">5. L3ST language</div>
          <div class="tip">
            Which language is L3ST?
            <a href="#L3STlanguage" class="openhelp">&#x26e8;</a>
            <div class="help">
              Free text. Type in the language for this particular L3ST-instance, e.g. Swedish, Korean, Klingon, Elvish, Dothraki.
              OR “unknown”. Type in a single word for the language, in English, with a capital first letter. If you cannot recognise
              the language, then type in the word unknown. When inserting a language, please specify in order of more general to more
              specific, in those cases that need specifying; e.g. Spanish South American Chile, or English US Southern Georgia.
              Only be as specific as you need to be and know for sure. For sign language, write “English sign-language”, or more specifically,
              “English US sign language”, or if you do not know, just: “sign language”.
              <p>This item is repeated in Form 4, for comparison.</p>
            </div>
          </div>
          <asp:TextBox ID="txtL3STlanguage" runat="server" />
        </div>


        <div class="question" id="L3STconstructedBasedOn">
          <div class="label">6. L3ST constructed based on</div>
          <div class="tip">
            If L3ST is “constructed”, is it based on any of the following options?
            <a href="#L3STconstructedBasedOn" class="openhelp">&#x26e8;</a>
            <div class="help">
              Options include L1 and L2 combinations, and other relevant distinctions such as historical or pseudo-historical
              (e.g. Lord of the Rings, Conan, or Game of Thrones-style L3 constructed languages, etc.).
              Gibberish is for unintelligible speech, normally interpreted as deliberately unintelligible.
              “From scratch” is for L3-constructed not based on any ‘real’ language (e.g. R2D2 in Star Wars).
              If “Other” is selected, maybe it is interesting to add why and how, in the “Remarks for L3ST analysis” item.
              <p>This item is repeated in Form 4, for comparison.</p>
            </div>
          </div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STconstructedBasedOn" runat="server" 
              DataSourceID="xmlL3STconstructedBasedOn" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question" id="L3STaudienceUnderstanding">
          <div class="label">7. L3ST meant to be understood</div>
          <div class="tip">
            Is L3ST meant to be understood by most of the audience?
            <a href="#L3STaudienceUnderstanding" class="openhelp">&#x26e8;</a>
            <div class="help">
              This item is asking about the comprehensibility of the L3 utterance for the intended audience
              without the aid of diegetic or non-diegetic translation or explanation.
              <p>This item is repeated in Form 4, for comparison.</p>
            </div>
          </div>
          <asp:DropDownList 
            ID="listL3STaudienceUnderstanding" runat="server"
            DataSourceID="xmlL3STaudienceUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question" id="L3STmessageUnderstanding">
          <div class="label">8. L3ST message required for understanding</div>
          <div class="tip">
            Does L3ST carry a meaningful message or one that requires it to be understood?
            <a href="#L3STmessageUnderstanding" class="openhelp">&#x26e8;</a>
            <div class="help">
              Regardless of whether L3 can be understood (“meant to be understood” item) this item is asking
              whether the audience needs to know what is being said, even if it can be understood but not necessary or vice versa,
              cannot be understood but should be, or both can be and needs to be understood.
              <p>This item is repeated in Form 4, for comparison.</p>
            </div>
          </div>
          <asp:DropDownList 
            ID="listL3STmessageUnderstanding" runat="server"
            DataSourceID="xmlL3STmessageUnderstanding" DataTextField="Value" DataValueField="Value" />
        </div>

        <div class="question" id="L3STmeaningDecipherable">
          <div class="label">9. L3ST meaning decipherable</div>
          <div class="tip">
            Can the (pragmatic) meaning of L3ST be deciphered by other means?
            <a href="#L3STmeaningDecipherable" class="openhelp">&#x26e8;</a>
            <div class="help">
              Even if the utterance is not meant to be understood verbally (due to its “foreignness”), can the message be decoded
              by non-verbal means or because it is (somehow) translated?
              By "translated" here we mean in the broadest sense of the word, ranging from literal foreign rendering to
              free rendering to interlingual or intralingual paraphrase.
              <p>This item is repeated in Form 4, for comparison.</p>
            </div>
          </div>
          <asp:DropDownList 
            ID="listL3STmeaningDecipherable" runat="server"
            DataSourceID="xmlL3STmeaningDecipherable" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question" id="L3STspeakerPerformance">
          <div class="label">10. Quality of L3ST speaker performance</div>
          <div class="tip">
            How well is the L3ST spoken?
            <a href="#L3STspeakerPerformance" class="openhelp">&#x26e8;</a>
            <div class="help">
              Three options, to know whether the L3 is spoken
              (i) natively or very well;
              (ii) not well; quite bad, communicatively incompetent or
              (iii) not even serious or realistic portrayal of the language.
              When in doubt, for example between “very well” and “not well”, or between “not well” and “farcical”,
              the determining factor must be the importance of the distinction in relation to the story, the script,
              character portrayal, the nature of the scene, etc.
              <p>This item is repeated in Form 4, for comparison.</p>
            </div>
          </div>
          <asp:DropDownList 
            ID="listL3STspeakerPerformance" runat="server"
            DataSourceID="xmlL3STspeakerPerformance" DataTextField="Value" DataValueField="Value" />
        </div>


        <div class="question" id="L3STmode">
          <div class="label">11. L3ST mode, written/spoken, diegetic</div>
          <div class="tip">
            Mode of L3ST?
            <a href="#L3STmode" class="openhelp">&#x26e8;</a>
            <div class="help">
              Here we are asking a two-in-one about whether L3 is spoken or written and whether it is within the fiction
              of the story or directly addressed to the audience. In the case of L3 it is unlikely that it will be non-diegetic,
              although the translation of L3 could be.
              Also included is the possibility of sign-language for the deaf as an oral-visual L3.
              <p>This item is repeated in Form 4, for comparison.</p>
            </div>
          </div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STmode" runat="server" 
              DataSourceID="xmlL3STmode" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question" id="L3STrepresented">
          <div class="label">12. L3ST merely represented</div>
          <div class="tip">
            There is no actual L3ST, but there are clues
            <a href="#L3STrepresented" class="openhelp">&#x26e8;</a>
            <div class="help">
              L3 is hinted at or foregrounded by certain “clues”, verbally (in the L1) or non-verbally (to be seen or heard).
              There may actually be no L3ST as such, strictly speaking. In the scene characters may be portrayed as not understanding
              each other (because they are supposed to be speaking different languages) even if the audience hears them all speaking
              the audience’s language (the main language of the film).
              <p>This item is repeated in Form 4, for comparison.</p>
            </div>
          </div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STrepresented" runat="server" 
              DataSourceID="xmlL3STrepresented" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question" id="L3STrepresentedOrally">
          <div class="label">13. L3ST merely represented orally</div>
          <div class="tip">
            If “oral” selected for question on “L3ST represented”, specify how:
            <a href="#L3STrepresentedOrally" class="openhelp">&#x26e8;</a>
            <div class="help">
              This item can be linked to the answer provided for item “L3ST represented” and can also be used to inquire about
              the various possibilities of oral representation of L3 by oral means.
              <p>This item is repeated in Form 4, for comparison.</p>
            </div>
          </div>
          <div class="tip"></div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STrepresentationsOral" runat="server" 
              DataSourceID="xmlL3STrepresentationsOral" DataTextField="Title" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        <div class="question" id="L3STrepresentedVisually">
          <div class="label">14. L3ST represented: visual</div>
          <div class="tip">
            If “visual” selected for question on “L3ST represented”, specify how:
            <a href="#L3STrepresentedVisually" class="openhelp">&#x26e8;</a>
            <div class="help">
              This item is NOT necessarily dependent on the answer provided for
              item “L3ST represented” as it inquiries about the various possibilities of representing (or reinforcing, or signaling)
              L3-presence by visual means. Use if you think it can provide useful complementary data for L3.
            </div>
          </div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STrepresentationsVisual" runat="server" 
              DataSourceID="xmlL3STrepresentationsVisual" DataTextField="Value" DataValueField="Value" 
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"
              />
           </asp:Panel>
        </div>


        <div class="question" id="L3STfunctions">
          <div class="label">15. L3ST functions</div>
          <div class="tip">
            What are the functions for this particular instance of L3ST?
            <a href="#L3STfunctions" class="openhelp">&#x26e8;</a>
            <div class="help">
              Any functions not provided as options, or if there are doubts or more than one possibility can all be recorded in Tags,
              or if problematic, “Remarks for L3ST analysis” item.
              Plot (twist) involves a shift (twist) in the story/narrative because of the L3;
              Suspense means the audience’s lack of understanding of L3 is used to create suspense... until they can find out what is involved.
              Dramatic effect means dramatic impact of communication barrier, e.g. creating misunderstanding, frustration, prejudice, missed
              opportunities, etc. among the characters.
              <p>This item is repeated in Form 4, for comparison.</p>
            </div>
          </div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STfunctions" runat="server" 
              DataSourceID="xmlL3STfunctions" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="9" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>


        <div class="question" id="L3STconversationFeatures">
          <div class="label">16. Conversation features for L3ST-instance</div>
          <div class="tip">
            Conversation types or features (functional or otherwise) related to L3ST presence
            <a href="#L3STconversationFeatures" class="openhelp">&#x26e8;</a>
            <div class="help">
              Especially recommendable for any relevant information that is needed to fully appreciate the presence of L3 in the scene,
              or even in the larger context of the film.
              Make sure to match the options for ST and TT, where that is the case, because any differences will be processed automatically
              as changes occurring between the ST and the TT on this point, to illustrate how the solution adopted for the translated version
              affects the nature of the conversation, i.e. producing diminished humour, or taboo, etc. If you can’t find an appropriate option,
              choose the one that is closest to your case, and then you can add a precise, exact description by inserting key words in the Tags
              item (19). If you think this creates a problem for you, write the nature of the problem in the Remarks item (20).
              <p>This item is repeated in Form 4, for comparison.</p>
            </div>
          </div>
          <asp:Panel runat="server" ScrollBars="Auto">
            <asp:CheckBoxList ID="clistL3STconversationFeatures" runat="server"
              DataSourceID="xmlL3STconversationFeatures" DataTextField="Value" DataValueField="Value"
              RepeatLayout="Table" RepeatColumns="8" RepeatDirection="Vertical"               
              />
           </asp:Panel>
        </div>

        
        <div class="question" id="L3STsources">
          <div class="label">17. L3ST sources <i>(with or without main language mix)</i></div>
          <div class="tip">
            Choose the description that best explains the number of sources (on or off screen, oral or written)
            and whether the main language is mixed with L3 (Main language, or “main”, is L1 for L3ST-instances)
            <a href="#L3STsources" class="openhelp">&#x26e8;</a>
            <div class="help">
              <p>
                The point of the wide range of possible answers is to get information regarding how many speakers (sources) there are,
                how many modes (oral or written) are used, as well as how they combine, all in the same item.
                One must realise the question says “choose the option that best describes (i.e. if there is more than one option then
                only choose the ‘best’, and if there is no exact option, choose the closest approximation).
              </p>
              <p>Same = one only (person or source)</p>
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
              
              <p>This item is repeated in Form 4, for comparison.</p>
            </div>
          </div>
          <asp:DropDownList
            ID="listL3STsources" runat="server"
            DataSourceID="xmlL3STsources" DataTextField="Title" DataValueField="Value"
            />
        </div>


        <%-- Calculated from L3TTinstances --%>

        <%-- //Count shown in parentheses next to title of respective list
        <div class="calculated" id=L3TTinstanceCount">
          <div class="label">Count of L3TT-instances (Calculated)</div>
          <asp:Label ID="lblL3TTinstanceCount" runat="server" />
        </div>    
        --%>

        <%-- ITrafilmMetadata --%>

        <div class="question" id="Transcription">
          <div class="label">18. Transcription </div>
          <div class="tip">
            Transcription for the specific L3ST-instance
            <a href="#Transcription" class="openhelp">&#x26e8;</a>
            <div class="help">
              If possible, copy here the transcript of the words uttered in L3 for this instance.
            </div>
          </div>
          <asp:TextBox ID="txtTranscription" runat="server" TextMode="MultiLine" Rows="5" />
        </div>

        <div class="question" id="Tags">
          <div class="label">19. Tags</div>
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
          <div class="label">20. Remarks </div>
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
            <div class="label">Video for ST conversation (L1)</div>
  
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


        <%-- L3TTinstances list --%>                  

        <div class="calculated" id="L3TTinstances">
          <div class="label">L3TT-instances (#<asp:Label ID="lblL3TTinstanceCount" runat="server" />)</div>
          <asp:Repeater ID="repeaterL3TTinstances" runat="server">
            <ItemTemplate>
              <a href="../../L3TTinstance/metadata/?film=<%#Eval("filmId")%>&conversation=<%#Eval("conversationId")%>&L3STinstance=<%#Eval("L3STinstanceId")%>&L3TTinstance=<%#Eval("L3TTinstanceId")%>"><%#Eval("L3TTinstanceId").ToString().TrimStart(Eval("L3STinstanceId").ToString() + ".")%></a>&nbsp;&nbsp;
            </ItemTemplate>
          </asp:Repeater>
          <br />
          <br />
        </div>
    
      </asp:Panel>

    </form>

  </body>

</html>
