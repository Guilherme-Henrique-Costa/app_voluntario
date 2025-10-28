class Validador {
  static String? nome(String? valor) {
    if (_is_empty(valor)) return 'Nome é obrigatório';
    if (valor!.trim().length < 3) return 'Nome deve ter ao menos 3 caracteres';
    return null;
  }

  static String? matricula(String? valor) {
    if (_is_empty(valor)) return 'Matrícula é obrigatória';
    if (!RegExp(r'^\d{8}$').hasMatch(valor!.trim())) {
      return 'Matrícula deve conter exatamente 8 números';
    }
    return null;
  }

  static String? cpf(String? valor) {
    if (_is_empty(valor)) return 'CPF é obrigatório';
    final digits = valor!.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11) return 'CPF deve conter 11 dígitos';
    if (_is_cpf_invalido(digits)) return 'CPF inválido';
    return null;
  }

  static String? celular(String? valor) {
    if (_is_empty(valor)) return 'Celular é obrigatório';
    if (!RegExp(r'^(\(?\d{2}\)?\s?)?\d{5}-?\d{4}$').hasMatch(valor!.trim())) {
      return 'Celular inválido (ex: (61) 99999-9999)';
    }
    return null;
  }

  static String? email(String? valor) {
    if (_is_empty(valor)) return 'E-mail é obrigatório';
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(valor!.trim())) {
      return 'E-mail inválido';
    }
    return null;
  }

  static String? senha(String? valor) {
    if (_is_empty(valor)) return 'Senha é obrigatória';
    if (valor!.length < 6) return 'Senha deve ter no mínimo 6 caracteres';
    return null;
  }

  static String? cidade(String? valor) {
    if (_is_empty(valor)) return 'Cidade e UF são obrigatórios';
    return null;
  }

  static String? motivacao(String? valor) {
    if (_is_empty(valor)) return 'Motivação é obrigatória';
    return null;
  }

  static String? horario(String? valor) {
    if (_is_empty(valor)) return 'Horário é obrigatório';
    return null;
  }

  static String? listaObrigatoria(List? lista) {
    if (lista == null || lista.isEmpty) return 'Este campo é obrigatório';
    return null;
  }

  static String? dataObrigatoria(DateTime? valor) {
    return valor == null ? 'Data é obrigatória' : null;
  }

  // ──────────────────────────────── Métodos auxiliares ────────────────────────────────

  static bool _is_empty(String? valor) => valor == null || valor.trim().isEmpty;

  static bool _is_cpf_invalido(String cpf) {
    // Evita CPFs repetidos tipo "11111111111"
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return true;

    int calcDV(List<int> numeros, int fator) {
      final soma = numeros.fold<int>(0, (acc, n) => acc + n * fator--);
      final dv = (soma * 10) % 11;
      return dv == 10 ? 0 : dv;
    }

    final nums = cpf.split('').map(int.parse).toList();
    final dv1 = calcDV(nums.sublist(0, 9), 10);
    final dv2 = calcDV(nums.sublist(0, 10), 11);

    return dv1 != nums[9] || dv2 != nums[10];
  }
}
