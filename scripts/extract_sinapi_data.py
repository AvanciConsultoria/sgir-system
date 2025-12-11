#!/usr/bin/env python3
"""
Script para extrair dados dos PDFs SINAPI e catálogos de ferramentas
e gerar INSERTs SQL para popular o banco de dados SGIR
"""

import re
import sys
from pathlib import Path

def extract_text_from_pdf(pdf_path):
    """Extrai texto de PDF usando pdfplumber"""
    try:
        import pdfplumber
        
        text_content = []
        with pdfplumber.open(pdf_path) as pdf:
            for page in pdf.pages:
                text = page.extract_text()
                if text:
                    text_content.append(text)
        
        return "\n\n".join(text_content)
    except ImportError:
        print("⚠️  pdfplumber não instalado. Instalando...")
        import subprocess
        subprocess.check_call([sys.executable, "-m", "pip", "install", "pdfplumber"])
        return extract_text_from_pdf(pdf_path)

def parse_sinapi_items(text):
    """Extrai itens do SINAPI"""
    items = []
    
    # Padrões comuns do SINAPI
    # Exemplo: código, descrição, unidade
    pattern = r'(\d{5,})\s+([A-Z].*?)\s+(UN|M|M2|M3|KG|L|CJ|PC|TON)'
    
    matches = re.findall(pattern, text, re.MULTILINE)
    
    for match in matches:
        codigo, descricao, unidade = match
        items.append({
            'codigo': codigo.strip(),
            'descricao': descricao.strip()[:300],  # Limitar a 300 chars
            'unidade': unidade.strip(),
            'categoria': 'SINAPI',
            'fonte': 'SINAPI - Setembro 2025'
        })
    
    return items

def parse_ferramentas_manuais(text):
    """Extrai ferramentas do catálogo de ferramentas manuais"""
    items = []
    
    # Padrões comuns: nome da ferramenta em MAIÚSCULAS
    lines = text.split('\n')
    
    current_item = None
    for i, line in enumerate(lines):
        line = line.strip()
        
        # Detectar início de novo item (geralmente em MAIÚSCULAS)
        if line.isupper() and len(line) > 5 and len(line) < 100:
            if current_item:
                items.append(current_item)
            
            current_item = {
                'descricao': line[:300],
                'unidade': 'UN',
                'categoria': 'FERRAMENTA_MANUAL',
                'fabricante': 'Diversos',
                'fonte': 'Catálogo Ferramentas Manuais'
            }
        
        # Capturar descrição técnica
        elif current_item and line and len(line) > 20:
            if 'especificacao' not in current_item:
                current_item['especificacao'] = line[:500]
    
    if current_item:
        items.append(current_item)
    
    return items

def generate_sql_inserts(items, output_file='imported_items.sql'):
    """Gera arquivo SQL com INSERTs"""
    
    sql_lines = [
        "-- =====================================================================",
        "-- SGIR - IMPORTAÇÃO CATÁLOGOS SINAPI E FERRAMENTAS",
        f"-- Total de itens: {len(items)}",
        "-- Data: 2025-12-10",
        "-- =====================================================================",
        "",
        "USE SGIR_DB;",
        "GO",
        "",
        "PRINT 'Importando itens de catálogos...';",
        "",
    ]
    
    for i, item in enumerate(items, 1):
        descricao = item['descricao'].replace("'", "''")
        categoria = item.get('categoria', 'GERAL')
        fabricante = item.get('fabricante', 'N/A').replace("'", "''") if item.get('fabricante') else 'NULL'
        unidade = item.get('unidade', 'UN')
        obs = item.get('fonte', '').replace("'", "''")
        
        # Gerar valor unitário estimado baseado na categoria
        valor_estimado = 0
        if 'FERRAMENTA' in categoria:
            valor_estimado = 150.00
        elif 'SINAPI' in categoria:
            valor_estimado = 50.00
        
        sql = f"""INSERT INTO Itens_Estoque (Descricao, Categoria, Fabricante, Unidade, EstoqueAtual, EstoqueMinimo, LocalPosse, ValorUnitario, OBS, DataCriacao, DataAtualizacao)
VALUES ('{descricao}', '{categoria}', '{fabricante}', '{unidade}', 0, 5, 'Almoxarifado Central', {valor_estimado}, '{obs}', GETDATE(), GETDATE());
"""
        
        sql_lines.append(sql)
        
        if i % 50 == 0:
            sql_lines.append(f"PRINT '   -> {i} itens importados...';")
            sql_lines.append("GO")
            sql_lines.append("")
    
    sql_lines.append("")
    sql_lines.append(f"PRINT '✅ Importação concluída: {len(items)} itens adicionados';")
    sql_lines.append("GO")
    
    # Salvar arquivo
    output_path = Path(output_file)
    output_path.write_text('\n'.join(sql_lines), encoding='utf-8')
    
    print(f"✅ Arquivo SQL gerado: {output_path}")
    print(f"📊 Total de itens: {len(items)}")

def main():
    print("🔧 SGIR - Extrator de Dados de Catálogos")
    print("=" * 60)
    
    # Caminhos dos PDFs
    sinapi_pdf = Path("/home/user/uploaded_files/SINAPI_Fichas_Especificacao_Tecnica_Insumos.pdf")
    ferramentas_pdf = Path("/home/user/uploaded_files/10-ferramentas_manuais.pdf")
    
    all_items = []
    
    # Processar SINAPI
    if sinapi_pdf.exists():
        print(f"\n📄 Processando SINAPI: {sinapi_pdf.name}")
        print("   Extraindo texto...")
        text = extract_text_from_pdf(sinapi_pdf)
        print(f"   ✅ {len(text)} caracteres extraídos")
        
        print("   Parseando itens...")
        items = parse_sinapi_items(text)
        print(f"   ✅ {len(items)} itens SINAPI encontrados")
        all_items.extend(items)
    else:
        print(f"⚠️  Arquivo não encontrado: {sinapi_pdf}")
    
    # Processar Ferramentas Manuais
    if ferramentas_pdf.exists():
        print(f"\n📄 Processando Ferramentas: {ferramentas_pdf.name}")
        print("   Extraindo texto...")
        text = extract_text_from_pdf(ferramentas_pdf)
        print(f"   ✅ {len(text)} caracteres extraídos")
        
        print("   Parseando itens...")
        items = parse_ferramentas_manuais(text)
        print(f"   ✅ {len(items)} ferramentas encontradas")
        all_items.extend(items)
    else:
        print(f"⚠️  Arquivo não encontrado: {ferramentas_pdf}")
    
    # Gerar SQL
    if all_items:
        print(f"\n📝 Gerando arquivo SQL...")
        output_file = "/home/user/sgir-system/database/imported-catalogs.sql"
        generate_sql_inserts(all_items, output_file)
        
        print("\n" + "=" * 60)
        print(f"✅ CONCLUÍDO!")
        print(f"📊 Total: {len(all_items)} itens extraídos")
        print(f"💾 Arquivo: {output_file}")
        print("\n💡 Próximo passo: Execute o SQL no banco de dados")
    else:
        print("\n❌ Nenhum item foi extraído dos PDFs")

if __name__ == "__main__":
    main()
