** Settings ***
Force Tags      Test
#Resource
Resource    ${CURDIR}/keywords-lib/util/common-keywords-and-resources.robot

#Suite Setup
Suite Setup   Setup Suite




*** Test Cases ***
Test
    Login    
*** Keywords ***
Login 
    # Login To App    ${Seed}[UserHomepage]       ${Agent}
    Should Be Equal    1    1

Setup Suite
    #Environment
    ${Headless}=    Get Environment Variable    HEADLESS
    Set Suite Variable  ${Headless}
    # ${DISPLAY}=    Get Environment Variable    DISPLAY
    # Set Suite Variable  ${DISPLAY}
    Load Page Objects
    Load Reference Data
    
Load Page Objects    
    #Login
    ${Login}=    Get Page Object    ${pagesDir}    Login.json
    Set Suite Variable    ${Login}
    #FlightSearch
    ${Workbench}=    Get Page Object    ${pagesDir}    Workbench.json
    Set Suite Variable    ${Workbench}
    #FlightSearchResults
    # ${FlightSearchResults}=    Get Page Object    ${pagesDir}    FlightSearchResults.json
    # Set Suite Variable    ${FlightSearchResults}
    # #NewOrder
    # ${NewOrder}=    Get Page Object    ${pagesDir}    NewOrder.json
    # Set Suite Variable    ${NewOrder}
    # #ViewOrderDetails
    # ${ViewOrderDetails}=    Get Page Object    ${pagesDir}    ViewOrderDetails.json
    # Set Suite Variable    ${ViewOrderDetails}
    # #RetrieveOrders
    # # ${RetrieveOrders}=    Get Page Object    ${pagesDir}    RetrieveOrders.json
    # # Set Suite Variable    ${RetrieveOrders}
    # #Payment
    # ${Payment}=    Get Page Object    ${pagesDir}    Payment.json
    # Set Suite Variable    ${Payment}
    # #UpdateSeat
    # ${UpdateOrder}=    Get Page Object    ${pagesDir}    UpdateOrder.json
    # Set Suite Variable    ${UpdateOrder}
    # #OrderReshop
    # ${OrderReshop}=   Get Page Object    ${pagesDir}    OrderReshop.json   
    # Set Suite Variable    ${OrderReshop}
    #Home
    ${Home}=    Get Page Object    ${pagesDir}    Home.json
    Set Suite Variable   ${Home}

Load Reference Data
    #Seed
    ${Seed}=    Get JSON From File    ${dataDir}/seed.json
    Set Suite Variable    ${Seed}
    
    #Reference
    ${Agencies}=    Get JSON From File   ${dataDir}/reference.json
    @{Agent}=   Get Value From Json     ${Agencies}     $.Agency-T-APEX.Users[?(@.Ref=='Agent-02')]
    ${Agent}=   Set Variable   ${Agent}[0] 
    Set Suite Variable    ${Agent}

    # #Pax-list
    # ${Paxlist}=    Get JSON From File    ${dataDir}/pax-list.json
    # Set Suite Variable    ${Paxlist}

# Setting Passenger List and ODList
#     [Arguments]     ${Ref}
#     Set Global Variable     ${Ref}
#     #Itineraries
#     ${Transaction_Itineraries}=    Get JSON From File    ${dataDir}/itineraries/passenger-remove.json
#     ${AirlineCode}    Get Value From Json     ${Transaction_Itineraries}    $.itineraries[?(@.ref =='${Ref}')].ODList.airlinecodes
#     ${AirlineCode}   Set Variable   ${AirlineCode}[0]
#     Set Suite Variable    ${AirlineCode}
    
#     @{ODList}   Get Value From Json     ${Transaction_Itineraries}    $.itineraries[?(@.ref =='${Ref}')].ODList
#     ${ODList}   Set Variable   ${ODList}[0]
#     Set Suite Variable    ${ODList}
    
#     ${pax_ids}     Get Value From Json     ${Transaction_Itineraries}    $.itineraries[?(@.ref == '${Ref}')].paxList
#     ${pax_ids}   Set Variable   ${pax_ids}[0]
#     Set Suite Variable    ${pax_ids}

#     @{rbd}=   Get Value From Json     ${Transaction_Itineraries}    $.itineraries[?(@.ref =='${Ref}')].ODList.rbd 
#     ${rbd}   Set Variable   ${rbd}[0]
#     Set Suite Variable  ${rbd}

# DDT Variable and Dictionary Making
#     &{Requirements}   Create Dictionary    agency=${Agent}     ODlist=${ODList}     passengerlist=${pax_ids}
#     Set Global Variable     ${Requirements}