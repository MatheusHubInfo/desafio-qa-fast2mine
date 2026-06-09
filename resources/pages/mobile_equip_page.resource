*** Settings ***
Documentation        Mapeamento de elementos (Locators) do aplicativo Mobile.

*** Variables ***
# Seletores nativos Android/iOS para a busca
${MOBILE_INPUT_BUSCA}          accessibility_id=search_equipment_input
${MOBILE_BTN_BUSCAR}           accessibility_id=search_button
${MOBILE_LISTA_RESULTADOS}     accessibility_id=equipment_list
${MOBILE_TXT_NOME_EQUIP}       xpath=//android.widget.TextView[@resource-id="equipment_name"]
${MOBILE_ALERTA_VAZIO}         accessibility_id=no_results_message
