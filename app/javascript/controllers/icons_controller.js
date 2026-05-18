import { Controller } from "@hotwired/stimulus";
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
  LogIn,
  Mail,
  MessageCircle,
  MapPin,
  Send,
  // --- Novos ícones para a tela de Cadastro ---
  Lock, // Para os campos de senha
  Eye, // Para o botão de visualizar senha
  EyeOff, // Para quando a senha estiver visível
  Contact, // Para o campo de CPF (ícone de crachá/documento)
  BadgePlus, // Para o ícone do topo da página de criar conta
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
        Keyboard,
        Volume2,
        Contrast,
        Type,
        Captions,
        HeartHandshake,
        ShieldCheck,
        LogIn,
        Mail,
        MessageCircle,
        MapPin,
        Send,
        Lock,
        Eye,
        EyeOff,
        Contact,
        BadgePlus,
      },
    });
  }
}
