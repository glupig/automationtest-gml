*** Settings ***
Documentation    Jupiter Toys Common
Library    Selenium2Library
Library    JSONLibrary
Library    OperatingSystem
Library    Collections
Library    DateTime
Library    String
Library    RequestsLibrary

*** Variables ***
${file_data}    ${CURDIR}\\Jupiter_Data.json
${submit_button}    //div//a[contains(text(), "Submit")]

*** Keywords ***
Navigate To "${page}" Page
    Wait Until Element Is Visible    //li//a[contains(text(),"${page}")]
    Click Element    //li//a[contains(text(),"${page}")]
    
Populate Fields
    [Arguments]    ${forename}=${EMPTY}    ${surname}=${EMPTY}    ${email}=${EMPTY}    ${telephone}=${EMPTY}    ${message}=${EMPTY}
    Navigate To "Contact" Page
    Wait Until Element Is Visible    //div//strong[contains(text(), "We welcome your feedback")]
    Input Text    //input[@id="forename"]    ${forename}
    Input Text    //input[@id="surname"]    ${surname}
    Input Text    //input[@id="email"]    ${email}
    Input Text    //input[@id="telephone"]    ${telephone}
    Input Text    //textarea[@id="message"]    ${message}
    Click Element    ${submit_button}
    
Validate Error Submission Message
    ${mandatory_forename}    Execute Javascript    return document.getElementById('forename').innerText
    ${mandatory_email}    Execute Javascript    return document.getElementById('email').innerText
    ${mandatory_message}    Execute Javascript    return document.getElementById('message').innerText
    Run Keyword If    "${mandatory_forename}"=="${EMPTY}"    Element Should Be Visible    //span[contains(text(), "Forename is required")]
    Run Keyword If    "${mandatory_email}"=="${EMPTY}"    Element Should Be Visible    //span[contains(text(), "Email is required")]
    Run Keyword If    "${mandatory_message}"=="${EMPTY}"    Element Should Be Visible    //span[contains(text(), "Message is required")]
    
Validate Success Submission Message
    Wait Until Element Is Visible    //div[@ui-if="contactValidSubmit"]    20s
    
Shop Toy
    [Arguments]    ${toy}    ${quantity}
    Sleep    3s
    :FOR    ${index}    IN RANGE    0    ${quantity}
    \    Run Keyword If    "${toy}"=="Stuffed Frog"    Click Element    //li[@id="product-2"]//p//a[@ng-click="add(item)"]
    \    Run Keyword If    "${toy}"=="Fluffy Bunny"    Click Element    //li[@id="product-4"]//p//a[@ng-click="add(item)"]
    \    Run Keyword If    "${toy}"=="Valentine Bear"    Click Element    //li[@id="product-7"]//p//a[@ng-click="add(item)"]

Verify Price And Subtotal
    ${test_data}    Get File    ${file_data}    encoding=iso-8859-1   encoding_errors=strict
    ${test_data}    Convert To String     ${test_data}
    ${test_data}    Convert String To Json    ${test_data}
    ${json_totalAmount}    Get Value From Json    ${test_data}    $.totalAmount
    Set Test Variable    ${json_totalAmount}
    Wait Until Element Is Visible    //p[@class="cart-msg"]    10s
    ${len}    Execute Javascript    return document.getElementsByTagName('table').length
    :FOR    ${index}    IN RANGE    0    ${len}
    \    @{json_price}    Get Value From Json    ${test_data}    $..price
    \    @{json_subtotal}    Get Value From Json    ${test_data}    $..subtotal
    \    ${toy}    Execute Javascript    return document.getElementsByTagName('table')[0].rows[${index}+1].cells[0].textContent
    \    ${price}    Execute Javascript    return document.getElementsByTagName('table')[0].rows[${index}+1].cells[1].textContent
    \    ${quantity}    Execute Javascript    return document.getElementsByTagName('table')[0].rows[${index}+1].cells[2].getElementsByTagName('input')[0].value
    \    ${subtotal}    Execute Javascript    return document.getElementsByTagName('table')[0].rows[${index}+1].cells[3].textContent
    \    ${sub_price}    Get Substring    ${price}    1    6
    \    ${final_subtotal}=    Evaluate    ${sub_price} * ${quantity}
    \    Should Be Equal As Strings    ${price}    @{json_price}[${index}]
    \    Should Be Equal As Strings    ${subtotal}    $${final_subtotal}
    
Verify Total Amount
    ${total_Amount}    Execute Javascript    return document.getElementsByClassName("total ng-binding")[0].innerText
    ${sub_totalAmount}    Get Substring    ${total_Amount}    6    12
    Log    ${sub_totalAmount}
    Should Be Equal As Strings    ${json_totalAmount}[0]    $${sub_totalAmount}