class Validador {
  static String? nome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Nome é obrigatório';
    }
    if (valor.trim().length < 3) {
      return 'Nome deve ter ao menos 3 caracteres';
    }
    return null;
  }

  static String? matricula(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Matrícula é obrigatória';
    }
    if (!RegExp(r'^\d{8}$').hasMatch(valor)) {
      return 'Matrícula deve conter exatamente 8 números';
    }
    return null;
  }

  static String? cpf(String? valor) {
    if (valor == null || valor.isEmpty) return 'CPF é obrigatório';
    final digits = valor.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length != 11) return 'CPF deve conter 11 dígitos';
    if (_isCpfInvalido(digits)) return 'CPF inválido';
    return null;
  }

  static bool _isCpfInvalido(String cpf) {
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return true;

    int calcDV(List<int> numbers, int fator) {
      int soma = 0;
      for (var n in numbers) {
        soma += n * fator--;
      }
      int dv = (soma * 10) % 11;
      return dv == 10 ? 0 : dv;
    }

    List<int> nums = cpf.split('').map(int.parse).toList();
    int dv1 = calcDV(nums.sublist(0, 9), 10);
    int dv2 = calcDV(nums.sublist(0, 10), 11);
    return dv1 != nums[9] || dv2 != nums[10];
  }

  static String? celular(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Celular é obrigatório';
    }
    if (!RegExp(r'^\(\d{2}\)\s\d{5}-\d{4}$').hasMatch(valor)) {
      return 'Celular inválido (formato esperado: (99) 99999-9999)';
    }
    return null;
  }

  static String? email(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'E-mail é obrigatório';
    }
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(valor)) {
      return 'E-mail inválido';
    }
    return null;
  }

  static String? senha(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Senha é obrigatória';
    }
    if (valor.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }

  static String? dataObrigatoria(DateTime? valor) {
    if (valor == null) {
      return 'Data é obrigatória';
    }
    return null;
  }

  static String? cidade(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Cidade e UF são obrigatórios';
    }
    return null;
  }

  static String? motivacao(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Motivação é obrigatória';
    }
    return null;
  }

  static String? horario(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Horário é obrigatório';
    }
    return null;
  }

  static String? listaObrigatoria(List? lista) {
    if (lista == null || lista.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }
}
