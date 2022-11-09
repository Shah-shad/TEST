*** Settings ***
Documentation    Shared keywords used in the Application - Search page.

*** Keywords ***
Trip Type    
    [Arguments]    ${list}
    Click    ${Workbench.TripType.Click}
    Wait For Elements State    ${Workbench.TripType.Menu}   Visible    timeout=15
    IF    '${list}' == 'One Way'
        Click    ${Workbench.TripType.OneWay}
    ELSE IF    '${list}' == 'Round Trip'
        Click    ${Workbench.TripType.RoundTrip}
    ELSE IF    '${list}' == 'Multi City'
        Click    ${Workbench.TripType.MultiCity}
    END

Passenger
    [Arguments]    ${pax_ids}
    Log     ${pax_ids}
    @{list_adult}    Create List     
    @{list_child}    Create List  
    @{list_infant}    Create List  
    FOR     ${paxtest_each}      IN    @{pax_ids}
        @{converting}    Split String    ${paxtest_each}    -
        ${converting}    Set Variable    ${converting}[1]
        ${converting}    Strip String    ${converting}
        IF  '${converting}' == 'ADT'
            Append To List	${list_adult}  ${converting}
        ELSE IF  '${converting}' == 'CHD'
            Append To List	${list_child}  ${converting}
        ELSE IF  '${converting}' == 'INF'
            Append To List	${list_infant}  ${converting}
        END
    END
    ${adults_num}    Get Length    ${list_adult}
    ${child_num}    Get Length    ${list_child}
    ${infant_num}    Get Length    ${list_infant}
    Set Global Variable  ${adults_num}
    Set Global Variable  ${child_num}
    Set Global Variable  ${infant_num}
    Click    ${Workbench.Passenger.Click}
    Wait For Elements State    ${Workbench.Passenger.Menu}   Visible    timeout=15
    #Adults
    IF   '${adults_num}' == '0'
        Click   ${Workbench.Passenger.AdultSub}
    ELSE
        FOR    ${i}    IN RANGE    ${adults_num}
            ${checking}    Get Text    ${Workbench.Passenger.AdultText}
            ${confirm}    Run Keyword And Return Status    Should Be Equal    '${checking}'    '${adults_num}'
            IF        '${confirm}' == 'True'
                Exit For Loop
            END
            IF        '${confirm}' == 'False'
                Click    ${Workbench.Passenger.AdultAdding}
            END
        END
    END
    #Childs
    FOR    ${i}    IN RANGE    ${child_num}+1
        ${checking}    Get Text    ${Workbench.Passenger.ChildText}
        ${confirm}    Run Keyword And Return Status    Should Be Equal    '${checking}'    '${child_num}'
        IF        '${confirm}' == 'True'
            Exit For Loop
        END
        IF        '${confirm}' == 'False'
            Click    ${Workbench.Passenger.ChildAdding}
        END
    END
    #Infant
    FOR    ${i}    IN RANGE    ${infant_num}+1
        ${checking}    Get Text    ${Workbench.Passenger.InfantText}
        ${confirm}    Run Keyword And Return Status    Should Be Equal    '${checking}'    '${infant_num}'
        IF        '${confirm}' == 'True'
            Exit For Loop
        END
        IF        '${confirm}' == 'False'
            Click    ${Workbench.Passenger.InfantAdding}
        END
    END
    Click    ${Workbench.Heading}

Cabin    
    [Arguments]    ${list}
    Log    ${list}
    IF    '${search_details}[triptype]' == 'One Way'
        ${value}     Set Variable     [1]
        Click    ${Workbench.Cabin.Click}${value}
        Cabin For Different     ${list}
    ELSE IF    '${search_details}[triptype]' == 'Round Trip'
        ${value}     Set Variable     [1]
        Click    ${Workbench.Cabin.Click}${value}
        Cabin For Different     ${list}
        ${value}     Set Variable     [2]
        Click    ${Workbench.Cabin.Click}${value}
        Cabin For Different     ${search_details}[returncabin]
    ELSE IF    '${search_details}[triptype]' == 'Multi City'
        FOR    ${i}    IN RANGE    1    2
            ${value}     Set Variable     [${i}]
            Click    ${Workbench.Cabin.Click}${value}
            Cabin For Different     ${list}
        END
    END

Cabin For Different    
    [Arguments]    ${list}
    Wait For Elements State    ${Workbench.Cabin.Menu}   Visible    timeout=15
    IF    '${list}' == 'First'    
        Click    ${Workbench.Cabin.First}
        Wait For Elements State    ${Workbench.Cabin.Menu}   Hidden    timeout=15
    END
    IF    '${list}' == 'Economy'
        Click    ${Workbench.Cabin.Economy}
        Wait For Elements State    ${Workbench.Cabin.Menu}   Hidden    timeout=15
    END
    IF    '${list}' == 'Business'
        Click    ${Workbench.Cabin.Business}
        Wait For Elements State    ${Workbench.Cabin.Menu}   Hidden    timeout=15
    END
    
Departure Date And Return Date
    [Arguments]     ${date}
    Departure Date    ${date}    [1]
    IF    '${search_details}[triptype]' == 'Round Trip'
        Return Date    ${search_details}[returnDateOffset]
    END

Departure Date
    [Arguments]    ${date}    ${value}
    ${Condition_Apply}      Run Keyword And Return Status  Should Contain     '${date}'     /
    IF  '${Condition_Apply}' == 'False'
        ${Adding_date}    Set Variable    ${date}
        Set Global Variable    ${Adding_date}
        ${date}     Get Current Date    result_format=%d/%m/%Y   increment=${date} days
    END
    Date Creation    ${date}
    Validating Date
    Click    ${Workbench.DepartureDate.Click}${value}
    Wait For Elements State    ${Workbench.DepartureDate.Menu}   Visible    timeout=15
    FOR    ${i}    IN RANGE    1    50
        ${checking}    Get Text    ${Workbench.DepartureDate.MenuMonthAndYear}
        @{month and year}    Split String    ${checking}    ${SPACE}
        ${text year}    Set Variable    ${month and year}[1]
        ${confirm}    Run Keyword And Return Status    Should Be Equal    '${text year}'    '${year}'
        IF    '${confirm}' == 'False'
            Click    ${Workbench.DepartureDate.NextMonth}
        END
        IF    '${confirm}' == 'True'
            Exit For Loop
        END
    END
    Take Screenshot
    FOR    ${i}    IN RANGE    1    12
        ${checking}    Get Text    ${Workbench.DepartureDate.MenuMonthAndYear}
        @{month and year}    Split String    ${checking}    ${SPACE}
        ${text month}    Set Variable    ${month and year}[0]
        ${text month}    Strip String    ${text month}
        ${confirm}    Run Keyword And Return Status    Should Be Equal    '${text month}'    '${str_month}'
        IF    '${confirm}' == 'False'
            Click    ${Workbench.DepartureDate.NextMonth}
        END
        IF    '${confirm}' == 'True'
            Exit For Loop
        END
    END
    Take Screenshot
    FOR    ${i}    IN RANGE    1    40
        ${value}    Set Variable    [${i}]
        ${checking}    Get Text    ${Workbench.DepartureDate.Day}${value}
        ${confirm}    Run Keyword And Return Status    Should Contain    '${checking}'    '${day}'
        IF    '${confirm}' == 'True'
            ${Checking_month}   Get Attribute   ${Workbench.DepartureDate.Day}${value}   aria-label
            ${contains}=  Evaluate   "${str_month}" in """${Checking_month}"""
            ${Confirming_month}     Run Keyword And Return Status    Should Be True      "${str_month}" in """${Checking_month}"""
            IF   '${Confirming_month}' == 'True'
                Click    ${Workbench.DepartureDate.Day}${value}
                Exit For Loop
            END
        END
    END
    ${Date_Creation_Departure_Date_Y-d-m}    Set Variable   ${Date_creation_Y-d-m}
    Set Global Variable     ${Date_Creation_Departure_Date_Y-d-m}
    
Return Date
    [Arguments]    ${date}
    ${Return_date}     Set Variable    ${date}
    ${Condition_Apply}      Run Keyword And Return Status  Should Contain     '${Return_date}'     /
    IF  '${Condition_Apply}' == 'False'
        ${Return_date}     Evaluate    ${Adding_date} + ${Return_date}
        ${Return_date}     Get Current Date    result_format=%d/%m/%Y   increment=${Return_date} days
    END
    Date Creation    ${Return_date}
    Validating Date
    Click    ${Workbench.ReturnDate.Click}
    Wait For Elements State    ${Workbench.ReturnDate.Menu}   Visible    timeout=15
    FOR    ${i}    IN RANGE    1    50
        ${checking}    Get Text    ${Workbench.ReturnDate.MenuMonthAndYear}
        @{month and year}    Split String    ${checking}    ${SPACE}
        ${text year}    Set Variable    ${month and year}[1]
        ${confirm}    Run Keyword And Return Status    Should Be Equal    '${text year}'    '${year}'
        IF    '${confirm}' == 'False'
            Click    ${Workbench.ReturnDate.NextMonth}
        END
        IF    '${confirm}' == 'True'
            Exit For Loop
        END
    END
    FOR    ${i}    IN RANGE    1    12
        ${checking}    Get Text    ${Workbench.ReturnDate.MenuMonthAndYear}
        @{month and year}    Split String    ${checking}    ${SPACE}
        ${text month}    Set Variable    ${month and year}[0]
        ${text month}    Strip String    ${text month}
        ${confirm}    Run Keyword And Return Status    Should Be Equal    '${text month}'    '${str_month}'
        IF    '${confirm}' == 'False'
            Click    ${Workbench.ReturnDate.NextMonth}
        END
        IF    '${confirm}' == 'True'
            Exit For Loop
        END
    END
    FOR    ${i}    IN RANGE    1    40
        ${value}    Set Variable    [${i}]
        ${checking}    Get Text    ${Workbench.ReturnDate.Day}${value}
        ${confirm}    Run Keyword And Return Status    Should Contain    '${checking}'    '${day}'
        IF    '${confirm}' == 'True'
            ${Checking_month}   Get Attribute   ${Workbench.ReturnDate.Day}${value}   aria-label
            ${contains}=  Evaluate   "${str_month}" in """${Checking_month}"""
            ${Confirming_month}     Run Keyword And Return Status    Should Be True      "${str_month}" in """${Checking_month}"""
            IF   '${Confirming_month}' == 'True'
                Click    ${Workbench.ReturnDate.Day}${value}
                Exit For Loop
            END
        END
    END

checking list from
    [Arguments]    ${list}
    FOR    ${i}    IN RANGE    1    10
        ${value1}    Set Variable    [${i}]
        ${value2}    Set Variable    ${Workbench.FromList}${value1}
        Wait For Elements State    ${value2}    Visible    timeout=15
        ${checking_text}    Get Text    ${value2}
        ${confirm}    Run Keyword And Return Status    should contain    ${checking_text}    ${list}
            IF    '${confirm}' == 'True' 
                Click    ${value2}
                Exit For Loop
            END
    END

checking list to
    [Arguments]    ${list}
    FOR    ${i}    IN RANGE    1    10
        ${value1}    Set Variable    [${i}]
        ${value2}    Set Variable    ${Workbench.ToList}${value1}
        Wait For Elements State    ${Workbench.ToList}${value1}   Visible    timeout=15
        ${checking_text}    Get Text    ${value2}
        ${confirm}    Run Keyword And Return Status    should contain    ${checking_text}    ${list}
        IF    '${confirm}' == 'True'
            Click    ${value2}
            Exit For Loop
        END
    END

Validating Date
    IF   ${day} < 10
        ${Checking_day}     Catenate    0    ${day}
        ${Checking_day}     Remove String   ${Checking_day}     ${SPACE}
    ELSE
       ${Checking_day}     Set Variable      ${day}
    END
    IF    ${int_month} < 10
        ${Checking_month}     Catenate    0    ${int_month}
        ${Checking_month}     Remove String   ${Checking_month}     ${SPACE}
    ELSE
       ${Checking_month}     Set Variable      ${int_month}
    END
    ${checking_date}    Catenate     SEPARATOR=-    ${year}    ${Checking_month}   ${Checking_day}
    ${CurrentForValidate}     Get Current Date     result_format=%Y-%m-%d
    ${Validating_Date}    Subtract Date From Date     ${checking_date}    ${CurrentForValidate} 
    IF   ${Validating_Date}<0
        Log     ${Validating_Date}
        Fail    Out Of Date
    END

Enterting Search Details With Valid Itineraries
    [Arguments]     ${search_details}
    Set Global Variable    ${search_details} 
    Trip Type    ${search_details}[triptype]
    Passenger    ${pax_ids}
    Cabin    ${search_details}[cabin]
    Departure Date And Return Date    ${search_details}[departureDateOffset]
    ${value}    Set Variable    [1]
    Fill Text    ${Workbench.From}${value}    ${search_details}[origin]
    Checking List From    ${search_details}[origin]
    For Multi City Origins
    ${value}    Set Variable    [1]
    Fill Text    ${Workbench.To}${value}    ${search_details}[destination]
    Checking List To    ${search_details}[destination]
    For Multi City Destinations
    ${value}    Set Variable    [1]
    ${Departure_date_Workbench}    Get Text     ${Workbench.DepartureDate.Click}${value}
    Set Global Variable     ${Departure_date_Workbench}
    Take Screenshot
    Click     ${Workbench.FlightSearchBtn}

For Multi City Origins
    IF    '${search_details}[triptype]' == 'Multi City'
        Finding Taking in to Origin list
        ${Starting}    Set Variable    2
        ${count}    Get Length    ${origin_list}
        ${count}    Evaluate    ${count} + 1
        FOR    ${origin_list_each}    IN     @{origin_list}
            FOR    ${org}    IN RANGE    ${Starting}    ${count} + 1
                IF    '${Starting}' > '2'
                    Click    ${Workbench.AddTripButton}
                END
                ${Starting}    Evaluate    ${org} + 1    
                Set Global Variable    ${Starting}
                ${each_org}    Set Variable    [${org}]
                Fill Text    ${Workbench.From}${each_org}     ${origin_list_each}
                checking list from    ${origin_list_each}
                ${Adding_date}    Evaluate     ${Adding_date} + ${search_details}[addingDateOffset]
                Set Global Variable     ${Adding_date}
                ${For_Multicity}     Get Current Date    result_format=%d/%m/%Y   increment=${Adding_date} days
                Departure Date     ${For_Multicity}    ${each_org}
                Exit For Loop
            END
        END
    END

For Multi City Destinations
    IF    '${search_details}[triptype]' == 'Multi City'
        Finding Taking in to destination list
        ${Starting}    Set Variable    2
        ${count}    Get Length    ${destination_list}
        ${count}    Evaluate    ${count} + 1
        FOR    ${destination_list_each}    IN     @{destination_list}
            FOR    ${des}    IN RANGE    ${Starting}    ${count} + 1
                ${Starting}    Evaluate    ${des} + 1
                Set Global Variable    ${Starting}
                ${each_des}    Set Variable    [${des}]
                Fill Text    ${Workbench.To}${each_des}     ${destination_list_each}
                checking list to     ${destination_list_each}
                Exit For Loop
            END
        END
    END

Finding Taking in to Origin list
    @{origin_list}     Create List
    @{date_list}     Create List
    ${checking}    Run Keyword And Return Status    Dictionary Should Contain Key    ${search_details}    secondorigin
    IF    '${checking}' == 'True'
        Append To List     ${origin_list}     ${search_details}[secondorigin]    
    END
    ${checking}    Run Keyword And Return Status    Dictionary Should Contain Key    ${search_details}    thirdorigin
    IF    '${checking}' == 'True'
        Append To List     ${origin_list}     ${search_details}[thirdorigin]
    END
    ${checking}    Run Keyword And Return Status    Dictionary Should Contain Key    ${search_details}    fourthorigin
    IF    '${checking}' == 'True'
        Append To List     ${origin_list}     ${search_details}[fourthorigin]
    END
    ${checking}    Run Keyword And Return Status    Dictionary Should Contain Key    ${search_details}    fifthorigin
    IF    '${checking}' == 'True'
        Append To List     ${origin_list}     ${search_details}[fifthorigin]
    END
    ${checking}    Run Keyword And Return Status    Dictionary Should Contain Key    ${search_details}    sixthorigin
    IF    '${checking}' == 'True'
        Append To List     ${origin_list}     ${search_details}[sixthorigin]
    END
    Set Global Variable     ${origin_list}

Finding Taking in to destination list
    @{destination_list}     Create List
    Log    ${search_details}
    ${checking}    Run Keyword And Return Status    Dictionary Should Contain Key    ${search_details}    seconddestination
    IF    '${checking}' == 'True'
        Append To List     ${destination_list}     ${search_details}[seconddestination]
    END
    ${checking}    Run Keyword And Return Status    Dictionary Should Contain Key    ${search_details}    thirddestination
    IF    '${checking}' == 'True'
        Append To List     ${destination_list}     ${search_details}[thirddestination]
    END
    ${checking}    Run Keyword And Return Status    Dictionary Should Contain Key    ${search_details}    fourthdestination
    IF    '${checking}' == 'True'
        Append To List     ${destination_list}     ${search_details}[fourthdestination]
    END
    ${checking}    Run Keyword And Return Status    Dictionary Should Contain Key    ${search_details}    fifthdestination
    IF    '${checking}' == 'True'
        Append To List     ${destination_list}     ${search_details}[fifthdestination]
    END
    ${checking}    Run Keyword And Return Status    Dictionary Should Contain Key    ${search_details}    sixthdestination
    IF    '${checking}' == 'True'
        Append To List     ${destination_list}     ${search_details}[sixthdestination]
    END
    Set Global Variable     ${destination_list}