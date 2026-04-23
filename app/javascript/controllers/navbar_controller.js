import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // Declaramos os elementos que vamos manipular
  static targets = ["container", "link", "loginBtn", "greeting"];

  connect() {
    // Garante que a nav inicie no estado correto caso a página seja recarregada já com scroll
    this.update();
  }

  update() {
    // Verifica se rolou mais de 10 pixels para baixo
    if (window.scrollY > 10) {
      this.applyScrolledState();
    } else {
      this.applyTopState();
    }
  }

  applyScrolledState() {
    // Fundo branco e sombra na Nav
    this.containerTarget.classList.remove("bg-transparent");
    this.containerTarget.classList.add("bg-white", "shadow-md");

    // Muda a cor dos links para azul escuro e hover azul claro
    this.linkTargets.forEach((link) => {
      link.classList.remove("text-white", "hover:text-yellow-400");
      link.classList.add("text-blue-900", "hover:text-blue-500");
    });

    // Muda a cor da borda e texto do botão Entrar/Painel para azul claro
    if (this.hasLoginBtnTarget) {
      this.loginBtnTarget.classList.remove("border-white", "text-white");
      this.loginBtnTarget.classList.add("border-blue-500", "text-blue-500");
    }

    // Altera a cor do texto de saudação
    if (this.hasGreetingTarget) {
      this.greetingTarget.classList.remove("text-white");
      this.greetingTarget.classList.add("text-blue-900");
    }
  }

  applyTopState() {
    // Fundo transparente na Nav
    this.containerTarget.classList.add("bg-transparent");
    this.containerTarget.classList.remove("bg-white", "shadow-md");

    // Retorna os links para branco e hover amarelo
    this.linkTargets.forEach((link) => {
      link.classList.add("text-white", "hover:text-yellow-400");
      link.classList.remove("text-blue-900", "hover:text-blue-500");
    });

    // Retorna o botão Entrar/Painel para branco
    if (this.hasLoginBtnTarget) {
      this.loginBtnTarget.classList.add("border-white", "text-white");
      this.loginBtnTarget.classList.remove("border-blue-500", "text-blue-500");
    }

    // Retorna o texto de saudação para branco
    if (this.hasGreetingTarget) {
      this.greetingTarget.classList.add("text-white");
      this.greetingTarget.classList.remove("text-blue-900");
    }
  }
}
