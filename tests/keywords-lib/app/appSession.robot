*** Settings ***
Documentation    Shared keywords used in the Application - Home Page, Login Page, Logout page.

*** Keywords ***
Login To App
    [Arguments]    ${URL}   ${Loginusers}
    Open Chrome Browser Maximize    ${URL}
    # Set Viewport Size    ${1920}    ${1080}
    Wait For Elements State    ${Login.Heading}    Visible    timeout=100
    Entering Login Details    ${Loginusers}
    Checking the HomePage,WorkbenchPage And AgencyAdmin     ${URL}

Checking the HomePage,WorkbenchPage And AgencyAdmin
    [Arguments]      ${URL}
    #Home
    IF  '${URL}' == '${Seed}[UserHomepage]'
        Wait For Elements State    ${Home.Home.Heading}    Visible    timeout=100
        Wait For Elements State    ${Home.Home.Label}    Visible    timeout=100

    #Agency Admin
    ELSE IF  '${URL}' == '${Seed}[AppWorkbench]'
        Wait For Elements State    ${Workbench.Heading}    Visible    timeout=100

    #Travel Workbench
    ELSE IF  '${URL}' == '${Seed}[AppAgencyAdmin]'
        Wait For Elements State    ${AgencyAdmin.Heading}    Visible    timeout=100
        Wait For Elements State    ${AgencyAdmin.Label}    Visible    timeout=100
    END

Entering Login Details
    [Arguments]     ${Loginusers}
    Fill Text    ${Login.Username}      ${Loginusers}[Username]
    Fill Text    ${Login.Password}      ${Loginusers}[Password]
    Click    ${Login.Button}
