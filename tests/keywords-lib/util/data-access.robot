*** Settings ***
Documentation    Provides framework keywords for Test Data Management. Data can be accessed from local data files (JSON).

*** Keywords ***
Get JSON From File
    [Arguments]    ${filePath}
    ${json}=    Get file    ${filePath}
    ${object}=    Evaluate    json.loads('''${json}''')    json
    ${object}    Set To Dictionary      ${object}
    [Return]    ${object}

Get Json
    # Consider removing this in favour of 'Get JSON From File'
    [Arguments]     ${filePath}
    ${json_object}= 	Load JSON From File 	${filePath}
    [Return]    ${json_object}

    