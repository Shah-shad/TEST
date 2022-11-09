*** Settings ***
Documentation    Provides framework keywords for Test Data Management. Storing Common Keywords, Every Resoruces,Every Libararies.
Library   Browser
Library    OperatingSystem
Library    Collections
Library    BuiltIn
Library    ${CURDIR}/../../../common/pylib/Commons.py
Library    ${CURDIR}/../../../common/pylib/DynamicTestLibrary.py
Library     String
Library     DateTime
Library    JSONLibrary
Library    JsonValidator
Library      XvfbRobot
# Library    Pdf2TextLibrary
Library      pabot.PabotLib
# Library      DocTest.VisualTest

#Resource
Resource    ${CURDIR}/../util/excel-access-and-reading.robot
Resource    ${CURDIR}/../util/pdf-access-and-reading.robot
Resource    ${CURDIR}/../util/data-access.robot
Resource    ${CURDIR}/../util/utilities.robot
Resource    ${CURDIR}/../app/appSession.robot
Resource    ${CURDIR}/../app/searchResults.robot
Resource    ${CURDIR}/../app/orderView.robot
Resource    ${CURDIR}/../app/search.robot
Resource    ${CURDIR}/../browser/browser-keywords.robot

*** Variables ***
${pagesDir}    ${CURDIR}/../../pages
${dataDir}    ${CURDIR}/../../data
${downloading_excel_path}     ${CURDIR}/../../dowloaded_excel_files
${downloading_pdf_path}     ${CURDIR}/../../dowloaded_pdf_files
${download_trace_path}    ${CURDIR}/../../downloaded_trace
${IMAGE_DIR}    ${CURDIR}/../../data/image
${AirlineCode}
*** Keywords ***
Date Creation
    [Arguments]    ${date}
    ${str_date}    Set Variable    ${date}
    @{date}  Split String  ${date}  /
    ${day}=    Remove String    ${date}[0]    ${SPACE}
    ${month}=    Remove String    ${date}[1]    ${SPACE}
    IF    '${month}' == '10'
        Log    ${month}
        ${creating_date_month}    Set Variable    ${month}
        ${int_month}=    Remove String    ${month}   ${SPACE}
    ELSE
        ${creating_date_month}    Set Variable    ${month}
        ${int_month}=    Remove String    ${month}   0
    END
    ${year}=    Remove String    ${date}[2]    ${SPACE}  
    ${convert_date}    Catenate    SEPARATOR=/    ${year}    ${month}    ${day}
    ${departuredate_month_str}    Convert Date   ${convert_date}      result_format=%B
    IF    '${day}' == '30'
        ${creating_date_day}    Set Variable    ${day}
    ELSE IF    '${day}' == '10'
        ${creating_date_day}    Set Variable    ${day}
    ELSE IF    '${day}' == '20'
        ${creating_date_day}    Set Variable    ${day}
    ELSE
        ${creating_date_day}    Set Variable    ${day}
        ${day}=    Remove String    ${day}   0
    END
    ${str_month}    Set Variable    ${departuredate_month_str}
    Set Global Variable    ${day}
    Set Global Variable    ${str_month}
    Set Global Variable    ${year}
    ${month}    Set Variable    ${int_month}
    Set Global Variable    ${int_month}
    Set Global Variable    ${month}
    ${Date_creation_Y-d-m}     Catenate    SEPARATOR=-     ${year}    ${creating_date_month}    ${creating_date_day}
    ${Date_creation_Y-d-m}    Set Variable     ${Date_creation_Y-d-m}
    Set Global Variable    ${Date_creation_Y-d-m}
    ${Date_creation}     Catenate    SEPARATOR=-    ${creating_date_day}    ${creating_date_month}    ${year}
    Set Global Variable    ${Date_creation}
    
Rule Set Validation For Discount And Service Fee    
    [Arguments]    ${RulesetFormula}
    @{Spliting_rule_set1}    Split String    ${RulesetFormula}    %      
    @{Spliting_rule_set2}    Split String    ${Spliting_rule_set1}[1]    +
    ${BaseFarenum}    Convert To Number    ${Spliting_rule_set2}[0]
    @{Spliting_rule_set3}    Split String    ${Spliting_rule_set1}[2]    +
    ${YQnum}    Convert To Number    ${Spliting_rule_set3}[0]
    ${YRnum}    Convert To Number    ${Spliting_rule_set1}[3]
    ${RuleSet_Formula}    Evaluate    (${BaseFare}*${BaseFarenum})/100 + (${YQ}*${YQnum})/100 + (${YR}*${YRnum})/100
    ${RuleSet_Formula}    Convert To Number    ${RuleSet_Formula}    2
    ${RuleSet_Formula}=  Evaluate  "%.2f" % ${RuleSet_Formula}
    Set Global Variable    ${RuleSet_Formula}

Downloading Trace
    [Arguments]     ${Path_to}
    Log     ${Path_to}
    Wait For Elements State    ${Workbench.DownloadTrace}   Visible    timeout=30
    Click    ${Workbench.DownloadTrace}
    Wait For Download In The Current Folder     ${Path_to}
    Set Size Of Window

# Lines Adding Into List
#     [Arguments]     ${splitted}
#     ${Splitting_lines}    Set Variable    ${splitted}
#     ${Splitting_lines}    Remove String    ${Splitting_lines}    " 
#     @{Splitting_lines}    Split String    ${Splitting_lines}    ,
#     ${count}    Get Length    ${Splitting_lines}
#     @{Splitting_lines_naming}    Create List
#     Append To List	 ${Splitting_lines_naming}    @{Splitting_lines}
#     [Return]     ${Splitting_lines_naming}

# Making Dictionary Of File
#     [Arguments]     ${Splitting_lines_Head_List_ARG}     ${Splitting_lines_val_List_arg}
#     ${Length_of_Lines}      Get Length      ${Splitting_lines_Head_List_ARG}
#     &{Naming_Values}     Create Dictionary
#     FOR   ${Length_of_Lines_Each}    IN RANGE    0    ${Length_of_Lines}
#         ${Key_Adding_Each}    Get From List    ${Splitting_lines_Head_List_ARG}     ${Length_of_Lines_Each}
#         ${Value_Adding_Each}    Get From List    ${Splitting_lines_val_List_arg}    ${Length_of_Lines_Each}
#         Set To Dictionary     ${Naming_Values}    ${Key_Adding_Each}      ${Value_Adding_Each}        
#     END
#     Set Global Variable     ${Naming_Values}

# Downloading File And Store Into Dictionary
#     [Arguments]      ${path_to}
#     Wait For Download In The Current Folder    ${path_to}
#     ${Taking_values}    Getting Excel File And Read File    ${Path_to}
#     ${line_count}    Get Line Count    ${Taking_values}
#     Set Global Variable     ${line_count}
#     @{Splitting_lines}   Split To Lines   ${Taking_values}
#     &{Splitting_lines_lists}     Create Dictionary  
#     &{Naming_Values_Mixing}     Create Dictionary   
#     ${Splitting_lines_Head_List}     Lines Adding Into List    ${Splitting_lines}[0]
#     FOR    ${i}    IN RANGE    1    ${line_count}
#         ${Splitting_lines_val_List}     Lines Adding Into List    ${Splitting_lines}[${i}]
#         Set To Dictionary     ${Splitting_lines_lists}     Lines_Each${i}=${Splitting_lines_val_List}
#         Making Dictionary Of File     ${Splitting_lines_Head_List}       ${Splitting_lines_lists}[Lines_Each${i}]
#         Set To Dictionary    ${Naming_Values_Mixing}     Taking_Values_From_Downloaded_File_${i}    ${Naming_Values}
#     END
#     [Return]     ${Naming_Values_Mixing}