*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String
Test Setup    Open Browser   https://abhigyank.github.io/To-Do-List/    Chrome
Test Teardown    TCs Teardown

*** Variables ***
${URL_TodoList}    https://abhigyank.github.io/To-Do-List/
#Add item
${menu_AddItem}    //*[text()='Add Item']
${txt_ItemName}    //input[@id='new-task']
${btn_AddItem}    //button[@class='mdl-button mdl-js-button mdl-button--fab mdl-button--mini-fab mdl-button--colored']
#Todo task
${menu_ToDo}    //*[text()='To-Do Tasks']
#Completed
${menu_Cpmpleted}    //*[text()='Completed']

*** Keywords ***
Go To Tab
    [Arguments]    ${menuTab}
    Click Element    ${menuTab}

Create Task Name
    [Arguments]    ${length}
    ${ItemName}=    Generate Random String    ${length}    [LOWER][UPPER]12345
    # ${Items}=    create list    ${ItemName}
    Set Test Variable    ${ItemName}
    # Set Test Variable    ${Items}

Check Item In Page
    [Arguments]    ${Menu}    ${ItemName}
    Click Element    ${Menu}
    Page Should Contain    ${ItemName}

Add tasks
    [Arguments]    ${์NoTasks}
    Create Task Name    5
    ${ItemName}=    Generate Random String    5    [LOWER][UPPER]12345
    @{ItemList}    create list    ${ItemName}
    Input Text    ${txt_ItemName}    ${ItemName}
    Click Element    ${btn_AddItem}
    ${์NoTasks}=    Evaluate    ${์NoTasks}-1
    FOR  ${INDEX}   IN RANGE   ${์NoTasks}
        Create Task Name    5
        Go To Tab    ${menu_AddItem} 
        Wait Until Element Is Visible    ${btn_AddItem}
        Input Text    ${txt_ItemName}    ${ItemName}
        Click Element    ${btn_AddItem}
        Check Item In Page    ${menu_ToDo}     ${ItemName}
        Append To List    ${ItemList}     ${ItemName}
        log    ${ItemList}
    END
    # @{ItemList}=    create list    ${ItemList}
    Set Test Variable    ${ItemList}

Add task
    Create Task Name    5
    Go To Tab    ${menu_AddItem}
    Wait Until Element Is Visible    ${btn_AddItem}
    Input Text    ${txt_ItemName}    ${ItemName}
    Click Element    ${btn_AddItem}
    Check Item In Page    ${menu_ToDo}     ${ItemName}

Delete tasks
    [Arguments]    ${ItemName}
    FOR    ${List}    IN    @{ItemName}
        Go To Tab    ${menu_ToDo}
        log    ${List}  
        Click Element    //*[text()='${List}']
    END

Check Completed tasks
    [Arguments]    ${ItemName}
    FOR    ${List}    IN    @{ItemName}
        Go To Tab    ${menu_Cpmpleted}
        log    ${List}  
        Page Should Contain    ${List}
    END

TCs Teardown
    Run Keyword If Test Passed    Capture Page Screenshot    EMBED
    Run Keyword If Test Failed    Capture Page Screenshot    EMBED
    Close Browser  

*** Test Cases ***
Addition One Task
    Add task

Complete One Task
    Add task
    Delete tasks    ${ItemName}
    Check Completed tasks    ${ItemName}

Addition Multiple Tasks
    Add tasks    3
    
 Complete Multiple Tasks
    Add tasks    3
    Delete tasks    ${ItemList}
    Check Completed tasks    ${ItemList}


