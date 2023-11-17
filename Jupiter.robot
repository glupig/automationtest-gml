*** Settings ***
Documentation    Jupiter Toys
Library    Selenium2Library
Library    JSONLibrary
Library    OperatingSystem
Resource   Jupiter_Common.robot

Suite Setup    Open Browser    https://jupiter.cloud.planittesting.com/#/home    edge
Suite Teardown    Close Browser

*** Test Cases ***
Test Case 1
    Navigate To "Home" Page
    Populate Fields    
    Validate Error Submission Message
    Populate Fields    forename=Test    email=TestAuto@gm.com    message=Hello There!
    Validate Success Submission Message
    
Test Case 2
    Navigate To "Home" Page
    Populate Fields    forename=Test    email=TestAuto@gm.com    message=Hello There!
    Validate Success Submission Message
    
Test Case 3
    Navigate To "Shop" Page
    Shop Toy    Stuffed Frog    2
    Shop Toy    Fluffy Bunny    5
    Shop Toy    Valentine Bear    3
    Navigate To "Cart" Page
    Verify Price And Subtotal
    Verify Total Amount