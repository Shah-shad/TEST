*** Settings ***
Documentation    Shared keywords used in the Application - Search Results page.

***Keywords***
RBD Card Selection
    Click  ${FlightSearchResults.RBDCardBox.ExpandBusinessOfferForSelectedFlightCard}
    Wait For Elements State    ${FlightSearchResults.Loading}   Hidden    timeout=100
    Wait For Elements State    ${FlightSearchResults.RBDCardBox.CardCheckBox}    Visible    timeout=15
    FOR    ${rbd_each}    IN    @{rbd}
        Log     ${rbd_each}
        Set Global Variable    ${rbd_each}
        RBD Card Check Each
        Log     ${FareBasis}
        Set Global Variable    ${FareBasis}
    END
    IF   '${checking_tile}' == 'False'
        Take Screenshot
        Fail     Chosen RBD wasn't present there.  Qualifier ${Ref} :- Chosen RBD wasn't present there.
    END

RBD Card Selection For Multiple
    FOR    ${rbd_each}    IN    @{rbd}
        Log     ${rbd_each}
        Set Global Variable    ${rbd_each}
        RBD Card Check Each
    END
    IF   '${checking_tile}' == 'False'
        Take Screenshot
        Fail     Chosen RBD wasn't present there.  Qualifier ${Ref} :- Chosen RBD wasn't present there.
    END

RBD Card Check Each
    ${elementcount} =  Get Element Count  ${FlightSearchResults.RBDCardBox.RBDValue}
    Set Global Variable    ${elementcount}
    ${exceptcheck}  Run Keyword And Return Status  Should Be True  "except" in """${rbd_each}"""
    IF   '${rbd_each}' == 'Any'
        ${value}    Set Variable     [1] 
        ${rbd_value}    Get Text    ${FlightSearchResults.RBDCardBox.FirstRBDValue}
        Set Global Variable    ${rbd_value}
        Take Screenshot
        ${FareBasis}  Get Text  ${FlightSearchResults.RBDCardBox.FareBasis}${value}
        Set Global Variable  ${FareBasis} 
        ${ClassName}  Get Text  ${FlightSearchResults.RBDCardBox.Class}${value}
        Set Global Variable    ${ClassName}
        ${BaseFareFromRBD}  Get Text  ${FlightSearchResults.RBDCardBox.BaseFare}${value}
        Set Global Variable    ${BaseFareFromRBD}
        Click  ${FlightSearchResults.RBDCardBox.FirstRBDValue}
        ${checking_tile}    Set Variable    True
        Set Global Variable     ${checking_tile}
        ${value}    Set Variable     [1] 
        Set Global Variable   ${value}
    ELSE IF  '${exceptcheck}' == 'True'
        Solving the case of RBD exceptions    
    ELSE
        FOR  ${j}  IN RANGE  1  ${elementcount} + 1
            ${value}    Set Variable     [${j}]
            ${text}=  Get Text   ${FlightSearchResults.RBDCardBox.RBDValue}${value}
            ${checking_tile}  Run Keyword And Return Status   Should Be Equal   '${rbd_each}'   '${text}' 
            Set Global Variable     ${checking_tile}
            IF   '${checking_tile}' == 'True'
                ${value}    Set Variable     [1] 
                Set Global Variable  ${value}
                ${FareBasis}  Get Text  ${FlightSearchResults.RBDCardBox.FareBasis}${value}
                Set Global Variable  ${FareBasis} 
                ${ClassName}  Get Text  ${FlightSearchResults.RBDCardBox.Class}${value}
                Set Global Variable    ${ClassName}
                ${BaseFareFromRBD}  Get Text  ${FlightSearchResults.RBDCardBox.BaseFare}${value}
                Set Global Variable    ${BaseFareFromRBD}
                Click   ${FlightSearchResults.RBDCardBox.RBDValue}${value}
                Wait For Elements State    ${FlightSearchResults.RBDCardBox.CardCheckBox}   Hidden    timeout=15
                Exit For Loop
            END
        END
    END 
    # Set Global Variable  ${value}

Solving the case of RBD exceptions
    ${exceptrbd}    Remove string    ${rbd_each}  except  ${SPACE}
    Log  ${exceptrbd}
    FOR  ${j}  IN RANGE  1  ${elementcount} + 1
        ${value}    Set Variable     [${j}]
        ${text}=  Get Text  ${FlightSearchResults.RBDCardBox.RBDValue}${value}
        ${checking_tile}  Run Keyword And Return Status   Should Not Be Equal As Strings   ${exceptrbd}  ${text} 
        Set Global Variable     ${checking_tile}
        IF   '${checking_tile}' == 'True'
            ${value}    Set Variable     [1] 
            Set Global Variable  ${value}
            ${FareBasis}  Get Text  ${FlightSearchResults.RBDCardBox.FareBasis}${value}
            Set Global Variable  ${FareBasis} 
            ${ClassName}  Get Text  ${FlightSearchResults.RBDCardBox.Class}${value}
            Set Global Variable    ${ClassName}
            ${BaseFareFromRBD}  Get Text  ${FlightSearchResults.RBDCardBox.BaseFare}${value}
            Set Global Variable    ${BaseFareFromRBD}
            Click   ${FlightSearchResults.RBDCardBox.RBDValue}${value}
            Wait For Elements State    ${FlightSearchResults.RBDCardBox.CardCheckBox}   Hidden    timeout=15
            Exit For Loop
        ELSE
            Continue For Loop
        END
    END

Selecting the Current AirlineTickets
    [Arguments]      ${AirlineCode_Checking}
    IF    '${search_details}[triptype]' == 'One Way'  
        ${value}     Set Variable    [1]  
        IF   '${AirlineCode_Checking}' == 'EK'
            ${check}  Run Keyword And Return Status  Wait For Elements State  ${FlightSearchResults.EKList}${value}  Visible  timeout=5
            IF  '${check}' == 'True' 
                Click   ${FlightSearchResults.EKList}${value}
            ELSE
                Take Screenshot
                Fail     EK Airlines aren't available     Qualifier ${Ref} :- EK Airlines aren't available
            END

        ELSE IF   '${AirlineCode_Checking}' == 'QR'
            ${check}  Run Keyword And Return Status  Wait For Elements State  ${FlightSearchResults.QRList}${value}  Visible  timeout=5
            IF  '${check}' == 'True' 
                Click   ${FlightSearchResults.QRList}${value}
            ELSE
                Take Screenshot
                Fail     QR Airlines aren't available    Qualifier ${Ref} :- QR Airlines aren't available
            END
            
        ELSE IF   '${AirlineCode_Checking}' == 'Any'
            Click   ${FlightSearchResults.AnyList}${value}
        END
    END
    IF    '${search_details}[triptype]' == 'Round Trip'  
        ${value}     Set Variable    [1]
        ${last}    Set Variable    [last()]
        @{rbd_values}    Create List
        IF   '${AirlineCode_Checking}' == 'EK'
            ${check}  Run Keyword And Return Status  Wait For Elements State  ${FlightSearchResults.EKList}${value}   Visible  timeout=5
            IF  '${check}' == 'True' 
                Click   ${FlightSearchResults.EKList}${value}
                Click    ${FlightSearchResults.RBDCardBox.EKExpandMore}${value}
                RBD Card Selection For Multiple
                Append To List     ${rbd_values}      ${rbd_value}
                Click  ${FlightSearchResults.RBDCardBox.Close}
                Click    ${FlightSearchResults.EKList}${last}
                Click    ${FlightSearchResults.RBDCardBox.EKExpandMore}${last}
                RBD Card Selection For Multiple
                Append To List     ${rbd_values}      ${rbd_value}
                Log     ${rbd_values}
            ELSE
                Take Screenshot
                Fail     EK Airlines aren't available     Qualifier ${Ref} :- EK Airlines aren't available
            END

        ELSE IF   '${AirlineCode_Checking}' == 'QR'
            ${check}  Run Keyword And Return Status  Wait For Elements State  ${FlightSearchResults.QRList}${value}   Visible  timeout=5
            IF  '${check}' == 'True' 
                Click   ${FlightSearchResults.QRList}${value}
                Click    ${FlightSearchResults.RBDCardBox.QRExpandMore}${value}
                RBD Card Selection For Multiple
                Append To List     ${rbd_values}      ${rbd_value}
                Click  ${FlightSearchResults.RBDCardBox.Close}
                Click   ${FlightSearchResults.QRList}${last}
                Click    ${FlightSearchResults.RBDCardBox.QRExpandMore}${last}
                Wait For Elements State    ${FlightSearchResults.Loading}   Hidden    timeout=100
                Wait For Elements State    ${FlightSearchResults.ContinueButton}   Visible    timeout=15
                Wait For Elements State    ${FlightSearchResults.Loading}   Hidden    timeout=100
                RBD Card Selection For Multiple
                Append To List     ${rbd_values}      ${rbd_value}
                Log     ${rbd_values}
            ELSE
                Take Screenshot
                Fail     QR Airlines aren't available    Qualifier ${Ref} :- QR Airlines aren't available
            END
            
        ELSE IF   '${AirlineCode_Checking}' == 'Any'
            Click   ${FlightSearchResults.AnyList}${value}
            Click    ${FlightSearchResults.RBDCardBox.ExpandMore}${value}
            RBD Card Selection For Multiple
            Click   ${FlightSearchResults.AnyList}${last}
            Click    ${FlightSearchResults.RBDCardBox.ExpandMore}${last}
            Wait For Elements State    ${FlightSearchResults.Loading}   Hidden    timeout=100
            Wait For Elements State    ${FlightSearchResults.ContinueButton}   Visible    timeout=15
            Wait For Elements State    ${FlightSearchResults.Loading}   Hidden    timeout=100
            RBD Card Selection For Multiple
            Append To List     ${rbd_values}      ${rbd_value}
            Log     ${rbd_values}
        END
    END
    IF    '${search_details}[triptype]' == 'Multi City'  
        ${value}     Set Variable    [1]
        ${last}    Set Variable    [last()]  
        IF   '${AirlineCode_Checking}' == 'EK'
            ${check}  Run Keyword And Return Status  Wait For Elements State  ${FlightSearchResults.EKList}${value}  Visible  timeout=5
            IF  '${check}' == 'True' 
                Click   ${FlightSearchResults.EKList}${value}
                Click    ${FlightSearchResults.MulticityCard}${value}
            ELSE
                Take Screenshot
                Fail     EK Airlines aren't available     Qualifier ${Ref} :- EK Airlines aren't available
            END

        ELSE IF   '${AirlineCode_Checking}' == 'QR'
            ${check}  Run Keyword And Return Status  Wait For Elements State  ${FlightSearchResults.QRList}${value}  Visible  timeout=5
            IF  '${check}' == 'True' 
                Click   ${FlightSearchResults.QRList}${value}
                Click    ${FlightSearchResults.MulticityCard}${value}
            ELSE
                Take Screenshot
                Fail     QR Airlines aren't available    Qualifier ${Ref} :- QR Airlines aren't available
            END
            
        ELSE IF   '${AirlineCode_Checking}' == 'Any'
            Click   ${FlightSearchResults.AnyList}
        END
    END

