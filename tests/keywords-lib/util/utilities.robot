*** Settings ***
Documentation    Provides framework keywords for Test Data Management. Utilities used in the particular Functions.

*** Keywords ***
Should Be Equal Values Or Warn   
    [Arguments]    ${value_first}    ${value_second}
    Log    ${value_first}
    Log    ${value_second}
    Run Keyword And Warn On Failure    Should be Equal     '${value_first}'    '${value_second}'

Should Be Equal Values
    [Arguments]    ${value_first}    ${value_second}
    Log    ${value_first}
    Log    ${value_second}
    Should be Equal     '${value_first}'    '${value_second}'

Wait For Download In The Current Folder
    [Arguments]   ${Path_to}
    ${Waiting_download}   Promise To Wait For Download    ${Path_to}
    Wait For   ${Waiting_download}

Getting Excel File And Read File
    [Arguments]   ${Path_to}
    ${Taking_values}   Get File    ${Path_to}    encoding=utf-8-sig    encoding_errors=strict
    [Return]    ${Taking_values}
    
# Getting Text And Log
#     [Arguments]     ${path}
#     ${getting}      Get Text    ${path}
#     Log    ${getting}
#     [Return]     ${getting}

Should Contain Values
    [Arguments]      ${val1}    ${val2}
    Log    ${val1}
    Log    ${val2}
    Should Be True      "${val1}" in """${val2}""" 

Should Contain Values Or Warn    
    [Arguments]      ${val1}    ${val2}
    Log    ${val1}
    Log    ${val2}
    Run Keyword And Warn On Failure     Should Be True      "${val2}" in """${val1}""" 

Should Be Equal Values Continue on Failure
    [Arguments]    ${value_first}    ${value_second}
    Log     ${value_first}    
    Log     ${value_second}
    Run keyword And Continue On Failure    Should Be Equal    '${value_first}'    '${value_second}'

Should Contain Values Continue on Failure
    [Arguments]    ${value_first}    ${value_second}
    Log     ${value_first}
    Log     ${value_second}
    Run keyword And Continue On Failure    Should Be True    '${value_second}'    '${value_first}'

Should Contain Values Continue on Failure.
    [Arguments]    ${value_first}    ${value_second}
    Log     ${value_first}
    Log     ${value_second}
    Run keyword And Continue On Failure    Should Be True    "${value_second}" in """${value_first}""" 

Infinite Waiting Time For Element To Disappear
    [Arguments]    ${path}
    FOR    ${i}    IN RANGE    1     99999999
        ${Check}    Run Keyword And Return Status    Wait For Elements State    ${path}   Hidden    timeout=0.5
        IF    '${Check}' == 'False'
            Continue For Loop
        ELSE IF    '${Check}' == 'True'
            Exit For Loop
        END
    END