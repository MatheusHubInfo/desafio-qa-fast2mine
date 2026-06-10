*** Settings ***
Documentation        Mapeamento de elementos (Locators) do aplicativo Mobile.

*** Variables ***
# Seletores nativos Android/iOS para a busca
${MOBILE_INPUT_BUSCA}          accessibility_id=search_equipment_input
${MOBILE_BTN_BUSCAR}           accessibility_id=search_button
${MOBILE_BTN_LIMPAR}           accessibility_id=clear_filter_button
${MOBILE_LISTA_RESULTADOS}     accessibility_id=equipment_list
${MOBILE_TXT_NOME_EQUIP}       xpath=//android.widget.TextView[@resource-id="equipment_name"]
${MOBILE_TXT_STATUS_EQUIP}     xpath=//android.widget.TextView[@resource-id="equipment_status"]
${MOBILE_BTN_EDITAR}           accessibility_id=edit_button
${MOBILE_ALERTA_VAZIO}         accessibility_id=no_results_message

# Seletores da tela de edição
${MOBILE_INPUT_NOME_EDIT}      accessibility_id=edit_equipment_name_input
${MOBILE_SELECT_STATUS_EDIT}   accessibility_id=edit_equipment_status_select
${MOBILE_BTN_SALVAR}           accessibility_id=save_button
${MOBILE_MSG_VALIDACAO}        accessibility_id=validation_message
${MOBILE_MSG_SUCESSO}          accessibility_id=success_message
