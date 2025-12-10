# Plano de profissionalização do SGIR

## Diagnóstico rápido
- A navegação lateral aponta para 10 rotas (projetos, recursos, colaboradores, alocações, certificações, estoque, movimentos, gap-analysis, compras, custos, importar), mas só existe a página `Index.razor`. Isso gera 404 imediatamente após clicar em qualquer item além do dashboard. O menu atual fica em `Shared/NavMenu.razor` e referencia rotas ainda inexistentes.
- Não há dados iniciais carregados no banco ou no front-end; tudo depende de importação manual. A análise da planilha real já traz listas de funções, déficits e exemplos de colaboradores e itens de estoque que poderiam ser usados como seeds iniciais.

## Como deixar a interface intuitiva com itens pré-cadastrados
1. **Remover 404 e organizar a navegação**: criar páginas reais para cada item do menu ou ocultar os que não estiverem prontos. Todas as rotas do menu devem ter componente associado e breadcrumb para orientar o usuário.
2. **Pré-cadastro baseado na planilha**: usar os dados já levantados (déficits por função, exemplos de colaboradores e itens de ferramentas/insumos) para popular automaticamente o banco na primeira execução.
3. **Fluxo guiado por etapas**: criar um wizard de onboarding que confirma/edita os dados pré-carregados e pede apenas o mínimo (datas, responsáveis) antes de liberar o dashboard.
4. **Dashboards acionáveis**: cada card do dashboard deve abrir a respectiva lista filtrada (projetos ativos, colaboradores com cert. vencidas, itens abaixo do mínimo, compras pendentes), evitando links quebrados.

## Passo a passo implementável
1. **Receber a planilha**: envie o arquivo `.xlsx` pelo chat ou salve em `docs/input/planilha-exemplo.xlsx` (podemos adicionar a pasta ao `.gitignore` para evitar commit acidental de dados sensíveis).
2. **Normalizar o modelo**: mapear as abas da planilha para as tabelas existentes (`Projetos`, `Atividades`, `Colaboradores`, `Certificacoes`, `Inventario`, `Movimentacao_Inventario`, `Pedidos_Compra`) conforme o script `02_CreateTables.sql`, garantindo chaves e relacionamentos.
3. **Criar seeds automáticos**:
   - Funções e déficits iniciais vindos da aba PLAN (ex.: 65 pessoas necessárias, déficit de 21, maior falta em Mecânico e Eletricista). 
   - Colaboradores SAT com status e certificações já extraídos (27 nomes, com datas de validade e alertas de vencimento).
   - Catálogo de ferramentas/insumos com sinalizadores como "aluguel" ou "temos X na Renault" para alimentar o cálculo de déficit e sugestão de compra/aluguel.
   - Implementar um `SeedService` que carrega esses dados na primeira execução (ou via comando `dotnet run --seed`).
4. **Substituir links quebrados por páginas reais**:
   - **Projetos**: lista + criação rápida de OS, com resumo de atividades e demandas por função.
   - **Recursos necessários / Gap Analysis**: tela única que consolida demandas vs. estoque/pessoas e gera ações (compra, aluguel, alocação).
   - **Colaboradores**: listagem com filtros por status, alerta de certificações vencidas e botão "Substituir/Integrar".
   - **Alocações**: quadro kanban por atividade/equipe mostrando vagas em aberto.
   - **Certificações**: visão de vencimento por período, com exportação.
   - **Estoque e Movimentações**: catálogo de itens, níveis mínimo/atual, registro de entradas/saídas.
   - **Compras**: pipeline de pedido gerado pela análise de déficit (status: Pendente → Aprovado → Aguardando entrega → Concluído).
   - **Importar Excel**: wizard que mostra pré-visualização e permite corrigir mapeamentos antes de gravar.
5. **UX e consistência**:
   - Breadcrumb e título claro em cada página; botões de ação primária sempre no topo direito.
   - Estados de carregamento/sucesso/erro padronizados; skeletons nas listas maiores.
   - Pesquisas e filtros salvos por usuário para reduzir digitação repetida.
6. **Qualidade e observabilidade**:
   - Testes de componente para o wizard e para os cálculos de déficit.
   - Health check/endpoint de smoke test para rodar após instalação no Windows.
   - Logging estruturado para importações (linhas ignoradas, campos ausentes) e para recomendações automáticas.
7. **Empacotamento e entrega**:
   - Manter o publish self-contained Windows já configurado e adicionar um target `dotnet publish /p:IncludeNativeLibrariesForSelfExtract=true` para reduzir bloqueios de antivírus.
   - Gerar pacote com os seeds incluídos e um comando único `SGIR.WebApp.exe --seed --init-admin` para preparar banco + usuário inicial.

## Ganhos esperados
- Zero links quebrados e navegação orientada por tarefas reais.
- Ambiente de demonstração pronto em minutos, com dados coerentes com a planilha real.
- Importações rastreáveis e reversíveis, reduzindo risco de dados incorretos.
- Caminho claro para transformar o protótipo em um produto utilizável em operação.
