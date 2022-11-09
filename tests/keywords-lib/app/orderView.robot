*** Settings ***
Documentation    Shared keywords used in the Application - OrderView page.
*** Keywords ***
Passport Expiry    
    [Arguments]    ${date}
    ${date}     Evaluate    366 * ${date}
    ${date}     Get Current Date    result_format=%d/%m/%Y   increment=${date} days
    Click    ${NewOrder.Passenger.PassportExpiry.Icon}${adding_each}
    Wait For Elements State    ${NewOrder.Passenger.PassportExpiry.Menu}   Visible    timeout=15
    Date Creation    ${date}
    Select Options By    ${NewOrder.Passenger.PassportExpiry.YearField}     ${NewOrder.Passenger.PassportExpiry.Tag}    ${year}  
    ${month}    Evaluate    ${month} - 1
    ${month}    Convert to String    ${month}
    Select Options By    ${NewOrder.Passenger.PassportExpiry.MonthField}     ${NewOrder.Passenger.PassportExpiry.Tag}    ${month}  
    FOR    ${i}    IN RANGE    1    40
        ${value}    Set Variable    [${i}]
        ${checking}    Get Text    ${NewOrder.Passenger.PassportExpiry.DayField}${value}
        ${confirm}    Run Keyword And Return Status    Should Be Equal    '${checking}'    '${day}'
        IF    '${confirm}' == 'True'
            Click    ${NewOrder.Passenger.PassportExpiry.DayField}${value}
            Exit For Loop
        END
    END
Date Of Birth
    [Arguments]    ${date}
    ${Sub_date}     Evaluate    366 * ${date}
    ${date}     Get Current Date    result_format=%Y/%m/%d
    ${date}    Subtract Time From Date    ${date}    ${Sub_date} days 
    ${date}     Convert Date    ${date}     result_format=%d/%m/%Y
    Click    ${NewOrder.Passenger.DateOfBirth.Icon}${adding_each}
    Wait For Elements State    ${NewOrder.Passenger.DateOfBirth.Menu}   Visible    timeout=15
    Date Creation    ${date}
    Click    ${NewOrder.Passenger.DateOfBirth.Year.Field}
    Wait For Elements State    ${NewOrder.Passenger.DateOfBirth.Year.Menu}   Visible    timeout=15
    FOR    ${i}    IN RANGE    1    100
        ${value}    Set Variable    [${i}]
        ${checking}    Get Text    ${NewOrder.Passenger.DateOfBirth.Year.MenuEach}${value}
        ${confirm}    Run Keyword And Return Status    Should Be Equal    '${checking}'    '${year}'
        IF    '${confirm}' == 'True'
            Click    ${NewOrder.Passenger.DateOfBirth.Year.MenuEach}${value}
            Exit For Loop
        END
    END
    Click    ${NewOrder.Passenger.DateOfBirth.Month.Field}
    Wait For Elements State    ${NewOrder.Passenger.DateOfBirth.Month.Menu}   Visible    timeout=15
    FOR    ${i}    IN RANGE    1    100
        ${value}    Set Variable    [${i}]
        ${checking}    Get Text    ${NewOrder.Passenger.DateOfBirth.Month.MenuEach}${value}
        ${checking}     Remove String    ${checking}    ✓
        ${checking}     Strip String    ${checking}
        ${confirm}    Run Keyword And Return Status    Should Contain    '${checking}'    '${str_month}'
        IF    '${confirm}' == 'True'
            Click    ${NewOrder.Passenger.DateOfBirth.Month.MenuEach}${value}
            Exit For Loop
        END
    END
    FOR    ${i}    IN RANGE    1    40
        ${value}    Set Variable    [${i}]
        ${checking}    Get Text    ${NewOrder.Passenger.DateOfBirth.DayField}${value}
        ${confirm}    Run Keyword And Return Status    Should Be Equal    '${checking}'    '${day}'
        IF    '${confirm}' == 'True'
            Click    ${NewOrder.Passenger.DateOfBirth.DayField}${value}
            ${check}     Run Keyword And Return Status   Wait For Elements State    ${NewOrder.Passenger.DateOfBirth.DayField}${value}   Hidden    timeout=0.5
            IF   '${check}' == 'False'
                Click    ${NewOrder.Passenger.DateOfBirth.DayField}${value}
            END
            Exit For Loop
        END
    END
Applying All Passenger Details In Adult And Child
    [Arguments]     ${i}  
    ${adding_each}    Set Variable    [${i}]
    Set Global Variable   ${adding_each}
    Wait For Elements State    ${NewOrder.Heading}   Visible    timeout=15
    Fill Text      ${NewOrder.Passenger.PassportNumber}${adding_each}    ${Applying_Passenger_Details}[identityDoc][identityDocId]
    Select Options By        ${NewOrder.Passenger.PassportNationality.Field}${adding_each}     ${NewOrder.Passenger.PassportNationality.Tag}    ${Applying_Passenger_Details}[identityDoc][Nationality]     
    Passport Expiry     ${Applying_Passenger_Details}[identityDoc][expiryDate_year] 
    Select Options By        ${NewOrder.Passenger.Title.Field}${adding_each}     ${NewOrder.Passenger.Title.Tag}    ${Applying_Passenger_Details}[individual][titleName]  
    Select Options By        ${NewOrder.Passenger.Gender.Field}${adding_each}     ${NewOrder.Passenger.Gender.Tag}    ${Applying_Passenger_Details}[individual][genderCode]         
    Date Of Birth       ${Applying_Passenger_Details}[individual][DOBAge]
    Fill Text    ${NewOrder.Passenger.FirstName}${adding_each}    ${Applying_Passenger_Details}[individual][givenName] 
    Fill Text    ${NewOrder.Passenger.MiddleName}${adding_each}    ${Applying_Passenger_Details}[individual][middleName]  
    Fill Text    ${NewOrder.Passenger.LastName}${adding_each}    ${Applying_Passenger_Details}[individual][surname] 
    IF  '${Applying_Passenger_Details}[identityDoc][issuingCountryCode]' == 'india'
        ${ISDCode}   Set Variable    +91
    END
    Fill Text    ${NewOrder.Passenger.ContactNumberISD}${adding_each}    ${ISDCode}
    Fill Text    ${NewOrder.Passenger.ContactNumber}${adding_each}    ${Applying_Passenger_Details}[contactInfo][phone]
    Fill Text    ${NewOrder.Passenger.EmailAddress}${adding_each}    ${Applying_Passenger_Details}[contactInfo][email]   

Applying Infant Details
    [Arguments]     ${i}  
    ${adding_each}    Set Variable    [${i}]
    Set Global Variable   ${adding_each}
    Wait For Elements State    ${NewOrder.Heading}   Visible    timeout=15
    Fill Text      ${NewOrder.Passenger.PassportNumber}${adding_each}    ${Applying_Passenger_Details}[identityDoc][identityDocId]
    Select Options By        ${NewOrder.Passenger.PassportNationality.Field}${adding_each}     ${NewOrder.Passenger.PassportNationality.Tag}    ${Applying_Passenger_Details}[identityDoc][Nationality]     
    Passport Expiry     ${Applying_Passenger_Details}[identityDoc][expiryDate_year] 
    Select Options By        ${NewOrder.Passenger.Gender.Field}${adding_each}     ${NewOrder.Passenger.Gender.Tag}    ${Applying_Passenger_Details}[individual][genderCode]     
    Date Of Birth       ${Applying_Passenger_Details}[individual][DOBAge]
    Fill Text    ${NewOrder.Passenger.FirstName}${adding_each}    ${Applying_Passenger_Details}[individual][givenName] 
    Fill Text    ${NewOrder.Passenger.LastName}${adding_each}    ${Applying_Passenger_Details}[individual][surname] 
    ${Count}     Get Element Count    ${NewOrder.Passenger.INFSelectingPassenger.Field}
    FOR   ${i}   IN RANGE   ${Starting_Var}    ${Count} + 1
        ${Selecting_Each}    Set Variable    [${i}]
        Select Options By        ${NewOrder.Passenger.INFSelectingPassenger.Field}${Selecting_Each}     ${NewOrder.Passenger.INFSelectingPassenger.Tag}    T${i}
        ${Selecting_Each}   Remove String    ${Selecting_Each}   ]      [
        ${Starting_Var}     Evaluate    ${Selecting_Each} + 1
        Set Global Variable     ${Starting_Var}
        Exit For Loop          
    END
    
Entering All Passenger Details In Adult, Child And Infant
    [Arguments]     ${passengerlist}
    FOR   ${pax_test_each}   IN     @{pax_ids}
        FOR   ${i}   IN RANGE    1   10
            ${just_test}     Run Keyword And Return Status     Should Be Equal    'T${i}-ADT'    '${pax_test_each}'
            IF   '${just_test}' == 'True'
                IF  '${pax_test_each}' == 'T1-ADT'
                    Getting Value From Json    ${pax_test_each}
                    Applying All Passenger Details In Adult And Child    ${i}
                    ${Transactions_adding_firstname}    Set Variable     ${Applying_Passenger_Details}[individual][givenName] 
                    Set Global Variable     ${Transactions_adding_firstname}
                    ${Transactions_adding_middlename}    Set Variable     ${Applying_Passenger_Details}[individual][middleName] 
                    Set Global Variable     ${Transactions_adding_middlename}
                    ${Transactions_adding_lastname}    Set Variable     ${Applying_Passenger_Details}[individual][surname] 
                    Set Global Variable     ${Transactions_adding_lastname}
                    ${Transactions_adding_Title}    Set Variable     ${Applying_Passenger_Details}[individual][titleName]  
                    Set Global Variable     ${Transactions_adding_Title}
                    Exit For Loop 
                ELSE
                    ${value_adult}    Set Variable   [${i}] 
                    ${Checking}    Get Text    ${NewOrder.PassengerCount}${value_adult}
                    ${Confirming_text}    Run Keyword And Return Status     Should Contain    ${Checking}    ADT
                    IF    '${Confirming_text}' == 'True'
                        Click    ${NewOrder.PassengerCount}${value_adult}
                        Wait For Elements State    ${NewOrder.Passenger.PassportNumber}${value_adult}   Visible    timeout=15
                        Getting Value From Json    ${pax_test_each}
                        Applying All Passenger Details In Adult And Child    ${i}
                        Exit For Loop  
                    ELSE
                        Continue For Loop
                    END
                END  
            END
        END
    END
    FOR   ${pax_test_each}   IN     @{pax_ids}
        FOR   ${i}   IN RANGE    1   10
            ${just_test}     Run Keyword And Return Status     Should Contain    ${pax_test_each}    CHD
            IF   '${just_test}' == 'True'
                ${value_child}    Set Variable   [${i}] 
                ${Link_checking}     Run Keyword And Return Status    Wait For Elements State    ${NewOrder.PassengerCount}${value_child}   Visible    timeout=3
                IF    '${Link_checking}' == 'True'
                    ${Checking}    Get Text    ${NewOrder.PassengerCount}${value_child}
                    ${Confirming_text}    Run Keyword And Return Status     Should Contain    ${Checking}    CHD
                    IF    '${Confirming_text}' == 'True'
                        ${Confirming_Value}    Run Keyword And Return Status    Wait For Elements State    ${NewOrder.PassengerArrowUp}${value_child}   Visible    timeout=1 
                        ${First_child}    Get Text     ${NewOrder.PassengerCount}${value_child}
                        IF  '${First_child}' == 'T1 ( CHD )'  
                            Wait For Elements State    ${NewOrder.Passenger.PassportNumber}${value_child}   Visible    timeout=15
                            Getting Value From Json    ${pax_test_each}
                            Applying All Passenger Details In Adult And Child    ${i}  
                            ${Transactions_adding_firstname}    Set Variable     ${Applying_Passenger_Details}[individual][givenName] 
                            Set Global Variable     ${Transactions_adding_firstname}
                            ${Transactions_adding_middlename}    Set Variable     ${Applying_Passenger_Details}[individual][middleName] 
                            Set Global Variable     ${Transactions_adding_middlename}
                            ${Transactions_adding_lastname}    Set Variable     ${Applying_Passenger_Details}[individual][surname] 
                            Set Global Variable     ${Transactions_adding_lastname}
                            ${Transactions_adding_Title}    Set Variable     ${Applying_Passenger_Details}[individual][titleName]  
                            Set Global Variable     ${Transactions_adding_Title}
                            Exit For Loop
                        ELSE IF    '${Confirming_Value}' == 'True'
                            Continue For Loop
                        ELSE
                            Click    ${NewOrder.PassengerCount}${value_child}
                            Wait For Elements State    ${NewOrder.Passenger.PassportNumber}${value_child}   Visible    timeout=15
                            Getting Value From Json    ${pax_test_each}
                            Applying All Passenger Details In Adult And Child    ${i}  
                            Exit For Loop
                        END
                    ELSE
                        Continue For Loop
                    END
                ELSE
                    Exit For Loop
                END
            END
        END
    END
    ${Starting_Var}     Set Variable    1
    Set Global Variable     ${Starting_Var}
    FOR   ${pax_test_each}   IN     @{pax_ids}
        FOR   ${i}   IN RANGE    1   10
            ${just_test}     Run Keyword And Return Status     Should Contain    ${pax_test_each}    INF
            IF   '${just_test}' == 'True'
                ${value_INF}    Set Variable   [${i}] 
                ${Link_checking}     Run Keyword And Return Status    Wait For Elements State    ${NewOrder.PassengerCount}${value_INF}   Visible    timeout=3
                IF    '${Link_checking}' == 'True'
                    ${Checking}    Get Text    ${NewOrder.PassengerCount}${value_INF}
                    ${Confirming_text}    Run Keyword And Return Status     Should Contain    ${Checking}    INF
                    IF    '${Confirming_text}' == 'True'
                        ${Confirming_Value}    Run Keyword And Return Status    Wait For Elements State    ${NewOrder.PassengerArrowUp}${value_INF}   Visible    timeout=1 
                        IF    '${Confirming_Value}' == 'True'
                            Continue For Loop
                        ELSE
                            Click    ${NewOrder.PassengerCount}${value_INF}
                            Wait For Elements State    ${NewOrder.Passenger.PassportNumber}${value_INF}   Visible    timeout=15
                            Getting Value From Json    ${pax_test_each}
                            Applying Infant Details    ${i}  
                            Exit For Loop
                        END
                    ELSE
                        Continue For Loop
                    END
                ELSE
                    Exit For Loop
                END
            END
        END
    END
    
Getting Value From Json
    [Arguments]       ${passengerlist}
    Log     ${passengerlist}
    @{Paxlist}   Get Value From Json     ${Paxlist}    $.pax[?(@.paxRefId=='${passengerlist}')]
    ${Applying_Passenger_Details}      Set Variable    ${Paxlist}[0]
    Set Global Variable     ${Applying_Passenger_Details}