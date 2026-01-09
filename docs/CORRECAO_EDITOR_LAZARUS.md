# 🔧 Correção do Editor de Código no Lazarus

**Data:** 02/01/2026  
**Versão:** 1.0.0

---

## 🔍 Problema Identificado

O editor de código-fonte (SourceNotebook) não estava aparecendo no Lazarus porque estava configurado como **minimizado** no layout de docking.

### Causa Raiz

No arquivo `C:\lazarus\Configuracao\environmentoptions.xml`, o desktop ativo "default docked" tinha:

1. **MainIDE** → `WindowState="Minimized"` (linha 295)
2. **AnchorDockSite3** (layout) → `WindowState="Minimized"` (linha 664)
3. **SourceNotebook** (editor) → `WindowState="Minimized"` (linha 668)

---

## ✅ Correções Aplicadas

### 1. MainIDE
```xml
<!-- ANTES -->
<WindowState Value="Minimized"/>

<!-- DEPOIS -->
<WindowState Value="Maximized"/>
```

### 2. AnchorDockSite3 (Layout)
```xml
<!-- ANTES -->
<Item1 Name="AnchorDockSite3" Type="Layout" WindowState="Minimized" Monitor="0">
  <Bounds Top="57" Width="1918" SplitterPos="57"/>
  <Anchors Align="Bottom"/>

<!-- DEPOIS -->
<Item1 Name="AnchorDockSite3" Type="Layout" WindowState="Normal" Monitor="0">
  <Bounds Top="57" Width="1918" Height="975" SplitterPos="57"/>
  <Anchors Align="Client"/>
```

### 3. SourceNotebook (Editor de Código)
```xml
<!-- ANTES -->
<Item1 Name="SourceNotebook" Type="Control" WindowState="Minimized" Monitor="0">
  <Bounds Width="1744"/>
  <Anchors Right="AnchorDockSplitter2"/>

<!-- DEPOIS -->
<Item1 Name="SourceNotebook" Type="Control" WindowState="Normal" Monitor="0">
  <Bounds Width="1744" Height="975"/>
  <Anchors Right="AnchorDockSplitter2" Top="0" Bottom="0"/>
```

### 4. SourceNotebook (Configuração Global)
```xml
<!-- ANTES -->
<SourceNotebook>
  <Caption Value="SourceNotebook"/>
  <CustomPosition Left="35" Top="108" Width="1727"/>
  <Visible Value="True"/>
</SourceNotebook>

<!-- DEPOIS -->
<SourceNotebook>
  <Caption Value="SourceNotebook"/>
  <CustomPosition Left="35" Top="108" Width="1727" Height="755"/>
  <WindowState Value="Normal"/>
  <Visible Value="True"/>
</SourceNotebook>
```

---

## 🚀 Como Aplicar

### Opção 1: Reiniciar o Lazarus

1. Feche o Lazarus completamente
2. Abra novamente
3. O editor de código deve aparecer normalmente

### Opção 2: Resetar Desktop (se ainda não aparecer)

1. No Lazarus: **View** → **Desktops** → **Manage Desktops**
2. Selecione o desktop "default docked"
3. Clique em **Reset** ou **Delete** e crie um novo
4. Ou alterne para o desktop "default" (sem docking)

### Opção 3: Restaurar Janelas

1. No Lazarus: **View** → **IDE Windows** → **Source Editor**
2. Ou use o atalho: **Ctrl+Shift+E**

---

## 📋 Verificações

### Verificar se o Editor Está Visível

1. Abra o Lazarus
2. Abra um arquivo `.pas` (ex: `ParamentersCSL.lpr`)
3. O editor de código deve aparecer na área central

### Se Ainda Não Aparecer

1. **View** → **IDE Windows** → **Source Editor** (Ctrl+Shift+E)
2. Verifique se não está oculto: **View** → **IDE Windows** → verifique se "Source Editor" está marcado
3. Tente alternar entre desktops: **View** → **Desktops** → **default** (sem docking)

---

## 🔧 Configurações Relacionadas

### Desktop Ativo

O desktop ativo é **"default docked"** (com docking). Se preferir o layout tradicional:

1. **View** → **Desktops** → **default**
2. Ou altere em `environmentoptions.xml`:
   ```xml
   <Desktops Count="2" ActiveDesktop="default">
   ```

### Desabilitar Docking (Opcional)

Se preferir janelas flutuantes tradicionais:

1. **Tools** → **Options** → **Environment** → **Desktop**
2. Desmarque **"Enable Anchor Docking"**
3. Reinicie o Lazarus

---

## 📝 Arquivos Modificados

- ✅ `C:\lazarus\Configuracao\environmentoptions.xml`
  - MainIDE: Minimized → Maximized
  - AnchorDockSite3: Minimized → Normal
  - SourceNotebook: Minimized → Normal
  - Adicionado Height e WindowState explícitos

---

## ✅ Status

- ✅ **Correções aplicadas**
- ✅ **Editor configurado para aparecer normalmente**
- ✅ **Layout de docking ajustado**

**Próximo Passo:** Reinicie o Lazarus para aplicar as mudanças.

---

**Status:** ✅ **Corrigido - Editor de Código Configurado**

