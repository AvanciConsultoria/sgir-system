# Rebuild vs. Refactor: Caminho para um SGIR funcional

## Situação atual
- Interface já possui rotas principais, porém a maioria das páginas é estática e não está conectada ao banco/serviços, gerando sensação de app não funcional.
- Quick Start e scripts de instalação foram escritos antes da interface atual e não refletem o fluxo real de uso.
- Não há carga inicial de dados (seed) nem validação de rotas, o que causa links vazios e 404 quando alguma rota é esquecida.
- O front-end não tem componentes reutilizáveis para formulários/listas; cada página é manual, o que aumenta esforço e risco de inconsistência visual.

## Recomendações (sem repositório novo)
Reaproveitar este repositório é mais rápido do que começar do zero, porque já há estrutura, scripts de banco e páginas iniciais. Abaixo, um plano para deixá-lo utilizável em ciclos curtos:

1) **Congelar o núcleo de dados**
   - Revisar as 15 tabelas SQL existentes e alinhar entidades C#/DTOs com nomes e tipos reais.
   - Documentar a connection string padrão em `appsettings.Development.json` e validar acesso ao banco local (LocalDB/SQL Express).

2) **Seed de dados reais**
   - Converter a planilha exemplo em um processo de importação: `docs/input/planilha-exemplo.xlsx` ➜ classes DTO ➜ seed inicial.
   - Preencher tabelas-chave (Projetos, Colaboradores, Certificações, Inventário, Pedidos) com o seed para evitar telas vazias.

3) **Amarrar rotas à navegação**
   - Criar uma matriz de rotas (menu ➜ página ➜ ação) e testes de smoke que abrem cada rota para garantir que nenhuma 404 permaneça.
   - Adicionar componentes de listagem (tabela, cartões) e formulários para incluir/editar registros reais.

4) **Fluxos mínimos completos**
   - Definir 3 fluxos fim a fim com dados reais: (a) Planejamento de OS ➜ Demanda ➜ Alocação, (b) Inventário ➜ Movimentação ➜ Gap Analysis, (c) Compra ➜ Recebimento ➜ Custo.
   - Cada fluxo deve ter criação, leitura e atualização funcionando (CRUD simples) e um indicador de status na UI.

5) **Melhoria visual incremental**
   - Extrair um `Layout` comum com cabeçalho, breadcrumb e cartões de resumo reusáveis.
   - Padronizar tipografia, espaçamento e cores usando variáveis CSS para evitar divergência entre páginas.

6) **Automação básica de qualidade**
   - Adicionar `dotnet test` com um conjunto mínimo de testes de integração de rotas (Blazor) e de acesso ao banco (health check da connection string).
   - Incluir CI simples (GitHub Actions) para build + lint + smoke UI.

## Quando considerar um repositório novo
- Se for necessário trocar o stack (ex.: migrar para React + API separada) ou descartar toda a estrutura de dados atual.
- Se a base atual tiver débitos técnicos impeditivos (ex.: schemas incoerentes, histórico irrelevante ou licenciamento).

Para o estado atual, **refatorar é a opção mais rápida e segura**: mantém histórico, scripts de banco e reduz tempo até uma versão utilizável.
