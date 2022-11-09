
*** Settings ***
Documentation    Provides framework keywords for Test Data Management. Used For Browser Settings

*** Variables ***


*** Keywords ***
Open Chrome Browser Maximize
    [Arguments]     ${URL}
    Close Browser    ALL
    New Browser    chromium    ${Headless}    
    New Page    ${URL}
    Set Size Of Window
    
Open Firefox Browser Maximize
    [Arguments]     ${URL}
    Close Browser    ALL
    New Browser    firefox    ${Headless}    
    New Page    ${URL}
    Set Size Of Window
    
New Page Maximise
    [Arguments]     ${URL}
    New Page    ${URL}
    Set Size Of Window

Set Size Of Window
    Set Viewport Size    ${1280}    ${1024}
    # Set Viewport Size    ${1920}    ${1080}
    # Set Viewport Size    ${1024}  ${768}