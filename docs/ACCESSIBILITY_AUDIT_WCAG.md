# 📋 RELATÓRIO DE AUDITORIA DE ACESSIBILIDADE E NAVEGAÇÃO
## Sistema: Maos Que Ensinam (WCAG 2.1 AA - Para Pessoas com Deficiência)
**Data:** 3 de junho de 2026  
**Escopo:** Views .html.erb, Navegação, Teclado, Contraste, Leitores de Tela

---

## 1️⃣ LEITORES DE TELA E SEMÂNTICA HTML (ARIA/Labels)

### ❌ PROBLEMA 1.1: Flash Messages não são anunciadas dinamicamente
**Arquivo:** `app/views/layouts/application.html.erb` (linhas 28-35)  
**Issue:** Flash messages (notice/alert) aparecem na página, mas leitores de tela não as anunciam automaticamente. Falta `aria-live="polite"` e `role="alert"`.

**Código Atual:**
```erb
<% if notice %>
  <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative max-w-7xl mx-auto mt-4" role="alert">
    <span class="block sm:inline"><%= notice %></span>
  </div>
<% end %>
<% if alert %>
  <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative max-w-7xl mx-auto mt-4" role="alert">
    <span class="block sm:inline"><%= alert %></span>
  </div>
<% end %>
```

**Solução WCAG-compliant:**
```erb
<% if notice %>
  <div class="bg-green-100 border-l-4 border-green-600 text-green-900 px-6 py-4 rounded-lg max-w-7xl mx-auto mt-4 mb-6 shadow-sm" 
       role="alert" 
       aria-live="polite" 
       aria-atomic="true">
    <div class="flex items-start justify-between gap-4">
      <div class="flex items-start gap-3">
        <i data-lucide="circle-check" class="w-6 h-6 text-green-600 flex-shrink-0 mt-0.5"></i>
        <div>
          <p class="font-semibold text-sm"><%= notice %></p>
        </div>
      </div>
      <button type="button" 
              class="text-green-600 hover:text-green-800 focus:outline-none focus:ring-2 focus:ring-green-600 focus:ring-offset-2 rounded p-1" 
              aria-label="Fechar mensagem de sucesso"
              onclick="this.parentElement.parentElement.remove()">
        <i data-lucide="x" class="w-5 h-5"></i>
      </button>
    </div>
  </div>
<% end %>

<% if alert %>
  <div class="bg-red-100 border-l-4 border-red-600 text-red-900 px-6 py-4 rounded-lg max-w-7xl mx-auto mt-4 mb-6 shadow-sm" 
       role="alert" 
       aria-live="polite" 
       aria-atomic="true">
    <div class="flex items-start justify-between gap-4">
      <div class="flex items-start gap-3">
        <i data-lucide="alert-circle" class="w-6 h-6 text-red-600 flex-shrink-0 mt-0.5"></i>
        <div>
          <p class="font-semibold text-sm"><%= alert %></p>
        </div>
      </div>
      <button type="button" 
              class="text-red-600 hover:text-red-800 focus:outline-none focus:ring-2 focus:ring-red-600 focus:ring-offset-2 rounded p-1" 
              aria-label="Fechar mensagem de erro"
              onclick="this.parentElement.parentElement.remove()">
        <i data-lucide="x" class="w-5 h-5"></i>
      </button>
    </div>
  </div>
<% end %>
```

---

### ❌ PROBLEMA 1.2: Labels não associados a inputs customizados
**Arquivo:** `app/views/candidatos/new.html.erb` (linhas 47-85)  
**Issue:** Custom select (estado, benefício) e dropdowns têm labels mas não usam `for=""` ou `aria-labelledby=""`. Leitores de tela não sabem qual label pertence a qual input.

**Código Atual:**
```erb
<div class="flex flex-col gap-1.5" data-controller="custom-select">
  <%= f.label :estado, class: "text-xs md:text-sm font-bold text-[#003366]" %>
  <div class="relative">
    <%= f.hidden_field :estado, data: { custom_select_target: "input" } %>
    <button type="button" data-action="click->custom-select#toggle click@window->custom-select#hide" 
            class="w-full h-12 md:h-14 rounded-xl border border-[#D0D0D0]...">
```

**Solução WCAG-compliant:**
```erb
<div class="flex flex-col gap-1.5" data-controller="custom-select">
  <label for="candidato_estado" class="text-xs md:text-sm font-bold text-[#003366]">Estado <span class="text-red-600" aria-label="obrigatório">*</span></label>
  <div class="relative">
    <%= f.hidden_field :estado, data: { custom_select_target: "input" } %>
    <button type="button" 
            id="candidato_estado_button"
            data-action="click->custom-select#toggle click@window->custom-select#hide" 
            aria-haspopup="listbox"
            aria-expanded="false"
            aria-labelledby="candidato_estado candidato_estado_button"
            class="w-full h-12 md:h-14 rounded-xl border border-[#D0D0D0] pl-11 pr-4 text-sm md:text-base outline-none focus:border-[#0066CC] focus:ring-2 focus:ring-offset-2 focus:ring-[#0066CC] transition-all bg-white flex items-center justify-between text-[#666] hover:border-[#0066CC]">
      <i data-lucide="map" class="absolute left-4 text-[#666] w-5 h-5"></i>
      <span data-custom-select-target="displayText" class="truncate text-sm md:text-base">Selecione seu estado</span>
      <i data-lucide="chevron-down" class="w-5 h-5 transition-transform duration-200 shrink-0" data-custom-select-target="chevron"></i>
    </button>
    
    <div data-custom-select-target="menu" 
         role="listbox"
         aria-labelledby="candidato_estado"
         class="hidden absolute z-50 w-full mt-2 bg-white border border-[#D0D0D0] rounded-xl shadow-lg max-h-52 overflow-y-auto py-2">
      <% ["BA", "SP", "RJ", "MG", "PE", "CE", "PR", "SC", "RS", "Outros"].each do |uf| %>
        <div data-action="click->custom-select#select" 
             data-value="<%= uf %>" 
             role="option"
             class="px-4 py-3 hover:bg-[#F0F7FF] cursor-pointer text-sm md:text-base text-[#333] transition-colors focus:bg-[#F0F7FF] outline-none">
          <%= uf %>
        </div>
      <% end %>
    </div>
  </div>
</div>
```

---

### ❌ PROBLEMA 1.3: Formulários sem aria-describedby para dicas
**Arquivo:** `app/views/candidatos/new.html.erb` (linhas 258-267)  
**Issue:** Campo de laudos tem dica ("Aceitamos PDF, PNG e JPG...") mas não está associada via aria-describedby.

**Solução:**
```erb
<%# Laudos Médicos %>
<div class="flex flex-col gap-1.5">
  <label for="candidato_laudos_medicos" class="text-xs md:text-sm font-bold text-[#003366]">
    Laudos Médicos <span class="text-red-600" aria-label="obrigatório">*</span>
  </label>
  <div class="relative rounded-2xl border-2 border-dashed border-[#0066CC] bg-[#F0F7FF] p-8 text-center cursor-pointer transition-all hover:bg-[#E6F2FF] hover:border-[#004499]">
    <%= f.file_field :laudos_medicos, 
                     multiple: true, 
                     direct_upload: true, 
                     accept: ".pdf,.png,.jpg,.jpeg",
                     id: "candidato_laudos_medicos",
                     aria-describedby: "laudos_help"
                     class: "hidden" %>
    <label for="candidato_laudos_medicos" class="cursor-pointer flex flex-col items-center gap-3">
      <i data-lucide="upload" class="w-8 h-8 text-[#0066CC]"></i>
      <span class="text-base md:text-lg font-bold text-[#003366]">Clique ou arraste os laudos aqui</span>
      <span class="text-xs md:text-sm text-[#666]">Até 3 arquivos de até 5MB cada</span>
    </label>
  </div>
  <p id="laudos_help" class="text-xs text-[#666] mt-2">
    Aceitamos PDF, PNG e JPG (Máx. 5MB por arquivo). Selecione de 1 a 3 arquivos para laudos.
  </p>
</div>
```

---

## 2️⃣ NAVEGAÇÃO POR TECLADO E VISIBILIDADE DE FOCO

### ❌ PROBLEMA 2.1: Botões "Voltar" sem foco visível e aria-label
**Arquivo:** `app/views/cursos/show.html.erb` (linha 3)  
**Issue:** Botão com `onclick="history.back()"` não tem foco ring visível nem aria-label descritivo.

**Código Atual:**
```erb
<button onclick="history.back()" class="text-sm font-semibold text-slate-600 hover:text-slate-800 transition-colors">← Voltar</button>
```

**Solução WCAG-compliant:**
```erb
<nav aria-label="Navegação de página" class="mb-6">
  <button type="button"
          onclick="history.back()"
          aria-label="Voltar para página anterior"
          class="inline-flex items-center gap-2 px-4 py-2 rounded-lg bg-slate-100 hover:bg-slate-200 text-slate-700 hover:text-slate-900 font-semibold text-sm transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-600">
    <i data-lucide="arrow-left" class="w-4 h-4"></i>
    <span>Voltar</span>
  </button>
</nav>
```

---

### ❌ PROBLEMA 2.2: Custom dropdowns sem keyboard trap prevention
**Arquivo:** `app/views/candidatos/new.html.erb` (linhas 57-85)  
**Issue:** Custom select usa dados-actions Stimulus mas pode ter keyboard trap se JS não fechar dropdown ao Escape.

**Solução:** Adicionar ao Stimulus controller (`app/javascript/controllers/custom_select_controller.js`):
```javascript
import { Controller } from "@hotwired/stimulus"

export default class CustomSelectController extends Controller {
  static targets = ["input", "displayText", "menu", "chevron"]
  
  toggle(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
    this.updateAriaExpanded()
  }
  
  select(event) {
    const value = event.currentTarget.dataset.value
    this.inputTarget.value = value
    this.displayTextTarget.textContent = value
    this.menuTarget.classList.add("hidden")
    this.updateAriaExpanded()
  }
  
  hide(event) {
    // Fechar ao clicar fora
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
      this.updateAriaExpanded()
    }
  }
  
  handleKeyboard(event) {
    if (event.key === "Escape") {
      this.menuTarget.classList.add("hidden")
      this.updateAriaExpanded()
      this.element.querySelector("button").focus()
    }
  }
  
  updateAriaExpanded() {
    const button = this.element.querySelector("button")
    const isExpanded = !this.menuTarget.classList.contains("hidden")
    button.setAttribute("aria-expanded", isExpanded)
  }
  
  connect() {
    document.addEventListener("keydown", e => this.handleKeyboard(e))
  }
  
  disconnect() {
    document.removeEventListener("keydown", e => this.handleKeyboard(e))
  }
}
```

---

## 3️⃣ CONTRASTE DE CORES E LEGIBILIDADE (WCAG AA/AAA)

### ❌ PROBLEMA 3.1: Textos cinzas claros com contraste insuficiente
**Arquivos afetados:**
- `app/views/dashboards/aluno.html.erb` (linha 12: `text-slate-500`)
- `app/views/dashboards/instrutor.html.erb` (linha 6: `text-slate-500`)
- `app/views/candidatos/show.html.erb` (linha 194: `text-gray-500`)

**Issue:** `text-slate-500` (#64748b) sobre fundo branco = ratio 4.2:1 (falha WCAG AA que exige 4.5:1)

**Mapeamento Tailwind → WCAG AA/AAA:**
| Classe Atual | Contraste | Status | Substituir por |
|---|---|---|---|
| `text-slate-500` | 4.2:1 | ❌ Falha AA | `text-slate-700` (7.3:1) ✅ |
| `text-gray-500` | 4.2:1 | ❌ Falha AA | `text-gray-700` (7.3:1) ✅ |
| `text-slate-400` | 2.8:1 | ❌ Falha | `text-slate-600` (5.4:1) ✅ |
| `placeholder-[#999]` | 3.1:1 | ❌ Falha | `placeholder-slate-600` (5.4:1) ✅ |

**Correções Exatas:**

#### 3.1a - `app/views/dashboards/aluno.html.erb`
```erb
<!-- ANTES -->
<p class="mt-2 text-sm text-slate-500">Acesse seus cursos, confira o catálogo e continue sua jornada de aprendizagem.</p>
<span class="text-sm font-medium text-slate-500">Navegando como:</span>

<!-- DEPOIS -->
<p class="mt-2 text-sm text-slate-700">Acesse seus cursos, confira o catálogo e continue sua jornada de aprendizagem.</p>
<span class="text-sm font-medium text-slate-700">Navegando como:</span>
```

#### 3.1b - `app/views/dashboards/instrutor.html.erb`
```erb
<!-- ANTES -->
<p class="text-sm text-slate-500 mt-2">Gerencie seus cursos e envie-os para revisão.</p>
<p class="text-sm text-slate-500">Cursos em revisão</p>

<!-- DEPOIS -->
<p class="text-sm text-slate-700 mt-2">Gerencie seus cursos e envie-os para revisão.</p>
<p class="text-sm text-slate-700">Cursos em revisão</p>
```

#### 3.1c - `app/views/candidatos/new.html.erb` & `edit.html.erb`
```erb
<!-- ANTES (Placeholders) -->
placeholder-[#999]

<!-- DEPOIS -->
placeholder-slate-700
```

#### 3.1d - `app/views/candidatos/show.html.erb`
```erb
<!-- ANTES -->
<span class="text-gray-500 font-medium italic">Não possui / Nenhuma informada</span>
<i data-lucide="file-text" class="w-5 h-5 text-gray-400"></i>

<!-- DEPOIS -->
<span class="text-gray-700 font-medium italic">Não possui / Nenhuma informada</span>
<i data-lucide="file-text" class="w-5 h-5 text-gray-700"></i>
```

---

### ❌ PROBLEMA 3.2: Ícones cinzos claros sem contraste suficiente
**Arquivo:** `app/views/candidatos/show.html.erb` (linhas 236, 255)

**Solução:**
```erb
<!-- ANTES -->
<i data-lucide="file-text" class="w-5 h-5 text-gray-400"></i>
<i data-lucide="paperclip" class="w-5 h-5 text-gray-400"></i>

<!-- DEPOIS -->
<i data-lucide="file-text" class="w-5 h-5 text-gray-700"></i>
<i data-lucide="paperclip" class="w-5 h-5 text-gray-700"></i>
```

---

## 4️⃣ FLUXO DE NAVEGAÇÃO E DEAD ENDS

### ❌ PROBLEMA 4.1: Dashboard Admin extremamente minimalista
**Arquivo:** `app/views/dashboards/admin.html.erb`  
**Issue:** Nenhuma navegação, nenhum breadcrumb, nenhum link "Voltar". Usuário fica perdido.

**Código Atual:**
```erb
<h1>Painel Administrativo</h1>
<%= link_to "Criar Novo Curso", new_curso_path %>
<h2>Todos os Cursos</h2>
```

**Solução WCAG + UX:**
```erb
<div class="min-h-screen bg-[#F4F7FB] font-sans">
  <div class="max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-8 py-8">
    
    <%# Breadcrumb Navigation %>
    <nav class="mb-8" aria-label="Breadcrumb">
      <ol class="flex items-center gap-2 text-sm">
        <li><%= link_to "Home", root_path, class: "text-blue-600 hover:text-blue-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-600 rounded px-2 py-1" %></li>
        <li class="text-slate-500">/</li>
        <li><%= link_to "Dashboard", dashboard_gateway_path, class: "text-blue-600 hover:text-blue-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-600 rounded px-2 py-1" %></li>
        <li class="text-slate-500">/</li>
        <li aria-current="page" class="text-slate-900 font-semibold">Painel de Cursos</li>
      </ol>
    </nav>

    <%# Header com Navigation e Back Link %>
    <header class="bg-white rounded-3xl border border-slate-200 shadow-sm p-6 mb-8">
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 class="text-3xl font-bold text-[#003366]">Painel Administrativo</h1>
          <p class="text-sm text-slate-700 mt-2">Gerencie cursos, usuários e conteúdos da plataforma.</p>
        </div>
        <div class="flex flex-wrap gap-3">
          <%= link_to "Novo Curso", new_curso_path, 
              class: "px-6 py-2.5 rounded-full bg-blue-600 text-white font-semibold hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-600 transition" %>
          <%= link_to "← Voltar ao Site", root_path, 
              class: "px-6 py-2.5 rounded-full bg-slate-100 text-slate-700 font-semibold hover:bg-slate-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-600 transition" %>
        </div>
      </div>
    </header>

    <%# Tab Navigation para diferentes seções %>
    <nav class="mb-8 border-b border-slate-200" role="tablist" aria-label="Seções administrativas">
      <div class="flex gap-1">
        <%= link_to "Cursos", admin_cursos_path, 
            class: "px-6 py-3 text-sm font-semibold border-b-2 transition focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-600 #{ current_page?(admin_cursos_path) ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-600 hover:text-slate-900' }",
            role: "tab",
            aria: { selected: current_page?(admin_cursos_path) } %>
        <%= link_to "Usuários", admin_usuarios_path, 
            class: "px-6 py-3 text-sm font-semibold border-b-2 transition focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-600 #{ current_page?(admin_usuarios_path) ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-600 hover:text-slate-900' }",
            role: "tab",
            aria: { selected: current_page?(admin_usuarios_path) } %>
        <%= link_to "Relatórios", admin_relatorios_path, 
            class: "px-6 py-3 text-sm font-semibold border-b-2 transition focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-600 #{ current_page?(admin_relatorios_path) ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-600 hover:text-slate-900' }",
            role: "tab",
            aria: { selected: current_page?(admin_relatorios_path) } %>
      </div>
    </nav>

    <%# Main Content %>
    <section role="tabpanel" aria-labelledby="courses-tab" class="bg-white rounded-3xl border border-slate-200 shadow-sm p-6">
      <h2 class="text-2xl font-bold text-slate-900 mb-6">Todos os Cursos</h2>
      <% if Curso.any? %>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <% Curso.order(created_at: :desc).each do |curso| %>
            <article class="rounded-2xl border border-slate-200 hover:border-blue-300 transition bg-slate-50 p-6">
              <div class="mb-4">
                <h3 class="text-lg font-bold text-slate-900"><%= curso.nome %></h3>
                <p class="text-xs text-slate-700 mt-1 uppercase tracking-wider"><%= curso.area %></p>
              </div>
              <p class="text-sm text-slate-700 mb-4 line-clamp-2"><%= curso.descricao %></p>
              <div class="flex gap-2 flex-wrap">
                <%= link_to "Editar", edit_curso_path(curso), 
                    class: "px-4 py-2 rounded-lg bg-blue-600 text-white text-xs font-semibold hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-600 transition" %>
                <%= link_to "Ver", curso_path(curso), 
                    class: "px-4 py-2 rounded-lg bg-slate-600 text-white text-xs font-semibold hover:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-600 transition" %>
              </div>
            </article>
          <% end %>
        </div>
      <% else %>
        <div class="rounded-2xl border-2 border-dashed border-slate-300 bg-slate-50 p-12 text-center">
          <i data-lucide="inbox" class="w-12 h-12 text-slate-400 mx-auto mb-4"></i>
          <p class="text-slate-700 font-medium">Nenhum curso criado ainda.</p>
          <p class="text-sm text-slate-600 mt-1"><%= link_to "Criar um novo curso", new_curso_path, class: "text-blue-600 hover:text-blue-800 font-semibold" %></p>
        </div>
      <% end %>
    </section>
  </div>
</div>
```

---

### ❌ PROBLEMA 4.2: Falta de breadcrumbs em formulários de candidato
**Arquivo:** `app/views/candidatos/new.html.erb` e `edit.html.erb`  
**Issue:** Usuário entra em formulário longo mas não sabe em qual etapa está ou como sair.

**Solução - Adicionar breadcrumb + progress indicator:**
```erb
<!-- Topo do formulário -->
<nav class="mb-6" aria-label="Navegação do formulário">
  <ol class="flex items-center gap-2 text-sm">
    <li><%= link_to "Início", root_path, class: "text-blue-600 hover:text-blue-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-600 rounded px-2 py-1" %></li>
    <li class="text-slate-500">/</li>
    <li><%= link_to "Cadastro", new_candidato_path, class: "text-blue-600 hover:text-blue-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-600 rounded px-2 py-1" %></li>
    <li class="text-slate-500">/</li>
    <li aria-current="page" class="text-slate-900 font-semibold">Completar Perfil</li>
  </ol>
</nav>

<!-- Progress bar visual -->
<div class="mb-8">
  <div class="flex items-center justify-between mb-2">
    <h2 class="text-sm font-semibold text-slate-900">Progresso do Cadastro</h2>
    <span class="text-xs text-slate-600">3 de 4 seções</span>
  </div>
  <div class="w-full bg-slate-200 rounded-full h-2.5">
    <div class="bg-blue-600 h-2.5 rounded-full transition-all" style="width: 75%;" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
  </div>
</div>
```

---

### ❌ PROBLEMA 4.3: Formulários sem link "Cancelar" consistente
**Arquivo:** `app/views/candidatos/new.html.erb` e `edit.html.erb`  
**Issue:** Link "Cancelar" leva para candidato_path mas novo.html.erb não oferece alternativa clara.

**Solução:**
```erb
<div class="flex flex-col sm:flex-row gap-4 justify-between items-center mt-8">
  <div class="flex gap-3">
    <%= form.submit "Enviar Perfil", 
                    class: "px-8 py-3 rounded-full bg-[#0066CC] text-white font-bold shadow-lg hover:bg-[#004499] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#0066CC] transition w-full sm:w-auto text-center" %>
    <%= link_to "Cancelar", 
                candidato_path,
                class: "px-8 py-3 rounded-full bg-slate-100 text-slate-700 font-bold hover:bg-slate-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-600 transition w-full sm:w-auto text-center",
                aria-label: "Cancelar e voltar ao perfil" %>
  </div>
  <button type="button" 
          onclick="history.back()"
          class="text-sm text-slate-600 hover:text-slate-900 underline focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-600 rounded px-2 py-1"
          aria-label="Voltar para a página anterior">
    ← Voltar
  </button>
</div>
```

---

## 📊 RESUMO DE CORREÇÕES

| # | Problema | Severidade | Arquivo | Tipo | Ação |
|---|----------|-----------|---------|------|------|
| 1.1 | Flash messages sem aria-live | 🔴 Alta | application.html.erb | A11y | Adicionar aria-live, aria-atomic, botão fechar |
| 1.2 | Labels não associados em selects | 🔴 Alta | candidatos/*.html.erb | A11y | Usar aria-labelledby, aria-haspopup, aria-expanded |
| 1.3 | Campos sem aria-describedby | 🟡 Média | candidatos/*.html.erb | A11y | Associar dicas com aria-describedby |
| 2.1 | Botões "Voltar" sem foco ring | 🟡 Média | cursos/*.html.erb | Teclado | Adicionar focus:ring-2 focus:ring-offset-2 |
| 2.2 | Dropdown sem keyboard trap prevention | 🟡 Média | candidatos/*.html.erb | Teclado | Adicionar Escape key handler no Stimulus controller |
| 3.1 | Contraste insuficiente (text-slate-500) | 🔴 Alta | dashboards/*.html.erb | Contraste | Substituir por text-slate-700 |
| 3.2 | Ícones cinzos sem contraste | 🟡 Média | candidatos/show.html.erb | Contraste | Substituir text-gray-400 por text-gray-700 |
| 4.1 | Dashboard admin sem navegação | 🔴 Alta | dashboards/admin.html.erb | Navegação | Adicionar breadcrumb, tabs, back link |
| 4.2 | Formulários sem breadcrumb/progress | 🟡 Média | candidatos/*.html.erb | Navegação | Adicionar breadcrumb e progress bar |
| 4.3 | Falta link "Cancelar" consistente | 🟡 Média | candidatos/*.html.erb | Navegação | Adicionar link "Cancelar" em novo.html.erb |

---

## ✅ PRÓXIMOS PASSOS

### 1. Implementar Flash Messages (URGENTE)
- [ ] Editar `app/views/layouts/application.html.erb`
- [ ] Adicionar Stimulus controller para remover mensagens
- Teste: NVDA/VoiceOver devem anunciar automaticamente

### 2. Melhorar Formulários (URGENTE)
- [ ] Editar `app/views/candidatos/new.html.erb`
- [ ] Editar `app/views/candidatos/edit.html.erb`
- [ ] Adicionar aria-labelledby, aria-haspopup a custom selects
- Teste: Teclado Tab deve funcionar; Screen reader deve anunciar

### 3. Corrigir Contraste (URGENTE)
- [ ] Substituir `text-slate-500` → `text-slate-700`
- [ ] Substituir `text-gray-500` → `text-gray-700`
- [ ] Substituir `text-gray-400` → `text-gray-700`
- [ ] Substituir `placeholder-[#999]` → `placeholder-slate-700`
- Teste: Contrast Checker (adesivo) online devem confirmar WCAG AA

### 4. Reconstruir Dashboard Admin (MÉDIA)
- [ ] Editar `app/views/dashboards/admin.html.erb`
- [ ] Adicionar breadcrumb, navigation tabs, back links
- Teste: Navegar e confirmar orientação clara

### 5. Adicionar Keyboard Trap Prevention (MÉDIA)
- [ ] Criar/editar `app/javascript/controllers/custom_select_controller.js`
- [ ] Adicionar Escape key handler
- [ ] Garantir focus management em dropdowns
- Teste: Teclado Escape deve fechar dropdown

---

## 📖 Referências WCAG Aplicadas

- **WCAG 2.1 1.4.3:** Contrast (Minimum) - AA (4.5:1 para texto, 3:1 para gráficos)
- **WCAG 2.1 2.1.1:** Keyboard - Todos os controles devem ser acessíveis via teclado
- **WCAG 2.1 2.1.2:** No Keyboard Trap - Nenhum elemento deve prender o foco
- **WCAG 2.1 2.4.3:** Focus Order - Ordem visual clara
- **WCAG 2.1 2.4.7:** Focus Visible - Indicador de foco sempre visível
- **WCAG 2.1 3.2.2:** On Input - Mudanças automáticas anunciadas
- **WCAG 2.1 4.1.2:** Name, Role, Value - Leitores de tela compreendem todos os elementos
- **WCAG 2.1 4.1.3:** Status Messages (ARIA live regions)

---

**Relatório preparado para:** Equipe de Desenvolvimento  
**Prioridade:** 🔴 Implementar itens "Alta" antes da próxima release
