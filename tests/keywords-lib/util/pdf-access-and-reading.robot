*** Settings ***
Documentation    Provides framework keywords for Test Data Management. Pdf Access And Reading used for reading Pdf files.

*** Keywords ***
Taking Values From PDF For Order Level
    [Arguments]    ${path}
    ${Values_From_PDf}    Set Variable    ${EMPTY}
    ${Values_From_PDf}    Pdf To Text    ${path}
    Log    ${Values_From_PDf}
    ${Values_of_list_from_the_pdf}     Split To Lines     ${Values_From_PDf}    
    Remove Values From List    ${Values_of_list_from_the_pdf}    ${EMPTY}    \x0c    -    .
    ${Values_of_list_from_the_pdf}    Remove Duplicates     ${Values_of_list_from_the_pdf}
    Log    ${Values_of_list_from_the_pdf}
    Set Global Variable     ${Values_of_list_from_the_pdf}
    &{Values_From_Downloaded}    Create Dictionary
    Set Global Variable     ${Values_From_Downloaded}
    ${count_for_validation}     Get Length     ${Values_of_list_from_the_pdf}
    Set Global Variable     ${count_for_validation}
    Your Trip From And To
    Booking Reference in the pdf file
    Booking Date in the pdf file
    Status in the pdf file
    Departing Place in the pdf file
    Departing Date in the pdf file
    Flight Number in the pdf file
    Passengers in the pdf file
    Nuflights Agency in the pdf file
    Nuflights mail in the pdf file
    Nuflights Phone Number in the pdf file
    Passengers Name And Ticket Number in the pdf file
    Important Notes in the pdf
    Remarks in the pdf
    Agency Address in the Pdf
    [Return]     ${Values_From_Downloaded}

Taking Values From PDF For Itinerary Level
    [Arguments]    ${path}
    ${Values_From_PDf}    Set Variable    ${EMPTY}
    ${Values_From_PDf}    Pdf To Text    ${path}
    Log    ${Values_From_PDf}
    ${Values_of_list_from_the_pdf}     Split To Lines     ${Values_From_PDf}    
    Remove Values From List    ${Values_of_list_from_the_pdf}    ${EMPTY}    \x0c    -    .
    ${Values_of_list_from_the_pdf}    Remove Duplicates     ${Values_of_list_from_the_pdf}
    Log    ${Values_of_list_from_the_pdf}
    Set Global Variable     ${Values_of_list_from_the_pdf}
    &{Values_From_Downloaded}    Create Dictionary
    Set Global Variable     ${Values_From_Downloaded}
    ${count_for_validation}     Get Length     ${Values_of_list_from_the_pdf}
    Set Global Variable     ${count_for_validation}
    Your Trip From And To
    Booking Reference in the pdf file
    Booking Date in the pdf file
    Status in the pdf file
    Departing Place in the pdf file
    Departing Date in the pdf file
    Flight Number in the pdf file
    # Passengers in the pdf file
    Nuflights Agency in the pdf file
    Nuflights mail in the pdf file
    Nuflights Phone Number in the pdf file
    Passengers Name And Ticket Number in the pdf file for single
    Important Notes in the pdf
    Remarks in the pdf
    Agency Address in the Pdf
    [Return]     ${Values_From_Downloaded}

Your Trip From And To
    @{count_for_list}     Create List
    &{for_adding}    Create Dictionary
    FOR    ${i}    IN RANGE    1    ${count_for_validation}
        ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[${i}]
        ${check}   Run Keyword And Return Status    Should Contain Values    Your Trip from    ${Text_Check}
        IF    '${check}' == 'True'
            ${Text_Check}    Remove String    ${Text_Check}    Your Trip from${SPACE}
            &{Values_for_adding}    Create Dictionary    Trip From And To    ${Text_Check}
            Append To List     ${count_for_list}     ${Values_for_adding}
            Continue For Loop    
        END
        Log    ${count_for_list}	
    END
    ${count}    Get Length	${count_for_list}
    IF    '${count}' == '1'
        ${adding}    Set Variable    ${count_for_list}[0]
        Set To Dictionary     ${Values_From_Downloaded}    Trip From And To    ${adding}[Trip From And To]
    ELSE
        FOR    ${i}    IN RANGE    0    ${count}
            ${adding}    Set Variable    ${count_for_list}[${i}]
            Set To Dictionary     ${for_adding}     Trip From And To ${i + 1}   ${adding}[Trip From And To]
        END
        Set To Dictionary     ${Values_From_Downloaded}    Trip From And To    ${for_adding}
    END
    Log    ${Values_From_Downloaded}

Booking Reference in the pdf file
    FOR    ${i}    IN RANGE    1    ${count_for_validation}
        ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[${i}]
        ${check}   Run Keyword And Return Status    Should Contain Values    Airline Reference    ${Text_Check}
        IF    '${check}' == 'True'
            ${Text_Check}    Split String    ${Text_Check}    :
            ${Text_Check}    Set Variable    ${Text_Check}[1]
            ${Text_Check}    Remove String    ${Text_Check}    ${SPACE}
            Set To Dictionary     ${Values_From_Downloaded}    Booking Reference         ${Text_Check}
            Exit For Loop
        END  
    END
    Log    ${Values_From_Downloaded}

Booking Date in the pdf file    
    FOR    ${i}    IN RANGE    1    ${count_for_validation}
        ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[${i}]
        IF    '${Text_Check}' == 'Booking Date'
            Set To Dictionary     ${Values_From_Downloaded}    Booking Date        ${Values_of_list_from_the_pdf}[${i + 1}]
            Exit For Loop
        END  
    END
    Log    ${Values_From_Downloaded}

Status in the pdf file
    FOR    ${i}    IN RANGE    1    ${count_for_validation}
        ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[${i}]
        IF    '${Text_Check}' == 'Status'
            Set To Dictionary     ${Values_From_Downloaded}    Status        ${Values_of_list_from_the_pdf}[${i + 1}]
            Exit For Loop
        END  
    END
    Log    ${Values_From_Downloaded}

Departing Place in the pdf file
    # FOR    ${i}    IN RANGE    1    ${count_for_validation}
    #     ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[${i}]
    #     IF    '${Text_Check}' == 'Departing From'
    #         Set To Dictionary     ${Values_From_Downloaded}    Departing Place        ${Values_of_list_from_the_pdf}[${i + 1}]
    #         Exit For Loop
    #     END  
    # END
    # Log    ${Values_From_Downloaded}
    ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[2]
    ${check}    Run Keyword And Return Status     Convert To Number    ${Text_Check}
    IF    '${check}' == 'True'
        ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[3]
    END
    Set To Dictionary     ${Values_From_Downloaded}    Departing Place    ${Text_Check}
    Log    ${Values_From_Downloaded}

Departing Date in the pdf file
    FOR    ${i}    IN RANGE    1    ${count_for_validation}
        ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[${i}]
        IF    '${Text_Check}' == 'Departing On'
            Set To Dictionary     ${Values_From_Downloaded}    Departing Date         ${Values_of_list_from_the_pdf}[${i + 1}]
            Exit For Loop
        END  
    END
    Log    ${Values_From_Downloaded}
    
Nuflights Agency in the pdf file
    FOR    ${i}    IN RANGE    1    ${count_for_validation}
        ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[${i}]
        ${check}   Run Keyword And Return Status    Should Contain Values    Email    ${Text_Check}
        IF    '${check}' == 'True'
            ${sub_value}    Evaluate    ${i} - 1
            ${Agency_name}    Set Variable    ${Values_of_list_from_the_pdf}[${sub_value}]
            Set To Dictionary     ${Values_From_Downloaded}    Agency Name    ${Agency_name}
            Exit For Loop
        END  
    END
    Log    ${Values_From_Downloaded}

Flight Number in the pdf file
    FOR    ${i}    IN RANGE    1    ${count_for_validation}
        ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[${i}]
        IF    '${Text_Check}' == 'Flight Number'
            Set To Dictionary     ${Values_From_Downloaded}    Flight Number        ${Values_of_list_from_the_pdf}[${i + 1}]
            Exit For Loop
        END  
    END
    Log    ${Values_From_Downloaded}

Passengers in the pdf file 
        FOR    ${i}    IN RANGE    1    ${count_for_validation}
        ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[${i}]
        IF    '${Text_Check}' == 'Passengers'
            ${pass}    Set Variable    ${Values_of_list_from_the_pdf}[${i + 1}]
            ${check1}   Run Keyword And Return Status    Should Contain    ${pass}     ADT
            ${check2}   Run Keyword And Return Status    Should Contain    ${pass}     CHD
            ${check3}   Run Keyword And Return Status    Should Contain    ${pass}     INF
            IF    '${check1}' == 'True'
                ${adult}    Split String    ${pass}    ADT
                ${adult}    Set Variable    ${adult}[0]
                ${adult}    Remove String    ${adult}    ${SPACE}
                ${Total_passenger}    Evaluate    ${adult}
            END
            IF    '${check2}' == 'True'
                ${child}    Split String    ${pass}    CHD
                ${child}    Set Variable    ${child}[0]
                ${check4}   Run Keyword And Return Status    Should Contain    ${child}     ADT
                IF    '${check4}' == 'True'
                    ${child}    Split String    ${child}    ADT
                    ${child}    Set Variable    ${child}[1]
                END
                ${child}    Remove String    ${child}    ${SPACE}
                ${Total_passenger}    Evaluate    ${Total_passenger} + ${child}
            END
            IF    '${check3}' == 'True'
                ${infant}    Split String    ${pass}    INF
                ${infant}    Set Variable    ${infant}[0]
                ${check5}   Run Keyword And Return Status    Should Contain    ${infant}     CHD
                IF    '${check5}' == 'True'
                    ${infant}    Split String    ${infant}    CHD
                    ${infant}    Set Variable    ${infant}[1]
                    ${check6}   Run Keyword And Return Status    Should Contain    ${infant}     ADT
                    IF    '${check6}' == 'True'
                        ${infant}    Split String    ${infant}    ADT
                        ${infant}    Set Variable    ${infant}[1]
                    END
                END
                ${infant}    Remove String    ${infant}    ${SPACE}
                ${Total_passenger}    Evaluate    ${Total_passenger} + ${infant}
            END
            Set Global Variable    ${Total_passenger}
            Set To Dictionary     ${Values_From_Downloaded}    Passengers         ${Values_of_list_from_the_pdf}[${i + 1}]
            Exit For Loop
        END  
    END
    Log    ${Values_From_Downloaded}

Nuflights mail in the pdf file
    FOR    ${i}    IN RANGE    1    ${count_for_validation}
        ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[${i}]
        ${check}   Run Keyword And Return Status    Should Contain Values    Email    ${Text_Check}
        IF    '${check}' == 'True'
            ${Text_Check}    Split String    ${Text_Check}    :
            ${Text_Check}    Set Variable    ${Text_Check}[1]
            ${Text_Check}    Remove String    ${Text_Check}    ${SPACE}
            Set To Dictionary     ${Values_From_Downloaded}    Agency Email         ${Text_Check}
            Exit For Loop
        END  
    END
    Log    ${Values_From_Downloaded}

Nuflights Phone Number in the pdf file
    FOR    ${i}    IN RANGE    1    ${count_for_validation}
        ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[${i}]
        ${check}   Run Keyword And Return Status    Should Contain Values    Phone    ${Text_Check}
        IF    '${check}' == 'True'
            ${Text_Check}    Split String    ${Text_Check}    :
            ${Text_Check}    Set Variable    ${Text_Check}[1]
            ${Text_Check}    Remove String    ${Text_Check}    ${SPACE}
            Set To Dictionary     ${Values_From_Downloaded}    Agency Phone         ${Text_Check}
            Exit For Loop
        END  
    END
    Log    ${Values_From_Downloaded}

Passengers Name And Ticket Number in the pdf file for single
    FOR    ${i}    IN RANGE    1    ${count_for_validation}
        ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[${i}]
        IF    '${Text_Check}' == 'FREQUENT FLYER'
            ${first_value}    Evaluate    ${i} + 1
            ${second_value}    Evaluate    ${first_value} + 1
            ${PassengerName_first}    Set Variable    ${Values_of_list_from_the_pdf}[${first_value}]
            ${PassengerName_second}    Set Variable    ${Values_of_list_from_the_pdf}[${second_value}]
            ${check_mr}     Run Keyword And Return Status    Should Contain    ${PassengerName_second}     MR
            ${check_mrs}     Run Keyword And Return Status    Should Contain    ${PassengerName_second}     MRS
            ${check_miss}     Run Keyword And Return Status    Should Contain    ${PassengerName_second}     MISS
            ${check_master}     Run Keyword And Return Status    Should Contain    ${PassengerName_second}     MASTER
            ${check_dr}     Run Keyword And Return Status    Should Contain    ${PassengerName_second}     DR
            IF  '${check_mr}' == 'True' or '${check_mrs}' == 'True' or '${check_miss}' == 'True' or '${check_master}' == 'True' or '${check_dr}' == 'True'
                ${PassengerName}     Catenate    SEPARATOR=     ${PassengerName_first}     ${PassengerName_second}
            ELSE
                ${PassengerName}     Set Variable   ${PassengerName_first}
            END
            Set To Dictionary     ${Values_From_Downloaded}    PassengerName   ${PassengerName}
            Exit For Loop
        END
    END
    IF    '${Values_From_Downloaded}[Status]' != 'Booked'   
        FOR    ${i}    IN RANGE    1    ${count_for_validation}
            ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[${i}]
            IF    '${Text_Check}' == 'SEAT'
                ${first_value}    Evaluate    ${i} + 1
                ${TicketNumber}    Set Variable    ${Values_of_list_from_the_pdf}[${first_value}]
                Set To Dictionary     ${Values_From_Downloaded}    TicketNumber   ${TicketNumber}
                Exit For Loop
            END
        END
    END
    Log    ${Values_From_Downloaded}

Passengers Name And Ticket Number in the pdf file
    FOR    ${i}    IN RANGE    1    ${count_for_validation}
        ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[${i}]
        IF    '${Text_Check}' == 'SEAT'
            IF    '${Values_From_Downloaded}[Status]' != 'Booked'
                ${for_checking_seat}    Evaluate     ${i} + 4
                ${check_seat}    Set Variable    ${Values_of_list_from_the_pdf}[${for_checking_seat}]
                ${check_seat_count}    Split String To Characters     ${check_seat}
                ${check_seat_count}    Get Length    ${check_seat_count}
                ${checking_seat_1}    Run keyword And Return Status    Should Be Equal    '3'    '${check_seat_count}'
                ${for_checking_seat}    Evaluate     ${i} + 5
                ${check_seat}    Set Variable    ${Values_of_list_from_the_pdf}[${for_checking_seat}]
                ${check_seat_count}    Split String To Characters     ${check_seat}
                ${check_seat_count}    Get Length    ${check_seat_count}
                ${checking_seat_2}    Run keyword And Return Status    Should Be Equal    '3'    '${check_seat_count}'
                ${for_checking}    Evaluate     ${i} + 4
                ${check1}    Set Variable    ${Values_of_list_from_the_pdf}[${for_checking}]
                ${check_hyphen}    Run keyword And Return Status    Should Contain Values    -    ${check1}
                IF    '${checking_seat_1}' == 'False' and '${checking_seat_2}' == 'False'
                    ${equating1}    Set Variable    2   
                    ${equating2}    Set Variable    3 
                ELSE IF    '${check_hyphen}' == 'True'
                    ${equating1}    Set Variable    4   
                    ${equating2}    Set Variable    5 
                ELSE IF    '${check_hyphen}' == 'False'
                    ${equating1}    Set Variable    3  
                    ${equating2}    Set Variable    4 
                END
                ${starting}    Evaluate    ${i} - ${equating1}
                ${ending}    Evaluate    ${starting} + ${Total_passenger}
                FOR    ${j}    IN RANGE    ${starting}    ${ending}
                    ${adding_values}    Evaluate     (${j} - ${starting} + 1) * ${equating2}
                    ${adding_values}    Evaluate     ${starting} + ${adding_values}
                    ${PassengerName_first}    Set Variable    ${Values_of_list_from_the_pdf}[${adding_values}]
                    ${adding_one}    Evaluate    ${adding_values} + 1
                    ${PassengerName_lastname}    Set Variable    ${Values_of_list_from_the_pdf}[${adding_one}]
                    ${check}   Run Keyword And Return Status    Should Contain Values    -    ${PassengerName_lastname}
                    IF    '${check}' == 'False'
                        ${adding_two}    Evaluate    ${adding_values} + 2
                        ${adding_three}    Evaluate    ${adding_values} + 3
                        ${TicketNumber}    Set Variable    ${Values_of_list_from_the_pdf}[${adding_two}]
                        ${PassengerName}     Catenate    SEPARATOR=     ${PassengerName_first}     ${PassengerName_lastname}
                        &{Passneger_Details}    Create Dictionary    PassengerName     ${PassengerName} 
                        IF    '${check_hyphen}' == 'True'
                            ${TicketNumber_reshop}    Set Variable    ${Values_of_list_from_the_pdf}[${adding_three}]
                            Set To Dictionary     ${Passneger_Details}    TicketNumber Reshop   ${TicketNumber_reshop}
                            ${adding_four}    Evaluate    ${adding_values} + 4
                            ${SeatNo}    Set Variable    ${Values_of_list_from_the_pdf}[${adding_four}]
                        ELSE IF    '${check_hyphen}' == 'False'
                            ${SeatNo}    Set Variable    ${Values_of_list_from_the_pdf}[${adding_three}]
                        END
                        IF    '${checking_seat_1}' == 'True' or '${checking_seat_2}' == 'True'
                            Set To Dictionary     ${Passneger_Details}    SeatNo   ${SeatNo}
                        END
                    ELSE IF    '${check}' == 'True'
                        ${TicketNumber}    Set Variable    ${Values_of_list_from_the_pdf}[${adding_one}]
                        ${PassengerName}    Set Variable    ${PassengerName_first}
                        &{Passneger_Details}    Create Dictionary    PassengerName     ${PassengerName} 
                        IF    '${check_hyphen}' == 'True'
                            ${adding_two}    Evaluate    ${adding_one} + 1
                            ${TicketNumber_reshop}    Set Variable    ${Values_of_list_from_the_pdf}[${adding_two}]
                            Set To Dictionary     ${Passneger_Details}    TicketNumber Reshop   ${TicketNumber_reshop}
                        END
                    END
                    Set To Dictionary     ${Passneger_Details}    TicketNumber   ${TicketNumber}
                    Set To Dictionary     ${Values_From_Downloaded}    Passenger_${j - ${starting} + 1}   ${Passneger_Details}
                    Exit For Loop If    '${j - ${starting} + 1}' == '${Total_passenger}'
                END
                Exit For Loop
            ELSE IF    '${Values_From_Downloaded}[Status]' == 'Booked'
                ${Number_check}    Set Variable    False
                ${starting}    Evaluate    ${i} - 1
                ${ending}    Evaluate    ${starting} + ${Total_passenger}
                ${value_added}    Set Variable    0
                ${adding_no}    Set Variable    0
                FOR    ${j}    IN RANGE    ${starting}    ${ending}
                    ${adding_values}    Evaluate     (${j} - ${starting} + 1) * 2
                    ${adding_values}    Evaluate     ${starting} + ${adding_values} + ${adding_no}
                    ${PassengerName_first_checking}    Set Variable    ${Values_of_list_from_the_pdf}[${adding_values}]
                    ${PassengerName_first}    Set Variable    ${Values_of_list_from_the_pdf}[${adding_values}]
                    # ${value_added}    Evaluate    ${value_added} + 1
                    ${adding_one}     Evaluate     ${adding_values} + 1
                    ${PassengerName_lastname}    Set Variable    ${Values_of_list_from_the_pdf}[${adding_one}]  
                    ${check1}    Run Keyword And Return Status    Should Contain    ${PassengerName_first_checking}     /
                    IF    '${check1}' == 'True'
                        ${PassengerName_first_check}     Split String     ${PassengerName_first_checking}    /
                        ${PassengerName_first_check}     Set Variable    ${PassengerName_first_check}[1]
                        ${check3}    Run Keyword And Return Status    Convert To Number    ${PassengerName_first_check}
                        IF    '${check3}' == 'True'
                            ${adding_no}    Set Variable    1
                            Set Global Variable    ${adding_no}
                            ${adding_values}    Evaluate    ${adding_values} + ${adding_no}
                            ${PassengerName_first}    Set Variable    ${Values_of_list_from_the_pdf}[${adding_values}]
                            ${adding_one}    Evaluate    ${adding_values} + 1
                            ${PassengerName_lastname}    Set Variable    ${Values_of_list_from_the_pdf}[${adding_one}]
                        END
                    END
                    ${check_mr}     Run Keyword And Return Status    Should Contain    ${PassengerName_lastname}     MR
                    ${check_mrs}     Run Keyword And Return Status    Should Contain    ${PassengerName_lastname}     MRS
                    ${check_miss}     Run Keyword And Return Status    Should Contain    ${PassengerName_lastname}     MISS
                    ${check_master}     Run Keyword And Return Status    Should Contain    ${PassengerName_lastname}     MASTER
                    ${check_dr}     Run Keyword And Return Status    Should Contain    ${PassengerName_lastname}     DR
                    IF  '${check_mr}' == 'True' or '${check_mrs}' == 'True' or '${check_miss}' == 'True' or '${check_master}' == 'True' or '${check_dr}' == 'True'
                        ${PassengerName}     Catenate    SEPARATOR=     ${PassengerName_first}     ${PassengerName_lastname}
                    ELSE
                        ${PassengerName}     Set Variable   ${PassengerName_first}
                    END
                    &{Passneger_Details}    Create Dictionary    PassengerName     ${PassengerName}  
                    Set To Dictionary     ${Values_From_Downloaded}    Passenger_${j - ${starting} + 1}   ${Passneger_Details}
                    Exit For Loop If    '${j - ${starting} + 1}' == '${Total_passenger}'
                END 
                Exit For Loop
            END
        END
    END
    Log    ${Values_From_Downloaded}

Important Notes in the pdf
    FOR    ${i}    IN RANGE    1    ${count_for_validation}
        ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[${i}]
        IF    '${Text_Check}' == 'IMPORTANT NOTES'
            ${end}    Evaluate    ${i} + 11
            ${start}    Evaluate    ${i} + 1
            @{mixing_list}     Create List
            FOR    ${j}    IN RANGE    ${start}    ${end}
                ${adding_value}    Set Variable     ${Values_of_list_from_the_pdf}[${j}]
                Append To List    ${mixing_list}    ${adding_value}
            END
            ${Mixing_value}    Catenate    SEPARATOR=     @{mixing_list}    
            Set To Dictionary     ${Values_From_Downloaded}    IMPORTANT NOTES        ${Mixing_value}
            Exit FOR Loop
        END  
    END
    Log    ${Values_From_Downloaded}

Remarks in the pdf
    Set To Dictionary     ${Values_From_Downloaded}    REMARKS        ${EMPTY}
    Log    ${Values_From_Downloaded}

Agency Address in the Pdf
    FOR    ${i}    IN RANGE    1    ${count_for_validation}
        ${Text_Check}    Set Variable    ${Values_of_list_from_the_pdf}[${i}]
        ${check}   Run Keyword And Return Status    Should Contain Values    REMARKS    ${Text_Check}
        IF    '${check}' == 'True'
            ${start}    Evaluate    ${i} + 1
            @{mixing_list}     Create List
            FOR    ${j}    IN RANGE    ${start}    ${count_for_validation}
                ${adding_value}    Set Variable     ${Values_of_list_from_the_pdf}[${j}]
                Append To List    ${mixing_list}    ${adding_value}
            END
            ${Mixing_value}    Catenate    SEPARATOR=     @{mixing_list}    
            Set To Dictionary     ${Values_From_Downloaded}    Agency Address    ${Mixing_value}
            Exit FOR Loop
        END
    END


    