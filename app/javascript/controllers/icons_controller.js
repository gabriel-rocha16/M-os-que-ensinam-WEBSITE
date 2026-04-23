import { Controller } from "@hotwired/stimulus";
// Adicionando os ícones da seção de Acessibilidade
import {
  createIcons,
  Home,
  GraduationCap,
  BookOpen,
  Phone,
  Heart,
  UserPlus,
  ArrowDown,
  Calendar,
  Star,
  ArrowRight,
  Clock,
  PlayCircle,
  Users,
  User,
  Keyboard,
  Volume2,
  Contrast,
  Type,
  Captions,
  HeartHandshake,
  ShieldCheck,
} from "lucide";

export default class extends Controller {
  connect() {
    createIcons({
      icons: {
        Home,
        GraduationCap,
        BookOpen,
        Phone,
        Heart,
        UserPlus,
        ArrowDown,
        Calendar,
        Star,
        ArrowRight,
        Clock,
        PlayCircle,
        Users,
        User,
        Keyboard, // Novo
        Volume2, // Novo
        Contrast, // Novo
        Type, // Novo
        Captions, // Novo
        HeartHandshake, // Novo
        ShieldCheck, // Novo
      },
    });
  }
}
