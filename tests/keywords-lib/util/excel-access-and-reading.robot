*** Settings ***
Documentation    Provides framework keywords for Test Data Management. Excel Access And Reading used for reading Excel files.

*** Keywords ***
Lines Adding Into List
    [Arguments]     ${splitted}
    ${Splitting_lines}    Set Variable    ${splitted}
    ${Splitting_lines}    Remove String    ${Splitting_lines}    " 
    @{Splitting_lines}    Split String    ${Splitting_lines}    ,
    ${count}    Get Length    ${Splitting_lines}
    @{Splitting_lines_naming}    Create List
    Append To List	 ${Splitting_lines_naming}    @{Splitting_lines}
    [Return]     ${Splitting_lines_naming}

Making Dictionary Of File
    [Arguments]     ${Splitting_lines_Head_List_ARG}     ${Splitting_lines_val_List_arg}
    ${Length_of_Lines}      Get Length      ${Splitting_lines_Head_List_ARG}
    &{Naming_Values}     Create Dictionary
    FOR   ${Length_of_Lines_Each}    IN RANGE    0    ${Length_of_Lines}
        ${Key_Adding_Each}    Get From List    ${Splitting_lines_Head_List_ARG}     ${Length_of_Lines_Each}
        ${Value_Adding_Each}    Get From List    ${Splitting_lines_val_List_arg}    ${Length_of_Lines_Each}
        Set To Dictionary     ${Naming_Values}    ${Key_Adding_Each}      ${Value_Adding_Each}        
    END
    Set Global Variable     ${Naming_Values}

Downloading File And Store Into Dictionary
    [Arguments]      ${path_to}
    Wait For Download In The Current Folder    ${path_to}
    ${Taking_values}    Getting Excel File And Read File    ${Path_to}
    ${line_count}    Get Line Count    ${Taking_values}
    Set Global Variable     ${line_count}
    @{Splitting_lines}   Split To Lines   ${Taking_values}
    &{Splitting_lines_lists}     Create Dictionary  
    &{Naming_Values_Mixing}     Create Dictionary   
    ${Splitting_lines_Head_List}     Lines Adding Into List    ${Splitting_lines}[0]
    FOR    ${i}    IN RANGE    1    ${line_count}
        ${Splitting_lines_val_List}     Lines Adding Into List    ${Splitting_lines}[${i}]
        Set To Dictionary     ${Splitting_lines_lists}     Lines_Each${i}=${Splitting_lines_val_List}
        Making Dictionary Of File     ${Splitting_lines_Head_List}       ${Splitting_lines_lists}[Lines_Each${i}]
        Set To Dictionary    ${Naming_Values_Mixing}     Taking_Values_From_Downloaded_File_${i}    ${Naming_Values}
    END
    [Return]     ${Naming_Values_Mixing}