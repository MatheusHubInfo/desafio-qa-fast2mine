*** Settings ***
Documentation        Seletores dos elementos das páginas - mapeados para sites reais.
...                  Cada site tem sua própria estrutura, então usamos seletores genéricos que funcionam na maioria dos casos.

*** Variables ***
# ============================================
# SELETORES PARA BUSCA (Funcionam nos 3 sites)
# ============================================

# Campo de busca - seletores CSS reais testados
${CAMPO_BUSCA_1}               css=#twotabsearchtextbox
${CAMPO_BUSCA_2}               css=#cb1-edit
${CAMPO_BUSCA_3}               css=input[name="q"]
${CAMPO_BUSCA_4}               css=input[type="search"]
${CAMPO_BUSCA_5}               css=input[type="text"]

# Botão de busca - seletores reais por site
${BTN_BUSCA_1}                 css=#nav-search-submit-button
${BTN_BUSCA_2}                 css=body > header > div > div.nav-area.nav-top-area.nav-center-area > form > button
${BTN_BUSCA_3}                 css=.nav-search-submit-button
${BTN_BUSCA_4}                 css=button.nav-action-button

# ============================================
# SELETORES PARA RESULTADOS
# ============================================

# Container com a lista de produtos
${LISTA_PRODUTOS}              css=[data-component-type="s-search-result"]
${LISTA_PRODUTOS_ML}           css=.ui-search-layout
${LISTA_PRODUTOS_SAMSUNG}      css=.product-list
${LISTA_PRODUTOS_GENERICO}     css=.s-result-list

# Título do primeiro produto encontrado
${TITULO_PRODUTO}              css=h2.s-line-clamp-2 span
${TITULO_PRODUTO_ML}           css=.poly-box.poly-component__title a
${TITULO_PRODUTO_SAMSUNG}      css=.product-card__name
${TITULO_PRODUTO_GENERICO}     css=h2 span

# Preço do produto
${PRECO_PRODUTO}               css=.a-price-whole
${PRECO_PRODUTO_ML}            css=.andes-money-amount__fraction
${PRECO_PRODUTO_SAMSUNG}       css=.product-card__price

# ============================================
# SELETORES PARA CASOS DE "NÃO ENCONTRADO"
# ============================================

# Mensagens quando a busca não retorna resultados
${MSG_NAO_ENCONTRADO}          css=.s-no-results-search-message
${MSG_NAO_ENCONTRADO_ML}       xpath=//h2[contains(text(), 'Não encontramos resultados')]
${MSG_NAO_ENCONTRADO_SAMSUNG}  css=.no-results-message
${MSG_NAO_ENCONTRADO_GENERICO}    css=.no-results

# ============================================
# SELETORES PARA FILTROS E LIMPEZA
# ============================================

# Botão de limpar filtros/busca
${BTN_LIMPAR_FILTROS}          css=.a-link-normal.s-navigation-clear-link        # Amazon
${BTN_LIMPAR_FILTROS_ML}       css=.andes-button--clear                          # Mercado Livre
${BTN_VOLTAR_HOME}             css=.nav-logo-link                                # Voltar para home (reset)

# ============================================
# SELETORES GERAIS DE NAVEGAÇÃO
# ============================================

${LOGO_SITE}                   css=.nav-logo-link, .logo, [aria-label*="logo"]   # Logo do site
${MENU_PRINCIPAL}              css=nav, .nav-menu, header                        # Menu principal
${WEB_MSG_SUCESSO}          css=.toast-success
